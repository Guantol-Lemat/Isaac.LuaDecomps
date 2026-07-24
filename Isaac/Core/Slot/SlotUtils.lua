--#region Dependencies

local TableUtils = require("General.Table")

--#endregion

local BEGGAR_VARIANT = TableUtils.CreateDictionary({
    SlotVariant.BEGGAR, SlotVariant.DEVIL_BEGGAR,
    SlotVariant.KEY_MASTER, SlotVariant.BOMB_BUM,
    SlotVariant.BATTERY_BUM, SlotVariant.ROTTEN_BEGGAR
})

---@param variant SlotVariant
---@return boolean
local function IsBeggar(variant)
    return BEGGAR_VARIANT[variant] ~= nil
end

---@class Gameplay.Slot.Utils
local Module = {}

--#region Module

Module.IsBeggar = IsBeggar

--#endregion

return Module