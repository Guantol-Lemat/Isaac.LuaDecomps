---@class SpriteUtils
local Module = {}

---@param sprite Sprite
local function ResetOverlayAnimation(sprite)
end

---@param sprite Sprite
---@param layerId integer
---@return NullFrame?
local function GetNullFrame(sprite, layerId)
end

---@param sprite Sprite
---@return Sprite
local function Copy(sprite)
end

--#region Module

Module.ResetOverlayAnimation = ResetOverlayAnimation
Module.GetNullFrame = GetNullFrame
Module.Copy = Copy

--#endregion

return Module