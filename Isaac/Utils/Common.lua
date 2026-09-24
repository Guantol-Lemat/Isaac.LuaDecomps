local Engine = require("Engine.Global")

local G = require("Isaac.Global")
local MTRNG = require("Isaac.Utils.MTRNG")

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

---@param seed integer
local function InitRandom(seed)
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
    return Random() / (2^32 - 1)
end

---@return Vector
local function RandomVector()
end

---@param seed integer
---@return Vector
local function RandomVector_Seed(seed)
end

---@generic T
---@param tbl T[]
---@param rng RNG
local function RandomShuffle(tbl, rng)
    for i = #tbl, 1, -1 do
        local swapIdx = rng:RandomInt(i) + 1
        if i ~= swapIdx then
            local temp = tbl[swapIdx]
            tbl[swapIdx] = tbl[i]
            tbl[i] = temp
        end
    end
end

---@generic T
---@param tbl T[]
---@param rng Component.MTRNG
local function RandomShuffle_MTRNG(tbl, rng)
    for i = #tbl, 1, -1 do
        local swapIdx = MTRNG.RandomInt(rng, i) + 1
        if i ~= swapIdx then
            local temp = tbl[swapIdx]
            tbl[swapIdx] = tbl[i]
            tbl[i] = temp
        end
    end
end

---@param friction number
---@param timescale number
---@return number
local function TimeScaledFriction(friction, timescale)
    if timescale == 1.0 then
        return friction
    end

    return friction / ((friction + timescale) - friction * timescale)
end

local WORLD_RENDER_ORIGIN = Vector(60.0, 140.0)
local WORLD_VIEWPORT_SIZE = Vector(338.0, 182)
local WORLD_TO_SCREEN_SCALE = 0.65

---@param distance Vector
---@return Vector
local function GetRenderDistance(distance)
    return distance * WORLD_TO_SCREEN_SCALE
end

---@param distance Vector
---@return Vector
local function ScreenToWorldDistance(distance)
    return distance / WORLD_TO_SCREEN_SCALE
end

---@param position Vector
---@param snapToClosest boolean
---@return Vector
local function GetRenderPosition(position, snapToClosest)
    local screenSize = Vector(G.WIDTH, G.HEIGHT)
    local renderPosition = (position - WORLD_RENDER_ORIGIN) * WORLD_TO_SCREEN_SCALE
    local uiViewport_topLeft = (screenSize - WORLD_VIEWPORT_SIZE) * 0.5

    -- Translate camera relative render position to viewport relative render position
    renderPosition = renderPosition + uiViewport_topLeft

    if snapToClosest then
        local pixelsPerUnit = G.POINTSCALE * G.DISPLAYPIXELSPERPOINT
        local x, y = renderPosition.X, renderPosition.Y
        x = math.floor(x * pixelsPerUnit + 0.5) / pixelsPerUnit
        y = math.floor(y * pixelsPerUnit + 0.5) / pixelsPerUnit

        renderPosition = Vector(x, y)
    end

    return renderPosition
end

local function PushRenderTarget()
end

local function PopRenderTarget()
end

---@param shaderType ShaderType
local function LoadShader(shaderType)
    Engine.GraphicsManager:SetShader(G.Shaders[shaderType + 1])
end

--#region Module

Module.GetDirectionToMoveAction = GetDirectionToMoveAction
Module.GetVectorDirection = GetVectorDirection
Module.GetAxisAlignedUnitVectorFromDirection = GetAxisAlignedUnitVectorFromDirection
Module.InitRandom = InitRandom
Module.Random = Random
Module.RandomInt = RandomInt
Module.RandomFloat = RandomFloat
Module.RandomVector = RandomVector
Module.RandomVector_Seed = RandomVector_Seed
Module.RandomShuffle = RandomShuffle
Module.RandomShuffle_MTRNG = RandomShuffle_MTRNG
Module.TimeScaledFriction = TimeScaledFriction
Module.GetRenderDistance = GetRenderDistance
Module.WorldToScreenDistance = GetRenderDistance
Module.ScreenToWorldDistance = ScreenToWorldDistance
Module.GetRenderPosition = GetRenderPosition
Module.PushRenderTarget = PushRenderTarget
Module.PopRenderTarget = PopRenderTarget
Module.LoadShader = LoadShader

--#endregion

return Module