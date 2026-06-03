---@class Component.LevelGenerator
---@field m_rng RNG : 0x0
---@field m_allowedShapes integer : 0x10
---@field m_occupiedPositions integer[] [169] : 0x14
---@field m_blockedPositions boolean[] [169] : 0x2b8
---@field m_rooms Component.LevelGenerator.Room[] : 0x364
---@field m_deadEnds integer[] : 0x370
---@field m_nonDeadEnds integer[] : 0x37c
---@field m_nextBossRoomIdx integer : 0x388
---@field m_numBossRooms integer : 0x38c
---@field m_isXL boolean : 0x390
---@field m_isChapter6 boolean : 0x391
---@field m_isStageVoid boolean : 0x392
---@field m_usable boolean : 0x393

---@param seed integer
---@return Component.LevelGenerator
local function New(seed)
    local occupiedPosition = {}
    local blockedPosition = {}

    for i = 1, 169 do
        occupiedPosition[i] = -1
        blockedPosition[i] = false
    end

    ---@type Component.LevelGenerator
    return {
        m_rng = RNG(seed, 35),
        m_allowedShapes = 0xFFFFFFFF & ((1 << RoomShape.NUM_ROOMSHAPES) - 1),
        m_occupiedPositions = occupiedPosition,
        m_blockedPositions = blockedPosition,
        m_rooms = {},
        m_deadEnds = {},
        m_nonDeadEnds = {},
        m_nextBossRoomIdx = -1,
        m_numBossRooms = 0,
        m_isXL = false,
        m_isChapter6 = false,
        m_isStageVoid = false,
        m_usable = true,
    }
end

---@class Module.LevelGenerator
local Module = {}

---#region Module

Module.New = New

---#endregion

return Module