---@class ColorUtils
local Module = {}

---@param color ColorModComponent
---@return ColorModComponent
local function Copy(color)
    ---@type ColorModComponent
    return {
        tintR = color.tintR,
        tintG = color.tintG,
        tintB = color.tintB,
        tintA = color.tintA,
        offsetR = color.offsetR,
        offsetG = color.offsetG,
        offsetB = color.offsetB,
        colorizeR = color.colorizeR,
        colorizeG = color.colorizeG,
        colorizeB = color.colorizeB,
        colorizeA = color.colorizeA,
    }
end

---@param color ColorModComponent
---@param other ColorModComponent
---@return ColorModComponent
local function MultiplyAssign(color, other)
    color.tintR = color.tintR * other.tintR
    color.tintG = color.tintG * other.tintG
    color.tintB = color.tintB * other.tintB
    color.tintA = color.tintA * other.tintA
    color.offsetR = color.offsetR * other.offsetR
    color.offsetG = color.offsetG * other.offsetG
    color.offsetB = color.offsetB * other.offsetB

    local otherCR, otherCG, otherCB, otherCA = other.colorizeR, other.colorizeG, other.colorizeB, other.colorizeA
    if otherCR + otherCB + otherCA ~= 0 then
        local cr, cg, cb, ca = color.colorizeR, color.colorizeG, color.colorizeB, color.colorizeA
        if cr + cg + cb == 0 then
            color.colorizeR = otherCR
            color.colorizeG = otherCG
            color.colorizeB = otherCB
            color.colorizeA = otherCA
        else
            color.colorizeR = (cr + otherCR) * 0.5
            color.colorizeG = (cg + otherCG) * 0.5
            color.colorizeB = (cb + otherCB) * 0.5
            color.colorizeA = (ca + otherCA) * 0.5
        end
    end

    return color
end

---@param color ColorModComponent
---@param other ColorModComponent
---@return ColorModComponent
local function Multiply(color, other)
    local result = Copy(color)
    return MultiplyAssign(result, other)
end

--#region Module

Module.Copy = Copy
Module.MultiplyAssign = MultiplyAssign
Module.Multiply = Multiply

--#endregion

return Module