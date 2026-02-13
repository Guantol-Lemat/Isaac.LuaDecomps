--#region Dependencies

local BitsetUtils = require("General.Bitset")
local TableUtils = require("General.Table")
local EntityUtils = require("Entity.Utils")
local PickupUtils = require("Entity.Pickup.Utils")

--#endregion

---@class RoomEntitySaveStateRules
local Module = {}

---@type Set<PickupVariant>
local PICKUP_BLACKLIST = TableUtils.CreateDictionary({
    PickupVariant.PICKUP_THROWABLEBOMB
})

---@type Set<BombVariant>
local BOMB_BLACKLIST = TableUtils.CreateDictionary({
    BombVariant.BOMB_THROWABLE, BombVariant.BOMB_ROCKET, BombVariant.BOMB_ROCKET_GIGA
})

---@type Set<EffectVariant>
local EFFECT_WHITELIST = TableUtils.CreateDictionary({
    EffectVariant.ISAACS_CARPET, EffectVariant.DICE_FLOOR, EffectVariant.HEAVEN_LIGHT_DOOR,
    EffectVariant.DIRT_PATCH, EffectVariant.SPAWNER
})

---@type Set<EffectVariant>
local ANIMAL_EFFECTS = TableUtils.CreateDictionary({
    EffectVariant.TINY_BUG, EffectVariant.TINY_FLY, EffectVariant.WALL_BUG,
    EffectVariant.WORM, EffectVariant.WISP, EffectVariant.BEETLE,
    EffectVariant.BUTTERFLY, EffectVariant.TADPOLE, EffectVariant.LIL_GHOST,
})

---@param variant integer
---@param subtype integer
---@param spawnerType EntityType | integer
---@param isClear boolean
---@return boolean
local function should_save_effect(variant, subtype, spawnerType, isClear)
    if EFFECT_WHITELIST[variant] then
        return true
    end

    if ANIMAL_EFFECTS[variant] then
        if isClear then
            return true
        end

        if spawnerType == EntityType.ENTITY_NULL then
            return true
        end
    end

    if variant == EffectVariant.SMOKE_CLOUD then
        return spawnerType == EntityType.ENTITY_NULL
    end

    if variant == EffectVariant.PORTAL_TELEPORT then
        return subtype < 899
    end

    return false
end

---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param spawnerType EntityType | integer
---@param isClear boolean
---@return boolean
local function should_save_type(type, variant, subtype, spawnerType, isClear)
    if type == EntityType.ENTITY_SHOPKEEPER then
        return true
    end

    if type == EntityType.ENTITY_FIREPLACE then
        return variant < 10
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
        return isClear and subtype == 1
    end

    if type == EntityType.ENTITY_GENERIC_PROP then
        return true
    end

    return false
end

---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param spawnerType EntityType | integer
---@param isClear boolean
---@return boolean
local function ShouldSaveEntity(type, variant, subtype, spawnerType, isClear)
    if type == EntityType.ENTITY_PICKUP then
        return not PICKUP_BLACKLIST[variant]
    end

    if type == EntityType.ENTITY_BOMB then
        return not BOMB_BLACKLIST[variant]
    end

    if type == EntityType.ENTITY_SLOT then
        return true
    end

    if type == EntityType.ENTITY_EFFECT then
        return should_save_effect(variant, subtype, spawnerType, isClear)
    end

    return should_save_type(type, variant, subtype, spawnerType, isClear)
end

---@param context Context
---@param room RoomComponent
---@param entity EntityComponent
---@param savingMinecartEntity boolean
---@return EntitySaveStateComponent?
local function SaveEntity(context, room, entity, savingMinecartEntity)
    if entity.m_isDead then
        return
    end

    if BitsetUtils.HasAny(entity.m_flags, EntityFlag.FLAG_PERSISTENT) then
        return
    end

    if entity.m_minecart.ref and not savingMinecartEntity then
        return
    end

    local entityType = entity.m_type
    local variant = entity.m_variant
    local subtype = entity.m_subtype
    if not ShouldSaveEntity(entityType, variant, subtype, entity.m_spawnerType, BitsetUtils(room.m_roomDescriptor.m_flags, RoomDescriptor.FLAG_CLEAR)) then
        return
    end

    if entityType == EntityType.ENTITY_PICKUP then
        if (PickupUtils.IsChest(variant) or variant == PickupVariant.PICKUP_COLLECTIBLE) and subtype == 0 then
            return
        end

        if variant == PickupVariant.PICKUP_HAUNTEDCHEST and EntityUtils.HasAnyFlag(entity, EntityFlag.FLAG_THROWN | EntityFlag.FLAG_HELD) then
            return
        end

        -- save pickup
    end

    if entityType == EntityType.ENTITY_SLOT then
        local slot = EntityUtils.ToSlot(entity)
        assert(slot, "Slot is not Slot")

        local state = slot.m_state
        if variant ~= SlotVariant.DONATION_MACHINE and (state == 3 or state == 4) then
            return
        end

        -- save slot
    end

    if entityType == EntityType.ENTITY_BOMB then
        if not entity.m_visible then
            return
        end

        -- save bomb
    end

    if entityType == EntityType.ENTITY_EFFECT then
        if variant == EffectVariant.HEAVEN_LIGHT_DOOR then
            local effect = EntityUtils.ToEffect(entity)
            assert(effect, "Effect is not Effect")

            if subtype == 1 and (effect.m_state < 0 or entity.m_spawnerType ~= EntityType.ENTITY_NULL) then
                return
            end
        end

        -- save effect
    end
end

--#region Module

Module.ShouldSaveEntity = ShouldSaveEntity
Module.SaveEntity = SaveEntity

--#endregion

return Module