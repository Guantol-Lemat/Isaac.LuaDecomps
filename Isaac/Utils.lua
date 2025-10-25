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

--#region Module

Module.GetAxisAlignedUnitVectorFromDirection = GetAxisAlignedUnitVectorFromDirection

--#endregion

return Module