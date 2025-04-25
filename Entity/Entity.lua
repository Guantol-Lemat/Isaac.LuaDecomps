local Enums = require("General.Enums")
local Math = require("Lib.Math")
local Table = require("Lib.Table")
local RNG = require("Lib.RNG")

require("General.Manager")
require("Room.Room")

local Class = Decomp.Class

local g_Game = Game()

---@class Decomp.Object.Entity : Decomp.Class.Entity.Data, Decomp.Class.Entity.API

---@class Decomp.Class.Entity.Data : Decomp.Data.EntityBase
---@field object Entity
---@field m_CollisionIndex integer
---@field m_CollidesWithNonTearEntity boolean

---@param data Decomp.Class.Entity.Data
local function constructor(data)
    data.m_CollisionIndex = 0
    data.m_CollidesWithNonTearEntity = false
end

--#region Collision

local s_ForcedCollision = 0

---@return boolean forcedCollision
local function IsForcedCollision()
    return s_ForcedCollision ~= 0
end

---@param entity Decomp.Object.Entity
---@param offset Vector
---@return Decomp.Math.Circle.Data
local function GetCollisionCircle(entity, offset)
    local object = entity.object
    return Math.Circle.new(object.Position + offset, object.Size)
end

---@param entity Decomp.Object.Entity
---@param offset Vector
---@return Capsule
local function GetCollisionCapsule(entity, offset)
    local object = entity.object
    return Capsule(object.Position + offset, object.SizeMulti, object.SpriteRotation)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@param force boolean
---@return boolean skipCollisionLogic
local function ForceCollide(entity, collider, force)
    s_ForcedCollision = s_ForcedCollision + 1

    local skipCollisionLogic = false

    if not force then
        skipCollisionLogic = entity:handle_collisions(collider)
    else
        local skipEntity = entity:handle_collision(collider, true)
        local skipCollider = collider:handle_collision(entity, false)
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

local s_PlayerObjects = Table.CreateDictionary({
    EntityType.ENTITY_PLAYER, EntityType.ENTITY_TEAR, EntityType.ENTITY_FAMILIAR,
    EntityType.ENTITY_KNIFE, EntityType.ENTITY_BOMB, EntityType.ENTITY_BLOOD_PUPPY,
    EntityType.ENTITY_DARK_ESAU, EntityType.ENTITY_POOP
})

---@param entity Decomp.Object.Entity
---@return boolean
local function is_player_object(entity)
    local object = entity.object
    if not not s_PlayerObjects[object.Type] then
        return true
    end

    ---@cast object EntityProjectile
    if object.Type == EntityType.ENTITY_PROJECTILE and entity.entityType == Enums.eBasicEntityType.PROJECTILE and object:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
        return true
    end

    ---@cast object Entity
    if object:IsEnemy() and object:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY) then
        return true
    end

    return false
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return boolean skipCollisionLogic
local function HandleCollisions(entity, collider)
    local object = entity.object
    local colliderObject = collider.object
    if object:IsDead() or colliderObject:IsDead() then
        return true
    end

    local entityCollisionClass = object.EntityCollisionClass
    local colliderCollisionClass = colliderObject.EntityCollisionClass

    if should_collide_with_all(object, entityCollisionClass) then
        entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end
    if should_collide_with_all(colliderObject, colliderCollisionClass) then
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
       (colliderCollisionClass == EntityCollisionClass.ENTCOLL_PLAYERONLY and object.Type ~= EntityType.ENTITY_PLAYER) then
        return true
    end

    if (entityCollisionClass == EntityCollisionClass.ENTCOLL_ENEMIES and not colliderObject:IsEnemy()) or
       (colliderCollisionClass == EntityCollisionClass.ENTCOLL_ENEMIES and not object:IsEnemy()) then
        return true
    end

    local skipEntity = entity:handle_collision(collider, true)
    local skipCollider = collider:handle_collision(entity, false)
    return skipEntity or skipCollider
end

---@class Decomp.Entity.Collision
---@field impulse Vector
---@field entityImpulseRatio number
---@field colliderImpulseRatio number
---@field collisionPoint Vector

