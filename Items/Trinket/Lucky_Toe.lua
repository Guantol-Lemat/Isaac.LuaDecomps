---@class Decomp.Trinket.LuckyToe
local LuckyToe = {}
Decomp.Item.Trinket.LuckyToe = LuckyToe

LuckyToe.TRINKET_ID = TrinketType.TRINKET_LUCKY_TOE

---@param lootCount integer
---@return integer newLootCount
function LuckyToe.ApplyLootCountModifier(lootCount)
    return lootCount + 1
end