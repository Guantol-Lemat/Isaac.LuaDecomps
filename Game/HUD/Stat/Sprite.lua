---@class StatHudSpriteUtils
local Module = {}

local function Load(sprite)
end

---@param sprite Sprite
---@param hudStat eHudStat
local function SetFrameToStat(sprite, hudStat)
    sprite:SetFrame(hudStat - 1)
end

---@param sprite Sprite
local function SetFrameToCombinedDeals(sprite)
    sprite:SetLastFrame()
end

--#region Module

Module.Load = Load
Module.SetFrameToStat = SetFrameToStat
Module.SetFrameToCombinedDeals = SetFrameToCombinedDeals

--#endregion

return Module