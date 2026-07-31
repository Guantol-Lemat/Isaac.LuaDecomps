--#region Dependencies

local Enums = require("Isaac.Enums")
local IGame = require("Isaac.Interface.Game")
local IEntityList = require("Isaac.Interface.EntityList")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local IsaacUtils = require("Isaac.Utils.Common")

local IEntityRef = IEntity.EntityRef

--#endregion

local eShopItemPrice = Enums.eShopItemPrice

local VECTOR_ZERO = Vector(0, 0)

---@param player Component.Entity.Player
---@param ctx Context.Common
local function YourSoul_Pay(player, ctx)
    local players = ctx.game.m_playerManager.m_players
    for i = 1, #players, 1 do
        player = players[i]
        if player.m_variant == PlayerVariant.PLAYER and IEntityPlayer.HasTrinket(ctx, player, TrinketType.TRINKET_YOUR_SOUL, false) then
            IEntityPlayer.TryRemoveTrinket(player, ctx, TrinketType.TRINKET_YOUR_SOUL)
            break
        end
    end
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param data table
local function can_pickup_heart(player, ctx, data)
    local healthType = IEntityPlayer.GetHealthType(player)
    if healthType == HealthType.NO_HEALTH or IEntityPlayer.HasInstantDeathCurse(player) then
        return true
    end

    local heartCost = data[1]
    local soulCost = data[2]

    if heartCost > 0 then
        if soulCost > 0 then
            return IEntityPlayer.GetEffectiveMaxHearts(player) > 1
        end

        if soulCost == 0 then
            return IEntityPlayer.GetEffectiveMaxHearts(player) > 0
        end
    elseif heartCost == 0 then
        if soulCost > 0 then
            return player.m_soulHearts > 0
        end
    end

    return true
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.PaySpecialPrice
---@param data table | unknown
local function pay_heart(player, ctx, blackboard, data)
    local healthType = IEntityPlayer.GetHealthType(player)
    if healthType == HealthType.NO_HEALTH or IEntityPlayer.HasInstantDeathCurse(player) then
        blackboard.noHealth_isFree = true
        return
    end

    local heartCost = data[1]
    local soulCost = data[2]

    if heartCost > 0 then
        IEntityPlayer.AddMaxHearts(player, ctx, heartCost * -2, false)
    end

    if soulCost > 0 then
        IEntityPlayer.AddSoulHearts(player, ctx, soulCost * -2)
    end
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.PaySpecialPrice
---@param data table | unknown
local function pay_soul_3(player, ctx, blackboard, data)
    local healthType = IEntityPlayer.GetHealthType(player)
    if healthType == HealthType.NO_HEALTH or IEntityPlayer.HasInstantDeathCurse(player) then
        blackboard.noHealth_isFree = true
        return
    end

    local soulCost = data[2]

    local soulHeartCount = (player.m_soulHearts + 1) // 2
    local playerSoulCost = math.min(soulHeartCount, soulCost)
    local heartCost = soulCost - playerSoulCost

    IEntityPlayer.AddMaxHearts(player, ctx, heartCost * -2, false)
    IEntityPlayer.AddSoulHearts(player, ctx, soulCost * -2)
end

---This is actually both the check and the payment logic
---@param player Component.Entity.Player
---@param ctx Context.Common
---@param damage number
local function can_pickup_spike_damage(player, ctx, damage)
    if IEntityPlayer.GetHealthType(player) == HealthType.NO_HEALTH or IEntityPlayer.HasInstantDeathCurse(player) then
        return true
    end

    local flags = DamageFlag.DAMAGE_NO_PENALTIES
        | DamageFlag.DAMAGE_INVINCIBLE
        | DamageFlag.DAMAGE_SPIKES

    return player:TakeDamage(ctx, damage, flags, IEntityRef.New(nil), 30)
end