---@class Decomp.Entity.CircleCollision : Decomp.Entity.Collision
---@field radiiSum number
---@field direction Vector
---@field distance number
---@field relativeVelocity Vector
---@field relativeSpeed number

---@class Decomp.Entity.CapsuleCollision : Decomp.Entity.Collision
---@field relativeSpeed number

---@param entity Decomp.Object.Entity
---@param other Decomp.Object.Entity
---@return Decomp.Object.Entity first
---@return Decomp.Object.Entity second
local function sort_collision_order(entity, other)
    local first, second = entity, other
    local object, colliderObject = entity.object, other.object

    if (true or object.Type ~= EntityType.ENTITY_TEAR or object.Type ~= EntityType.ENTITY_PLAYER) and
       colliderObject.Type < object.Type then
        first = other
        second = entity
    end

    return first, second
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return number entityImpulseRatio
---@return number colliderImpulseRatio
local function get_collision_impulse_ratios(entity, collider)
    local entityMass = entity:get_collision_mass(collider)
    local colliderMass = collider:get_collision_mass(entity)

    local totalMass = entityMass + colliderMass
    return entityMass / totalMass, colliderMass / totalMass
end

---@param collisionData Decomp.Entity.CircleCollision
local function get_circle_collision_point(collisionData)
    local penetrationDepth = (collisionData.radiiSum - collisionData.distance) / collisionData.distance
    return collisionData.direction * penetrationDepth
end

---@param collisionData Decomp.Entity.CircleCollision
---@return boolean
local function does_collision_bounce(collisionData)
    if not (collisionData.relativeSpeed > 0.5 * collisionData.radiiSum) then -- Not fast enough
        return false
    end

    if not (collisionData.relativeVelocity:Dot(collisionData.direction) < 0.0) then -- Not moving towards each other
        return false
    end

    return true
end

---@param collisionData Decomp.Entity.CircleCollision
---@return Vector direction
local function collision_bounce(collisionData)
    local project = collisionData.direction:Normalized():Dot(collisionData.relativeVelocity:Normalized())
    return collisionData.direction + 2 * project * collisionData.direction
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return Decomp.Entity.CircleCollision
local function prepare_circle_collision_data(entity, collider)
    local object, colliderObject = entity.object, collider.object
    ---@type Decomp.Entity.CircleCollision
---@diagnostic disable-next-line: missing-fields
    local collisionData = {}

    collisionData.radiiSum = object.Size + colliderObject.Size
    collisionData.direction = colliderObject.Position - object.Position
    collisionData.distance = collisionData.direction:Length()
    collisionData.relativeVelocity = colliderObject.Velocity - object.Velocity
    collisionData.relativeSpeed = collisionData.relativeVelocity:Length()

    if does_collision_bounce(collisionData) then
        collisionData.direction = collision_bounce(collisionData)
        collisionData.distance = collisionData.direction:Length()
    end

    collisionData.entityImpulseRatio, collisionData.colliderImpulseRatio = get_collision_impulse_ratios(entity, collider)
    collisionData.collisionPoint = get_circle_collision_point(collisionData)

    if object.Type == EntityType.ENTITY_PLAYER or (object.Type == EntityType.ENTITY_FAMILIAR and object.Variant == FamiliarVariant.PUNCHING_BAG) then
        local predictedPositionChange = -1.0 * collisionData.collisionPoint * collisionData.colliderImpulseRatio
        if entity:WillPlayerCollideWithGrid(predictedPositionChange) then
            collisionData.colliderImpulseRatio = 0.0
            collisionData.entityImpulseRatio = 1.0
        end
    end

    if object.Type == EntityType.ENTITY_PLAYER then
        collisionData.colliderImpulseRatio = collisionData.colliderImpulseRatio * 0.5
    end

    collisionData.impulse = (collisionData.direction / collisionData.distance) * collisionData.relativeSpeed
    return collisionData
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@param collisionPoint Vector
---@return Decomp.Entity.CapsuleCollision
local function prepare_capsule_collision_data(entity, collider, collisionPoint)
    local object, colliderObject = entity.object, collider.object
    ---@type Decomp.Entity.CapsuleCollision
