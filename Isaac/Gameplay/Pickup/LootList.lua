--#region Dependencies

local IGame = require("Isaac.Interface.Game")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IItemPool = require("Isaac.Interface.ItemPool")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local LootListUtils = require("Isaac.Utils.LootList")

--#endregion

---@alias PickupLootList.Switch.GetLootList fun(ctx: PickupLootList.Closure)

---@alias PickupLootList.Switch.Chest.GetOutcomeLoot fun(ctx: PickupLootList.Closure, isLocked: boolean, outcome: integer)

---@alias PickupLootList.Switch.ChestPickups.GetOutcomeLoot fun(ctx: PickupLootList.Closure)

---@class PickupLootList.Closure : Context.Common
---@field pickup Component.Entity.Pickup
---@field lootList Component.LootList
---@field rng RNG
---@field shouldAdvance boolean
---@field level_isStage6 boolean
---@field aceSpades_rng RNG?
---@field safetyCap_rng RNG?
---@field matchStick_rng RNG?
---@field childsHeart_rng RNG?
---@field rustedKey_rng RNG?
---@field daemonsTail_rng RNG?

local OUTCOME_TRINKET = 0
local OUTCOME_CHEST = 1
local OUTCOME_LOCKED_CHEST = 2
local OUTCOME_PICKUPS = 3
local OUTCOME_PILL = 4
local OUTCOME_CARD = 5
local OUTCOME_COLLECTIBLE = 6
local OUTCOME_GILDED_KEY_PICKUPS = 7

local PICKUP_COIN = 0
local PICKUP_HEART = 1
local PICKUP_KEY = 2
local PICKUP_BOMB = 3
local PICKUP_PILL = 4
local PICKUP_CARD = 5
local PICKUP_RUNE = 6
local PICKUP_TRINKET = 7
local PICKUP_BATTERY = 8

---@param wop WeightedOutcomePicker
---@param rng RNG
---@return integer
local function wop_pick_outcome(wop, rng)
    local wop_rng = RNG(rng:Next(), 35)
    return wop:PickOutcome(wop_rng)
end

local ChestPickups_Switch_get_loot = {
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_COIN + 1] = function(ctx)
        local count = ctx.rng:RandomInt(3) + 1
        for i = 1, count, 1 do
            LootListUtils.Add(
                ctx.lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COIN,
                0,
                ctx.rng:Next()
            )
        end
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_HEART + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_HEART,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_KEY + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_KEY,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_BOMB + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_BOMB,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_PILL + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_PILL,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_CARD + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TAROTCARD,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_RUNE + 1] = function(ctx)
        local rune = IItemPool.GetCard(ctx, ctx.rng:Next(), false, true, true)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TAROTCARD,
            rune,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_TRINKET + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.ChestPickups.GetOutcomeLoot
    [PICKUP_BATTERY + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_LIL_BATTERY,
            0,
            ctx.rng:Next()
        )
    end,
}

