--#region Dependencies

--#endregion

---@class LevelUtils
local Module = {}

---@type RoomDescriptorComponent
local s_defaultRoom = {}

---@param coordinates XYComponent
local function ToRoomIdx(coordinates)
    local x = coordinates.x
    local y = coordinates.y

    if (0 <= x and x < 13) and (0 <= y and y < 13) then
        return y * 13 + x
    end

    return -1
end

---@param level LevelComponent
---@param idx integer
---@return RoomDescriptorComponent
local function GetRoomByListIdx(level, idx)
    return level.m_roomList[idx + 1]
end

---@param level LevelComponent
---@return boolean
local function IsAltPath(level)
end

---@param level LevelComponent
---@return boolean
local function IsCorpseEntrance(level)
end

---@param stage LevelStage | integer
---@param stageType StageType | integer
local function GetFloor(stage, stageType)
    if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
        return stage + 1
    end

    return stage
end

---@param level LevelComponent
---@return RoomDescriptorComponent
local function GetCurrentRoomDesc(level)
    return level.m_room.m_roomDescriptor
end

---@param level LevelComponent
local function reset_room_list(level)

end

---@param level LevelComponent
local function reset_dimension_lookup(level)
    local dimensionLookup = level.m_dimensionLookups

    for i = 1, GridRooms.MAX_GRID_ROOMS, 1 do
        local dimension = i // 169
        local gridIdx = i // 3

        dimensionLookup[dimension + 1][gridIdx + 1] = -1
    end
end



---@param level LevelComponent
---@param idx GridRooms | integer
---@param dimension Dimension | integer
---@return RoomDescriptorComponent
local function get_dimension_room_by_idx(level, idx, dimension)
    local roomListIdx = level.m_dimensionLookups[dimension][idx]
    if roomListIdx == -1 then
        return s_defaultRoom
    end

    return level.m_roomList[roomListIdx]
end

---@param level LevelComponent
---@param idx GridRooms | integer
---@param dimension Dimension | integer
---@return RoomDescriptorComponent
local function GetRoomByIdx(level, idx, dimension)
    if dimension == Dimension.CURRENT then
        dimension = level.m_dimension
    end

    if dimension >= 3 then
        return s_defaultRoom
    end

    if idx == GridRooms.ROOM_MIRROR_IDX then
        idx = level.m_roomIdx
        if idx < 0 then
            return s_defaultRoom
        end

        dimension = dimension == Dimension.NORMAL and Dimension.MIRROR or Dimension.NORMAL
        return get_dimension_room_by_idx(level, idx, dimension)
    end

    if idx == GridRooms.ROOM_MINESHAFT_IDX then
        if dimension == Dimension.NORMAL then
            return get_dimension_room_by_idx(level, 162, Dimension.MINESHAFT)
        end

        local roomList = level.m_roomList
        local roomCount = level.m_roomCount

        for i = 1, roomCount, 1 do
            local room = roomList[i]
            local data = room.m_data

            ---@cast data RoomDataComponent
            if room.m_dimension == Dimension.NORMAL and data.m_type == RoomType.ROOM_DEFAULT and data.m_subtype == RoomSubType.MINES_MINESHAFT_ENTRANCE then
                return room
            end
        end

        return s_defaultRoom
    end

    local offgridIdx = -idx -1
    if (0 <= offgridIdx and offgridIdx < GridRooms.NUM_OFF_GRID_ROOMS) then
        return level.m_roomList[offgridIdx + GridRooms.MAX_GRID_ROOMS]
    end

    if (0 <= idx and idx < 169) then
        return get_dimension_room_by_idx(level, idx, dimension)
    end

    return s_defaultRoom
end

--#region Module

Module.ToRoomIdx = ToRoomIdx
Module.GetRoomByListIdx = GetRoomByListIdx
Module.IsAltPath = IsAltPath
Module.IsCorpseEntrance = IsCorpseEntrance
Module.GetFloor = GetFloor
Module.GetCurrentRoomDesc = GetCurrentRoomDesc
Module.reset_room_list = reset_room_list
Module.reset_dimension_lookup = reset_dimension_lookup
Module.GetRoomByIdx = GetRoomByIdx

--#endregion

return Module