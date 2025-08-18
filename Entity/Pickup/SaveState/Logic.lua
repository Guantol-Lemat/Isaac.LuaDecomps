--#region Dependencies

local EntitySaveState = require("Entity.Common.SaveState.Logic")
local CoopExtraItemData = require("Mechanics.Pickup.CoopExtraItem.Data")
local FlipStateData = require("Mechanics.Pickup.FlipState.Data")

--#endregion

---@class PickupSaveStateLogic
local Module = {}

---@param context Context
---@param pickup EntityPickupComponent
---@param saveState PickupSaveStateComponent
local function hook_pickup_save_state(context, pickup, saveState)
    CoopExtraItemData.SaveState(pickup, saveState)
    FlipStateData.SaveState(pickup, saveState)
end

---@param context Context
---@param pickup EntityPickupComponent
---@param saveState PickupSaveStateComponent
---@return PickupSaveStateComponent
local function SaveState(context, pickup, saveState)
    EntitySaveState.SaveState(context, pickup, saveState)
    saveState.touched = pickup.m_touched
    hook_pickup_save_state(context, pickup, saveState)
    return saveState
end

--#region Module

Module.SaveState = SaveState

--#endregion

return Module