---@type PickupLootList.Switch.Chest.GetOutcomeLoot
local function Chest_get_pickups_loot(ctx, isLocked, outcome)
    local ctx_game = ctx.game
    local ctx_playerManager = ctx_game.m_playerManager
    local rng = ctx.rng
    local lootList = ctx.lootList

    local isGilded = outcome == OUTCOME_GILDED_KEY_PICKUPS

    local lootCountMax = isLocked and 7 or 4
    local lootCount = rng:RandomInt(lootCountMax)
    lootCount = math.min(lootCount, 2)

    local hasExtraPickup = rng:RandomInt(3) ~= 0
    if hasExtraPickup then
        local extraPickup_variant
        local extraPickup_seed

        if ctx.aceSpades_rng and ctx.aceSpades_rng:RandomInt(2) == 0 then
            extraPickup_variant = PickupVariant.PICKUP_TAROTCARD
            extraPickup_seed = ctx.aceSpades_rng:Next()
        elseif ctx.safetyCap_rng and ctx.safetyCap_rng:RandomInt(2) == 0 then
            extraPickup_variant = PickupVariant.PICKUP_PILL
            extraPickup_seed = ctx.safetyCap_rng:Next()
        elseif ctx.matchStick_rng and ctx.matchStick_rng:RandomInt(2) == 0 then
            extraPickup_variant = PickupVariant.PICKUP_BOMB
            extraPickup_seed = ctx.matchStick_rng:Next()
        elseif (ctx.childsHeart_rng and ctx.childsHeart_rng:RandomInt(2) == 0)
          and (not ctx.daemonsTail_rng or ctx.daemonsTail_rng:RandomInt(5) == 0) then
            extraPickup_variant = PickupVariant.PICKUP_HEART
            extraPickup_variant = ctx.childsHeart_rng:Next()
        elseif ctx.rustedKey_rng and ctx.rustedKey_rng:RandomInt(2) == 0 then
            extraPickup_variant = PickupVariant.PICKUP_KEY
            extraPickup_variant = ctx.rustedKey_rng:Next()
        end

        if extraPickup_variant then
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                extraPickup_variant,
                0,
                extraPickup_seed
            )
        end

        if IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_LUCKY_TOE) then
            lootCount = lootCount + 1
        end
    end

    if IPlayerManager.AnyoneHasCollectible(ctx_playerManager, ctx, CollectibleType.COLLECTIBLE_MOMS_KEY) then
        lootCount = lootCount * 2
    end

    if IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_POKER_CHIP) then
        local pokerChip_rng = RNG(rng:GetSeed(), 7)
        if pokerChip_rng:RandomInt(2) == 0 then
            lootCount = lootCount * 2
        else
            lootCount = 0
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_ATTACKFLY,
                0,
                0,
                rng:Next()
            )
        end
    end

    -- build picker
    local wop = WeightedOutcomePicker()
    if isGilded then
        wop:AddOutcomeWeight(PICKUP_COIN, 25)
        local heart_weight = ctx.daemonsTail_rng ~= nil and 4 or 20
        wop:AddOutcomeWeight(PICKUP_HEART, heart_weight)
        wop:AddOutcomeWeight(PICKUP_KEY, 10)
        wop:AddOutcomeWeight(PICKUP_BOMB, 20)
        wop:AddOutcomeWeight(PICKUP_PILL, 5)
        wop:AddOutcomeWeight(PICKUP_CARD, 5)
        wop:AddOutcomeWeight(PICKUP_RUNE, 5)
        wop:AddOutcomeWeight(PICKUP_TRINKET, 5)
        wop:AddOutcomeWeight(PICKUP_BATTERY, 5)
    else
        wop:AddOutcomeWeight(PICKUP_COIN, 35)
        local heart_weight = ctx.daemonsTail_rng ~= nil and 4 or 20
        wop:AddOutcomeWeight(PICKUP_HEART, heart_weight)
        wop:AddOutcomeWeight(PICKUP_KEY, 15)
        wop:AddOutcomeWeight(PICKUP_BOMB, 30)
    end

    for i = 1, lootCount, 1 do
        local loot_outcome = wop_pick_outcome(wop, rng)
        local get_pickup_loot = ChestPickups_Switch_get_loot[loot_outcome + 1]
        get_pickup_loot(ctx)
    end
end

