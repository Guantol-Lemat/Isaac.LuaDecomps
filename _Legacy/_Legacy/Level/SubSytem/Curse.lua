---@class Decomp.Level.SubSystem.Curse
local Curse = {}
Decomp.Level.SubSystem.Curse = Curse

local g_Level = Game():GetLevel()

--#region CurseOfMaze

local CURSE_OF_MAZE_MAX_DEPTH = 2

---@param roomDesc RoomDescriptor
---@param door DoorSlot
---@param startIdx integer | GridRooms
local function is_curse_of_maze_candidate(roomDesc, door, startIdx)
    local targetGridIdx = roomDesc.Doors[door]
    if targetGridIdx == startIdx or targetGridIdx < 0 then
        return false
    end

    if (roomDesc.AllowedDoors & 1 << door) == 0 then
        return false
    end

    local targetRoomDesc = g_Level:GetRoomByIdx(targetGridIdx, -1)
    if (targetRoomDesc.Data.Type == RoomType.ROOM_DEFAULT or targetRoomDesc.VisitedCount ~= 0) and (targetRoomDesc.Flags & RoomDescriptor.FLAG_CLEAR) == 0 then
        return true
    end

    return false
end

---@param roomDesc RoomDescriptor
---@param startIdx integer | GridRooms
---@param candidates table<integer, boolean>
local function get_near_maze_candidates(roomDesc, startIdx, candidates, depth)
    if depth > CURSE_OF_MAZE_MAX_DEPTH then
        return
    end

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        if is_curse_of_maze_candidate(roomDesc, i, startIdx) then
            local roomIdx = roomDesc.Doors[i]
            candidates[roomIdx] = true
            get_near_maze_candidates(g_Level:GetRoomByIdx(roomIdx, -1), startIdx, candidates, depth + 1)
        end
    end
end

---@param roomIdx integer | GridRooms
---@return table<integer, boolean>
local function get_curse_of_maze_candidates(roomIdx)
    local candidates = {}
    get_near_maze_candidates(g_Level:GetRoomByIdx(roomIdx, -1), roomIdx, candidates, 1)
    return candidates
end

--#endregion