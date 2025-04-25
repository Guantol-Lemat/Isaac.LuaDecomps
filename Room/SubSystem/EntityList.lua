---@class Decomp.Room.SubSystem.EntityList
local EntityList = {}
Decomp.Room.SubSystem.EntityList = EntityList

---@class Decomp.Class.EntityList.EL
local EL = {}
EntityList.EL = EL

require("Entity.Entity")
require("Room.SubSystem.CellSpace")
require("Lib.EntityPlayer")

local CellSpace = Decomp.Class.CellSpace
local Class = Decomp.Class
local Lib = Decomp.Lib

local g_Game = Game()

---@class Decomp.Class.EntityList.Data
---@field m_FamiliarPartition Decomp.Class.CellSpace.Data
---@field m_TearPartition Decomp.Class.CellSpace.Data
---@field m_EnemyPartition Decomp.Class.CellSpace.Data
---@field m_BulletPartition Decomp.Class.CellSpace.Data
---@field m_PickupPartition Decomp.Class.CellSpace.Data
---@field m_PlayerPartition Decomp.Class.CellSpace.Data
---@field m_PickupInteractionEnemyPartition Decomp.Class.CellSpace.Data
---@field m_AllyEnemyPartition Decomp.Class.CellSpace.Data
---@field m_MainEL Decomp.Class.EntityList.EL.Data
---@field m_PersistentEL Decomp.Class.EntityList.EL.Data
---@field m_RoomEL Decomp.Class.EntityList.EL.Data
---@field m_RenderEL Decomp.Class.EntityList.EL.Data
---@field m_EffectEL Decomp.Class.EntityList.EL.Data
---@field m_CollisionMap boolean[] @Tracks if a pair of collision indexes has collided, in order to avoid triggering collision twice.
---@field m_CollisionMapWidth integer

---@class Decomp.Class.EntityList.EL.Data
---@field m_IsSubList boolean
---@field m_Data Entity[]
---@field m_Capacity integer
---@field m_Size integer

local function switch_break()
end

--#region EL

---@param el Decomp.Class.EntityList.EL.Data
---@param entity Entity
local function EL_push_back(el, entity)
    if el.m_Capacity < el.m_Size + 1 then
        Isaac.DebugString("[ASSERT] EL: not enough space for push_back")
    end

    el.m_Data[el.m_Size] = entity
    el.m_Size = el.m_Size + 1
end

--#endregion

---@param partition Decomp.Class.CellSpace.Data
local function reset_partition(partition)
    for i = 1, #partition.m_Cells, 1 do
        partition.m_Cells[i].m_EntityCount = 0
    end
end

---@param entityList Decomp.Class.EntityList.Data
local function reset_partitions(entityList)
    entityList.m_EffectEL.m_Size = 0
    reset_partition(entityList.m_FamiliarPartition)
    reset_partition(entityList.m_TearPartition)
    reset_partition(entityList.m_EnemyPartition)
    reset_partition(entityList.m_BulletPartition)
    reset_partition(entityList.m_PickupPartition)
    reset_partition(entityList.m_PlayerPartition)
    reset_partition(entityList.m_PickupInteractionEnemyPartition)
    reset_partition(entityList.m_AllyEnemyPartition)
end

---@class Decomp.EntityList.CollisionData
---@field shouldCollideTearsProjectile boolean

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_familiar_in_partition(entityList, entity, io)
    if entity.Variant == FamiliarVariant.CUBE_BABY then
        CellSpace.insert(entityList.m_EnemyPartition, entity)
        CellSpace.insert(entityList.m_AllyEnemyPartition, entity)
        return true
    end

    CellSpace.insert(entityList.m_FamiliarPartition, entity)
    return true
end

---@param projectile EntityProjectile
---@return boolean
local function should_projectile_force_tear_projectile_collision(projectile)
    return projectile:HasProjectileFlags(ProjectileFlags.SHIELDED)
end

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_projectile_in_partition(entityList, entity, io)
    CellSpace.insert(entityList.m_BulletPartition, entity)
    local projectile = entity:ToProjectile()
    if not projectile then
        return true
    end

    io.shouldCollideTearsProjectile = io.shouldCollideTearsProjectile or should_projectile_force_tear_projectile_collision(projectile)
    if projectile:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
        CellSpace.insert(entityList.m_PlayerPartition, entity)
    end

    return true
