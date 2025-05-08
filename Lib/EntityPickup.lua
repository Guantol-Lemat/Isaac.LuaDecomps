---@class Decomp.Lib.EntityPickup
local Lib_EntityPickup = {}
Decomp.Lib.EntityPickup = Lib_EntityPickup

local Table = require("Lib.Table")

local IsAfterbirthPlus = not REPENTANCE and not REPENTANCE_PLUS

--#region GetCard

---@param env Decomp.EnvironmentObject
---@param itemPool Decomp.ItemPoolObject
---@param seed integer
---@param specialChance integer
---@param runeChance integer
---@param suitChance integer
---@param allowNonCards boolean
---@return Card | integer card
local function GetCard(env, itemPool, seed, specialChance, runeChance, suitChance, allowNonCards)
    local api = env._API
    local card = api.ItemPool.GetCardEx(itemPool, seed, specialChance, runeChance, suitChance, allowNonCards)

    local rng = RNG()
    rng:SetSeed(seed, 35)
    local includePlayingCards = suitChance < 0
    local includeRunes = runeChance < 0
    local onlyRunes = (runeChance == 1 or runeChance == -1) and specialChance == 0

    return api.Environment.RunCallback(env, ModCallbacks.MC_GET_CARD, rng, card, includePlayingCards, includeRunes, onlyRunes) or card -- GetCardEx does not call the callback, so we have to, to maintain mod compatibility
end

---@param env Decomp.EnvironmentObject
---@param itemPool Decomp.ItemPoolObject
---@param seed integer
---@return Card | integer card
local function GetRune(env, itemPool, seed)
    return GetCard(env, itemPool, seed, 0, -1, 0, false)
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

---@class Decomp.Lib.EntityPickup.Switch.IsAvailable
---@field _API Decomp.IGlobalAPI
---@field _ENV Decomp.EnvironmentObject
---@field variant PickupVariant | integer
---@field subType integer

---@param io Decomp.Lib.EntityPickup.Switch.IsAvailable
local function is_collectible_available(io)
    local itemConfig = io._API.Environment.GetItemConfig(io._ENV)
    local collectibleConfig = io._API.ItemConfig.GetCollectible(itemConfig, io.subType)
    return not not (collectibleConfig and collectibleConfig:IsAvailable())
end

---@param io Decomp.Lib.EntityPickup.Switch.IsAvailable
local function is_trinket_available(io)
    local itemConfig = io._API.Environment.GetItemConfig(io._ENV)
    local trinketConfig = io._API.ItemConfig.GetTrinket(itemConfig, io.subType)
    return not not (trinketConfig and trinketConfig:IsAvailable())
end

---@param io Decomp.Lib.EntityPickup.Switch.IsAvailable
local function is_card_available(io)
    local itemConfig = io._API.Environment.GetItemConfig(io._ENV)
    local cardConfig = io._API.ItemConfig.GetCard(itemConfig, io.subType)
    return not not (cardConfig and cardConfig:IsAvailable())
end

---@param io Decomp.Lib.EntityPickup.Switch.IsAvailable
local function is_pill_available(io)
    local itemConfig = io._API.Environment.GetItemConfig(io._ENV)
    local pillConfig = io._API.ItemConfig.GetPillEffect(itemConfig, io.subType)
    return not not (pillConfig and pillConfig:IsAvailable())
end

---@param io Decomp.Lib.EntityPickup.Switch.IsAvailable
local function is_pickup_available(io)
    local persistentGameData = io._API.Environment.GetPersistentGameData(io._ENV)
    local variant = io.variant

    local achievement = s_LockedPickupVariants[variant]
    if achievement and not io._API.PersistentGameData.Unlocked(persistentGameData, achievement) then
        return false
    end

    achievement = s_LockedPickupSubTypes[variant] and s_LockedPickupSubTypes[variant][io.subType]
    if achievement and not io._API.PersistentGameData.Unlocked(persistentGameData, achievement) then
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

---@param env Decomp.EnvironmentObject
---@param variant PickupVariant | integer
---@param subType integer
---@return boolean
local function IsAvailable(env, variant, subType)
    ---@type Decomp.Lib.EntityPickup.Switch.IsAvailable
    local io = {_API = env._API, _ENV = env, variant = variant, subType = subType}
    local is_available = switch_IsVariantAvailable[variant] or switch_IsVariantAvailable.default
    return is_available(io)
end

--#endregion

--#region TypeChecks

local s_Chests = Table.CreateDictionary({
    PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_REDCHEST, PickupVariant.PICKUP_BOMBCHEST,
    PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_SPIKEDCHEST, PickupVariant.PICKUP_MIMICCHEST, PickupVariant.PICKUP_MOMSCHEST,
    PickupVariant.PICKUP_OLDCHEST, PickupVariant.PICKUP_WOODENCHEST, PickupVariant.PICKUP_MEGACHEST, PickupVariant.PICKUP_HAUNTEDCHEST,
})

---@param variant PickupVariant | integer
---@return boolean isChest
local function IsChest(variant)
    return not not s_Chests[variant]
end

--#endregion

--#region Module

Lib_EntityPickup.GetCard = GetCard
Lib_EntityPickup.GetRune = GetRune
Lib_EntityPickup.IsAvailable = IsAvailable
Lib_EntityPickup.IsChest = IsChest

--#endregion

return Lib_EntityPickup