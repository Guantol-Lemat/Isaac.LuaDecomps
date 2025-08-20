--#region Dependencies

local eStringKey = require("General.StringTable.Keys")

--#endregion

---@class HudScoreboardLogic
local Module = {}

---@param context Context
---@param font Font
local function get_time_position(context, font)
    local timeString = context:GetString(eStringKey.MINIMAP_TIME_LABEL)
    assert(timeString, "Time string cannot be nil")

    local trialTextWidth_1 = font:GetStringWidthUTF8(timeString) + font:GetStringWidth(" 00:00:00")
    local trialTextWidth_2 = font:GetStringWidthUTF8(timeString) + font:GetStringWidth(" 000000")
    local timeTextWidth = math.max(trialTextWidth_1, trialTextWidth_2)

    local screen = context:GetScreen()
    return (screen.m_width - timeTextWidth) * 0.5
end

---@param context Context
---@param font Font
local function Render(context, font, alpha)
    if alpha <= 0.0 then
        return
    end

    local timeTextPosition = get_time_position(context, font)
    -- TODO
end

--#region Module

Module.Render = Render

--#endregion

return Module