---@type table<integer, PickupLootList.Switch.Chest.GetOutcomeLoot>
local Switch_Chest_get_outcome_loot = {
    ---@type PickupLootList.Switch.Chest.GetOutcomeLoot
    [OUTCOME_TRINKET + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.Chest.GetOutcomeLoot
    [OUTCOME_CHEST + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_CHEST,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.Chest.GetOutcomeLoot
    [OUTCOME_LOCKED_CHEST + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_LOCKEDCHEST,
            0,
            ctx.rng:Next()
        )
    end,
    [OUTCOME_PICKUPS + 1] = Chest_get_pickups_loot,
    ---@type PickupLootList.Switch.Chest.GetOutcomeLoot
    [OUTCOME_PILL + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_PILL,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.Chest.GetOutcomeLoot
    [OUTCOME_CARD + 1] = function(ctx)
        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TAROTCARD,
            0,
            ctx.rng:Next()
        )
    end,
    ---@type PickupLootList.Switch.Chest.GetOutcomeLoot
    [OUTCOME_COLLECTIBLE + 1] = function(ctx)
        local rng = ctx.rng
        local entrySeed = rng:Next()
        local flags = ctx.shouldAdvance and 0 or 1
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_GOLDEN_CHEST, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )
    end,
    [OUTCOME_GILDED_KEY_PICKUPS + 1] = Chest_get_pickups_loot
}

---@type PickupLootList.Switch.GetLootList
local function Chest_get_loot_list(ctx)
    local ctx_game = ctx.game

    local pickup = ctx.pickup
    local variant = pickup.m_variant
    local level_isStage6 = ctx.level_isStage6
    local rng = ctx.rng
    local shouldAdvance = ctx.shouldAdvance
    local lootList = ctx.lootList

    local chest_isLocked = variant == PickupVariant.PICKUP_LOCKEDCHEST
        or variant == PickupVariant.PICKUP_BOMBCHEST
        or variant == PickupVariant.PICKUP_ETERNALCHEST
        or variant == PickupVariant.PICKUP_MEGACHEST

    local chest_isMega = PickupVariant.PICKUP_MEGACHEST

    local giveCollectible = level_isStage6
        or (chest_isMega and rng:RandomInt(2) == 0)

    if giveCollectible then
        local entrySeed = rng:Next()
        local flags = shouldAdvance and 0 or 1
        local collectible = IItemPool.GetCollectible(ctx_game.m_itemPool, ctx, ItemPoolType.POOL_TREASURE, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )

        if chest_isMega then
            entrySeed = rng:Next()
            collectible = IItemPool.GetCollectible(ctx_game.m_itemPool, ctx, ItemPoolType.POOL_TREASURE, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                collectible,
                entrySeed
            )
        end

        return
    end

    local gildedKeyList = chest_isLocked and IPlayerManager.AnyoneHasTrinket(ctx_game.m_playerManager, ctx, TrinketType.TRINKET_GILDED_KEY)

    -- build weighted outcome picker
    local wop = WeightedOutcomePicker()
    if not gildedKeyList then
        wop:AddOutcomeWeight(OUTCOME_TRINKET, 10)

        if not chest_isMega then
            wop:AddOutcomeWeight(OUTCOME_CHEST, 1)
            wop:AddOutcomeWeight(OUTCOME_LOCKED_CHEST, 1)
        end

        if not chest_isLocked then
            wop:AddOutcomeWeight(OUTCOME_PILL, 10)
            wop:AddOutcomeWeight(OUTCOME_PICKUPS, 78)
        else
            wop:AddOutcomeWeight(OUTCOME_CARD, 10)
            if not chest_isMega then
                wop:AddOutcomeWeight(OUTCOME_COLLECTIBLE, 20)
            end
            wop:AddOutcomeWeight(OUTCOME_PICKUPS, 58)
        end
    else
        wop:AddOutcomeWeight(OUTCOME_GILDED_KEY_PICKUPS, 80)

        if not chest_isMega then
            wop:AddOutcomeWeight(OUTCOME_COLLECTIBLE, 20)
        end
    end

    local loopCount = chest_isMega and 5 or 1
    for i = 1, loopCount, 1 do
        local outcome = wop_pick_outcome(wop, rng)
        local get_outcome_loot = Switch_Chest_get_outcome_loot[outcome + 1]
        get_outcome_loot(ctx, chest_isLocked, outcome)
    end
end

local OLD_OUTCOME_HEART = 0
local OLD_OUTCOME_TRINKET = 1
local OLD_OUTCOME_OLD_COLLECTIBLE = 2
local OLD_OUTCOME_ANGEL_COLLECTIBLE = 3

---@type table<integer, PickupLootList.Switch.GetLootList>
local Switch_OldChest_get_outcome_loot = {
    [OLD_OUTCOME_HEART + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        local count = rng:RandomInt(3) + 1
        for i = 1, count, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_HEART,
                HeartSubType.HEART_SOUL,
                rng:Next()
            )
        end
    end,
    [OLD_OUTCOME_TRINKET + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        for i = 1, 3, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TRINKET,
                0,
                rng:Next()
            )
        end
    end,
    [OLD_OUTCOME_OLD_COLLECTIBLE + 1] = function (ctx)
        local rng = ctx.rng
        local flags = ctx.shouldAdvance and 0 or 1
        local entrySeed = rng:Next()
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_OLD_CHEST, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )
    end,
    [OLD_OUTCOME_ANGEL_COLLECTIBLE + 1] = function (ctx)
        local rng = ctx.rng
        local flags = ctx.shouldAdvance and 0 or 1
        local entrySeed = rng:Next()
        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_ANGEL, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )
    end
}

