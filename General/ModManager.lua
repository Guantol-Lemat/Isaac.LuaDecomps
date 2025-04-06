---@class Decomp.Class.ModManager
local Class_ModManager = {}
Decomp.Class.ModManager = Class_ModManager

---@class Decomp.ModManager.ModEntry.Data
---@field m_Directory string
---@field m_Name string
---@field m_ResourcesDirectory string
---@field m_ContentDirectory string
---@field m_Enabled boolean
---@field m_Loaded boolean
---@field m_Outdated boolean

---@class Decomp.ModManager.ModEntry
---@field __data Decomp.ModManager.ModEntry.Data
local ModEntry = {}

---@param filePath string
---@return string
function ModEntry:GetContentPath(filePath)
    local data = self.__data
    return data.m_ContentDirectory .. "/" .. filePath
end

---@return Decomp.ModManager.ModEntry
local function new_mod_entry()
    ---@type Decomp.ModManager.ModEntry
    local modEntry = {
        __data = {
            m_Directory = "",
            m_Name = "",
            m_ResourcesDirectory = "",
            m_ContentDirectory = "",
            m_Enabled = false,
            m_Loaded = false,
            m_Outdated = false,
        },

        GetContentPath = ModEntry.GetContentPath,
    }

    return modEntry
end

---@class Decomp.Class.ModManager.Data
---@field m_ModEntries Decomp.ModManager.ModEntry[]

local function ModManager_new()
    ---@type Decomp.Class.ModManager.Data
    local modManager = {
        m_ModEntries = {},
    }

    return modManager
end

local m_ModManagerData = ModManager_new()

---@return Decomp.ModManager.ModEntry[]
function Class_ModManager.GetModEntries()
    local modEntry = m_ModManagerData.m_ModEntries[1]
    modEntry:GetContentPath("trial")
    return m_ModManagerData.m_ModEntries
end