---@class CoopExtraItemData
local Module = {}

---@param pickup Component.Entity.Pickup
local function InitData(pickup)
    pickup.m_coopExtra_collectedItems = -1
end

---@param pickup Component.Entity.Pickup
---@param saveState PickupSaveStateComponent
local function SaveState(pickup, saveState)
    saveState.collectedCoopItems = pickup.m_coopExtra_collectedItems
end

---@param pickup Component.Entity.Pickup
---@param saveState PickupSaveStateComponent
local function RestoreState(pickup, saveState)
    pickup.m_coopExtra_collectedItems = saveState.collectedCoopItems
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