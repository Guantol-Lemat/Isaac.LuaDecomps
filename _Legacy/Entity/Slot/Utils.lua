--#region Dependencies

local TableUtils = require("General.Table")

--#endregion

---@class SlotUtils
local Module = {}

local BEGGARS = TableUtils.CreateDictionary({
    SlotVariant.BEGGAR, SlotVariant.DEVIL_BEGGAR, SlotVariant.KEY_MASTER,
    SlotVariant.KEY_MASTER, SlotVariant.BOMB_BUM, SlotVariant.BATTERY_BUM,
    SlotVariant.ROTTEN_BEGGAR,
})

---@param variant SlotVariant
---@return boolean
local function IsBeggar(variant)
    return not not BEGGARS[variant]
end

---@param variant SlotVariant
---@return boolean
local function IsShellGame(variant)
    return variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME
end

--#region Module

Module.IsBeggar = IsBeggar
Module.IsShellGame = IsShellGame

--#endregion

return Module