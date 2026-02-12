---@class GameStatePlayerComponent
---@field m_playerType PlayerType | integer
---@field m_controllerIdx integer
---@field m_backupOwnerIdx integer -- treated as offset from current state in the playerManager.players list (0 if this is not a backup player)
---@field m_parentIdx integer -- index in the playerManager.players list (< 0 if this is not a parent)
---@field m_familiarData GameStatePlayer.FamiliarData[]
---@field m_familiarCount integer

---@class GameStatePlayer.FamiliarData

---@class ConsumableDataComponent
---@field m_coins integer : 0x0
---@field m_keys integer : 0x4
---@field m_bombs integer : 0x8
---@field m_hasGoldKey boolean : 0xc
---@field m_hasGoldBomb boolean : 0xd
---@field m_soulCharges integer : 0x10
---@field m_gigaBombs integer : 0x14
---@field m_poopMana integer : 0x18
---@field m_bloodCharges integer : 0x1c

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