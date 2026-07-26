---@class Decomp.Room.UltraSecret
local UltraSecretRoom = {}

local Lib = {
    LevelGenerator = require("Lib.LevelGenerator")
}

--#region LevelGenerator Rules

local NUM_GRID_ROOMS = 169

local eSourceDirection = {
    LEFT = 0,
    LEFT_UP = 1,
    UP = 2,
    UP_RIGHT = 3,
    RIGHT = 4,
    RIGHT_DOWN = 5,
    DOWN = 6,
    DOWN_LEFT = 7,
    NUM_POSSIBLE_SOURCE = 8
}

-- These represent the position offsets of all possible UltraSecret room sources
local s_SourceOffsets = {
    [eSourceDirection.LEFT] = Vector(-2, 0),
    [eSourceDirection.LEFT_UP] = Vector(-1, -1),
    [eSourceDirection.UP] = Vector(0, -2),
    [eSourceDirection.UP_RIGHT] = Vector(1, -1),
    [eSourceDirection.RIGHT] = Vector(2, 0),
    [eSourceDirection.RIGHT_DOWN] = Vector(1, 1),
    [eSourceDirection.DOWN] = Vector(0, 2),
    [eSourceDirection.DOWN_LEFT] = Vector(-1, 1)
}

---@param levelGen LevelGenerator
---@param gridIdx integer
---@param blacklist table<integer, boolean>
---@return boolean valid
local function is_valid_grid_idx(levelGen, gridIdx, blacklist)
    return Lib.LevelGenerator.IsGridIdxFree(levelGen, gridIdx) and (not blacklist[gridIdx])
end

---@param levelGen any
---@param gridIdx any
---@return boolean isFree
local function are_neighbors_free(levelGen, gridIdx)
    local neighbors = Lib.LevelGenerator.GetNeighborGridIndexesFromGridIdx(gridIdx)

    for _, value in ipairs(neighbors) do
        if not Lib.LevelGenerator.IsGridIdxFree(levelGen, value) then
            return false
        end
    end

    return true
end

---@param levelGen LevelGenerator
---@param gridIdx integer
---@return LevelGeneratorRoom room
local function LevelGenerator_GetRoomByIdx(levelGen, gridIdx)
    local rooms = levelGen:GetAllRooms()
    return 
end

---@param levelGen LevelGenerator
---@param gridIdx integer
local function get_sources(levelGen, gridIdx)
    for i = eSourceDirection.LEFT, eSourceDirection.NUM_POSSIBLE_SOURCE - 1, 1 do
        levelGen.
    end
end

local function get_source_count(levelGen, gridIdx, blacklist)

end

---@param levelGen LevelGenerator
---@param gridIdx integer
---@param blacklist table<integer, boolean>
---@return integer? score -- if room is invalid then we return no score
local function get_candidate_score(levelGen, gridIdx, blacklist)
    local rng = RNG() -- Should be levelGen RNG
    local score = rng:RandomInt(5) + 10

    if not are_neighbors_free(levelGen, gridIdx) then
        return nil
    end

    local numSources = get_source_count()
end

---@param levelGen LevelGenerator
---@param blacklist table<integer, boolean>
---@return integer[]
local function get_ultra_secret_room_candidates(levelGen, blacklist)
    local bestScore = 0
    local candidates = {}

    for i = 0, NUM_GRID_ROOMS - 1, 1 do
        if not is_valid_grid_idx(levelGen, i, blacklist) then
            goto continue
        end

        local score = get_candidate_score(levelGen, i, blacklist)
        if not score then
            goto continue
        end

        if score > bestScore then
            candidates = {i}
        elseif score == bestScore then
            table.insert(candidates, i)
        end
        ::continue::
    end

    return candidates
end

---@param levelGen LevelGenerator
---@param blacklist table<integer, boolean>
---@return LevelGeneratorRoom? ultraSecretRoom
function UltraSecretRoom.GetNewUltraSecretRoom(levelGen, blacklist)
    local candidates = get_ultra_secret_room_candidates(levelGen, blacklist)

    local numCandidates = #candidates
    if numCandidates == 0 then -- If no candidates have been found then do not generate a room
        return nil
    end

    local rng = RNG() -- This should be the levelGen RNG
    local gridIdx = candidates[rng:RandomInt(numCandidates) + 1]

    return place_ultra_secret_room(gridIdx)
end

--#endregion