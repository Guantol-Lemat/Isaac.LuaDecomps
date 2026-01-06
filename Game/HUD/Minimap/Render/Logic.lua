--#region Dependencies

local RoomTransitionUtils = require("Game.Transition.RoomTransition.Utils")
local FontUtils = require("General.Font")
local ScoreBoardLogic = require("HUD.Minimap.Render.Scoreboard")

--#endregion

---@class MinimapRenderLogic
local Module = {}

---@param context Context
---@param minimap MinimapComponent
local function Render(context, minimap)
    -- evaluate render

    local roomTransition = context:GetRoomTransition()
    local alpha = RoomTransitionUtils.GetAlpha(roomTransition)

    -- render normal map
    -- render expanded map

    local scoreBoardAlpha = alpha * minimap.m_expandedMapDesc.m_alpha
    ScoreBoardLogic.Render(context, font, scoreBoardAlpha)
end

--#region Module

Module.Render = Render

--#endregion

return Module