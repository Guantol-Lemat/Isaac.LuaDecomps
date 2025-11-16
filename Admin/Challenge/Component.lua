---@class ChallengeParamsComponent
---@field m_endStage LevelStage | integer
---@field m_curses LevelCurse | integer
---@field m_curseFilter LevelCurse | integer
---@field m_roomFilter Set<RoomType>
---@field m_altersEndStage boolean -- consider challenge EndStage and AltPath params
---@field m_isAltPath boolean
---@field m_isMegaSatan boolean
---@field m_isSecretPath boolean

---@class ChallengeParamsComponentUtils
local Module = {}

---@return ChallengeParamsComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module