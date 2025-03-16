---@class Decomp.Trinket.RustedKey
local RustedKey = {}
Decomp.Item.Trinket.RustedKey = RustedKey

RustedKey.TRINKET_ID = TrinketType.TRINKET_RUSTED_KEY

---@param rng RNG
---@return integer? pickupVariant
function RustedKey.TryGetExtraPickup(rng)
    if rng:RandomInt(2) then
        return PickupVariant.PICKUP_KEY
    end
end