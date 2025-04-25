---@class Decomp.Lib.Math
local Lib_Math = {}

---@class Decomp.Math.Circle
local Circle = {}
Lib_Math.Circle = Circle

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

---@param vector Vector
---@param other Vector
---@return boolean
function Lib_Math.IsVectorEqual(vector, other)
    return vector.X == other.X and vector.Y == other.Y
end

---@param vector Vector
---@return Vector
function Lib_Math.VectorCopy(vector)
    return Vector(vector.X, vector.Y)
end

return Lib_Math