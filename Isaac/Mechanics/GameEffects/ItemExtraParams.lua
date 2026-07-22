--#region Dependencies

local TableUtils = require("General.Table")

--#endregion

local PROCEDURAL_USE_ACTIVE_BLACKLIST = TableUtils.CreateDictionary({
    CollectibleType.COLLECTIBLE_PLAN_C, CollectibleType.COLLECTIBLE_CLICKER,
    CollectibleType.COLLECTIBLE_BLUE_BOX, CollectibleType.COLLECTIBLE_MYSTERY_GIFT,
    CollectibleType.COLLECTIBLE_FORGET_ME_NOW, CollectibleType.COLLECTIBLE_MAMA_MEGA,
    CollectibleType.COLLECTIBLE_DIPLOPIA, CollectibleType.COLLECTIBLE_ALABASTER_BOX,
    CollectibleType.COLLECTIBLE_EDENS_SOUL, CollectibleType.COLLECTIBLE_R_KEY,
    CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE
})

---@param item Component.ItemConfig.Item
local function BanActiveFromProceduralPool(item)
    return PROCEDURAL_USE_ACTIVE_BLACKLIST[item.m_id] ~= nil
end

---@class GameEffects.ItemExtraParams
local Module = {}

--#region Module

Module.BanActiveFromProceduralPool = BanActiveFromProceduralPool

--#endregion

return Module