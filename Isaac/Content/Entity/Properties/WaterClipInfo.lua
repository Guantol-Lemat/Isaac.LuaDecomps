--#region Dependencies

local G = require("Isaac.Global")

local ISprite = require("Isaac.Interface.ANM2")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")

--#endregion

local FLAG_0 = 1 << 0
local DISABLE_ABOVE = WaterClipFlag.DISABLE_RENDER_ABOVE_WATER
local ENABLE_BELOW = WaterClipFlag.ENABLE_RENDER_BELOW_WATER
local DISABLE_BELOW = WaterClipFlag.DISABLE_RENDER_BELOW_WATER
local FLAG_4 = 1 << 4
local DISABLE_REFLECTION = WaterClipFlag.DISABLE_RENDER_REFLECTION
local ABOVE_ONLY = WaterClipFlag.IGNORE_WATER_RENDERING
local FORCE_RIPPLE = WaterClipFlag.FORCE_WATER_RIPPLE_WHEN_MOVING

local DEFAULT_FLAGS = FLAG_0 | DISABLE_BELOW | FLAG_4

---@class Entity.Properties.WaterClipInfoDesc
---@field beforeSortingLayer boolean
---@field value Component.WaterClipInfo?
---@field op (fun(entity: Component.Entity): Component.WaterClipInfo?)?

---@param type EntityType | integer
---@param variant integer?
---@param subtype integer?
---@return string
local function get_hash(type, variant, subtype)
    local hash = tostring(type)
    if variant then
        hash = hash .. ":" .. tostring(variant)
        if subtype then
            hash = hash .. ":" .. tostring(subtype)
        end
    end

    return hash
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function Player_GetWaterClipInfo(entity)
    ---@cast entity Component.Entity.Player
    local noReflection = IEntityPlayer.HasCollectible(entity, CollectibleType.COLLECTIBLE_CHARM_VAMPIRE, false)

    if noReflection then
        ---@type Component.WaterClipInfo
        return {
            flags = DEFAULT_FLAGS | DISABLE_REFLECTION,
            float = -2.0
        }
    end

    if IEntity.IsFlying(entity) then
        ---@type Component.WaterClipInfo
        return {
            flags = DEFAULT_FLAGS,
            float = 0.0
        }
    end
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function Pickup_GetWaterClipInfo(entity)
    ---@cast entity Component.Entity.Pickup
    if IEntityPickup.IsShopItem(entity) then
        ---@type Component.WaterClipInfo
        return {
            flags = ABOVE_ONLY,
            float = 0.0
        }
    end

    if entity.m_variant == PickupVariant.PICKUP_COLLECTIBLE then
        local nonDefaultPedestal = not IEntityPickup.IsShopItem(entity)
            and ISprite.GetOverlayFrame(entity.m_sprite) ~= PedestalType.DEFAULT

        if nonDefaultPedestal then
            ---@type Component.WaterClipInfo
            return {
                flags = DEFAULT_FLAGS,
                float = -5.0
            }
        end
    end
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function Fireplace_GetWaterClipInfo(entity)
    if entity.m_health <= 1.0 then
        ---@type Component.WaterClipInfo
        return {
            flags = DISABLE_ABOVE | ENABLE_BELOW | DISABLE_REFLECTION,
            float = 0.0
        }
    end
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function SmallLeech_GetWaterClipInfo(entity)
    if entity.m_positionOffset.Y > -3.0 then
        ---@type Component.WaterClipInfo
        return {
            flags = ENABLE_BELOW | DISABLE_REFLECTION,
            float = 0.0
        }
    end
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function Fissure_GetWaterClipInfo(entity)
    if entity.m_positionOffset.Y > 0.0 then
        ---@type Component.WaterClipInfo
        return {
            flags = ENABLE_BELOW | DISABLE_REFLECTION,
            float = 0.0
        }
    end
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function WormWood_GetWaterClipInfo(entity)
    local flags = DEFAULT_FLAGS
    if entity.m_positionOffset.Y >= 0.0 then
        flags = DISABLE_ABOVE | ENABLE_BELOW | DISABLE_REFLECTION
    elseif entity.m_position.Y >= -16.0 then
        flags = FORCE_RIPPLE
    end

    ---@type Component.WaterClipInfo
    return {
        flags = flags,
        float = -2.0
    }
