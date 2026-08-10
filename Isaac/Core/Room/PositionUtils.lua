--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")
local IRoom = require("Isaac.Interface.Room")

--#endregion

---@param room Component.Room
---@param margin number
---@return Vector
local function GetRandomPosition(room, margin)
    local shape = room.m_roomDescriptor.m_data.m_shape
    local isLShape = RoomShape.ROOMSHAPE_LTL <= shape and shape <= RoomShape.ROOMSHAPE_LBR

    if isLShape then
        local areaDesc = IRoom.GetLRoomAreaDesc(room)
        local highRectangle = {topLeft = areaDesc.highTopLeft - margin, bottomRight = areaDesc.highBottomRight + margin}
        local lowRectangle = {topLeft = areaDesc.lowTopLeft - margin, bottomRight = areaDesc.lowBottomRight + margin}

        local highBase = highRectangle.bottomRight.X - highRectangle.topLeft.X
        local lowBase = lowRectangle.bottomRight.X - lowRectangle.topLeft.X

        local splitY = highBase < lowBase and lowRectangle.topLeft.Y or highRectangle.bottomRight.Y
        local highHeight = splitY - highRectangle.topLeft.Y
        local lowHeight = lowRectangle.bottomRight.Y - splitY

        local highArea = math.abs(highBase * highHeight)
        local lowArea = math.abs(lowBase * lowHeight)

        local highWeight = highArea / (highArea + lowArea)
        local randomX, randomY
        if IsaacUtils.RandomFloat() < highWeight then
            randomX = highBase * IsaacUtils.RandomFloat() + highRectangle.topLeft.X
            randomY = highHeight * IsaacUtils.RandomFloat() + highRectangle.topLeft.Y
        else
            randomX = lowBase * IsaacUtils.RandomFloat() + lowRectangle.topLeft.X
            randomY = lowHeight * IsaacUtils.RandomFloat() + splitY
        end

        return Vector(randomX, randomY)
    end

    local relativeSpace = room.m_bottomRightBound - room.m_topLeftBound
    local x = relativeSpace.X * IsaacUtils.RandomFloat()
    local y = relativeSpace.Y * IsaacUtils.RandomFloat()
    local relativeRandom = Vector(x, y)
    local randomPosition = relativeRandom + room.m_topLeftBound

    return IRoom.GetClampedPosition(room, randomPosition, margin, margin, margin, margin)
end

---@param room Component.Room
---@param startPos Vector
---@param margin number
---@return Vector
local function FindFreeTilePosition(room, startPos, margin)
    local bestPosition = Vector(startPos.X, startPos.Y)
    local collision = IRoom.GetGridCollisionAtPos(room, startPos)
    if collision == GridCollisionClass.COLLISION_NONE then
        return bestPosition
    end

    local gridSize = room.m_gridWidth * room.m_gridHeight
    local gridIdx = IRoom.GetGridIndex(room, startPos)
    local bestDistane = math.huge

    for i = 0, gridSize - 1, 1 do
        if i == gridIdx or IRoom.GetGridCollision(room, i) ~= GridCollisionClass.COLLISION_NONE then
            goto continue
        end

        local position = IRoom.GetGridPosition(room, i)
        local distance = position:Distance(startPos)
        if distance < bestDistane then
            bestPosition = position
            bestDistane = distance

            local targetDistance = margin * margin
            if distance < margin * margin then
                break
            end
        end
        ::continue::
    end

    return bestPosition
end

---@param room Component.Room
---@param pos Vector
---@param InitialStep number
---@param AvoidActiveEntities boolean
---@param AllowPits boolean
---@return Vector
local function FindFreePickupSpawnPosition(room, pos, InitialStep, AvoidActiveEntities, AllowPits) end


---@class Room.PositionUtils
local Module = {}

--#region Module

Module.GetRandomPosition = GetRandomPosition
Module.FindFreeTilePosition = FindFreeTilePosition

--#endregion

return Module