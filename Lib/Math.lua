---@class Decomp.Lib.Math
local Lib_Math = {}
Decomp.Lib.Math = Lib_Math

---@param value number
---@param min number
---@param max number
---@return number clampedValue
function Lib_Math.Clamp(value, min, max)
    return math.max(math.min(value, max),  min)
end

---@param value number
---@param previousRange number[]
---@param newRange number[]
---@param clamp boolean
---@return number remappedNumber
function Lib_Math.MapToRange(value, previousRange, newRange, clamp)
    assert(previousRange[1] ~= previousRange[2], "invalid range")

    local normalizedForm = (value - previousRange[1]) / (previousRange[2] - previousRange[1])
    if clamp then
        normalizedForm = Lib_Math.Clamp(normalizedForm, 0.0, 1.0)
    end

    return newRange[1] + normalizedForm * (newRange[2] - newRange[1])
end