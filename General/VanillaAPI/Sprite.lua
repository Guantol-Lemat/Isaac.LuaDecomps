---@param sprite Sprite
---@param frameNum number
local function SetFramePrecise(sprite, frameNum)
    local isPlaying = sprite:IsPlaying()
    sprite:SetFrame(frameNum) -- this gets converted into an integer so the effect is not 1:1

    if isPlaying then
        sprite:Continue() -- SetFrame sets isPlaying to false while SetFramePrecise keeps it it's original value
    end
end

---@class Utils.VanillaApi.Sprite
local Module = {}

--#region Module

Module.SetFramePrecise = SetFramePrecise

--#endregion

return Module