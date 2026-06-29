---@class Component.GameState.Player
---@field m_playerType PlayerType | integer
---@field m_controllerIdx integer
---@field m_backupOwnerIdx integer -- treated as offset from current state in the playerManager.players list (0 if this is not a backup player)
---@field m_parentIdx integer -- index in the playerManager.players list (< 0 if this is not a parent)
---@field m_familiarData GameState.Player.FamiliarData[]
---@field m_familiarCount integer

---@class GameState.Player.FamiliarData

---@class Component.ConsumableData
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

---@param saveState Component.GameState.Player
local function Init(saveState)
end

---@return Component.GameState.Player
local function Create()
    local saveState = {}
    Init(saveState)
    return saveState
end

---@param familiarData GameState.Player.FamiliarData
---@return GameState.Player.FamiliarData
local function FamiliarDataCopy(familiarData)
end

--#region Module

Module.Create = Create
Module.Init = Init
Module.FamiliarDataCopy = FamiliarDataCopy

--#endregion

return Module