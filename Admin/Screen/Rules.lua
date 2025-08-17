--#region Dependencies

local ScreenUtils = require("Admin.Screen.Utils")

--#endregion

---@class ScreenRules
local Module = {}

---@param context Context
---@param screen ScreenComponent
---@param position Vector
---@return Vector
local function WorldToScreenPosition(context, screen, position)
    local game = context:GetGame()
    local room = context:GetRoom()

    local screenPosition = ScreenUtils.GetScreenPosition(screen, position, true)
    screenPosition = screenPosition + room.m_renderScrollOffset
    screenPosition = screenPosition + game.m_screenShakeOffset

    return screenPosition
end

---@param context Context
---@param screen ScreenComponent
---@return boolean
local function ShouldTriggerLostFocusPause(context, screen)
end

--#region Module

Module.WorldToScreenPosition = WorldToScreenPosition
Module.ShouldTriggerLostFocusPause = ShouldTriggerLostFocusPause

--#endregion

return Module