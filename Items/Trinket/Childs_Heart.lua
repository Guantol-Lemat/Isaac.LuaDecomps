---@class Decomp.Trinket.ChildsHeart
local ChildsHeart = {}
Decomp.Item.Trinket.ChildsHeart = ChildsHeart

ChildsHeart.TRINKET_ID = TrinketType.TRINKET_CHILDS_HEART

---@param rng RNG
---@return integer? pickupVariant
function ChildsHeart.TryGetExtraPickup(rng)
    if rng:RandomInt(2) then
        return PickupVariant.PICKUP_HEART
    end
end