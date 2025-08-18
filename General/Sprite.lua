---@class SpriteUtils
local Module = {}

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

Module.GetNullFrame = GetNullFrame
Module.Copy = Copy

--#endregion

return Module