end

---@param entity Component.Entity
---@return Component.WaterClipInfo?
local function Poof1_GetWaterClipInfo(entity)
    local wraithInvisible = entity.m_spawnerType == EntityType.ENTITY_WRAITH
        and not IRoom.IsMirrorWorld(G.Game.m_level.m_room)
    if wraithInvisible then
        ---@type Component.WaterClipInfo
        return {
            flags = DEFAULT_FLAGS | DISABLE_ABOVE,
            float = -2.0
        }
    end
end

---@type Entity.Properties.WaterClipInfoDesc
local BACKGROUND_DESC = {
    beforeSortingLayer = true,
    value = {
        flags = DISABLE_ABOVE | ENABLE_BELOW | DISABLE_REFLECTION,
        float = 0.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local FLOOR_DESC = {
    beforeSortingLayer = true,
    value = {
        flags = ABOVE_ONLY,
        float = 0.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local PRE_DEFAULT_0_DESC = {
    beforeSortingLayer = true,
    value = {
        flags = DEFAULT_FLAGS,
        float = 0.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local PRE_DEFAULT_2_DESC = {
    beforeSortingLayer = true,
    value = {
        flags = DEFAULT_FLAGS,
        float = 2.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local DEFAULT_0_DESC = {
    beforeSortingLayer = false,
    value = {
        flags = DEFAULT_FLAGS,
        float = 0.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local DEFAULT_2_DESC = {
    beforeSortingLayer = false,
    value = {
        flags = DEFAULT_FLAGS,
        float = 2.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local PLAYER_DESC = {
    beforeSortingLayer = false,
    op = Player_GetWaterClipInfo,
}

---@type Entity.Properties.WaterClipInfoDesc
local PICKUP_DESC = {
    beforeSortingLayer = false,
    op = Pickup_GetWaterClipInfo,
}

---@type Entity.Properties.WaterClipInfoDesc
local FIREPLACE_DESC = {
    beforeSortingLayer = false,
    op = Fireplace_GetWaterClipInfo
}

---@type Entity.Properties.WaterClipInfoDesc
local SMALL_LEECH_DESC = {
    beforeSortingLayer = false,
    op = SmallLeech_GetWaterClipInfo
}

---@type Entity.Properties.WaterClipInfoDesc
local STRIDER_DESC = {
    beforeSortingLayer = false,
    value = {
        flags = DEFAULT_FLAGS | FORCE_RIPPLE,
        float = 0.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local SPLURT_DESC = {
    beforeSortingLayer = false,
    value = {
        flags = FORCE_RIPPLE,
        float = 0.0
    }
}

---@type Entity.Properties.WaterClipInfoDesc
local FISSURE_DESC = {
    beforeSortingLayer = false,
    op = Fissure_GetWaterClipInfo
}

---@type Entity.Properties.WaterClipInfoDesc
local WORMWOOD_DESC = {
    beforeSortingLayer = false,
    op = WormWood_GetWaterClipInfo
}

---@type Entity.Properties.WaterClipInfoDesc
local POOF1_DESC = {
    beforeSortingLayer = false,
    op = Poof1_GetWaterClipInfo
}

---@type table<string, Entity.Properties.WaterClipInfoDesc>
local CLASS = {
    [get_hash(EntityType.ENTITY_PLAYER)] = PLAYER_DESC,
    [get_hash(EntityType.ENTITY_TEAR)] = DEFAULT_2_DESC,
    [get_hash(EntityType.ENTITY_PICKUP)] = PICKUP_DESC,
    [get_hash(EntityType.ENTITY_LASER)] = PRE_DEFAULT_2_DESC,
    [get_hash(EntityType.ENTITY_PROJECTILE)] = DEFAULT_2_DESC,
    [get_hash(EntityType.ENTITY_EFFECT)] = DEFAULT_2_DESC,

    [get_hash(EntityType.ENTITY_FAMILIAR, FamiliarVariant.GEMINI)] = DEFAULT_2_DESC,

    [get_hash(EntityType.ENTITY_WALL_CREEP)] = DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_BLIND_CREEP)] = DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_RAGE_CREEP)] = DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_THE_THING)] = DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_FIREPLACE)] = FIREPLACE_DESC,
    [get_hash(EntityType.ENTITY_SMALL_LEECH)] = SMALL_LEECH_DESC,
    [get_hash(EntityType.ENTITY_STRIDER)] = STRIDER_DESC,
    [get_hash(EntityType.ENTITY_DRIP)] = SPLURT_DESC,
    [get_hash(EntityType.ENTITY_SPLURT)] = SPLURT_DESC,
    [get_hash(EntityType.ENTITY_PREY, 1)] = DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_FISSURE)] = FISSURE_DESC,
    [get_hash(EntityType.ENTITY_PIN, 3)] = WORMWOOD_DESC,

    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.WATER_RIPPLE)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.PEDESTAL_RIPPLE)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.MIST)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.WHIRLPOOL, 0)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.TADPOLE)] = BACKGROUND_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.WATER_SPLASH)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.TARGET)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.OCCULT_TARGET)] = FLOOR_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.COLOSTOMIA_PUDDLE)] = PRE_DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.POOF01)] = POOF1_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.POOF02)] = PRE_DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT)] = PRE_DEFAULT_0_DESC,
    [get_hash(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY)] = PRE_DEFAULT_0_DESC,
}