local SPECIAL_COST = {
    [eShopItemPrice.HEART_1] = {data = {1, 0}, CanPickup = can_pickup_heart, Pay = pay_heart},
    [eShopItemPrice.HEART_2] = {data = {2, 0}, CanPickup = can_pickup_heart, Pay = pay_heart},
    [eShopItemPrice.SOUL_3] = {data = {0, 3}, CanPickup = can_pickup_heart, Pay = pay_soul_3},
    [eShopItemPrice.SOUL_2_HEART_1] = {data = {1, 2}, CanPickup = can_pickup_heart, Pay = pay_heart},
    [eShopItemPrice.SPIKES] = {data = 2.0, CanPickup = can_pickup_spike_damage, Pay = function() end},
    [eShopItemPrice.YOUR_SOUL] = {CanPickup = function() return true end, Pay = YourSoul_Pay},
    [eShopItemPrice.SOUL_1] = {data = {0, 1}, CanPickup = can_pickup_heart, Pay = pay_heart},
    [eShopItemPrice.SOUL_2] = {data = {0, 2}, CanPickup = can_pickup_heart, Pay = pay_heart},
    [eShopItemPrice.SOUL_1_HEART_1] = {data = {1, 1}, CanPickup = can_pickup_heart, Pay = pay_heart},
}

---@param entityList Component.EntityList
---@return integer
local function CouponWisp_GetExtraShopCoins_NoDecrease(entityList)
    return IEntityList.CountWisps(entityList, CollectibleType.COLLECTIBLE_COUPON)
end

---@param entityList Component.EntityList
---@param ctx Context.Common
---@param price integer
---@return integer
local function CouponWisp_GetExtraShopCoins(entityList, ctx, price)
    local couponWisps = IEntityList.QueryType(entityList, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, CollectibleType.COLLECTIBLE_COUPON, false, false)
    local extraCoins = 0

    for i = 1, couponWisps, 1 do
        if price - extraCoins <= 0 then
            break
        end

        couponWisps[i]:Kill(ctx)
        extraCoins = extraCoins + 1
    end

    return extraCoins
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param spentCoins integer
local function KeepersSack_AddSpentCoins(player, ctx, spentCoins)
    if IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_KEEPERS_SACK, false) then
        return
    end

    player.m_keepersSack_coinsSpent = player.m_keepersSack_coinsSpent + spentCoins
    ITemporaryEffects.RemoveCollectibleEffect(player.m_temporaryEffects, ctx, CollectibleType.COLLECTIBLE_KEEPERS_SACK, -1)
    ITemporaryEffects.AddCollectibleEffect(player.m_temporaryEffects, ctx, CollectibleType.COLLECTIBLE_KEEPERS_SACK, true, 1)
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param price eShopItemPrice | integer
---@return boolean
local function SpecialPrice_CanPickup(player, ctx, price)
    local costHandler = SPECIAL_COST[price]
    if costHandler then return costHandler.CanPickup(player, ctx, costHandler.data) end

    return true
end

