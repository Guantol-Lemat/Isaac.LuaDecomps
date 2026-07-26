---@class Decomp.Lib.EntitySlot
local Lib_EntitySlot = {}

local Table = require("Lib.Table")

local g_PersistentGameData = Isaac.GetPersistentGameData()

local s_LockedSlots = {
    [SlotVariant.HELL_GAME] = Achievement.HELL_GAME,
    [SlotVariant.CRANE_GAME] = Achievement.CRANE_GAME,
    [SlotVariant.CONFESSIONAL] = Achievement.CONFESSIONAL,
    [SlotVariant.ROTTEN_BEGGAR] = Achievement.ROTTEN_BEGGAR,
}

local s_BeggarSlot = Table.CreateDictionary({
    SlotVariant.BEGGAR, SlotVariant.DEVIL_BEGGAR, SlotVariant.KEY_MASTER,
    SlotVariant.BOMB_BUM, SlotVariant.BATTERY_BUM, SlotVariant.ROTTEN_BEGGAR,
})

---@param variant SlotVariant | integer
---@return boolean isAvailable
local function IsAvailable(variant)
    local achievement = s_LockedSlots[variant]
    return not achievement or g_PersistentGameData:Unlocked(achievement)
end

---@param variant SlotVariant | integer
---@return boolean isBeggar
local function IsBeggar(variant)
    return s_BeggarSlot[variant] ~= nil
end

--#region Module

---@param variant SlotVariant | integer
---@return boolean isAvailable
function Lib_EntitySlot.IsAvailable(variant)
    return IsAvailable(variant)
end

---@param variant SlotVariant | integer
---@return boolean isBeggar
function Lib_EntitySlot.IsBeggar(variant)
    return IsBeggar(variant)
end

--#endregion

return Lib_EntitySlot