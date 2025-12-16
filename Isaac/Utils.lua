---@class IsaacUtils
local Module = {}

local s_DirectionUnitVector = {
    [Direction.LEFT + 1] = Vector(-1.0, 0.0),
    [Direction.UP + 1] = Vector(0.0, -1.0),
    [Direction.RIGHT + 1] = Vector(1.0, 0.0),
    [Direction.DOWN + 1] = Vector(0.0, 1.0),
}

---@param direction Direction
---@return Vector
local function GetAxisAlignedUnitVectorFromDirection(direction)
    if direction == Direction.NO_DIRECTION then
        return Vector(0, 0)
    end

    local vector = s_DirectionUnitVector[direction + 1]
    return Vector(vector.X, vector.Y)
end

---@return integer
local function Random()
end

---@param max integer
---@return integer
local function RandomInt(max)
    if max == 0 then
        return 0
    end

    return Random() % max
end

---@return number
local function RandomFloat()
end

--#region Module

Module.GetAxisAlignedUnitVectorFromDirection = GetAxisAlignedUnitVectorFromDirection
Module.Random = Random
Module.RandomInt = RandomInt
Module.RandomFloat = RandomFloat

--#endregion

return Module