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

---@param context IsaacContext.PlaySound
---@param soundId SoundEffect | integer
---@param volume number
---@param frameDelay integer
---@param loop boolean
---@param pitch integer
local function PlaySound(context, soundId, volume, frameDelay, loop, pitch)
end

---@param isaac IsaacManager
local function IsInterpolation(isaac)
    return isaac.m_frameCount % 2 == 1
end

--#region Module

Module.IsInterpolation = IsInterpolation
Module.GetAxisAlignedUnitVectorFromDirection = GetAxisAlignedUnitVectorFromDirection
Module.Random = Random
Module.RandomInt = RandomInt
Module.RandomFloat = RandomFloat
Module.PlaySound = PlaySound

--#endregion

return Module