---@type PickupLootList.Switch.GetLootList
local function OldChest_get_loot_list(ctx)
    local rng = ctx.rng

    local daemonsTail_hasEffect = ctx.daemonsTail_rng ~= nil
    local heart_weight = daemonsTail_hasEffect and 9 or 43

    local wop = WeightedOutcomePicker()
    wop:AddOutcomeWeight(OLD_OUTCOME_HEART, heart_weight)
    wop:AddOutcomeWeight(OLD_OUTCOME_TRINKET, 42)
    wop:AddOutcomeWeight(OLD_OUTCOME_OLD_COLLECTIBLE, 10)
    wop:AddOutcomeWeight(OLD_OUTCOME_ANGEL_COLLECTIBLE, 5)

    local outcome = wop_pick_outcome(wop, rng)
    local get_outcome_loot = Switch_OldChest_get_outcome_loot[outcome + 1]
    get_outcome_loot(ctx)
end

local WOODEN_OUTCOME_ITEM = 0
local WOODEN_OUTCOME_CARD = 1
local WOODEN_OUTCOME_PILL = 2

---@type PickupLootList.Switch.GetLootList
local function WoodenChest_get_loot_list(ctx)
    local ctx_game = ctx.game
    local ctx_playerManager = ctx_game.m_playerManager

    local aceSpades_rng = ctx.aceSpades_rng
    local safetyCap_rng = ctx.safetyCap_rng
    local lootList = ctx.lootList
    local rng = ctx.rng
    local shouldAdvance = ctx.shouldAdvance

    local wop = WeightedOutcomePicker()

    wop:AddOutcomeWeight(WOODEN_OUTCOME_ITEM, 2)
    wop:AddOutcomeWeight(WOODEN_OUTCOME_CARD, 10)
    wop:AddOutcomeWeight(WOODEN_OUTCOME_PILL, 10)

    local outcome = wop_pick_outcome(wop, rng)

    local lootCount = rng:RandomInt(2) + 2

    -- extra pickup
    local canHaveExtraPickup = outcome ~= WOODEN_OUTCOME_ITEM
    if canHaveExtraPickup then
        local hasExtraPickup = rng:RandomInt(3) ~= 0
        if hasExtraPickup then
            local extraPickup_isCard = aceSpades_rng and aceSpades_rng:RandomInt(2) == 0
            local extraPickup_isPill = not extraPickup_isCard
                and (safetyCap_rng and safetyCap_rng:RandomInt(2) == 0)

            if extraPickup_isCard then
                ---@cast aceSpades_rng RNG
                LootListUtils.Add(
                    lootList,
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TAROTCARD,
                    0,
                    aceSpades_rng:Next()
                )
            elseif extraPickup_isPill then
                ---@cast safetyCap_rng RNG
                LootListUtils.Add(
                    lootList,
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_PILL,
                    0,
                    safetyCap_rng:Next()
                )
            end

            if IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_LUCKY_TOE) then
                lootCount = lootCount + 1
            end
        end
    end

    if IPlayerManager.AnyoneHasCollectible(ctx_playerManager, ctx, CollectibleType.COLLECTIBLE_MOMS_KEY) then
        lootCount = lootCount * 2
    end

    if IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_POKER_CHIP) then
        local pokerChip_rng = RNG(rng:GetSeed(), 7)
        if pokerChip_rng:RandomInt(2) == 0 then
            lootCount = lootCount * 2
        else
            lootCount = 0
        end
    end

    -- BUG: the outcome is picked again
    outcome = wop_pick_outcome(wop, rng)

    if outcome == WOODEN_OUTCOME_ITEM then
        local entrySeed = rng:Next()
        local collectibleSeed = rng:Next()
        local flags = shouldAdvance and 0 or 1
        local collectible = IItemPool.GetCollectible(ctx_game.m_itemPool, ctx, ItemPoolType.POOL_WOODEN_CHEST, collectibleSeed, flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )
    elseif outcome == WOODEN_OUTCOME_CARD then
        for i = 1, lootCount, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TAROTCARD,
                0,
                rng:Next()
            )
        end
    elseif outcome == WOODEN_OUTCOME_PILL then
        for i = 1, lootCount, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_PILL,
                0,
                rng:Next()
            )
        end
    end

    if lootCount == 0 then
        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_ATTACKFLY,
            0,
            0,
            rng:Next()
        )
    end
