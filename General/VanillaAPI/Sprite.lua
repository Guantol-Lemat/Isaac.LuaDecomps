---@class Vanilla.AnimationState

---@param sprite Sprite
---@return Vanilla.AnimationState
local function GetOverlayAnimState(sprite)
end

---@param sprite Sprite
---@param layerId integer
---@return NullFrame?
local function GetNullFrameById(sprite, layerId)
end

---@param sprite Sprite
---@param frameNum number
local function SetFramePrecise(sprite, frameNum)
    local isPlaying = sprite:IsPlaying()
    sprite:SetFrame(frameNum) -- this gets converted into an integer so the effect is not 1:1

    if isPlaying then
        sprite:Continue() -- SetFrame sets isPlaying to false while SetFramePrecise keeps it it's original value
    end
end

---@param state Vanilla.AnimationState
---@param animation AnimationData?
local function ResetAnimationState(state, animation)
end

---@class Utils.VanillaApi.Sprite
local Module = {}

--#region Module

Module.GetOverlayAnimState = GetOverlayAnimState
Module.GetNullFrameById = GetNullFrameById
Module.SetFramePrecise = SetFramePrecise
Module.ResetAnimationState = ResetAnimationState

--#endregion

return Module