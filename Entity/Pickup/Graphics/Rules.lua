---@class PickupGraphicRules
local Module = {}

---@param context Context
---@param sprite Sprite
---@param layer integer
---@param collectible CollectibleType | integer
---@param seed integer
---@param isBlind boolean
local function SetupCollectibleGraphics(context, sprite, layer, collectible, seed, isBlind)
end

--#region Module

Module.SetupCollectibleGraphics = SetupCollectibleGraphics

--#endregion

return Module