---@class PersistentDataComponent
---@field m_achievements boolean[]
---@field m_eventCounters integer[]
---@field m_itemsCollection boolean[]
---@field m_timesStageCompleted integer[]
---@field m_sinsKilled boolean[]
---@field m_bossesKilled boolean[]
---@field m_challenges boolean[]
---@field m_readOnly boolean
---@field m_changesMade boolean

---@class PersistentDataComponentUtils
local Module = {}

---@return PersistentDataComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module