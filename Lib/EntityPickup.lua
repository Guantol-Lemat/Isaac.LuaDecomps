local Lib = {}
---@class Decomp.Lib.EntityPickup
Lib.EntityPickup = {}

local DaemonsTail = require("Items.Trinket.Daemons_Tail")
local AceOfSpades = require("Items.Trinket.Ace_Of_Spades")
local SafetyCap = require("Items.Trinket.Safety_Cap")
local MatchStick = require("Items.Trinket.Match_Stick")
local ChildsHeart = require("Items.Trinket.Childs_Heart")
local RustedKey = require("Items.Trinket.Rusted_Key")

local g_Game = Game()
local g_ItemPool = g_Game:GetItemPool()
local g_ItemConfig = Isaac.GetItemConfig()
local g_PersistentGameData = Isaac.GetPersistentGameData()

local IsAfterbirthPlus = not REPENTANCE and not REPENTANCE_PLUS

--#region BlockVariant

local s_VariantBlockers = {
    [PickupVariant.PICKUP_HEART] = {
        {DaemonsTail.TRINKET_ID, DaemonsTail.TryBlockHeart}
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
function Lib.EntityPickup.TryBlockPickupVariant(player, variant)
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
    [TrinketType.TRINKET_ACE_SPADES] = AceOfSpades.TryGetExtraPickup,
    [TrinketType.TRINKET_SAFETY_CAP] = SafetyCap.TryGetExtraPickup,
    [TrinketType.TRINKET_MATCH_STICK] = MatchStick.TryGetExtraPickup,
    [TrinketType.TRINKET_CHILDS_HEART] = ChildsHeart.TryGetExtraPickup,
    [TrinketType.TRINKET_RUSTED_KEY] = RustedKey.TryGetExtraPickup
}

---@param player EntityPlayer
---@param trinket TrinketType | integer
---@return integer? pickupVariant
---@return RNG? rng
function Lib.EntityPickup.TryGetExtraTrinketPickup(player, trinket)
    assert(s_ExtraPickupTrinkets[trinket], "trinket does not give an extra pickup reward")

    if player:GetTrinketMultiplier(trinket) > 0 then
        return nil
    end

    local trinketRNG = player:GetTrinketRNG(trinket)
    local pickupVariant = s_ExtraPickupTrinkets[trinket](trinketRNG)

    if not pickupVariant or Lib.EntityPickup.TryBlockPickupVariant(player, pickupVariant) then
        return nil
    end

    return pickupVariant, trinketRNG
end

--#endregion

--#region GetCard

function Lib.EntityPickup.GetCard(seed, specialChance, runeChance, suitChance, allowNonCards)
    local card = g_ItemPool:GetCardEx(seed, specialChance, runeChance, suitChance, allowNonCards)

    local rng = RNG()
    rng:SetSeed(seed, 35)
    local includePlayingCards = suitChance < 0
    local includeRunes = runeChance < 0
    local onlyRunes = (runeChance == 1 or runeChance == -1) and specialChance == 0

    return Isaac.RunCallback(ModCallbacks.MC_GET_CARD, rng, card, includePlayingCards, includeRunes, onlyRunes) or card -- GetCardEx does not call the callback, so we have to, to maintain mod compatibility
end

function Lib.EntityPickup.GetRune(seed)
    return Lib.EntityPickup.GetCard(seed, 0, -1, 0, 0)
end

--#endregion

--#region CheckUnlock

local s_LockedPickupVariants = {
    [PickupVariant.PICKUP_WOODENCHEST] = Achievement.WOODEN_CHEST,
    [PickupVariant.PICKUP_MEGACHEST] = Achievement.MEGA_CHEST,
    [PickupVariant.PICKUP_HAUNTEDCHEST] = Achievement.HAUNTED_CHEST,
}

local s_LockedPickupSubTypes = {
    [PickupVariant.PICKUP_HEART] = {
        [HeartSubType.HEART_GOLDEN] = Achievement.GOLDEN_HEARTS,
        [HeartSubType.HEART_HALF_SOUL] = IsAfterbirthPlus and Achievement.SCARED_HEART or Achievement.EVERYTHING_IS_TERRIBLE,
        [HeartSubType.HEART_SCARED] = Achievement.SCARED_HEART,
        [HeartSubType.HEART_BONE] = Achievement.BONE_HEARTS,
        [HeartSubType.HEART_ROTTEN] = Achievement.ROTTEN_HEARTS,
    },
    [PickupVariant.PICKUP_COIN] = {
        [CoinSubType.COIN_LUCKYPENNY] = Achievement.LUCKY_PENNIES,
        [CoinSubType.COIN_STICKYNICKEL] = Achievement.STICKY_NICKELS,
        [CoinSubType.COIN_GOLDEN] = Achievement.GOLDEN_PENNY,
    },
    [PickupVariant.PICKUP_BOMB] = {
        [BombSubType.BOMB_GOLDEN] = Achievement.GOLDEN_BOMBS,
    },
    [PickupVariant.PICKUP_KEY] = {
        [KeySubType.KEY_CHARGED] = Achievement.CHARGED_KEY,
    },
    [PickupVariant.PICKUP_LIL_BATTERY] = {
        [BatterySubType.BATTERY_MICRO] = Achievement.EVERYTHING_IS_TERRIBLE,
        [BatterySubType.BATTERY_GOLDEN] = Achievement.GOLDEN_BATTERY,
    },
    [PickupVariant.PICKUP_GRAB_BAG] = {
        [SackSubType.SACK_BLACK] = Achievement.BLACK_SACK,
    }
}

local function is_collectible_available(_, collectible)
    local collectibleConfig = g_ItemConfig:GetCollectible(collectible)
    return not not (collectibleConfig and collectibleConfig:IsAvailable())
end

local function is_trinket_available(_, trinket)
    local trinketConfig = g_ItemConfig:GetTrinket(trinket)
    return not not (trinketConfig and trinketConfig:IsAvailable())
end

local function is_card_available(_, card)
    local cardConfig = g_ItemConfig:GetCard(card)
    return not not (cardConfig and cardConfig:IsAvailable())
end

local function is_pill_available(_, pill)
    local pillConfig = g_ItemConfig:GetPillEffect(pill)
    return not not (pillConfig and pillConfig:IsAvailable())
end

local function is_pickup_available(variant, subType)
    local achievement = s_LockedPickupVariants[variant]
    if achievement and not g_PersistentGameData:Unlocked(achievement) then
        return false
    end

    achievement = s_LockedPickupSubTypes[variant] and s_LockedPickupSubTypes[variant][subType]
    if achievement and not g_PersistentGameData:Unlocked(achievement) then
        return false
    end

    return true
end

local switch_IsVariantAvailable = {
    [PickupVariant.PICKUP_COLLECTIBLE] = is_collectible_available,
    [PickupVariant.PICKUP_TRINKET] = is_trinket_available,
    [PickupVariant.PICKUP_TAROTCARD] = is_card_available,
    [PickupVariant.PICKUP_PILL] = is_pill_available,
    default = is_pickup_available
}

function Lib.EntityPickup.IsAvailable(variant, subType)
    local is_available = switch_IsVariantAvailable[variant] or switch_IsVariantAvailable.default
    return is_available(variant, subType)
end

--#endregion

return Lib.EntityPickup