end

---@param tear EntityTear?
---@return boolean
local function should_tear_force_tear_projectile_collision(tear)
    return not not tear and tear:HasTearFlags(TearFlags.TEAR_SHIELDED)
end

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_tear_in_partition(entityList, entity, io)
    local tear = entity:ToTear()

    io.shouldCollideTearsProjectile = io.shouldCollideTearsProjectile or should_tear_force_tear_projectile_collision(tear)
    CellSpace.insert(entityList.m_TearPartition, entity)
    return true
end

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_pickup_in_partition(entityList, entity, io)
    CellSpace.insert(entityList.m_PickupPartition, entity)
    return true
end

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_player_in_partition(entityList, entity, io)
    if entity:IsEnemy() then -- Only in DeathMatch
        CellSpace.insert(entityList.m_EnemyPartition, entity)
    end

    return true -- Considered inserted even if not inserted
end

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_effect_in_partition(entityList, entity, io)
    EL.push_back(entityList.m_EffectEL, entity)
    return true
end

---@param entity Entity
---@return boolean
local function entity_is_grid_destroyer(entity)
    if entity.Type == EntityType.ENTITY_BOMB and (entity.Variant == BombVariant.BOMB_ROCKET or entity.Variant == BombVariant.BOMB_ROCKET_GIGA) then
        return true
    end

    if entity.Type == EntityType.ENTITY_ULTRA_GREED or entity.Type == EntityType.ENTITY_BUMBINO then
        return true
    end

    return false
end

---@param entity Entity
---@return boolean
local function entity_is_ally(entity)
    if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_BAITED) then
        return true
    end

    if entity.Type == EntityType.ENTITY_POOP or entity.Type == EntityType.ENTITY_FROZEN_ENEMY then
        return true
    end

    if entity.Type == EntityType.ENTITY_BLOOD_PUPPY or entity.Type == EntityType.ENTITY_DARK_ESAU then
        return true
    end

    return false
end

---@param entityList Decomp.Class.EntityList.Data
---@param entity Entity
---@param io Decomp.EntityList.CollisionData
---@return boolean?
local function insert_generic_entity_in_partition(entityList, entity, io)
    if not (entity.Type == EntityType.ENTITY_BOMB or entity:IsEnemy()) then
        return false
    end

    CellSpace.insert(entityList.m_EnemyPartition, entity)

    if entity_is_grid_destroyer(entity) then
        CellSpace.insert(entityList.m_PickupInteractionEnemyPartition, entity)
    end

    if entity_is_ally(entity) then
        CellSpace.insert(entityList.m_AllyEnemyPartition, entity)
    end

    return true
end

local switch_InsertInPartition = {
    [EntityType.ENTITY_FAMILIAR] = insert_familiar_in_partition,
    [EntityType.ENTITY_PROJECTILE] = insert_projectile_in_partition,
    [EntityType.ENTITY_TEAR] = insert_tear_in_partition,
    [EntityType.ENTITY_KNIFE] = insert_tear_in_partition,
    [EntityType.ENTITY_PICKUP] = insert_pickup_in_partition,
    [EntityType.ENTITY_SLOT] = insert_pickup_in_partition,
    [EntityType.ENTITY_PLAYER] = insert_player_in_partition,
    [EntityType.ENTITY_EFFECT] = insert_effect_in_partition,
    default = insert_generic_entity_in_partition,
}

---@param entityList Decomp.Class.EntityList.Data
---@return Decomp.EntityList.CollisionData
local function prepare_collision_data(entityList)
    reset_partitions(entityList)

    ---@type Decomp.EntityList.CollisionData
    local io = {
        shouldCollideTearsProjectile = false,
    }

    local insertCount = 0

    for i = 1, entityList.m_RoomEL.m_Size, 1 do
        local entity = entityList.m_RoomEL.m_Data[i]
        local entityData = Class.Entity.GetData(entity)
        entityData.m_CollidesWithNonTearEntity = false

        if entity.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then
            goto continue
        end

        local InsertInPartition = switch_InsertInPartition[entity.Type] or switch_InsertInPartition.default
        if InsertInPartition(entityList, entity, io) then
            entityData.m_CollisionIndex = insertCount
            insertCount = insertCount + 1
        end

        ::continue::
    end

    entityList.m_CollisionMap = {}
    for i = 1, insertCount * insertCount, 1 do
        entityList.m_CollisionMap[i] = false
    end
    entityList.m_CollisionMapWidth = insertCount

    return io
