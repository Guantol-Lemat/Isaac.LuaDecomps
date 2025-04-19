---@class Decomp.Class.Entity
local Class_Entity = {}
Decomp.Class.Entity = Class_Entity

require("General.Manager")
require("Lib.Math")
require("Lib.Table")
require("Room.Room")

local Lib = Decomp.Lib
local Class = Decomp.Class
local Math = Lib.Math

local g_Game = Game()

---@class Decomp.Class.Entity.Data
---@field vtable Decomp.Class.Entity.Vtable
---@field m_CollisionIndex integer
---@field m_CollidesWithNonTearEntity boolean

---@class Decomp.Class.Entity.Vtable
---@field handle_collision fun(entity: Entity, collider: Entity, low: boolean):boolean

---@return Decomp.Class.Entity.Data
local function new()
    ---@type Decomp.Class.Entity.Data
    local data = {
        vtable = Class_Entity.vtable,
        m_CollisionIndex = 0,
        m_CollidesWithNonTearEntity = false,
    }

    return data
end

---@param entity Entity
---@return Decomp.Class.Entity.Data
local function GetData(entity)
    local data = entity:GetData() -- It is highly suggested to replace this with your own data getter, GetData is only used here for demonstration purposes
    if not data.EntityData then
        data.EntityData = new()
    end

    return data.Entity
end

--#region Collision

local s_ForcedCollision = 0

---@return boolean forcedCollision
local function IsForcedCollision()
    return s_ForcedCollision ~= 0
end

---@param entity Entity
---@param offset Vector
---@return Decomp.Math.Circle.Data
local function GetCollisionCircle(entity, offset)
    return Math.Circle.new(entity.Position + offset, entity.Size)
end

---@param entity Entity
---@param offset Vector
---@return Capsule
local function GetCollisionCapsule(entity, offset)
    return Capsule(entity.Position + offset, entity.SizeMulti, entity.SpriteRotation)
end

---@param entity Entity
---@param collider Entity
---@param force boolean
---@return boolean skipCollisionLogic
local function ForceCollide(entity, collider, force)
    local entityData = Class_Entity.GetData(entity)
    local colliderData = Class_Entity.GetData(collider)
    s_ForcedCollision = s_ForcedCollision + 1

    local skipCollisionLogic = false

    if not force then
        skipCollisionLogic = Class_Entity.handle_collisions(entity, collider)
    else
        local skipEntity = entityData.vtable.handle_collision(entity, collider, true)
        local skipCollider = colliderData.vtable.handle_collision(collider, entity, false)
        skipCollisionLogic = skipEntity or skipCollider
    end

    s_ForcedCollision = s_ForcedCollision - 1
    return skipCollisionLogic
end

---@param entity Entity
---@param collisionClass EntityCollisionClass
---@return boolean
local function should_collide_with_all(entity, collisionClass)
    if collisionClass ~= EntityCollisionClass.ENTCOLL_PLAYEROBJECTS or collisionClass ~= EntityCollisionClass.ENTCOLL_PLAYERONLY then
        return false
    end

    return entity:IsEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
end

local s_PlayerObjects = Lib.Table.CreateDictionary({
    EntityType.ENTITY_PLAYER, EntityType.ENTITY_TEAR, EntityType.ENTITY_FAMILIAR,
    EntityType.ENTITY_KNIFE, EntityType.ENTITY_BOMB, EntityType.ENTITY_BLOOD_PUPPY,
    EntityType.ENTITY_DARK_ESAU, EntityType.ENTITY_POOP
})

---@param entity Entity
---@return boolean
local function is_player_object(entity)
    if not not s_PlayerObjects[entity.Type] then
        return true
    end

    local projectile = entity:ToProjectile()
    if entity.Type == EntityType.ENTITY_PROJECTILE and projectile and projectile:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
        return true
    end

    if entity:IsEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY) then
        return true
    end

    return false
end

