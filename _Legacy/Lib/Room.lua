local Lib = {
    Table = require("Lib.Table"),
    Pickup = require("Lib.EntityPickup")
}

local s_NonSavableBombs = Lib.Table.CreateDictionary({
    BombVariant.BOMB_THROWABLE, BombVariant.BOMB_ROCKET, BombVariant.BOMB_ROCKET_GIGA
})

local function is_storing_game_state()
    return false -- cannot be detected
end

local function should_save_bomb(variant)
    if s_NonSavableBombs[variant] then
        return false
    end

    return true
end

local function should_save_pickup(variant)
    return variant ~= PickupVariant.PICKUP_THROWABLEBOMB
end

---@param variant integer
---@param subType integer
---@param spawnerType EntityType
---@return boolean
local function should_save_effect(variant, subType, spawnerType)
    if variant == EffectVariant.SMOKE_CLOUD then
        return spawnerType == EntityType.ENTITY_NULL
    end

    if variant == EffectVariant.PORTAL_TELEPORT then
        return subType > 899 or is_storing_game_state()
    end

    if variant == EffectVariant.TALL_LADDER then
        return subType == 1 and is_storing_game_state()
    end

    return false
end

---@param type EntityType | integer
---@param variant integer
---@param subType integer
---@param spawnerType EntityType | integer
---@param clearedRoom boolean
---@return boolean
local function should_save_npc(type, variant, subType, spawnerType, clearedRoom)
    if type == EntityType.ENTITY_SHOPKEEPER then
        return true
    end

    if type == EntityType.ENTITY_FIREPLACE then
        return variant ~= 10
    end

    if type == EntityType.ENTITY_MOVABLE_TNT then
        return true
    end

    if type == EntityType.ENTITY_PITFALL then
        return spawnerType == EntityType.ENTITY_NULL
    end

    if type == EntityType.ENTITY_MINECART then
        return variant ~= 10
    end

    if type == EntityType.ENTITY_GIDEON then
        return subType ~= 1 and clearedRoom
    end

    if type == EntityType.ENTITY_GENERIC_PROP then
        return true
    end

    return false
end

---@param type EntityType | integer
---@param variant integer
---@param subType integer
---@param spawnerType EntityType | integer
---@param clearedRoom boolean
---@return boolean
local function ShouldSaveEntity(type, variant, subType, spawnerType, clearedRoom)
    if type == EntityType.ENTITY_BOMB then
        return should_save_bomb(variant)
    end

    if type == EntityType.ENTITY_SLOT then
        return true
    end

    if type == EntityType.ENTITY_PICKUP then
        return should_save_pickup(variant)
    end

    if type == EntityType.ENTITY_EFFECT then
        return should_save_effect(variant, subType, spawnerType)
    end

    return should_save_npc(type, variant, subType, spawnerType, clearedRoom)
end

---@param room Room
---@param entityObject Decomp.Object.Entity
---@param minecartEntity boolean
local function ShouldSaveEntityInList(room, entityObject, minecartEntity)
    local entity = entityObject.object

    if entity:GetMinecart() and not minecartEntity then
        return false
    end

    if not ShouldSaveEntity(entity.Type, entity.Variant, entity.SubType, entity.SpawnerType, room:IsClear()) then
        return false
    end

    if not entityObject:should_save() then
        return false
    end

    return true
end