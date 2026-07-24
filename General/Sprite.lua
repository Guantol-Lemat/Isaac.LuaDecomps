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

---@param layer LayerState
---@param value integer
local function LayerState_SetMinFilterMode(layer, value)
end

---@param layer LayerState
---@param value integer
local function LayerState_SetMagFilterMode(layer, value)
end

---@param layer LayerState
---@param value BlendMode
local function LayerState_SetBlendMode(layer, value)
end

---@param sprite Sprite
---@return Sprite
local function Copy(sprite)
    return sprite:Copy()
end

--#region Module

Module.ResetOverlayAnimation = ResetOverlayAnimation
Module.GetNullFrame = GetNullFrame
Module.LayerState_SetMinFilterMode = LayerState_SetMinFilterMode
Module.LayerState_SetMagFilterMode = LayerState_SetMagFilterMode
Module.LayerState_SetBlendMode = LayerState_SetBlendMode
Module.Copy = Copy

--#endregion

return Module