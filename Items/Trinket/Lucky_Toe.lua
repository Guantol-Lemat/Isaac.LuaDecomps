---@class Decomp.Trinket.LuckyToe
local LuckyToe = {}

LuckyToe.TRINKET_ID = TrinketType.TRINKET_LUCKY_TOE

local g_Game = Game()

---@param lootCount integer
---@return integer newLootCount
function LuckyToe.ApplyLootCountModifier(lootCount)
    return lootCount + 1
end

return LuckyToe