---@class Decomp.Lib.Math
local Module = {}

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

Module.VectorZero = Vector(0, 0)
Module.VectorOne = Vector(1, 1)

---@param value number
---@param min number
---@param max number
---@return number clampedValue
function Module.Clamp(value, min, max)
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
        normalizedForm = Module.Clamp(normalizedForm, 0.0, 1.0)
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

---Normalizes the angle into the [-180, 180] interval
---@param angle number
---@return number
local function NormalizeAngle(angle)
    angle = math.fmod(angle, 360.0)  -- reduce to [-360, 360]
    if angle > 180.0 then
        return angle - 360.0
    elseif angle < -180.0 then
        return angle + 360.0
    else
        return angle
    end
end

---@param start number
---@param target number
---@param interpolationFactor number
---@return number
local function InterpolateAngle(start, target, interpolationFactor)
    start = NormalizeAngle(start)
    target = NormalizeAngle(target)

    local delta = target - start
    -- Adjust for shortest path
    if math.abs(delta) > 180 then
        if delta > 0 then
            start = start + 360
        else
            target = target + 360
        end
    end

    -- Linear interpolation
    local result = (target - start) * interpolationFactor + start
    return NormalizeAngle(result)
end

--#region Module

Module.Circle = Circle

Module.Lerp = Lerp
Module.MapToRange = MapToRange
Module.TimeScaledFriction = TimeScaledFriction
Module.IsVectorEqual = IsVectorEqual
Module.VectorCopy = VectorCopy
Module.NormalizeAngle = NormalizeAngle
Module.InterpolateAngle = InterpolateAngle

--#endregion

return Module