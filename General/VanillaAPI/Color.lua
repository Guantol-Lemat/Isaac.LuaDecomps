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

---@param color Color
---@param other Color
---@return Color
local function MultiplyCompound(color, other)
    color.R = color.R * other.R
    color.G = color.G * other.G
    color.B = color.B * other.B
    color.A = color.A * other.A

    color.RO = color.RO * other.RO
    color.GO = color.GO * other.GO
    color.BO = color.BO * other.BO

    local colorize, otherColorize = color:GetColorize(), other:GetColorize()
    if otherColorize.R + otherColorize.G + otherColorize.B ~= 0 then
        local cr, cg, cb, ca = colorize.R, colorize.G, colorize.B, colorize.A
        if cr + cg + cb == 0 then
            colorize.R = otherColorize.R
            colorize.G = otherColorize.G
            colorize.B = otherColorize.B
            colorize.A = otherColorize.A
        else
            colorize.R = (cr + otherColorize.R) * 0.5
            colorize.G = (cg + otherColorize.G) * 0.5
            colorize.B = (cb + otherColorize.B) * 0.5
            colorize.A = (ca + otherColorize.A) * 0.5
        end

        color:SetColorize(colorize.R, colorize.G, colorize.B, colorize.A)
    end

    return color
end

---@param color Color
---@param other Color
---@return Color
local function Multiply(color, other)
    return MultiplyCompound(Copy(color), other)
end

--#region Module

Module.Copy = Copy
Module.KColor_Copy = KColor_Copy
Module.ApplyColorMod = ApplyColorMod
Module.Multiply = Multiply
Module.MultiplyCompound = MultiplyCompound

--#endregion

return Module