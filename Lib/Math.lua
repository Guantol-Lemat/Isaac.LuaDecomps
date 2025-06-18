---@class Decomp.Lib.Math
local Lib_Math = {}

---@class Decomp.Math.Circle
local Circle = {}

---@class Decomp.Math.Circle.Data
---@field center Vector
---@field radius number

---@param center Vector
---@param radius number
---@return Decomp.Math.Circle.Data
function Circle.new(center, radius)
    ---@type Decomp.Math.Circle.Data
    local circle = {
        center = Vector(center.X, center.Y),
        radius = radius
    }
    return circle
end

---@param circle Decomp.Math.Circle.Data
---@param other Decomp.Math.Circle.Data
---@return boolean collided
---@return number distance
function Circle.Collide(circle, other)
    local distance = (other.center - circle.center):Length()
    return distance < (circle.radius + circle.radius), distance
end

Lib_Math.VectorZero = Vector(0, 0)
Lib_Math.VectorOne = Vector(1, 1)

---@param value number
---@param min number
---@param max number
---@return number clampedValue
function Lib_Math.Clamp(value, min, max)
    return math.max(math.min(value, max),  min)
end

---@param a number
---@param b number
---@param blendFactor number
local function Lerp(a, b, blendFactor)
    return (b - a) * blendFactor + a
end

---@param value number
---@param previousRange number[]
---@param newRange number[]
---@param clamp boolean
---@return number remappedNumber
local function MapToRange(value, previousRange, newRange, clamp)
    assert(previousRange[1] ~= previousRange[2], "invalid range")

    local normalizedForm = (value - previousRange[1]) / (previousRange[2] - previousRange[1])
    if clamp then
        normalizedForm = Lib_Math.Clamp(normalizedForm, 0.0, 1.0)
    end

    return newRange[1] + normalizedForm * (newRange[2] - newRange[1])
end

---@param friction number
---@param timeScale number
---@return number
local function TimeScaledFriction(friction, timeScale)
    if timeScale == 1.0 then
        return friction
    end

    local normalizationFactor = (friction + timeScale) - friction * timeScale
    return friction / normalizationFactor
end

---@param vector Vector
---@param other Vector
---@return boolean
local function IsVectorEqual(vector, other)
    return vector.X == other.X and vector.Y == other.Y
end

---@param vector Vector
---@return Vector
local function VectorCopy(vector)
    return Vector(vector.X, vector.Y)
end

--#region Module

Lib_Math.Circle = Circle

Lib_Math.Lerp = Lerp
Lib_Math.MapToRange = MapToRange
Lib_Math.TimeScaledFriction = TimeScaledFriction
Lib_Math.IsVectorEqual = IsVectorEqual
Lib_Math.VectorCopy = VectorCopy

--#endregion

return Lib_Math