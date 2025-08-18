--#region Dependencies

local EntitySaveStateComponentUtils = require("Entity.Common.SaveState.Component")

--#endregion

---@class PickupSaveStateComponent : EntitySaveStateComponent
---@field collectedCoopItems integer
---@field flipState PickupSaveStateComponent?
---@field touched boolean

---@class PickupSaveStateComponentUtils
local Module = {}

---@return PickupSaveStateComponent
local function Create()
    local saveState = EntitySaveStateComponentUtils.Create()
    ---@cast saveState PickupSaveStateComponent
    saveState.collectedCoopItems = -1
    saveState.flipState = nil

    return saveState
end

--#region Module

Module.Create = Create

--#endregion

return Module