---@param ctx Context.Common
local function no_health_balance_free_pickups(ctx, boughtPickup)
    local game = ctx.game
    local level = game.m_level

    local pickups = IEntityList.QueryType(level.m_room.m_entityList, EntityType.ENTITY_PICKUP, -1, -1, false, false)
    local isStage6StartingRoom = level.m_startingRoomIdx == level.m_roomIdx
        and level.m_stage == LevelStage.STAGE6 and not IGame.IsGreedMode(game)

    for i = 1, #pickups, 1 do
        local pickup = IEntity.ToPickup(pickups[i])
        local shouldRemove = pickup ~= nil and pickup ~= boughtPickup
            and ((pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE
            and pickup.m_subtype ~= CollectibleType.COLLECTIBLE_NULL
            and pickup.m_price < 0) -- special price
            or (isStage6StartingRoom
            and pickup.m_variant == PickupVariant.PICKUP_REDCHEST))

        if shouldRemove then
            ---@cast pickup Component.Entity.Pickup
            local poofPosition = pickup.m_position + Vector(0.0, 10.0)
            IGame.Spawn(
                ctx, game,
                EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
                poofPosition, VECTOR_ZERO, nil,
                0, IsaacUtils.Random()
            )

            pickup.m_wait = 4
        end
    end
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param price eShopItemPrice | integer
---@param pickup Component.Entity.Pickup
local function SpecialPrice_Pay(player, ctx, price, pickup)
    local costHandler = SPECIAL_COST[price]
    ---@type Pickup.Blackboard.PaySpecialPrice
    local blackboard = {noHealth_isFree = false}
    if costHandler then
        costHandler.Pay(player, ctx, blackboard, costHandler.data)
    end

    IEntityPlayer.SetLastDamage(player, DamageFlag.DAMAGE_DEVIL, IEntityRef.New(nil))

    if blackboard.noHealth_isFree then
        no_health_balance_free_pickups(ctx, pickup)
    end

    if IEntityPlayer.CanPickupItem(player) and not IEntityPlayer.IsHoldingItem(player) then
        IEntityPlayer.check_death(player, ctx)
    end
end

---@param player Component.Entity.Player
---@return boolean
local function StoreCredit_lose_gold(player)
    local rng = IEntityPlayer.GetTrinketRNG(player, TrinketType.TRINKET_STORE_CREDIT)
    return rng:RandomInt(4) == 0 -- 1/4 to lose
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.HandleCollision
local function StoreCredit_Pay(player, ctx, blackboard)
    local droppedTrinket = blackboard.droppedTrinket
    local hasDroppedStoreCredit = droppedTrinket ~= nil
        and droppedTrinket.m_type == EntityType.ENTITY_PICKUP
        and droppedTrinket.m_variant == PickupVariant.PICKUP_TRINKET
        and (droppedTrinket.m_subtype & TrinketType.TRINKET_ID_MASK) == TrinketType.TRINKET_STORE_CREDIT

    if hasDroppedStoreCredit then
        ---@cast droppedTrinket Component.Entity.Pickup
        if droppedTrinket.m_subtype & TrinketType.TRINKET_GOLDEN_FLAG == 0 then -- not golden
            droppedTrinket:Remove(ctx)
        elseif StoreCredit_lose_gold(player) then
            IEntityPickup.Morph(
                droppedTrinket, ctx,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_STORE_CREDIT,
                false, true, true
            )
        end

        return
    end

    local owner = player
    if not IEntityPlayer.HasTrinket(ctx, owner, TrinketType.TRINKET_STORE_CREDIT, false) then
        owner = IPlayerManager.FirstTrinketOwner(ctx.game.m_playerManager, ctx, TrinketType.TRINKET_STORE_CREDIT, false)
    end

    if not owner then
        return
    end

    if not IEntityPlayer.HasGoldenTrinket(player, ctx, TrinketType.TRINKET_STORE_CREDIT) then
        IEntityPlayer.TryRemoveTrinket(player, ctx, TrinketType.TRINKET_STORE_CREDIT)
    elseif StoreCredit_lose_gold(player) then
        IEntityPlayer.TryReplaceTrinket(player, ctx)
    end
end

---@class PlayerEffects.Shop
local Module = {}

--#region Module

Module.CouponWisp_GetExtraShopCoins = CouponWisp_GetExtraShopCoins
Module.CouponWisp_GetExtraShopCoins_NoDecrease = CouponWisp_GetExtraShopCoins_NoDecrease
Module.KeepersSack_AddSpentCoins = KeepersSack_AddSpentCoins
Module.YourSoul_Pay = YourSoul_Pay
Module.SpecialPrice_CanPickup = SpecialPrice_CanPickup
Module.SpecialPrice_Pay = SpecialPrice_Pay
Module.StoreCredit_Pay = StoreCredit_Pay

--#endregion

return Module