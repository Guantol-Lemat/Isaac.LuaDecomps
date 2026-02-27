---@class IsaacUtils
local Module = {}

local DIRECTION_UNIT_VECTOR = {
    [Direction.LEFT + 1] = Vector(-1.0, 0.0),
    [Direction.UP + 1] = Vector(0.0, -1.0),
    [Direction.RIGHT + 1] = Vector(1.0, 0.0),
    [Direction.DOWN + 1] = Vector(0.0, 1.0),
}

local DIRECTION_TO_MOVE_ACTION = {
    [Direction.LEFT + 1] = ButtonAction.ACTION_LEFT,
    [Direction.UP + 1] = ButtonAction.ACTION_UP,
    [Direction.RIGHT + 1] = ButtonAction.ACTION_RIGHT,
    [Direction.DOWN + 1] = ButtonAction.ACTION_DOWN,
}

---@param vector Vector
---@return Direction | integer
local function GetVectorDirection(vector)
    if math.abs(vector.X) > math.abs(vector.Y) then
        return vector.X < 0.0 and Direction.LEFT or Direction.RIGHT
    else
        return vector.Y < 0.0 and Direction.UP or Direction.DOWN
    end
end

---@param direction Direction
---@return Vector
local function GetAxisAlignedUnitVectorFromDirection(direction)
    if direction == Direction.NO_DIRECTION then
        return Vector(0, 0)
    end

    local vector = DIRECTION_UNIT_VECTOR[direction + 1]
    return Vector(vector.X, vector.Y)
end

---@param direction Direction | integer
---@return ButtonAction | integer
local function GetDirectionToMoveAction(direction)
    return DIRECTION_TO_MOVE_ACTION[direction + 1]
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

---@param myContext Context.Common
---@param soundId SoundEffect | integer
---@param volume number
---@param frameDelay integer
---@param loop boolean
---@param pitch integer
local function PlaySound(myContext, soundId, volume, frameDelay, loop, pitch)
end

---@param isaac IsaacManager
local function IsInterpolation(isaac)
    return isaac.m_frameCount % 2 == 1
end

---@param isaac IsaacManager
---@param ignoreModRestrictions boolean
---@return boolean
local function AchievementUnlocksDisallowed(isaac, ignoreModRestrictions)
end

---@param isaac IsaacManager
---@param action ButtonAction| integer
---@param controllerIdx integer
---@param entity EntityComponent?
---@return boolean
local function IsActionTriggered(isaac, action, controllerIdx, entity)

end

---@param isaac IsaacManager
---@param action ButtonAction| integer
---@param controllerIdx integer
---@param entity EntityComponent?
---@return boolean
local function IsActionPressed(isaac, action, controllerIdx, entity)

end

---@param isaac IsaacManager
---@param action ButtonAction| integer
---@param controllerIdx integer
---@param entity EntityComponent?
---@return number
local function GetActionValue(isaac, action, controllerIdx, entity)

end

--#region Module

Module.IsInterpolation = IsInterpolation
Module.GetDirectionToMoveAction = GetDirectionToMoveAction
Module.GetVectorDirection = GetVectorDirection
Module.GetAxisAlignedUnitVectorFromDirection = GetAxisAlignedUnitVectorFromDirection
Module.Random = Random
Module.RandomInt = RandomInt
Module.RandomFloat = RandomFloat
Module.PlaySound = PlaySound
Module.AchievementUnlocksDisallowed = AchievementUnlocksDisallowed
Module.IsActionTriggered = IsActionTriggered
Module.IsActionPressed = IsActionPressed
Module.GetActionValue = GetActionValue

--#endregion

return Module