end

---@param partition Decomp.Class.CellSpace.Data
local function collide_players(partition)
    for i = 0, g_Game:GetNumPlayers() - 1, 1 do
        local player = Isaac.GetPlayer(i)
        CellSpace.collide_entity(partition, player)
    end
end

---@param player EntityPlayer
local function collide_player_twin(player)
    local twin = player:GetOtherTwin()
    if not twin then
        return
    end

    if not Lib.EntityPlayer.IsMainTwin(player) then
        return
    end

    if g_Game:GetFrameCount() % 2 == 0 then
        Class.Entity.Collide(player, twin)
        Class.Entity.Collide(twin, player)
    else
        Class.Entity.Collide(twin, player)
        Class.Entity.Collide(player, twin)
    end
end

local function collide_twin_players()
    for i = 0, g_Game:GetNumPlayers() - 1, 1 do
        local player = Isaac.GetPlayer(i)
        collide_player_twin(player)
    end
end

---@param entityList Decomp.Class.EntityList.Data
---@param collisionData Decomp.EntityList.CollisionData
local function collide_entities_with_entities(entityList, collisionData)
    if false then -- In DeathMatch
        CellSpace.collide(entityList.m_FamiliarPartition, entityList.m_TearPartition)
        CellSpace.collide(entityList.m_TearPartition, entityList.m_TearPartition)
    end

    CellSpace.collide(entityList.m_FamiliarPartition, entityList.m_BulletPartition)
    CellSpace.collide(entityList.m_FamiliarPartition, entityList.m_EnemyPartition)
    collide_players(entityList.m_FamiliarPartition)
    CellSpace.collide(entityList.m_TearPartition, entityList.m_EnemyPartition)
    CellSpace.collide_self(entityList.m_EnemyPartition)
    collide_players(entityList.m_EnemyPartition)
    collide_players(entityList.m_BulletPartition)
    collide_players(entityList.m_PickupPartition)

    if false then -- In DeathMatch
        collide_players(entityList.m_TearPartition)
    end

    CellSpace.collide_self(entityList.m_PickupPartition)
    CellSpace.collide(entityList.m_PickupPartition, entityList.m_PickupInteractionEnemyPartition)
    CellSpace.collide(entityList.m_PlayerPartition, entityList.m_EnemyPartition)

    if collisionData.shouldCollideTearsProjectile then
        CellSpace.collide(entityList.m_BulletPartition, entityList.m_TearPartition)
    end

    CellSpace.collide(entityList.m_AllyEnemyPartition, entityList.m_BulletPartition)
    CellSpace.collide(entityList.m_AllyEnemyPartition, entityList.m_EnemyPartition)

    collide_twin_players()
end

---@param entity Entity
local function collide_grid(entity)
    if entity.Type == EntityType.ENTITY_LASER then
        return
    end

    if entity.Type == EntityType.ENTITY_PLAYER then
        Class.Entity.PlayerCollideWithGrid(entity, false)
    else
        Class.Entity.CollideWithGrid(entity, false)
    end
end

---@param entityList Decomp.Class.EntityList.Data
local function collide_entities_with_grid(entityList)
    for i = 1, entityList.m_RoomEL.m_Size, 1 do
        collide_grid(entityList.m_RoomEL.m_Data[i])
    end
end

---@param entityList Decomp.Class.EntityList.Data
local function Collide(entityList)
    local collisionData = prepare_collision_data(entityList)
    collide_entities_with_entities(entityList, collisionData)
    collide_entities_with_grid(entityList)
end

--#region Module

---@param el Decomp.Class.EntityList.EL.Data
---@param entity Entity
function EL.push_back(el, entity)
    EL_push_back(el, entity)
end

---@param entityList Decomp.Class.EntityList.Data
function EntityList.collide(entityList)
    Collide(entityList)
end

--#endregion