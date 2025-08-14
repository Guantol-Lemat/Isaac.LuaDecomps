--#region Dependencies



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

--#region Module

Module.HasCollectible = HasCollectible

--#endregion

return Module