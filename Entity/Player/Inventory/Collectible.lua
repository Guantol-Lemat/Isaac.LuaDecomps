--#region Dependencies

local TemporaryEffectsUtils = require("Items.TemporaryEffects.Utils")

--#endregion

---@class PlayerCollectibleInventory
local Module = {}

---@param context Context
---@param player EntityPlayerComponent
---@param collectible CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
local function HasCollectible(context, player, collectible, ignoreModifiers)
end

---@param context Context
---@param player EntityPlayerComponent
---@param collectible CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
local function HasCollectibleRealOrEffect(context, player, collectible, ignoreModifiers)
    if HasCollectible(context, player, collectible, ignoreModifiers) then
        return true
    end

    if TemporaryEffectsUtils.HasCollectibleEffect(player.m_temporaryEffects, collectible) then
        return true
    end

    return false
end

--#region Module

Module.HasCollectible = HasCollectible
Module.HasCollectibleRealOrEffect = HasCollectibleRealOrEffect

--#endregion

return Module