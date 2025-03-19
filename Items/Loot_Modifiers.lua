---@class Decomp.Item.LootModifiers
local LootModifiers = {}
Decomp.Item.LootModifiers = LootModifiers

--#region BlockVariant

local function daemons_tail_try_block_heart(rng)
    return rng:RandomInt(5) ~= 0
end

local s_VariantBlockers = {
    [PickupVariant.PICKUP_HEART] = {
        {TrinketType.TRINKET_DAEMONS_TAIL, daemons_tail_try_block_heart}
    }
}

local function try_trinket_block(player, trinket, blockFunction)
    if player:GetTrinketMultiplier(trinket) <= 0 then
        return false
    end

    return blockFunction(player:GetTrinketRNG(trinket))
end

---@param player EntityPlayer
---@param variant PickupVariant | integer
---@return boolean block
function LootModifiers.TryBlockPickupVariant(player, variant)
    local variantBlockers = s_VariantBlockers[variant]
    if not variantBlockers then
        return false
    end

    for index, value in ipairs(variantBlockers) do
        if try_trinket_block(player, value[1], value[2]) then
            return true
        end
    end

    return false
end

--#endregion

--#region ExtraPickups

local s_ExtraPickupTrinkets = {
    [TrinketType.TRINKET_ACE_SPADES] = PickupVariant.PICKUP_TAROTCARD,
    [TrinketType.TRINKET_SAFETY_CAP] = PickupVariant.PICKUP_PILL,
    [TrinketType.TRINKET_MATCH_STICK] = PickupVariant.PICKUP_BOMB,
    [TrinketType.TRINKET_CHILDS_HEART] = PickupVariant.PICKUP_HEART,
    [TrinketType.TRINKET_RUSTED_KEY] = PickupVariant.PICKUP_KEY
}

---@param player EntityPlayer
---@param trinket TrinketType | integer
---@return integer? pickupVariant
---@return RNG? rng
function LootModifiers.TryGetExtraTrinketPickup(player, trinket)
    assert(s_ExtraPickupTrinkets[trinket], "trinket does not give an extra pickup reward")

    if player:GetTrinketMultiplier(trinket) > 0 then
        return nil
    end

    local pickupVariant = nil

    local trinketRNG = player:GetTrinketRNG(trinket)
    if trinketRNG:RandomInt(2) == 0 then
        pickupVariant = s_ExtraPickupTrinkets[trinket]
    end

    if not pickupVariant or LootModifiers.TryBlockPickupVariant(player, pickupVariant) then
        return nil
    end

    return pickupVariant, trinketRNG
end

--#endregion

--#region LootCountModifiers

---@param lootCount integer
---@return integer newLootCount
function LootModifiers.ApplyLootCountModifier_LuckyToe(lootCount)
    return lootCount + 1
end


--#endregion