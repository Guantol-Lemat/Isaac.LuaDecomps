---@class Decomp.Trinket.AceOfSpades
local AceOfSpades = {}
Decomp.Item.Trinket.AceOfSpades = AceOfSpades

AceOfSpades.TRINKET_ID = TrinketType.TRINKET_ACE_SPADES

---@param rng RNG
---@return integer? pickupVariant
function AceOfSpades.TryGetExtraPickup(rng)
    if rng:RandomInt(2) then
        return PickupVariant.PICKUP_TAROTCARD
    end
end