--#region Dependencies

local EntityUtils = require("Entity.Common.Utils")
local Inventory = require("Entity.Player.Inventory.Inventory")
local PlayerUtils = require("Entity.Player.Utils")

--#endregion

---@class FamiliarRules
local Module = {}

---@param context Context
---@param entity EntityFamiliarComponent
---@param multiplier number
---@return number
local function hook_get_multiplier(context, entity, multiplier)
    local player = entity.m_player
    local hasCollectibleBoost = false

    if entity.m_variant == FamiliarVariant.BLUE_FLY or entity.m_variant == FamiliarVariant.BLUE_SPIDER then
        hasCollectibleBoost = Inventory.HasCollectibleRealOrEffect(context, player, CollectibleType.COLLECTIBLE_HIVE_MIND, false) and EntityUtils.HasAnyConfigTags(entity, EntityTag.FLY | EntityTag.SPIDER)
    else
        hasCollectibleBoost = Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_BFFS, false)
    end

    if hasCollectibleBoost then
        multiplier = 2.0
    end

    if player.m_playerType == PlayerType.PLAYER_BETHANY_B then
        multiplier = multiplier * 0.75
    end

    if PlayerUtils.IsHologram(player) then
        multiplier = multiplier * 0.25
    end

    return multiplier
end

---@param context Context
---@param entity EntityFamiliarComponent
---@return number
local function GetMultiplier(context, entity)
    local multiplier = 1.0
    multiplier = hook_get_multiplier(context, entity, multiplier)
    return multiplier
end

---@param context Context
---@param entity EntityFamiliarComponent
---@return boolean
local function CanBlockProjectiles(context, entity)
end

--#region Module

Module.GetMultiplier = GetMultiplier
Module.CanBlockProjectiles = CanBlockProjectiles

--#endregion

return Module