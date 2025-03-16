---@class Decomp.Trinket.SafetyCap
local SafetyCap = {}
Decomp.Item.Trinket.SafetyCap = SafetyCap

SafetyCap.TRINKET_ID = TrinketType.TRINKET_SAFETY_CAP

---@param rng RNG
---@return integer? pickupVariant
function SafetyCap.TryGetExtraPickup(rng)
    if rng:RandomInt(2) then
        return PickupVariant.PICKUP_PILL
    end
end