---@param entity Entity
---@param collider Entity
---@return boolean skipCollisionLogic
local function HandleCollisions(entity, collider)
    if entity:IsDead() or collider:IsDead() then
        return true
    end

    local entityCollisionClass = entity.EntityCollisionClass
    local colliderCollisionClass = collider.EntityCollisionClass

    if should_collide_with_all(entity, entityCollisionClass) then
        entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end
    if should_collide_with_all(collider, colliderCollisionClass) then
        colliderCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    if entityCollisionClass == EntityCollisionClass.ENTCOLL_NONE or colliderCollisionClass == EntityCollisionClass.ENTCOLL_NONE then
        return true
    end

    if (entityCollisionClass == EntityCollisionClass.ENTCOLL_PLAYEROBJECTS and not is_player_object(collider)) or
       (colliderCollisionClass == EntityCollisionClass.ENTCOLL_PLAYEROBJECTS and not is_player_object(entity)) then
        return true
    end

    if entityCollisionClass == EntityCollisionClass.ENTCOLL_PLAYERONLY or -- Bug?
       (colliderCollisionClass == EntityCollisionClass.ENTCOLL_PLAYERONLY and entity.Type ~= EntityType.ENTITY_PLAYER) then
        return true
    end

    if (entityCollisionClass == EntityCollisionClass.ENTCOLL_ENEMIES and not collider:IsEnemy()) or
       (colliderCollisionClass == EntityCollisionClass.ENTCOLL_ENEMIES and not entity:IsEnemy()) then
        return true
    end

    local entityData = Class_Entity.GetData(entity)
    local colliderData = Class_Entity.GetData(collider)

    local skipEntity = entityData.vtable.handle_collision(entity, collider, true)
    local skipCollider = colliderData.vtable.handle_collision(collider, entity, false)
    return skipEntity or skipCollider
end

---@param entity Entity
---@param other Entity
---@return Entity first
---@return Entity second
local function sort_collision_order(entity, other)
    local first, second = entity, other
    if (true or entity.Type ~= EntityType.ENTITY_TEAR or entity.Type ~= EntityType.ENTITY_PLAYER) and
       other.Type < entity.Type then
        first = other
        second = entity
    end

    return first, second
end

---@param entity Entity
---@param collider Entity
---@return number entityImpulseRatio
---@return number colliderImpulseRatio
local function get_collision_impulse_ratios(entity, collider)
    local entityMass = Class_Entity.get_collision_mass(entity, collider)
    local colliderMass = Class_Entity.get_collision_mass(collider, entity)

    local totalMass = entityMass + colliderMass
    return entityMass / totalMass, colliderMass / totalMass
end

---@param entity Entity
---@param collider Entity
---@return boolean
local function does_collision_bounce(entity, collider)
    local relativeVelocity = entity.Velocity - collider.Velocity
    if not (relativeVelocity:Length() > 0.5 * (entity.Size + collider.Size)) then -- Not fast enough
        return false
    end

    local direction = collider.Position - entity.Position
    if not (relativeVelocity:Dot(direction) < 0.0) then -- Not moving towards each other
        return false
    end

    return true
end

---@param entity Entity
---@param collider Entity
---@return Vector direction
local function collision_bounce(entity, collider)
    local relativeVelocity = entity.Velocity - collider.Velocity
    local direction = collider.Position - entity.Position

    local project = direction:Normalized():Dot(relativeVelocity:Normalized())
    direction = direction + 2 * project * direction
    return direction
end

---@param entity Entity
---@param collider Entity
---@param direction Vector
---@param distance number
---@return Vector
local function get_circle_collision_impulse(entity, collider, direction, distance)
    local relativeSpeed = (collider.Velocity - entity.Velocity):Length()
    return (direction / distance) * relativeSpeed
end

---@param entity Entity
---@param collider Entity
---@param collisionPoint Vector
---@return Vector
local function get_capsule_collision_impulse(entity, collider, collisionPoint)
    local relativeSpeed = (collider.Velocity - entity.Velocity):Length()
    return collisionPoint:Normalized() * relativeSpeed
end

---@param entity Entity
---@param impulse Vector
---@param receivingImpulseRatio number
---@param direction Vector
---@param penetrationDepth number
---@param isCollider boolean
local function apply_circle_physic_knockback(entity, impulse, receivingImpulseRatio, direction, penetrationDepth, isCollider)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
        return
    end

    local knockbackScale = 1.0
    local directionMultiplier = isCollider and 1.0 or -1.0

    if entity.Type == EntityType.ENTITY_PLAYER and Class.Room.IsBeastDungeon(g_Game:GetRoom()) then
        knockbackScale = 0.25
    else
        entity.Position = entity.Position + (direction * penetrationDepth * receivingImpulseRatio) * directionMultiplier
    end

    entity.Velocity = entity.Velocity + (impulse * receivingImpulseRatio * knockbackScale) * directionMultiplier
end

---@param entity Entity
---@param impulse Vector
---@param receivingImpulseRatio number
---@param collisionPoint Vector
---@param isCollider boolean
local function apply_capsule_physic_knockback(entity, impulse, receivingImpulseRatio, collisionPoint, isCollider)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
        return
    end

    local knockbackScale = 1.0
    local direction = isCollider and 1.0 or -1.0

    if entity.Type == EntityType.ENTITY_PLAYER and Class.Room.IsBeastDungeon(g_Game:GetRoom()) then
        knockbackScale = 0.25
    else
        entity.Position = entity.Position + (collisionPoint * receivingImpulseRatio) * direction
    end

    entity.Velocity = entity.Velocity + (impulse * receivingImpulseRatio * knockbackScale) * direction
