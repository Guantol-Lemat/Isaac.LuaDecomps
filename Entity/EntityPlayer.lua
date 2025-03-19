---@class Decomp.Class.EntityPlayer
local Class_EntityPlayer = {}
Decomp.Class.EntityPlayer = Class_EntityPlayer

require("Lib.Math")
require("Lib.EntityPlayer")
require("Lib.EntityPickup")

require("General.Enums")

require("Items.Collectible.Birthright")
require("Items.Collectible.Book_of_Belial")
require("Items.Collectible.Binge_Eater")
require("Items.Collectible.Candy_Heart")
require("Items.Collectible.Soul_Locket")

require("Items.Trinket.Lucky_Toe")
require("Items.Trinket.Cracked_Crown")

require("Players.Tainted_Bethany")

local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_ItemPool = g_Game:GetItemPool()

local Lib = Decomp.Lib
local Enums = Decomp.Enums
local Player = Decomp.Player
local Item = Decomp.Item
local Collectible = Item.Collectible

--#region SalvageCollectible

local s_ExtraPickupTrinkets = {
    TrinketType.TRINKET_ACE_SPADES,
    TrinketType.TRINKET_SAFETY_CAP,
    TrinketType.TRINKET_MATCH_STICK,
}

---@param player EntityPlayer
---@return integer? variant
---@return integer? seed
local function try_get_extra_trinket_reward(player)
    for index, trinket in ipairs(s_ExtraPickupTrinkets) do
        local pickupVariant, rng = Item.LootModifiers.TryGetExtraTrinketPickup(player, trinket)
        if pickupVariant and rng then
            return pickupVariant, rng:Next()
        end
    end

    return nil
end

local function get_devil_salvage_pickup()
    return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK}
end

local function get_angel_salvage_pickup()
    return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL}
end

local function get_secret_salvage_pickup()
    return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE}
end

local function get_red_chest_salvage_pickup()
    return {PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY}
end

local function get_curse_salvage_pickup()
    return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN}
end

local function get_planetarium_salvage_pickup(_, rng)
    return {PickupVariant.PICKUP_TAROTCARD, g_ItemPool:GetCardEx(rng:Next(), 0, -1, 0, true)} -- GET_CARD is not called so it's mod incompatible
end

local s_SalvageOutcomes = {
    [0] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL},
    [1] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL},
    [2] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME},
    [3] = {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN},
    [4] = {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN},
    [5] = {PickupVariant.PICKUP_NULL, NullPickupSubType.ANY},
}

---@param player EntityPlayer
---@param rng RNG
local function get_first_salvage_pickup(player, rng)
    local wop = WeightedOutcomePicker()

    if not Item.LootModifiers.TryBlockPickupVariant(player, PickupVariant.PICKUP_HEART) then
        wop:AddOutcomeWeight(0, 10)
    end
    wop:AddOutcomeWeight(1, 10)
    wop:AddOutcomeWeight(2, 5)
    wop:AddOutcomeWeight(3, 1)
    wop:AddOutcomeWeight(4, 1)
    wop:AddOutcomeWeight(5, 30)

    local wopRNG = RNG()
    wopRNG:SetSeed(rng:Next(), 35)
    return s_SalvageOutcomes[wop:PickOutcome(wopRNG)]
end

local switch_GetFirstSalvagePickup = {
    [ItemPoolType.POOL_DEVIL] = get_devil_salvage_pickup,
    [ItemPoolType.POOL_GREED_DEVIL] = get_devil_salvage_pickup,
    [ItemPoolType.POOL_ANGEL] = get_angel_salvage_pickup,
    [ItemPoolType.POOL_GREED_ANGEL] = get_angel_salvage_pickup,
    [ItemPoolType.POOL_SECRET] = get_secret_salvage_pickup,
    [ItemPoolType.POOL_GREED_SECRET] = get_secret_salvage_pickup,
    [ItemPoolType.POOL_RED_CHEST] = get_red_chest_salvage_pickup,
    [ItemPoolType.POOL_CURSE] = get_curse_salvage_pickup,
    [ItemPoolType.POOL_GREED_CURSE] = get_curse_salvage_pickup,
    [ItemPoolType.POOL_PLANETARIUM] = get_planetarium_salvage_pickup,
    default = get_first_salvage_pickup
}