---@diagnostic disable-next-line: missing-fields
    local collisionData = {}

    collisionData.collisionPoint = collisionPoint
    collisionData.relativeSpeed = (colliderObject.Velocity - object.Velocity):Length()

    collisionData.entityImpulseRatio, collisionData.colliderImpulseRatio = get_collision_impulse_ratios(entity, collider)
    collisionData.impulse = collisionPoint:Normalized() * collisionData.relativeSpeed
    return collisionData
end

---@param collisionData Decomp.Entity.CircleCollision
local function play_colliding_singe_balls_sound(collisionData)
    local volume = math.min(collisionData.relativeSpeed * 0.05 + 0.2, 1.2)
    local pitch = RNG.SeedToFloatInclusive(Random()) * 0.2 + 0.9
    Class.Manager.PlaySound(SoundEffect.SOUND_STONE_IMPACT, volume, 2, false, pitch)
end

---@param entity Entity
---@param collisionData Decomp.Entity.Collision
---@param isCollider boolean
local function apply_physic_knockback(entity, collisionData, isCollider)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
        return
    end

    local knockbackScale = 1.0
    local direction = isCollider and 1.0 or -1.0
    local receivingImpulseRatio = isCollider and collisionData.entityImpulseRatio or collisionData.colliderImpulseRatio

    if entity.Type == EntityType.ENTITY_PLAYER and Class.Room.IsBeastDungeon(g_Game:GetRoom()) then
        knockbackScale = 0.25
    else
        entity.Position = entity.Position + (collisionData.collisionPoint * receivingImpulseRatio) * direction
    end

    entity.Velocity = entity.Velocity + (collisionData.impulse * receivingImpulseRatio * knockbackScale) * direction
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@param distance number
local function post_circle_collision(entity, collider, distance)
    local object, colliderObject = entity.object, collider.object

    entity.m_CollidesWithNonTearEntity = colliderObject.Type ~= EntityType.ENTITY_TEAR
    collider.m_CollidesWithNonTearEntity = object.Type ~= EntityType.ENTITY_TEAR

    if distance < 1e-4 then
        return
    end

    local collisionData = prepare_circle_collision_data(entity, collider)

    if (object.Type == EntityType.ENTITY_SINGE and object.Variant == 1) and (colliderObject.Type == EntityType.ENTITY_SINGE and colliderObject.Variant == 1) then
        play_colliding_singe_balls_sound(collisionData)
    end

    apply_physic_knockback(object, collisionData, false)
    apply_physic_knockback(colliderObject, collisionData, true)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@param collisionPoint Vector
local function post_capsule_collision(entity, collider, collisionPoint)
    if Math.IsVectorEqual(collisionPoint, Math.VectorZero) then
        return
    end

    local collisionData = prepare_capsule_collision_data(entity, collider, collisionPoint)
    apply_physic_knockback(entity.object, collisionData, false)
    apply_physic_knockback(collider.object, collisionData, true)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return boolean collided
local function CollideCircles(entity, collider)
    entity, collider = sort_collision_order(entity, collider)
    local entityCircle = entity:GetCollisionCircle(Math.VectorZero)
    local colliderCircle = collider:GetCollisionCircle(Math.VectorZero)

    local collided, distance = Math.Circle.Collide(entityCircle, colliderCircle)
    if not collided then
        return false
    end

    if entity:handle_collisions(collider) then
        return false
    end

    post_circle_collision(entity, collider, distance)
    return true
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return boolean collided
local function CollideCapsules(entity, collider)
    entity, collider = sort_collision_order(entity, collider)
    local object = entity.object
    local colliderObject = collider.object

    local entityCapsule = object:GetCollisionCapsule(Math.VectorZero)
    local colliderCapsule = colliderObject:GetCollisionCapsule(Math.VectorZero)

    local collisionPoint = Vector(0, 0)
    if not entityCapsule:Collide(colliderCapsule, collisionPoint) then
        return false
    end

    if entity:handle_collisions(collider) then
        return false
    end

    post_capsule_collision(entity, collider, collisionPoint)
    return true
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
local function Collide(entity, collider)
    local object = entity.object
    if Math.IsVectorEqual(object.SizeMulti, Math.VectorOne) and Math.IsVectorEqual(object.SizeMulti, Math.VectorOne) then
        entity:collide_circles(collider)
    else
        entity:collide_capsules(collider)
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

