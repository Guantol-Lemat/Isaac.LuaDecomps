---@class Decomp.Data.EntityFactory
local EntityFactory = {}

---@class Decomp.Data.Entity
local EntityData = {}

---@class Decomp.Interface.EntityCreate
---@field constructor fun(entityData: table)
---@field store_data fun(entityData: table, saveData: table)
---@field restore_data fun(entityData: table, saveData: table)
---@field API table<string, function>

---@class Decomp.Data.EntityBase
---@field object Entity | EntityFamiliar | EntityBomb | EntityPickup | EntitySlot | EntityLaser | EntityKnife | EntityProjectile | EntityNPC | EntityEffect
---@field entityType Decomp.Enum.eBasicEntityType
---@field entityPtr EntityPtr

local Enums = require("General.Enums")
local EntityClass = {
    Entity = require("Entity.Entity"),
    Player = require("Entity.EntityPlayer"),
    Familiar = require("Entity.EntityFamiliar"),
    Bomb = require("Entity.EntityBomb"),
    Pickup = require("Entity.EntityPickup"),
    Slot = require("Entity.EntitySlot"),
    Laser = require("Entity.EntityLaser"),
    Knife = require("Entity.EntityKnife"),
    Projectile = require("Entity.EntityProjectile"),
    NPC = require("Entity.EntityNPC"),
    Effect = require("Entity.EntityEffect"),
    Text = require("Entity.EntityText"),
}

local s_EntityTypeToBasicType = {
    [EntityType.ENTITY_PLAYER] = Enums.eBasicEntityType.PLAYER,
    [EntityType.ENTITY_TEAR] = Enums.eBasicEntityType.TEAR,
    [EntityType.ENTITY_FAMILIAR] = Enums.eBasicEntityType.FAMILIAR,
    [EntityType.ENTITY_BOMB] = Enums.eBasicEntityType.BOMB,
    [EntityType.ENTITY_PICKUP] = Enums.eBasicEntityType.PICKUP,
    [EntityType.ENTITY_SLOT] = Enums.eBasicEntityType.SLOT,
    [EntityType.ENTITY_LASER] = Enums.eBasicEntityType.LASER,
    [EntityType.ENTITY_KNIFE] = Enums.eBasicEntityType.KNIFE,
    [EntityType.ENTITY_PROJECTILE] = Enums.eBasicEntityType.PROJECTILE,
    [EntityType.ENTITY_EFFECT] = Enums.eBasicEntityType.EFFECT,
    [EntityType.ENTITY_TEXT] = Enums.eBasicEntityType.TEXT,
}

---@type Entity
local luaEntityClass = Entity.__class

---@type table<Decomp.Enum.eBasicEntityType, function?>
local s_BasicTypeToCastFunction = {
    [Enums.eBasicEntityType.ENTITY] = nil,
    [Enums.eBasicEntityType.PLAYER] = luaEntityClass.ToPlayer,
    [Enums.eBasicEntityType.TEAR] = luaEntityClass.ToTear,
    [Enums.eBasicEntityType.FAMILIAR] = luaEntityClass.ToFamiliar,
    [Enums.eBasicEntityType.BOMB] = luaEntityClass.ToBomb,
    [Enums.eBasicEntityType.PICKUP] = luaEntityClass.ToPickup,
    [Enums.eBasicEntityType.SLOT] = luaEntityClass.ToSlot,
    [Enums.eBasicEntityType.LASER] = luaEntityClass.ToLaser,
    [Enums.eBasicEntityType.KNIFE] = luaEntityClass.ToKnife,
    [Enums.eBasicEntityType.PROJECTILE] = luaEntityClass.ToProjectile,
    [Enums.eBasicEntityType.NPC] = luaEntityClass.ToNPC,
    [Enums.eBasicEntityType.EFFECT] = luaEntityClass.ToEffect,
    [Enums.eBasicEntityType.TEXT] = nil,
}

