---@class CoopStatsComponent
---@field m_playerInfos CoopStats.PlayerInfoComponent[]
---@field m_awards CoopAwardDescComponent[] -- 21
---@field m_finalized boolean

---@class CoopStats.PlayerInfoComponent
---@field m_userId UserId
---@field m_stats number[] -- 22

---@class CoopAwardDescComponent
---@field string string
---@field stat integer
---@field allowsMultipleWinners boolean
---@field highestWins boolean
---@field threshold number
---@field minimumStages integer
---@field finalizedWinners UserId[]