end

---@param entity Entity
---@param collider Entity
---@param distance number
local function post_circle_collision(entity, collider, distance)
    local entityData = Class_Entity.GetData(entity)
    local colliderData = Class_Entity.GetData(collider)

    entityData.m_CollidesWithNonTearEntity = collider.Type ~= EntityType.ENTITY_TEAR
    colliderData.m_CollidesWithNonTearEntity = entity.Type ~= EntityType.ENTITY_TEAR

    if distance < 1e-4 then
        return
    end

    local direction = collider.Position - entity.Position
    if does_collision_bounce(entity, collider) then
        direction = collision_bounce(entity, collider)
        distance = direction:Length()
    end

    local entityImpulseRatio, colliderImpulseRatio = get_collision_impulse_ratios(entity, collider)
    local penetrationDepth = ((entity.Size + collider.Size) - distance) / distance

    if entity.Type == EntityType.ENTITY_PLAYER or (entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.PUNCHING_BAG) then
        local predictedPositionChange = -direction * colliderImpulseRatio * penetrationDepth
        if Class_Entity.WillPlayerCollideWithGrid(entity, predictedPositionChange) then
            colliderImpulseRatio = 0.0
            entityImpulseRatio = 1.0
        end
    end

    if entity.Type == EntityType.ENTITY_PLAYER then
        colliderImpulseRatio = colliderImpulseRatio * 0.5
    end

    if (entity.Type == EntityType.ENTITY_SINGE and entity.Variant == 1) and (collider.Type == EntityType.ENTITY_SINGE and collider.Variant == 1) then
        local relativeSpeed = (collider.Velocity - entity.Velocity):Length()
        local volume = math.min(relativeSpeed * 0.05 + 0.2, 1.2)
        local pitch = Lib.RNG.SeedToFloatInclusive(Random()) * 0.2 + 0.9
        Class.Manager.PlaySound(SoundEffect.SOUND_STONE_IMPACT, volume, 2, false, pitch)
    end

    local impulse = get_circle_collision_impulse(entity, collider, direction, distance)
    apply_circle_physic_knockback(entity, impulse, colliderImpulseRatio, direction, penetrationDepth, false)
    apply_circle_physic_knockback(collider, impulse, entityImpulseRatio, direction, penetrationDepth, true)
end

---@param entity Entity
---@param collider Entity
---@param collisionPoint Vector
local function post_capsule_collision(entity, collider, collisionPoint)
    if Lib.Math.IsVectorEqual(collisionPoint, Lib.Math.VectorZero) then
        return
    end

    local entityImpulseRatio, colliderImpulseRatio = get_collision_impulse_ratios(entity, collider)
    local impulse = get_capsule_collision_impulse(entity, collider, collisionPoint)
    apply_capsule_physic_knockback(entity, impulse, colliderImpulseRatio, collisionPoint, false)
    apply_capsule_physic_knockback(collider, impulse, entityImpulseRatio, collisionPoint, true)
end

---@param entity Entity
---@param collider Entity
---@return boolean collided
local function CollideCircles(entity, collider)
    entity, collider = sort_collision_order(entity, collider)
    local entityCircle = Class_Entity.GetCollisionCircle(entity, Lib.Math.VectorZero)
    local colliderCircle = Class_Entity.GetCollisionCircle(collider, Lib.Math.VectorZero)

    local collided, distance = Math.Circle.Collide(entityCircle, colliderCircle)
    if not collided then
        return false
    end

    if Class_Entity.handle_collisions(entity, collider) then
        return false
    end

    post_circle_collision(entity, collider, distance)
    return true
end

---@param entity Entity
---@param collider Entity
---@return boolean collided
local function CollideCapsules(entity, collider)
    entity, collider = sort_collision_order(entity, collider)
    local entityCapsule = entity:GetCollisionCapsule(Lib.Math.VectorZero)
    local colliderCapsule = collider:GetCollisionCapsule(Lib.Math.VectorZero)

    local collisionPoint = Vector(0, 0)
    if not entityCapsule:Collide(colliderCapsule, collisionPoint) then
        return false
    end

    if Class_Entity.handle_collisions(entity, collider) then
        return false
    end

    post_capsule_collision(entity, collider, collisionPoint)
    return true
end

---@param entity Entity
---@param collider Entity
local function Collide(entity, collider)
    local vectorOne = Vector(1, 1)
    if Lib.Math.IsVectorEqual(entity.SizeMulti, vectorOne) and Lib.Math.IsVectorEqual(collider.SizeMulti, vectorOne) then
        Class_Entity.collide_circles(entity, collider)
    else
        Class_Entity.collide_capsules(entity, collider)
    end
end

