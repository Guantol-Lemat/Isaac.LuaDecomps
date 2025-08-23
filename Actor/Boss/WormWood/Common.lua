--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")

--#endregion

---@class WormWoodComponent : EntityNPCComponent
---@field m_fallingSpeed number -- V1.x
---@field m_height number -- V1.y
---@field m_positionQueue Vector[]
---@field m_heightQueue number[] -- it's actually the y value of a queue of Vectors (but the x is forced to 0.0)

---@class CommonWormWoodLogic
local Module = {}

---@param entity WormWoodComponent
local function evaluate_queue_position(entity)
    if #entity.m_positionQueue == 0 then
        return true
    end

    local previousPosition = entity.m_positionQueue[1]
    local previousHeight = entity.m_heightQueue[1]

    local positionDelta = previousPosition - entity.m_position
    local heightDelta = previousHeight - entity.m_height

    return VectorUtils.Vec3Length(positionDelta.X, positionDelta.Y, heightDelta) > 3.0
end

---@param entity WormWoodComponent
local function queue_position(entity)
    local positionQueue = entity.m_positionQueue
    local heightQueue = entity.m_heightQueue

    table.insert(positionQueue, 1, VectorUtils.Copy(entity.m_position))
    table.insert(heightQueue, 1, entity.m_height)

    while #positionQueue > 60 do
        table.remove(positionQueue)
        table.remove(heightQueue)
    end
end

---@param entity WormWoodComponent
local function HandleQueuePosition(entity)
    if evaluate_queue_position(entity) then
        queue_position(entity)
    end
end

--#region Module

Module.HandleQueuePosition = HandleQueuePosition

--#endregion

return Module