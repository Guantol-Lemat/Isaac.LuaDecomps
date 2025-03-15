---@class Decomp.Trinket.MatchStick
local MatchStick = {}

MatchStick.TRINKET_ID = TrinketType.TRINKET_MATCH_STICK

---@param rng RNG
---@return integer? pickupVariant
function MatchStick.TryGetExtraPickup(rng)
    if rng:RandomInt(2) then
        return PickupVariant.PICKUP_BOMB
    end
end

return MatchStick