---@class Decomp.Trinket.DaemonsTail
local DaemonsTail = {}

DaemonsTail.TRINKET_ID = TrinketType.TRINKET_DAEMONS_TAIL

local g_Game = Game()

---@param rng RNG
---@return boolean block
function DaemonsTail.TryBlockHeart(rng)
    return rng:RandomInt(5) ~= 0
end

return DaemonsTail