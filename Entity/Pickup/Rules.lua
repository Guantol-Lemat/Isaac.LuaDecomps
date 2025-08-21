--#region Dependencies

local TableUtils = require("General.Table")
local SeedsUtils = require("Admin.Seeds.Utils")
local LevelRules = require("Level.Rules")

--#endregion

---@class PickupRules
local Module = {}

local NON_REROLLABLE = TableUtils.CreateDictionary({
    PickupVariant.PICKUP_BED, PickupVariant.PICKUP_TROPHY, PickupVariant.PICKUP_BIGCHEST,
    PickupVariant.PICKUP_THROWABLEBOMB, PickupVariant.PICKUP_MOMSCHEST
})

---@param context Context
---@param variant PickupVariant | integer
---@param subtype integer
---@param canReroll boolean
---@return boolean
local function hook_can_reroll(context, variant, subtype, canReroll)
    if NON_REROLLABLE(variant) then
        return false
    end

    if variant == PickupVariant.PICKUP_COLLECTIBLE and subtype == CollectibleType.COLLECTIBLE_DADS_NOTE then
        return false
    end

    local seeds = context:GetSeeds()
    if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL) and variant == PickupVariant.PICKUP_COLLECTIBLE and subtype == -1 then
        return false
    end

    return canReroll
end

---@param context Context
---@param variant PickupVariant | integer
---@param subtype integer
---@return boolean
local function CanReroll(context, variant, subtype)
    local canReroll = true
    canReroll = hook_can_reroll(context, variant, subtype, canReroll)
    return canReroll
end

---@param context Context
---@param isBlind boolean
---@return boolean
local function hook_is_blind_effect_active(context, isBlind)
    local level = context:GetLevel()
    if level.m_dimension == Dimension.DEATH_CERTIFICATE then
        return false
    end

    if LevelRules.HasCurses(context, level, LevelCurse.CURSE_OF_BLIND) then
        return true
    end

    return isBlind
end

---@param context Context
---@return boolean
local function IsBlindEffectActive(context)
    local isBlind = false
    isBlind = hook_is_blind_effect_active(context, isBlind)
    return isBlind
end

---@param context Context
---@param entity EntityPickupComponent
---@param type EntityType | integer
---@param variant PickupVariant | integer
---@param subtype integer
---@param keepPrice boolean
---@param keepSeed boolean
---@param ignoreModifiers boolean
local function Morph(context, entity, type, variant, subtype, keepPrice, keepSeed, ignoreModifiers)

end

--#region Module

Module.CanReroll = CanReroll
Module.IsBlindEffectActive = IsBlindEffectActive
Module.Morph = Morph

--#endregion

return Module