local Class = {}
---@class Decomp.Class.EntityPlayer
Class.EntityPlayer = {}

local Lib = {
    Math = require("Lib.Math"),
    EntityPlayer = require("Lib.EntityPlayer"),
    EntityPickup = require("Lib.EntityPickup")
}

local LuckyToe = require("Items.Trinket.Lucky_Toe")
local Birthright = require("Items.Collectible.Birthright")

local g_Game = Game()
local g_ItemPool = g_Game:GetItemPool()
local g_SFXManager = SFXManager()

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
        local pickupVariant, rng = Lib.EntityPickup.TryGetExtraTrinketPickup(player, trinket)
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

    if not Lib.EntityPickup.TryBlockPickupVariant(player, PickupVariant.PICKUP_HEART) then
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
    elseif randomFloat < 0.55 and not Lib.EntityPickup.TryBlockPickupVariant(player, PickupVariant.PICKUP_HEART) then
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
function Class.EntityPlayer.SalvageCollectible(player, position, collectible, seed, pool)
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
            numPickups = LuckyToe.ApplyLootCountModifier(numPickups)
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, false) then
        numPickups = Birthright.ApplySalvageCountModifier(player, numPickups)
    end

    local i = 1
    while i <= numPickups do
        numPickups = numPickups - spawn_salvage_pickup(player, rng, pool, position, i == 1)
        i = i + 1
    end
end

--#endregion

--#region ControlActiveItem

function Class.EntityPlayer.control_active_item(player, slot)
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
---@return SoundEffect | integer sound
local function get_belial_sound(player)
    local temporaryEffects = player:GetEffects()
    if temporaryEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) and temporaryEffects:HasNullEffect(NullItemID.ID_JUDAS_BIRTHRIGHT) then
        return SoundEffect.SOUND_DEVIL_CARD
    end

    return SoundEffect.SOUND_CANDLE_LIGHT
end

---@return Color newColor
local function get_belial_poof_color()
    local color = Color()
    color:SetTint(0.2, 0.2, 0.2, 0.6)
    color:SetColorize(1.0, 1.0, 1.0, 1.0)
    color:SetOffset(0.0, 0.0, 0.0)

    return color
end

---@param player EntityPlayer
---@param charge integer
local function animate_belial_poof(player, charge)
    if charge < 4 then
        local effect = g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, player.Position, Vector(0, 0), nil, 0, Random())
        effect.Color = get_belial_poof_color()
        effect:Update()
    else
        player:MakeGroundPoof(player.Position, get_belial_poof_color(), 1.0)
    end
end

---@param count integer
---@return Vector velocity
local function get_belial_flame_speed(count)
    local randomFloat = Random() * (1 / 2^32) -- the same as rng:RandomFloat but without initializing an RNG object
    local baseVelocity = Vector(0.0, randomFloat * -6.0 - 10.0)
    baseVelocity = baseVelocity * (count * 0.7 * 0.25 + 0.3)

    randomFloat = Random() * (1 / 2^32)
    local angle = randomFloat * 10.0 - 5.0

    local speedBoost = Lib.Math.MapToRange(count, {0.0, 12.0}, {0.6, 2.0}, true)
    return baseVelocity:Rotated(angle) * speedBoost
end

---@param flameEffect EntityEffect
local function post_process_belial_flame(flameEffect)
    local sprite = flameEffect:GetSprite()
    local layer = sprite:GetLayer(0)
    if not layer then
        return
    end
    layer:GetBlendMode():SetMode(BlendType.ADDITIVE)

    local color = layer:GetColor()
    color:Reset()
    color:SetTint(5.0, 0.5, 0.2, 1.0)
    layer:SetColor(color)

    local randomFloat = Random() * (1 / 2^32)
    flameEffect.Rotation = randomFloat * 10.0 + 2.0

    local randomInt = Random() % 10 + 10 -- RandomInt(10) + 10
    flameEffect.Timeout = randomInt
    flameEffect.LifeSpan = randomInt

    randomFloat = Random() * (1 / 2^32)
    local scale = randomFloat * 0.4 + 0.2
    sprite.Scale = Vector(1, 1) * scale * flameEffect.SpriteScale

    flameEffect.RenderZOffset = -600
end

---@param player EntityPlayer
local function animate_belial_flames(player)
    for i = 1, 5, 1 do
        local velocity = get_belial_flame_speed(i - 1)
        local startPosition = (velocity * 2) + player.Position

        local flame = g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, startPosition, velocity, player, 0, Random())
        local flameEffect = flame:ToEffect()
        if not flameEffect then
            flame:Remove() -- something went wrong for this to not be an effect
            goto continue
        end

        post_process_belial_flame(flameEffect)
        ::continue::
    end
end

---@param player EntityPlayer
---@param charge integer
local function animate_belial(player, charge)
    animate_belial_poof(player, charge)
    animate_belial_flames(player)
end

---@param player EntityPlayer
---@param collectible CollectibleType | integer
---@param charge integer
function Class.EntityPlayer.TriggerBookOfBelial(player, collectible, charge)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, false) then
        return
    end

    if trigger_belial_collectible_effect(collectible) then
        return
    end

    g_SFXManager:Play(get_belial_sound(player), 1.0, 2, false, 1.0, 0)

    local temporaryEffects = player:GetEffects()
    temporaryEffects:AddNullEffect(NullItemID.ID_JUDAS_BIRTHRIGHT, true, 1)

    animate_belial(player, charge)
end

--#endregion