end

---@type PickupLootList.Switch.GetLootList
local function GrabBag_get_loot_list(ctx)
    local pickup = ctx.pickup
    local lootList = ctx.lootList
    local rng = ctx.rng

    local grabBag_isBlack = pickup.m_subtype == SackSubType.SACK_BLACK
    local wop = WeightedOutcomePicker()

    local OUTCOME_BLACK_HEART = PickupVariant.PICKUP_HEART | (HeartSubType.HEART_BLACK << 16)
    local OUTCOME_BONE_HEART = PickupVariant.PICKUP_HEART | (HeartSubType.HEART_BONE << 16)
    local BLACK_HEART_WEIGHT = 10
    local BONE_HEART_WEIGHT = 5

    -- build picker
    if grabBag_isBlack then
        wop:AddOutcomeWeight(PickupVariant.PICKUP_BOMB, 10)
        wop:AddOutcomeWeight(OUTCOME_BLACK_HEART, BLACK_HEART_WEIGHT)
        wop:AddOutcomeWeight(OUTCOME_BONE_HEART, BONE_HEART_WEIGHT)
        wop:AddOutcomeWeight(PickupVariant.PICKUP_PILL, 15)
    else
        wop:AddOutcomeWeight(PickupVariant.PICKUP_BOMB, 10)
        wop:AddOutcomeWeight(PickupVariant.PICKUP_KEY, 20)
        wop:AddOutcomeWeight(PickupVariant.PICKUP_COIN, 15)
        wop:AddOutcomeWeight(PickupVariant.PICKUP_LIL_BATTERY, 4)
        wop:AddOutcomeWeight(PickupVariant.PICKUP_TAROTCARD, 4)
    end

    local lootCount = rng:RandomInt(2) + 2
    for i = 1, lootCount, 1 do
        local outcome = wop_pick_outcome(wop, rng)

        local pickup_variant = outcome & 0xFFFF
        local pickup_subtype = outcome >> 16

        rng:Next()
        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_PICKUP,
            pickup_variant,
            pickup_subtype,
            rng:Next()
        )

        if grabBag_isBlack and pickup_variant == PickupVariant.PICKUP_HEART then
            -- remove heart from pool
            wop:AddOutcomeWeight(OUTCOME_BLACK_HEART, -BLACK_HEART_WEIGHT)
            wop:AddOutcomeWeight(OUTCOME_BONE_HEART, -BONE_HEART_WEIGHT)
        end
    end
end

local RED_OUTCOME_COLLECTIBLE = 0
local RED_OUTCOME_DEAL_WARP = 1
local RED_OUTCOME_ENEMY_SPIDERs = 2
local RED_OUTCOME_SUPER_TROLL_BOMB = 3
local RED_OUTCOME_BLUE_FLIES = 4
local RED_OUTCOME_BLUE_SPIDERS = 5
local RED_OUTCOME_SOUL_HEART = 6
local RED_OUTCOME_TROLL_BOMBS = 7
local RED_OUTCOME_PILLS = 8