---@param player EntityPlayer
local function has_player_reduced_projectile_collision_mass(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART) then
        return true
    end

    if player:GetEffects():HasNullEffect(NullItemID.ID_TOOTH_AND_NAIL) then
        return true
    end

    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
        return true
    end

    return false
end

---@param entity Entity
---@param collider Entity
---@param mass number
---@return number newMass
local function get_player_collision_mass(entity, collider, mass)
    local player = entity:ToPlayer()
    if not player then -- Game doesn't check
        return mass
    end

    local temporaryEffects = player:GetEffects()

    if collider.Type == EntityType.ENTITY_FAMILIAR and collider.Variant == FamiliarVariant.CUBE_BABY then
        mass = mass * 10.0
    end

    if temporaryEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
        mass = mass * 10.0
    end

    if collider.Type == EntityType.ENTITY_PROJECTILE and has_player_reduced_projectile_collision_mass(player) then
        mass = mass * 20.0
    end

    return mass
end

local s_EnemyReducedCollisionMassSet = Lib.Table.CreateDictionary({
    EntityType.ENTITY_BOOMFLY, EntityType.ENTITY_PIN, EntityType.ENTITY_KNIGHT,
    EntityType.ENTITY_FLOATING_KNIGHT, EntityType.ENTITY_SWARMER, EntityType.ENTITY_CHARGER,
    EntityType.ENTITY_MOVABLE_TNT, EntityType.ENTITY_POOP, EntityType.ENTITY_LEECH,
    EntityType.ENTITY_BONE_KNIGHT
})

---@param entity Entity
local function has_enemy_reduced_tear_collision_mass(entity)
    return not not s_EnemyReducedCollisionMassSet[entity.Type]
end

---@param entity Entity
---@param collider Entity
---@return number mass
local function GetCollisionMass(entity, collider)
    local mass = entity.Mass

    if entity:HasEntityFlags(EntityFlag.FLAG_MAGNETIZED) and collider:IsEnemy() then
        mass = mass * 10.0
    end

    if entity.Type == EntityType.ENTITY_PLAYER then
        mass = get_player_collision_mass(entity, collider, mass)
    end

    if entity:IsEnemy() and (collider.Type == EntityType.ENTITY_TEAR or collider.Type == EntityType.ENTITY_LASER) and has_enemy_reduced_tear_collision_mass(entity) then
        mass = mass * 100.0
    end

    return mass
end

--#endregion

--#region Module

---@param entity Entity
---@param collider Entity
---@return boolean
function Class_Entity.handle_collision(entity, collider)
    -- TODO
end

---@type Decomp.Class.Entity.Vtable
Class_Entity.vtable = {
    handle_collision = Class_Entity.handle_collision,
}

---@param entity Entity
---@return Decomp.Class.Entity.Data
function Class_Entity.GetData(entity)
    return GetData(entity)
end

---@return boolean forcedCollision
function Class_Entity.IsForcedCollision()
    return IsForcedCollision()
end

---@param entity Entity
---@param collider Entity
---@param force boolean
---@return boolean skipCollisionLogic
function Class_Entity.ForceCollide(entity, collider, force)
    return ForceCollide(entity, collider, force)
end

---@param entity Entity
---@param collider Entity
function Class_Entity.Collide(entity, collider)
    Collide(entity, collider)
end

---@param entity Entity
---@param unk boolean
function Class_Entity.PlayerCollideWithGrid(entity, unk)
    -- TODO
end

---@param entity Entity
---@param unk boolean
function Class_Entity.CollideWithGrid(entity, unk)
   -- TODO 
end

---@param entity Entity
---@param positionChange Vector
---@return boolean
function Class_Entity.WillPlayerCollideWithGrid(entity, positionChange)
    -- TODO
end

---@param entity Entity
---@param offset Vector
---@return Decomp.Math.Circle.Data
function Class_Entity.GetCollisionCircle(entity, offset)
    return GetCollisionCircle(entity, offset)
end

---@param entity Entity
---@param offset Vector
---@return Capsule
function Class_Entity.GetCollisionCapsule(entity, offset)
    return GetCollisionCapsule(entity, offset)
end

---@param entity Entity
---@param collider Entity
---@return boolean collided
function Class_Entity.collide_circles(entity, collider)
    return CollideCircles(entity, collider)
end

---@param entity Entity
---@param collider Entity
---@return boolean collided
function Class_Entity.collide_capsules(entity, collider)
    return CollideCapsules(entity, collider)
end

---@param entity Entity
---@param collider Entity
---@return boolean skipCollisionLogic
function Class_Entity.handle_collisions(entity, collider)
    return HandleCollisions(entity, collider)
end

---@param entity Entity
---@param collider Entity
---@return number mass
function Class_Entity.get_collision_mass(entity, collider)
    return GetCollisionMass(entity, collider)
end

--#endregion