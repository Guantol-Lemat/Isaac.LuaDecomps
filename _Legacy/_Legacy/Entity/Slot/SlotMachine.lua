---@class Decomp.Entity.Slot.SlotMachine
local SlotMachine = {}

local g_Game = Game()

require("Items.Loot_Modifiers")

local LootModifiers = Decomp.Item.LootModifiers

local ePrizeType = {
    FLY = 3, -- Can be either Pretty Fly or Enemy Fly
    BOMB = 4,
    HEART_1 = 5,
    HEART_2 = 6,
    KEY = 7,
    PILL = 8,
    DOLLAR = 9,
    PORTABLE_SLOT = 10,
    COIN_1 = 11,
    COIN_2 = 12,
    COIN_3 = 13,
}

---@param slot EntitySlot
local function trigger_explosion(slot)
    g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, slot.Position, Vector(0, 0), nil, 0, Random())
    slot:CreateDropsFromExplosion()
    slot:SetState(3)
    local sprite = slot:GetSprite()
    sprite:SetAnimation("Death", false)
end

---@param prize integer
---@param player EntityPlayer
---@param rng RNG
---@return integer?
local function try_morph_prize(prize, player, rng)
    if prize >= ePrizeType.COIN_1 and rng:RandomInt(10) ~= 0 then
        return prize + 1 -- 1/3 chance for the coin to be nothing
    end

    if prize == ePrizeType.DOLLAR and rng:RandomInt(10) >= 3 then
        return ePrizeType.COIN_1
    end

    if prize == ePrizeType.PORTABLE_SLOT and rng:RandomInt(10) >= 5 then
        return ePrizeType.COIN_1
    end

    if prize == ePrizeType.KEY and rng:RandomInt(3) == 0 then
        return ePrizeType.COIN_1
    end

    if (prize == ePrizeType.HEART_1 or prize == ePrizeType.HEART_2) and LootModifiers.TryBlockPickupVariant_Player(player, PickupVariant.PICKUP_HEART) then
        return ePrizeType.COIN_1
    end
end

---@param prize integer
---@return integer?
local function check_deathmatch_prize_restrictions(prize)
    if not false then -- In Deathmatch
        return
    end

    if prize == ePrizeType.DOLLAR and false then -- Is Collectible Banned
        return ePrizeType.COIN_1
    end

    if prize == ePrizeType.PORTABLE_SLOT and false then -- Is Collectible Banned
        return ePrizeType.FLY
    end
end

---@param slot EntitySlot
---@param player EntityPlayer
---@param rng RNG
---@return integer
local function get_prize_type(slot, player, rng)
    local prize = 0

    local possibleValues = player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) and 15 or 21
    prize = rng:RandomInt(possibleValues) + 3
    prize = try_morph_prize(prize, player, rng) or prize

    if g_Game.Difficulty == Difficulty.DIFFICULTY_HARD and rng:RandomInt(2) == 0 then
        prize = 0
    end

    prize = check_deathmatch_prize_restrictions(prize) or prize
    return prize
end

---@param slot EntitySlot
---@param player EntityPlayer
local function SetPrize(slot, player)
    local sprite = slot:GetSprite()
    sprite:SetAnimation("Prize", false)

    local rng = slot:GetDropRNG()
    if rng:RandomInt(50) == 0 then
        trigger_explosion(slot)
        return
    end

    local prize = get_prize_type(slot, player, rng)
    slot:SetPrizeType(prize)
    update_sprite_layers(slot, prize)
end

function SlotMachine.SetPrize()

end