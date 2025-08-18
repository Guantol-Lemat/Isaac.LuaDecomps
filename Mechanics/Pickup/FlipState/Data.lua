---@class FlipStateData
local Module = {}

---@param pickup EntityPickupComponent
local function InitData(pickup)
    pickup.m_flipState = nil
    pickup.m_flipCollectibleSprite = Sprite()
end

---@param pickup EntityPickupComponent
---@param saveState PickupSaveStateComponent
local function SaveState(pickup, saveState)
    -- The game does not perform a copy of the original save state
    saveState.flipState = pickup.m_flipState
end

---@param pickup EntityPickupComponent
---@param saveState PickupSaveStateComponent
local function RestoreState(pickup, saveState)
    pickup.m_flipState = saveState.flipState
    pickup.m_flipCollectibleSprite:Reset()
end

---@param saveState PickupSaveStateComponent
---@param other PickupSaveStateComponent
local function CopyState(saveState, other)
    saveState.flipState = other.flipState
end

--#region Module

Module.InitData = InitData
Module.SaveState = SaveState
Module.RestoreState = RestoreState
Module.CopyState = CopyState

--#endregion

return Module