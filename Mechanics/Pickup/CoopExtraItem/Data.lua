---@class CoopExtraItemData
local Module = {}

---@param pickup EntityPickupComponent
local function InitData(pickup)
    pickup.m_collectedCoopItems = -1
end

---@param pickup EntityPickupComponent
---@param saveState PickupSaveStateComponent
local function SaveState(pickup, saveState)
    saveState.collectedCoopItems = pickup.m_collectedCoopItems
end

---@param pickup EntityPickupComponent
---@param saveState PickupSaveStateComponent
local function RestoreState(pickup, saveState)
    pickup.m_collectedCoopItems = saveState.collectedCoopItems
end

---@param saveState PickupSaveStateComponent
---@param other PickupSaveStateComponent
local function CopyState(saveState, other)
    saveState.collectedCoopItems = other.collectedCoopItems
end

--#region Module

Module.InitData = InitData
Module.SaveState = SaveState
Module.RestoreState = RestoreState
Module.CopyState = CopyState

--#endregion

return Module