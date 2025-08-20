--#region Dependencies

local MathUtils = require("General.Math")
local StatHudUtils = require("HUD.Stat.Utils")

--#endregion

---@class StatHudRenderRules
local Module = {}

---The sprite must already be set to the correct frame before calling this function.
---@param sprite Sprite
---@param renderPos Vector
local function RenderStatIcon(sprite, renderPos)
    sprite.Color.A = 0.5
    sprite:Render(Vector(0, 0), Vector(0, 0), Vector(0, 0))
end

---@param playerIndex integer
---@param isMultiplayer boolean
---@return Vector
local function get_player_text_pos_offset(playerIndex, isMultiplayer)
    local multiplayerOffset = isMultiplayer and -5.0 and -1.0
    local xOffset = (playerIndex - 1) * 4.0
    local yOffset = (playerIndex - 1) * 7.0 + multiplayerOffset
    return Vector(xOffset, yOffset)
end

---@param context Context
local function get_icon_to_text_offset(context)
    local game = context:GetGame()
    return Vector(16.0, 1.0) + game.m_screenShakeOffset
end

---@param font Font
---@param str string
---@param position Vector
---@param isMainPlayer boolean
local function draw_stat_string(font, str, position, isMainPlayer)
    local color = not isMainPlayer and KColor(1.0, 0.8, 0.8, 0.5) or KColor(1.0, 1.0, 1.0, 0.5)
    font:DrawString(str, position.X, position.Y, color, 0, false)
end

---@param font Font
---@param value number
---@param position Vector
---@param isMainPlayer boolean
local function draw_stat_value(font, value, position, isMainPlayer)
    local str = string.format("%.2f", value)
    draw_stat_string(font, str, position, isMainPlayer)

end

---@param font Font
---@param value number
---@param position Vector
---@param isMainPlayer boolean
local function draw_stat_value_percentage(font, value, position, isMainPlayer)
    local str = string.format("%.1f%%", value)
    draw_stat_string(font, str, position, isMainPlayer)
end

---@param font Font
---@param str string
---@param delta number
---@param countdown integer
---@param baseTextPosition Vector
local function draw_delta_string(font, str, delta, countdown, baseTextPosition)
    local xOffset = 0.0
    local alpha = 1.0

    if countdown > StatHudUtils.DELTA_FADEIN_END then
        alpha = MathUtils.InverseLerp(StatHudUtils.DELTA_DURATION, StatHudUtils.DELTA_FADEIN_END, countdown)
        local easeIn = (1.0 - alpha) ^ 2 -- quadratic ease-in
        xOffset = easeIn * -20.0
    elseif countdown <= StatHudUtils.DELTA_FADEOUT_START then
        alpha = MathUtils.InverseLerp(0.0, StatHudUtils.DELTA_FADEOUT_START, countdown)
    end

    local red = 0.03
    local green = 0.9

    if delta < 0.0 then
        red = 0.9
        green = 0.03
    end

    local color = KColor(red, green, 0.03, alpha * 0.5)
    local positionX = baseTextPosition.X + 30.0 + xOffset
    font:DrawString(str, positionX, baseTextPosition.Y, color, 0, false)
end

---@param font Font
---@param delta number
---@param countdown integer
---@param baseTextPosition Vector
local function draw_delta_value(font, delta, countdown, baseTextPosition)
    local format = "%.2f"
    if delta > 0.0 then
        format = "+%.2f"
    end

    local str = string.format(format, delta)
    draw_delta_string(font, str, delta, countdown, baseTextPosition)
end

---@param font Font
---@param delta number
---@param countdown integer
---@param baseTextPosition Vector
local function draw_delta_value_percentage(font, delta, countdown, baseTextPosition)
    local format = "%.1f%%"
    if delta > 0.0 then
        format = "+%.1f%%"
    end

    local str = string.format(format, delta)
    draw_delta_string(font, str, delta, countdown, baseTextPosition)
end

---@param context Context
---@param font Font
---@param playerIndex integer
---@param stat HudStatComponent
---@param isMultiplayer boolean
---@param isPercentage boolean
---@param renderPos Vector
local function DrawPlayerStat(context, font, playerIndex, stat, isMultiplayer, isPercentage, renderPos)
    renderPos = renderPos + get_icon_to_text_offset(context)
    renderPos = renderPos + get_player_text_pos_offset(playerIndex, isMultiplayer)

    if isPercentage then
        draw_stat_value_percentage(font, stat.m_value, renderPos, playerIndex == 1)
        draw_delta_value_percentage(font, stat.m_deltaFromPrevious, stat.m_deltaCountdown, renderPos)
    else
        draw_stat_value(font, stat.m_value, renderPos, playerIndex == 1)
        draw_delta_value(font, stat.m_deltaFromPrevious, stat.m_deltaCountdown, renderPos)
    end
end

---@param context Context
---@param font Font
---@param stat HudStatComponent
---@param isPercentage boolean
---@param renderPos Vector
local function DrawGlobalStat(context, font, stat, isPercentage, renderPos)
    renderPos = renderPos + get_icon_to_text_offset(context)

    if isPercentage then
        draw_stat_value_percentage(font, stat.m_value, renderPos, true)
        draw_delta_value_percentage(font, stat.m_deltaFromPrevious, stat.m_deltaCountdown, renderPos)
    else
        draw_stat_value(font, stat.m_value, renderPos, true)
        draw_delta_value(font, stat.m_deltaFromPrevious, stat.m_deltaCountdown, renderPos)
    end
end

--#region Module

Module.RenderStatIcon = RenderStatIcon
Module.DrawPlayerStat = DrawPlayerStat
Module.DrawGlobalStat = DrawGlobalStat

--#endregion

return Module