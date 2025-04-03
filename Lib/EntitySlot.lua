---@class Decomp.Lib.EntitySlot
local Lib_EntitySlot = {}
Decomp.Lib.EntitySlot = Lib_EntitySlot

require("Lib.Table")

local g_PersistentGameData = Isaac.GetPersistentGameData()

local Lib = Decomp.Lib

--#region CheckAvailable

local s_LockedSlots = {
    [SlotVariant.HELL_GAME] = Achievement.HELL_GAME,
    [SlotVariant.CRANE_GAME] = Achievement.CRANE_GAME,
    [SlotVariant.CONFESSIONAL] = Achievement.CONFESSIONAL,
    [SlotVariant.ROTTEN_BEGGAR] = Achievement.ROTTEN_BEGGAR,
}

---@param variant SlotVariant | integer
---@return boolean isAvailable
function Lib_EntitySlot.IsAvailable(variant)
    local achievement = s_LockedSlots[variant]
    return not achievement or g_PersistentGameData:Unlocked(achievement)
end

--#endregion