---@type table<Decomp.Enum.eBasicEntityType, Decomp.Interface.EntityCreate>
local s_BasicTypeToClass = {
    [Enums.eBasicEntityType.ENTITY] = EntityClass.Entity,
    [Enums.eBasicEntityType.PLAYER] = EntityClass.Player,
    [Enums.eBasicEntityType.TEAR] = EntityClass.Tear,
    [Enums.eBasicEntityType.FAMILIAR] = EntityClass.Familiar,
    [Enums.eBasicEntityType.BOMB] = EntityClass.Bomb,
    [Enums.eBasicEntityType.PICKUP] = EntityClass.Pickup,
    [Enums.eBasicEntityType.SLOT] = EntityClass.Slot,
    [Enums.eBasicEntityType.LASER] = EntityClass.Laser,
    [Enums.eBasicEntityType.KNIFE] = EntityClass.Knife,
    [Enums.eBasicEntityType.PROJECTILE] = EntityClass.Projectile,
    [Enums.eBasicEntityType.NPC] = EntityClass.NPC,
    [Enums.eBasicEntityType.EFFECT] = EntityClass.Effect,
    [Enums.eBasicEntityType.TEXT] = EntityClass.Text,
}

---@param entityType EntityType
---@return Decomp.Enum.eBasicEntityType
local function get_basic_type_from_entity_type(entityType)
    return s_EntityTypeToBasicType[entityType] or Enums.eBasicEntityType.NPC
end

---@param entity Entity
---@return Decomp.Enum.eBasicEntityType
local function get_basic_type_from_cast(entity)
    for key, cast in pairs(s_BasicTypeToCastFunction) do
        if cast(entity) then
            return key
        end
    end

    return Enums.eBasicEntityType.ENTITY
end

---@param entity Entity
---@return Decomp.Enum.eBasicEntityType
local function get_basic_data_type(entity)
    local basicType = get_basic_type_from_entity_type(entity.Type)
    local Cast = s_BasicTypeToCastFunction[basicType]

    if Cast and not Cast(entity) then
        Isaac.DebugString(string.format("[ERROR] EntityFactory: normal cast failed for entity (%d, %d, %d)", entity.Type, entity.Variant, entity.SubType))
        return get_basic_type_from_cast(entity)
    end

    return basicType
end

---@param data table
---@param class Decomp.Interface.EntityCreate
local function apply_class_api(data, class)
    setmetatable(data, {__index = class.API})
end

---@param entity Entity
---@return Decomp.Data.EntityBase
local function Create(entity)
    local basicType = get_basic_data_type(entity)
    local Cast = s_BasicTypeToCastFunction[basicType]

    local object = Cast and Cast(entity) or entity
    local class = s_BasicTypeToClass[basicType] or s_BasicTypeToClass[Enums.eBasicEntityType.ENTITY]

    local data = {object = object, entityType = basicType, entityPtr = EntityPtr(entity)}
    assert(class.constructor, string.format("[ASSERT] EntityFactory: class constructor for entity type %d is nil", basicType))
    class.constructor(data)
    apply_class_api(data, class)

    return data
end

--#region EntityFactory

---@param entity Entity
---@return Decomp.Data.EntityBase
function EntityFactory.Create(entity)
    return Create(entity)
end

--#endregion

---@param entity Entity
---@return table
local function GetData(entity)
    local entityData = entity:GetData()
    local data = entityData.DecompData
    if not data then
        data = EntityFactory.Create(entity)
        entityData.DecompData = data
    end
    return data
end

---@param entity Entity
---@param saveState table
local function SaveData(entity, saveState)
    ---@type Decomp.Data.EntityBase
    local data = GetData(entity)
    local class = s_BasicTypeToClass[data.entityType] or s_BasicTypeToClass[Enums.eBasicEntityType.ENTITY]
    class.store_data(data, saveState)
end

---@param entity Entity
---@param saveState table
local function LoadData(entity, saveState)
    ---@type Decomp.Data.EntityBase
    local data = GetData(entity)
    local class = s_BasicTypeToClass[data.entityType] or s_BasicTypeToClass[Enums.eBasicEntityType.ENTITY]
    class.restore_data(data, saveState)
end

--#region Module

---@param entity Entity
---@return table
function EntityData.GetData(entity)
    return GetData(entity)
end

---@param entity Entity
---@param saveState table
function EntityData.SaveData(entity, saveState)
    SaveData(entity, saveState)
end

---@param entity Entity
---@param saveState table
function EntityData.LoadData(entity, saveState)
    LoadData(entity, saveState)
end

--#endregion

return EntityData