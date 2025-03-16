---@class Decomp.Trinket.DaemonsTail
local DaemonsTail = {}
Decomp.Item.Trinket.DaemonsTail = DaemonsTail

DaemonsTail.TRINKET_ID = TrinketType.TRINKET_DAEMONS_TAIL

---@param rng RNG
---@return boolean block
function DaemonsTail.TryBlockHeart(rng)
    return rng:RandomInt(5) ~= 0
end