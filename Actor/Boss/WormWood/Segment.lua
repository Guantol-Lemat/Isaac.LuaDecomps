--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")

--#endregion

---@class WormWoodSegmentLogic
local Module = {}

---@param entity WormWoodComponent
---@param parent WormWoodComponent
local function follow_parent(entity, parent)
    local positionQueue = parent.m_positionQueue
    local heightQueue = parent.m_heightQueue

    local queueCount = #positionQueue
    if queueCount <= 0 then
        return
    end

    local leftoverLength = 0.0
    local nextPosition = parent.m_position
    local nextHeight = parent.m_height

    for i = 1, queueCount, 1 do
        local previousPosition = positionQueue[i]
        local previousHeight = heightQueue[i]

        local positionDelta = previousPosition - nextPosition
        local heightDelta = previousHeight - nextHeight

        local length = VectorUtils.Vec3Length(positionDelta.X, positionDelta.Y, heightDelta)
        if length + leftoverLength > 20.0 then
            local distanceMultiplier = (20.0 - leftoverLength) / length
            entity.m_velocity = ((distanceMultiplier * positionDelta + nextPosition) - entity.m_position) / entity.m_friction
            entity.m_fallingSpeed = (distanceMultiplier * heightDelta + nextHeight) - entity.m_height
            return
        end

        leftoverLength = leftoverLength + length
        nextPosition = previousPosition
        nextHeight = previousHeight
    end

    local positionDelta = entity.m_position - nextPosition
    local heightDelta = entity.m_height - nextHeight

    local length = VectorUtils.Vec3Length(positionDelta.X, positionDelta.Y, heightDelta)
    if length > 20.0 then
        entity.m_velocity = positionDelta / entity.m_friction
        entity.m_fallingSpeed = nextHeight - entity.m_height
    end
end

---@param entity WormWoodComponent
---@param parent WormWoodComponent
local function FollowParent(entity, parent)
    follow_parent(entity, parent)
    entity.m_height = entity.m_height + entity.m_fallingSpeed * entity.m_timeScale
end

--#region Module

Module.FollowParent = FollowParent

--#endregion

return Module