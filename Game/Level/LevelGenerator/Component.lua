--#region Dependencies

local LevelGeneratorUtils = require("Level.Generation.LevelGenerator.Utils")

--#endregion

---@class LevelGeneratorModule
local Module = {}

---@class LevelGeneratorComponent
---@field m_rng RNG
---@field m_allowedShapes integer -- bitset of RoomShape
---@field m_occupiedPositions integer[] -- [gridIdx] = generationIdx | -1
---@field m_blockedPositions boolean[] -- [gridIdx] = occupied
---@field m_rooms LevelGeneratorRoomComponent[]
---@field m_deadEndQueue integer[]
---@field m_nonDeadEndsQueue integer[]
---@field m_nextBossRoomIdx integer -- An auxiliary variable used by GetNewBossRoom to hold the result of determine_boss_room and the newly created extra boss room for XL floors
---@field m_numBossRooms integer
---@field m_isXL boolean
---@field m_isChapter6 boolean
---@field m_isVoid boolean
---@field m_isUsable boolean

---@class LevelGeneratorRoomComponent
---@field m_generationIdx integer
---@field m_position XYComponent
---@field m_size XYComponent
---@field m_shape RoomShape | integer
---@field m_requiredDoors integer -- bitset of DoorSlot
---@field m_originDirection Direction | integer
---@field m_originDoorSlot DoorSlot | integer
---@field m_linkPosition XYComponent
---@field m_neighbors Set<integer>
---@field m_deadEnd boolean
---@field m_distanceFromStart integer
---@field m_secret boolean

---@param seed integer
---@return LevelGeneratorComponent
local function NewLevelGenerator(seed)
    local occupiedPositions = {}
    for i = 1, 169, 1 do
        occupiedPositions[i] = -1
    end

    local blockedPositions = {}
    for i = 1, 169, 1 do
        blockedPositions[i] = false
    end

    ---@type LevelGeneratorComponent
    return {
        m_rng = RNG(seed, 35),
        m_allowedShapes = 0x1fff,
        m_occupiedPositions = occupiedPositions,
        m_blockedPositions = blockedPositions,
        m_rooms = {},
        m_deadEndQueue = {},
        m_nonDeadEndsQueue = {},
        m_nextBossRoomIdx = -1,
        m_numBossRooms = 0,
        m_isXL = false,
        m_isChapter6 = false,
        m_isVoid = false,
        m_isUsable = false,
    }
end

---@param position XYComponent
---@param shape RoomShape | integer
local function NewRoom(position, shape)
    local size = LevelGeneratorUtils.get_room_size(shape)

    ---@type LevelGeneratorRoomComponent
    return {
        m_generationIdx = -1,
        m_position = {x = position.x, y = position.y},
        m_size = {x = size[1], y = size[2]},
        m_shape = shape,
        m_requiredDoors = 0,
        m_originDirection = Direction.NO_DIRECTION,
        m_originDoorSlot = DoorSlot.NO_DOOR_SLOT,
        m_linkPosition = {x = -1, y = -1},
        m_neighbors = {},
        m_deadEnd = false,
        m_distanceFromStart = 0,
        m_secret = false,
    }
end

--#region Module

Module.NewLevelGenerator = NewLevelGenerator
Module.NewRoom = NewRoom

--#endregion

return Module