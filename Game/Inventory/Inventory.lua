---#region Dependencies

local TemporaryEffects = require("Entity.Player.Inventory.TemporaryEffects")

---#endregion

---@class PlayerInventory
local Module = {}

---@param context InventoryContext.HasCollectible
---@param player EntityPlayerComponent
---@param collectible CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
local function HasCollectible(context, player, collectible, ignoreModifiers)
end

---@param context InventoryContext.HasCollectible
---@param player EntityPlayerComponent
---@param collectible CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
local function HasCollectibleRealOrEffect(context, player, collectible, ignoreModifiers)
    if HasCollectible(context, player, collectible, ignoreModifiers) then
        return true
    end

    if TemporaryEffects.HasCollectibleEffect(player.m_temporaryEffects, collectible) then
        return true
    end

    return false
end

--#region Module

Module.HasCollectible = HasCollectible
Module.HasCollectibleRealOrEffect = HasCollectibleRealOrEffect

--#endregion

return Module