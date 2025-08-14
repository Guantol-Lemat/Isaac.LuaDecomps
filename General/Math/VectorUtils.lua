---@class VectorUtils
local Module = {}

local VectorZero = Vector(0, 0)
local VectorOne = Vector(1, 1)

---@param vector Vector
---@param other Vector
---@return boolean
local function Equals(vector, other)
    return vector.X == other.X and vector.Y == other.Y
end

---@param vector Vector
---@return Vector
local function Copy(vector)
    return Vector(vector.X, vector.Y)
end

---@param vector Vector
---@return Vector
local function get_dominant_axis(vector)
    if math.abs(vector.X) <= math.abs(vector.Y) then
        local direction = vector.Y < 0.0 and -1.0 or 1.0
        return Vector(0.0, direction)
    else
        local direction = vector.X < 0.0 and -1.0 or 1.0
        return Vector(direction, 0.0)
    end
end

---@param vector Vector
---@return Vector
local function AxisAlign(vector)
    local length = vector:Length()
    local dominantAxis = get_dominant_axis(vector)
    return Vector(length * dominantAxis.X, length * dominantAxis.Y)
end

--#region Module

Module.VectorZero = VectorZero
Module.VectorOne = VectorOne
Module.Equals = Equals
Module.Copy = Copy
Module.AxisAlign = AxisAlign

--#endregion

return Module