---@param rng RNG
---@param position Vector
local function spawn_salvage_coins(rng, position)
    local numCoins = rng:RandomInt(3) + 1
    for i = 1, numCoins, 1 do
        g_Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, position, EntityPickup.GetRandomPickupVelocity(position, nil, 0), nil, 0, rng:Next())
    end
end

---@param player EntityPlayer
---@param rng RNG
---@param pool integer
---@param position Vector
---@param isFirst boolean
---@return integer numPickupsReduction -- mark whether or not the number of pickups must be further reduced
local function spawn_salvage_pickup(player, rng, pool, position, isFirst)
    local randomFloat = rng:RandomFloat()

    if pool == ItemPoolType.POOL_NULL then
        pool = g_ItemPool:GetPoolForRoom(g_Game:GetRoom():GetType(), rng:Next())
    end

    if isFirst then
        get_first_salvage_pickup = switch_GetFirstSalvagePickup[pool] or switch_GetFirstSalvagePickup.default
        local firstSalvagePickup = get_first_salvage_pickup(player, rng)

        if firstSalvagePickup[1] ~= PickupVariant.PICKUP_NULL and Lib.EntityPickup.IsAvailable(firstSalvagePickup[1], firstSalvagePickup[2]) then
            g_Game:Spawn(EntityType.ENTITY_PICKUP, firstSalvagePickup[1], position, EntityPickup.GetRandomPickupVelocity(position, nil, 0), nil, firstSalvagePickup[2], rng:Next())
            return 0
        end
    end

    local numPickupsReduction = 0

    if randomFloat < 0.35 then
        spawn_salvage_coins(rng, position)
    elseif randomFloat < 0.55 and not Item.LootModifiers.TryBlockPickupVariant(player, PickupVariant.PICKUP_HEART) then
        g_Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, position, EntityPickup.GetRandomPickupVelocity(position, nil, 0), nil, 0, rng:Next())
        if rng:RandomInt(2) == 0 then
            numPickupsReduction = 1 -- reduce the total amount of pickups to spawn by one
        end
    elseif randomFloat < 0.7 then
        g_Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, position, EntityPickup.GetRandomPickupVelocity(position, nil, 0), nil, 0, rng:Next())
    else
        g_Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, position, EntityPickup.GetRandomPickupVelocity(position, nil, 0), nil, 0, rng:Next())
    end

    return numPickupsReduction
end

---@param player EntityPlayer
---@param position Vector
---@param collectible CollectibleType | integer
---@param seed integer
---@param pool ItemPoolType | integer
function Class_EntityPlayer.SalvageCollectible(player, position, collectible, seed, pool)
    local rng = RNG()
    rng:SetSeed(seed, 13)

    local numPickups = math.max(rng:RandomInt(4) + 3, 4)

    if rng:RandomInt(3) ~= 0 then
        local velocity = EntityPickup.GetRandomPickupVelocity(position, nil, 0)
        local extraVariant, extraSeed = try_get_extra_trinket_reward(player)

        if extraVariant and extraSeed then
            g_Game:Spawn(EntityType.ENTITY_PICKUP, extraVariant, position, velocity, nil, 0, extraSeed)
        end

        if player:GetTrinketMultiplier(TrinketType.TRINKET_LUCKY_TOE) > 0 then
            numPickups = Decomp.Item.LootModifiers.ApplyLootCountModifier_LuckyToe(numPickups)
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, false) then
        numPickups = Collectible.Birthright.ApplySalvageCountModifier(player, numPickups)
    end

    local i = 1
    while i <= numPickups do
        numPickups = numPickups - spawn_salvage_pickup(player, rng, pool, position, i == 1)
        i = i + 1
    end
end

--#endregion

--#region ControlActiveItem

