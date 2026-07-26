--#region Dependencies

local EntitySaveStateComponentUtils = require("Entity.Common.SaveState.Component")

--#endregion

---@class PickupSaveStateComponent : EntitySaveStateComponent
---@field alternatePedestal integer
---@field charge integer
---@field price PickupPrice | integer
---@field shopItemId integer
---@field timeout integer
---@field touched boolean
---@field isBlind boolean
---@field optionsPickupIndex integer
---@field collectedCoopItems integer
---@field flipState PickupSaveStateComponent?

---@class PickupSaveStateComponentUtils
local Module = {}

---@return PickupSaveStateComponent
local function Create()
    local saveState = EntitySaveStateComponentUtils.Create()
    ---@cast saveState PickupSaveStateComponent
    saveState.price = 0
    saveState.collectedCoopItems = -1
    saveState.flipState = nil

    return saveState
end

--#region Module

Module.Create = Create

--#endregion

return Module