---@type table<integer, PickupLootList.Switch.GetLootList>
local Switch_RedChest_get_outcome_loot = {
    [RED_OUTCOME_COLLECTIBLE + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng
        local entrySeed = rng:Next()
        local flags = ctx.shouldAdvance and 0 or 1

        local collectible = IItemPool.GetCollectible(ctx.game.m_itemPool, ctx, ItemPoolType.POOL_RED_CHEST, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )
    end,
    [RED_OUTCOME_DEAL_WARP + 1] = function (ctx)
        LootListUtils.Add(
            ctx.lootList,
            0,
            1,
            0,
            0
        )
    end,
    [RED_OUTCOME_ENEMY_SPIDERs + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        for i = 1, 2, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_SPIDER,
                0,
                0,
                rng:Next()
            )
        end
    end,
    [RED_OUTCOME_SUPER_TROLL_BOMB + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_BOMB,
            BombVariant.BOMB_SUPERTROLL,
            0,
            rng:Next()
        )
    end,
    [RED_OUTCOME_BLUE_FLIES + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        for i = 1, 3, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_FAMILIAR,
                FamiliarVariant.BLUE_FLY,
                0,
                rng:Next()
            )
        end
    end,
    [RED_OUTCOME_BLUE_SPIDERS + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        for i = 1, 3, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_FAMILIAR,
                FamiliarVariant.BLUE_SPIDER,
                0,
                rng:Next()
            )
        end
    end,
    [RED_OUTCOME_SOUL_HEART + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        LootListUtils.Add(
            lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_HEART,
            HeartSubType.HEART_SOUL,
            rng:Next()
        )

        local giveSecondHeart = rng:RandomInt(2) == 0
            and (ctx.daemonsTail_rng == nil or ctx.daemonsTail_rng:RandomInt(5) == 0)

        if giveSecondHeart then
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_HEART,
                HeartSubType.HEART_SOUL,
                rng:Next()
            )
        end
    end,
    [RED_OUTCOME_TROLL_BOMBS + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        for i = 1, 2, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_BOMB,
                BombVariant.BOMB_TROLL,
                0,
                rng:Next()
            )
        end
    end,
    [RED_OUTCOME_PILLS + 1] = function (ctx)
        local lootList = ctx.lootList
        local rng = ctx.rng

        for i = 1, 2, 1 do
            LootListUtils.Add(
                lootList,
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_PILL,
                0,
                rng:Next()
            )
        end
    end
}

---@type PickupLootList.Switch.GetLootList
local function RedChest_get_loot_list(ctx)
    local ctx_game = ctx.game
    local level = ctx_game.m_level
    local rng = ctx.rng
    local giveCollectible = ctx.level_isStage6 and level.m_roomIdx == level.m_startingRoomIdx

    if giveCollectible then
        local flags = ctx.shouldAdvance and 0 or 1
        local entrySeed = rng:Next()
        local collectible = IItemPool.GetCollectible(ctx_game.m_itemPool, ctx, ItemPoolType.POOL_DEVIL, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)

        LootListUtils.Add(
            ctx.lootList,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectible,
            entrySeed
        )

        return
    end

    local roomIdx = level.m_roomIdx
    local canDealWarp = roomIdx ~= GridRooms.ROOM_DEVIL_IDX
        and roomIdx ~= GridRooms.ROOM_GENESIS_IDX
    local daemonsTail_hasEffect = ctx.daemonsTail_rng ~= nil

    -- build picker
    local wop = WeightedOutcomePicker()
    wop:AddOutcomeWeight(RED_OUTCOME_COLLECTIBLE, 10)
    if canDealWarp then
        wop:AddOutcomeWeight(RED_OUTCOME_DEAL_WARP, 5)
    end
    wop:AddOutcomeWeight(RED_OUTCOME_ENEMY_SPIDERs, 13)
    wop:AddOutcomeWeight(RED_OUTCOME_SUPER_TROLL_BOMB, 13)
    wop:AddOutcomeWeight(RED_OUTCOME_BLUE_FLIES, 7)
    wop:AddOutcomeWeight(RED_OUTCOME_BLUE_SPIDERS, 7)
    local heart_weight = daemonsTail_hasEffect and 3 or 16
    wop:AddOutcomeWeight(RED_OUTCOME_SOUL_HEART, heart_weight)
    wop:AddOutcomeWeight(RED_OUTCOME_TROLL_BOMBS, 15)
    wop:AddOutcomeWeight(RED_OUTCOME_PILLS, 15)

    local outcome = wop_pick_outcome(wop, rng)
    local get_outcome_loot = Switch_RedChest_get_outcome_loot[outcome + 1]
    get_outcome_loot(ctx)
end

---@type PickupLootList.Switch.GetLootList
local function MomsChest_get_loot_list(ctx)
    local ctx_game = ctx.game

    local lootList = ctx.lootList
    local rng = ctx.rng
    local shouldAdvance = ctx.shouldAdvance

    local entrySeed
    local collectibleType
    if not IPersistentGameData.Unlocked(ctx.manager.m_persistentGameData, ctx, Achievement.RED_KEY) then
        entrySeed = rng:Next()
        collectibleType = CollectibleType.COLLECTIBLE_RED_KEY
    else
        entrySeed = rng:Next()
        local flags = shouldAdvance and 0 or 1
        collectibleType = IItemPool.GetCollectible(ctx_game.m_itemPool, ctx, ItemPoolType.POOL_MOMS_CHEST, rng:Next(), flags, CollectibleType.COLLECTIBLE_NULL)
    end

    LootListUtils.Add(
        lootList,
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        collectibleType,
        entrySeed
    )
end

local Switch_get_loot_list = {
    [PickupVariant.PICKUP_OLDCHEST] = OldChest_get_loot_list,
    [PickupVariant.PICKUP_WOODENCHEST] = WoodenChest_get_loot_list,
    [PickupVariant.PICKUP_GRAB_BAG] = GrabBag_get_loot_list,
    [PickupVariant.PICKUP_REDCHEST] = RedChest_get_loot_list,
    [PickupVariant.PICKUP_MOMSCHEST] = MomsChest_get_loot_list,
}

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param shouldAdvance boolean
---@return Component.LootList
local function GetLootList(ctx, pickup, shouldAdvance)
    local ctx_game = ctx.game
    local ctx_playerManager = ctx_game.m_playerManager
    local level = ctx_game.m_level

    -- setup rng
    local rng = pickup.m_dropRNG
    local seed = rng:GetSeed()
    local noDecreaseRNG = RNG(seed, rng:GetShiftIdx())

    ---@type RNG?
    local daemonsTail_rng = RNG(seed, 1)
    ---@type RNG?
    local aceSpades_rng = RNG(seed, 2)
    ---@type RNG?
    local safetyCap_rng = RNG(seed, 3)
    ---@type RNG?
    local matchStick_rng = RNG(seed, 4)
    ---@type RNG?
    local childsHeart_rng = RNG(seed, 5)
    ---@type RNG?
    local rustedKey_rng = RNG(seed, 6)

    if not IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_DAEMONS_TAIL) then
        daemonsTail_rng = nil
    end

    if not IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_ACE_SPADES) then
        aceSpades_rng = nil
    end

    if not IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_SAFETY_CAP) then
        safetyCap_rng = nil
    end

    if not IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_MATCH_STICK) then
        matchStick_rng = nil
    end

    if not IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_CHILDS_HEART) then
        childsHeart_rng = nil
    end

    if not IPlayerManager.AnyoneHasTrinket(ctx_playerManager, ctx, TrinketType.TRINKET_RUSTED_KEY) then
        rustedKey_rng = nil
    end

    ---@type Component.LootList
    local lootList = {}

    if not shouldAdvance then
        rng = noDecreaseRNG
    end

    local eternalChest_canFail = pickup.m_variant == PickupVariant.PICKUP_ETERNALCHEST
        and level.m_stage ~= LevelStage.STAGE6
        and pickup.m_subtype < 2

    local eternalChest_fail = eternalChest_canFail and rng:RandomInt(4) == 0

    if eternalChest_fail then
        return lootList
    end

    local level_isStage6 = level.m_stage == LevelStage.STAGE6
        and not IGame.IsGreedMode(ctx_game)

    ---@type PickupLootList.Closure
    local myCtx = {
        manager = ctx.manager,
        game = ctx_game,
        pickup = pickup,
        lootList = lootList,
        rng = rng,
        shouldAdvance = shouldAdvance,
        level_isStage6 = level_isStage6,
        aceSpades_rng = aceSpades_rng,
        safetyCap_rng = safetyCap_rng,
        matchStick_rng = matchStick_rng,
        childsHeart_rng = childsHeart_rng,
        rustedKey_rng = rustedKey_rng,
        daemonsTail_rng = daemonsTail_rng,
    }

    local get_loot_list = Switch_get_loot_list[pickup.m_variant] or Chest_get_loot_list
    get_loot_list(myCtx)

    return lootList
end

---@class Gameplay.Pickup.LootList
local Module = {}

--#region Module

Module.GetLootList = GetLootList

--#endregion

return Module