function Class_EntityPlayer.control_active_item(player, slot)
    local playerType = player:GetPlayerType()
    if player.Variant == 1 or player:IsCoopGhost() or player:IsHologram() or playerType == PlayerType.PLAYER_THESOUL_B then
        return
    end

    if player.ItemHoldCooldown ~= 0 and player:GetItemState() ~= CollectibleType.COLLECTIBLE_NULL then
        return
    end

    local controllingActiveItem = Lib.EntityPlayer.IsControllingActiveItem(player, slot)
    -- TODO: insert Item Logic here
end

--#endregion

--#region TriggerBookOfBelial

---@param collectible CollectibleType | integer
---@return boolean earlyReturn
local function trigger_belial_collectible_effect(collectible)
    --- TODO: place item logic
    return false
end

---@param player EntityPlayer
---@param collectible CollectibleType | integer
---@param charge integer
function Class_EntityPlayer.TriggerBookOfBelial(player, collectible, charge)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, false) then
        return
    end

    if trigger_belial_collectible_effect(collectible) then
        return
    end

    Collectible.BookOfBelial.PostTriggerBookOfBelial(player, charge)
end

--#endregion

--#region EvaluateItems

---@param player EntityPlayer
---@param cacheFlags CacheFlag
---@return CacheFlag newCacheFlags
local function force_enable_cache_flags(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_SHOTSPEED then
        cacheFlags = cacheFlags | CacheFlag.CACHE_RANGE
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_LIBRA, false) or player:GetZodiacEffect() == CollectibleType.COLLECTIBLE_LIBRA then
        local libraStats = CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_SPEED
        if cacheFlags & libraStats then
            cacheFlags = cacheFlags | libraStats
        end
    end

    return cacheFlags
end

---@param player EntityPlayer
---@param cacheFlags CacheFlag -- cacheFlags are not actually passed, but we cannot read the player's flag from lua
function Class_EntityPlayer.EvaluateItems(player, cacheFlags)
    local statModifiers = Decomp.StatEvaluation.GetStatModifiers(player)
    local statGainMultiplier = Decomp.StatEvaluation.GetStatGainMultiplier(player)

    if cacheFlags & CacheFlag.CACHE_WEAPON then
        evaluate_weapon()
    end

    cacheFlags = force_enable_cache_flags(player, cacheFlags)

    if cacheFlags & CacheFlag.CACHE_FIREDELAY then
        Decomp.StatEvaluation.EvaluateFireDelay(player, statModifiers[Enums.eStatModifiers.TEARS], statGainMultiplier)
    end

    if cacheFlags & CacheFlag.CACHE_DAMAGE then
        evaluate_damage()
    end

    if cacheFlags & CacheFlag.CACHE_SHOTSPEED then
        evaluate_shot_speed()
    end

    if cacheFlags & CacheFlag.CACHE_RANGE then
        evaluate_range()
    end

    if cacheFlags & CacheFlag.CACHE_SPEED then
        evaluate_speed()
    end

    if cacheFlags & CacheFlag.CACHE_TEARFLAG then
        evaluate_tear_flags()
    end

    if cacheFlags & CacheFlag.CACHE_TEARCOLOR then
        evaluate_tear_color()
    end

    if cacheFlags & CacheFlag.CACHE_FLYING then
        evaluate_flying()
    end

    if cacheFlags & CacheFlag.CACHE_FAMILIARS and player.Variant == 0 then
        evaluate_familiars()
    end

    if cacheFlags & CacheFlag.CACHE_LUCK then
        evaluate_luck()
    end

    if cacheFlags & CacheFlag.CACHE_SIZE and player.Variant == 0 then
        evaluate_size()
    end

    if cacheFlags & CacheFlag.CACHE_COLOR then
        evaluate_color()
    end

    apply_libra_stats()
    apply_rock_bottom_stats()
    apply_dogma_stats()

    if cacheFlags & CacheFlag.CACHE_TWIN_SYNC == 0x10 then
        sync_twin_stats()
    end

    if cacheFlags & CacheFlag.CACHE_PICKUP_VISION then
        evaluate_pickup_vision()
    end

    normalize_stats()
    apply_gfuel_stats()

    cacheFlags = 0
end

--#endregion