---@param type EntityType | integer 
---@param variant integer
---@param subtype integer
---@return string[]
local function get_hashes(type, variant, subtype)
    local classHash = tostring(type)
    local subClassHash = classHash .. ":" .. tostring(variant)
    local identityHash = subClassHash .. ":" .. tostring(subtype)

    return {classHash, subClassHash, identityHash}
end

---@param hashes string[]
---@param entity Component.Entity
---@param beforeSortingLayer boolean
---@return Component.WaterClipInfo?
local function get_water_clip_info(hashes, entity, beforeSortingLayer)
    for i = 3, 1, -1 do
        local hash = hashes[i]
        local desc = CLASS[hash]
        if not desc then
            goto continue
        end

        if desc.beforeSortingLayer ~= beforeSortingLayer then
            goto continue
        end

        if desc.value then
            return {flags = desc.value.flags, float = desc.value.float}
        else
            local waterClipInfo = desc.op(entity)
            if waterClipInfo then
                return waterClipInfo
            end
        end
        ::continue::
    end
end

---@param entity Component.Entity
---@return Component.WaterClipInfo
local function GetWaterClipInfo(entity)
    local hashes = get_hashes(entity.m_type, entity.m_variant, entity.m_subtype)

    local waterClipInfo = get_water_clip_info(hashes, entity, true)
    if waterClipInfo then
        return waterClipInfo
    end

    local sortingLayer = entity.m_sortingLayer
    if sortingLayer == SortingLayer.SORTING_BACKGROUND then
        ---@type Component.WaterClipInfo
        return {
            flags = DISABLE_ABOVE | ENABLE_BELOW | DISABLE_REFLECTION,
            float = 0.0
        }
    end

    if sortingLayer == SortingLayer.SORTING_DOOR then
        ---@type Component.WaterClipInfo
        return {
            flags = FLAG_0 | ENABLE_BELOW | DISABLE_REFLECTION,
            float = 0.0
        }
    end

    waterClipInfo = get_water_clip_info(hashes, entity, false)
    if waterClipInfo then
        return waterClipInfo
    end

    ---@type Component.WaterClipInfo
    return {
        flags = DEFAULT_FLAGS,
        float = -2.0
    }
end

---@class Content.Entity.Properties.WaterClipInfo
local Module = {}

--#region Module

Module.GetWaterClipInfo = GetWaterClipInfo

--#endregion

return Module