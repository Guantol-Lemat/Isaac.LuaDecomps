--#region Dependencies

local MathUtils = require("General.Math")

--#endregion

---@class VanillaColorUtils
local Module = {}

---@param color Color
---@return Color
local function Copy(color)
    local colorize = color:GetColorize()
    return Color(
        color.R, color.G, color.B, color.A,
        color.RO, color.GO, color.BO,
        colorize.R, colorize.G, colorize.B, colorize.A
    )
end

---@param color KColor
---@return KColor
local function KColor_Copy(color)
    return KColor(color.Red, color.Green, color.Blue, color.Alpha)
end

---@param color KColor
---@param colorMod Color
---@return KColor
local function ApplyColorMod(color, colorMod)
    local r = color.Red
    local g = color.Green
    local b = color.Blue
    local a = color.Alpha

    -- apply_tint
    local tint = colorMod:GetTint()
    r = r * tint.R
    g = g * tint.G
    b = b * tint.B
    a = a * tint.A

    -- apply_colorize
    local colorize = colorMod:GetColorize()
    local colorizeMulti = colorize.A
    if colorizeMulti ~= 0.0 then
        local luminance = r * 0.2127 + g * 0.7152 + b * 0.0722
        r = r + MathUtils.Lerp(r, colorize.R, luminance) * colorizeMulti
        g = g + MathUtils.Lerp(g, colorize.G, luminance) * colorizeMulti
        b = b + MathUtils.Lerp(b, colorize.B, luminance) * colorizeMulti
    end

    local offset = colorMod:GetOffset()
    r = r + offset.R
    g = g + offset.G
    b = b + offset.B

    return KColor(r, g, b, a)
end

--#region Module

Module.Copy = Copy
Module.KColor_Copy = KColor_Copy
Module.ApplyColorMod = ApplyColorMod

--#endregion

return Module