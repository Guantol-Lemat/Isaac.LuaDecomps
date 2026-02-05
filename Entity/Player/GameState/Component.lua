---@class GameStatePlayerComponent
---@field m_playerType PlayerType | integer
---@field m_controllerIdx integer
---@field m_backupOwnerIdx integer -- treated as offset from current state in the playerManager.players list (0 if this is not a backup player)
---@field m_parentIdx integer -- index in the playerManager.players list (< 0 if this is not a parent)
---@field m_familiarData GameStatePlayer.FamiliarData[]
---@field m_familiarCount integer

---@class GameStatePlayer.FamiliarData

--#region Dependencies



--#endregion

---@class GameStatePlayerComponentModule
local Module = {}

---@param saveState GameStatePlayerComponent
local function Init(saveState)
end

---@return GameStatePlayerComponent
local function Create()
    local saveState = {}
    Init(saveState)
    return saveState
end

---@param familiarData GameStatePlayer.FamiliarData
---@return GameStatePlayer.FamiliarData
local function FamiliarDataCopy(familiarData)
end

--#region Module

Module.Create = Create
Module.Init = Init
Module.FamiliarDataCopy = FamiliarDataCopy

--#endregion

return Module