---@class MathUtils
local Module = {}

---@param value number
---@param min number
---@param max number
---@return number clampedValue
local function Clamp(value, min, max)
    return math.max(math.min(value, max),  min)
end

---@param a number
---@param b number
---@param blendFactor number
---@return number value
local function Lerp(a, b, blendFactor)
    return (b - a) * blendFactor + a
end

---@param a number
---@param b number
---@param value number
---@return number blendFactor
local function InverseLerp(a, b, value)
    assert(a ~= b, "start and end values cannot be the same.")
    return (value - a) / (b - a)
end

---@param current number
---@param target number
---@param rate number
---@return number
local function MoveTowards(current, target, rate)
    local delta = target - current
    local step = delta < 0 and -rate or rate
    step = math.abs(delta) < rate and delta or step

    return current + step
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

---@param radius number
---@param angle number -- in degrees
local function PolarToCartesian(radius, angle)
    local angleUnitVector = Vector.FromAngle(angle)
    return angleUnitVector * radius
end

--#region Module

Module.Clamp = Clamp
Module.Lerp = Lerp
Module.InverseLerp = InverseLerp
Module.MoveTowards = MoveTowards
Module.MapToRange = MapToRange
Module.TimeScaledFriction = TimeScaledFriction
Module.NormalizeAngle = NormalizeAngle
Module.InterpolateAngle = InterpolateAngle
Module.PolarToCartesian = PolarToCartesian

--#endregion

return Module