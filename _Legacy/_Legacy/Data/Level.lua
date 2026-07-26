---@class Decomp.Data.Level.Portal
---@field m_RoomIdx integer
---@field m_GridIdx integer
---@field m_UnkBookOfVirtuesRelated boolean

---@class Decomp.Data.Level
---@field m_Portals Decomp.Data.Level.Portal[]

---@class Decomp.Data.Level.API
local LevelData = {}
Decomp.Data.Level = LevelData

---@return Decomp.Data.Level.Portal data
local function init_portal_data()
    ---@type Decomp.Data.Level.Portal
    local data = {
        m_RoomIdx = GridRooms.NO_ROOM_IDX,
        m_GridIdx = 0,
        m_UnkBookOfVirtuesRelated = false,
    }

    return data
end

---@param data Decomp.Data.Level.Portal
---@param storedData Decomp.Data.Level.Portal
local function store_portal_data(storedData, data)
    storedData.m_RoomIdx = data.m_RoomIdx
    storedData.m_GridIdx = data.m_GridIdx
    storedData.m_UnkBookOfVirtuesRelated = data.m_UnkBookOfVirtuesRelated
end

---@return Decomp.Data.Level data
local function init_level_data()
    ---@type Decomp.Data.Level
    local data = {
        m_Portals = {[0] = init_portal_data(), [1] = init_portal_data()},
    }

    return data
end

---@param data Decomp.Data.Level
---@param storedData Decomp.Data.Level
local function store_level_data(data, storedData)
    store_portal_data(storedData.m_Portals[0], data.m_Portals[0])
    store_portal_data(storedData.m_Portals[1], data.m_Portals[1])
end

local s_LevelData = init_level_data()

---@return Decomp.Data.Level data
function LevelData.GetData()
    return s_LevelData
end