---@param player EntityPlayer
---@param collider Entity
---@param mass number
---@return number newMass
local function get_player_collision_mass(player, collider, mass)
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

local s_EnemyReducedCollisionMassSet = Table.CreateDictionary({
    EntityType.ENTITY_BOOMFLY, EntityType.ENTITY_PIN, EntityType.ENTITY_KNIGHT,
    EntityType.ENTITY_FLOATING_KNIGHT, EntityType.ENTITY_SWARMER, EntityType.ENTITY_CHARGER,
    EntityType.ENTITY_MOVABLE_TNT, EntityType.ENTITY_POOP, EntityType.ENTITY_LEECH,
    EntityType.ENTITY_BONE_KNIGHT
})

---@param entity Entity
local function has_enemy_reduced_tear_collision_mass(entity)
    return not not s_EnemyReducedCollisionMassSet[entity.Type]
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return number mass
local function GetCollisionMass(entity, collider)
    local object = entity.object
    local colliderObject = collider.object

    local mass = object.Mass

    if object:HasEntityFlags(EntityFlag.FLAG_MAGNETIZED) and colliderObject:IsEnemy() then
        mass = mass * 10.0
    end

    if object.Type == EntityType.ENTITY_PLAYER and entity.entityType == Enums.eBasicEntityType.PLAYER then
        ---@cast object EntityPlayer
        mass = get_player_collision_mass(object, colliderObject, mass)
    end

    if object:IsEnemy() and (colliderObject.Type == EntityType.ENTITY_TEAR or colliderObject.Type == EntityType.ENTITY_LASER) and has_enemy_reduced_tear_collision_mass(object) then
        mass = mass * 100.0
    end

    return mass
end

--#endregion

--#region Module

---@class Decomp.Class.Entity.API
local API = {}

---@class Decomp.Class.Entity : Decomp.Interface.EntityCreate
local Class_Entity = {
    constructor = constructor,
    API = API
}

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@param low boolean
---@return boolean
function API.handle_collision(entity, collider, low)
    -- TODO
end

---@return boolean forcedCollision
function API.IsForcedCollision()
    return IsForcedCollision()
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@param force boolean
---@return boolean skipCollisionLogic
function API.ForceCollide(entity, collider, force)
    return ForceCollide(entity, collider, force)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
function API.Collide(entity, collider)
    Collide(entity, collider)
end

---@param entity Decomp.Object.Entity
---@param unk boolean
function API.PlayerCollideWithGrid(entity, unk)
    -- TODO
end

---@param entity Decomp.Object.Entity
---@param unk boolean
function API.CollideWithGrid(entity, unk)
   -- TODO 
end

---@param entity Decomp.Object.Entity
---@param positionChange Vector
---@return boolean
function API.WillPlayerCollideWithGrid(entity, positionChange)
    -- TODO
end

---@param entity Decomp.Object.Entity
---@param offset Vector
---@return Decomp.Math.Circle.Data
function API.GetCollisionCircle(entity, offset)
    return GetCollisionCircle(entity, offset)
end

---@param entity Decomp.Object.Entity
---@param offset Vector
---@return Capsule
function API.GetCollisionCapsule(entity, offset)
    return GetCollisionCapsule(entity, offset)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return boolean collided
function API.collide_circles(entity, collider)
    return CollideCircles(entity, collider)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return boolean collided
function API.collide_capsules(entity, collider)
    return CollideCapsules(entity, collider)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return boolean skipCollisionLogic
function API.handle_collisions(entity, collider)
    return HandleCollisions(entity, collider)
end

---@param entity Decomp.Object.Entity
---@param collider Decomp.Object.Entity
---@return number mass
function API.get_collision_mass(entity, collider)
    return GetCollisionMass(entity, collider)
end

--#endregion