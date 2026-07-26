---@class Decomp.Lib.Color
local Lib_Color = {}

--#region Requirement

local Lib = {
    Math = require("Lib.Math"),
}

--#endregion

---@class Decomp.Color
---@field r number
---@field g number
---@field b number
---@field a number

---@param r number
---@param g number
---@param b number
---@param a number
---@return Decomp.Color
local function Create(r, g, b, a)
    ---@class Decomp.Color
    local color = {
        r = r,
        g = g,
        b = b,
        a = a,
    }

    return color
end

---@param r integer
---@param g integer
---@param b integer
---@param a integer
---@return Decomp.Color
local function CreateFromHex(r, g, b, a)
    ---@class Decomp.Color
    local color = {
        r = r / 255.0,
        g = g / 255.0,
        b = b / 255.0,
        a = a / 255.0
    }

    return color
end

local function Copy(other)
    ---@class Decomp.Color
    local color = {
        r = other.r,
        g = other.g,
        b = other.b,
        a = other.a
    }

    return color
end

---Computes the luminance or grayscale of the tint
---@param r number
---@param g number
---@param b number
local function compute_luminance(r, g, b)
    return r * 0.2127 + g * 0.7152 + b * 0.0722
end

---@param color Decomp.Color
---@param colorMod Color
local function apply_tint(color, colorMod)
    local tint = colorMod:GetTint()

    color.r = color.r * tint.R
    color.g = color.g * tint.G
    color.b = color.b * tint.B
    color.a = color.a * tint.A
end

---@param color Decomp.Color
---@param colorMod Color
local function apply_colorize(color, colorMod)
    local colorize = colorMod:GetColorize()
    local colorizeMulti = colorize.A
    if colorizeMulti == 0.0 then
        return
    end

    local luminance = compute_luminance(color.r, color.g, color.b)
    color.r = color.r + Lib.Math.Lerp(color.r, colorize.R, luminance) * colorizeMulti
    color.g = color.g + Lib.Math.Lerp(color.g, colorize.G, luminance) * colorizeMulti
    color.b = color.b + Lib.Math.Lerp(color.b, colorize.B, luminance) * colorizeMulti
end

---@param color Decomp.Color
---@param colorMod Color
local function apply_offset(color, colorMod)
    local offset = colorMod:GetOffset()

    color.r = color.r + offset.R
    color.g = color.g + offset.G
    color.b = color.b + offset.B
end

---@param color Decomp.Color
---@param colorMod Color
local function ApplyColorMod(color, colorMod)
    local result = Copy(color)
    apply_tint(result, colorMod)
    apply_colorize(result, colorMod)
    apply_offset(result, colorMod)
    return result
end

--#region Module

Lib_Color.Create = Create
Lib_Color.CreateFromHex = CreateFromHex
Lib_Color.ApplyColorMod = ApplyColorMod

--#endregion

return Lib_Color