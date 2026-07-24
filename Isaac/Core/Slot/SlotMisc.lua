--#region Dependencies

local Enums = require("Isaac.Enums")
local IGame = require("Isaac.Interface.Game")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IsaacUtils = require("Isaac.Utils.Common")

local Actor_BloodDonationMachine = require("Isaac.Actor.Slot.BloodDonationMachine")
local Actor_DevilBeggar = require("Isaac.Actor.Slot.DevilBeggar")
local Actor_ShellGame = require("Isaac.Actor.Slot.ShellGame")
local Actor_ShopRestockMachine = require("Isaac.Actor.Slot.ShopRestockMachine")
local Actor_MomsDressingTable = require("Isaac.Actor.Slot.MomsDressingTable")
local Actor_CraneGame = require("Isaac.Actor.Slot.CraneGame")
local Actor_RottenBeggar = require("Isaac.Actor.Slot.RottenBeggar")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

---@alias Slot.Switch.OnSetPrizeCollectible fun(slot: Component.Entity.Slot, ctx: Context.Common, collectible: CollectibleType | integer)
---@alias Slot.Switch.CustomExplosionDrops fun(slot: Component.Entity.Slot, ctx: Context.Common, closure: Slot.Closure.CustomExplosionDrops)

---@class Slot.Closure.CustomExplosionDrops
---@field extraRng RNG
---@field daemonsTailRng RNG?

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_COIN_JAM = {
    "CoinJam",
    "CoinJam2",
    "CoinJam3",
    "CoinJam4"
}

---@type table<SlotVariant, Slot.Switch.OnSetPrizeCollectible>
local Switch_OnSetPrizeCollectible = {
    [SlotVariant.HELL_GAME] = Actor_ShellGame.HellGame_OnSetPrizeCollectible,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.OnSetPrizeCollectible,
}

---@type table<SlotVariant, Slot.Switch.CustomExplosionDrops>
local Switch_CustomExplosionDrops = {
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.CustomExplosionDrops,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.CustomExplosionDrops,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.CustomExplosionDrops,
    [SlotVariant.MOMS_DRESSING_TABLE] = Actor_MomsDressingTable.CustomExplosionDrops,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.HellGame_CustomExplosionDrops,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.CustomExplosionDrops,
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@return Vector
local function GetCollectibleSpawnPosition(slot, ctx)
    return IEntityPickup.GetCollectibleSpawnPos(ctx, slot.m_position)
end

---@return string
local function RandomCoinJamAnim()
    local index = IsaacUtils.RandomInt(4) + 1
    return ANIMATION_COIN_JAM[index]
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collectible CollectibleType | integer
local function SetPrizeCollectible(slot, ctx, collectible)
    slot.m_prizeCollectible = collectible

    local OnSetPrizeCollectible = Switch_OnSetPrizeCollectible[slot.m_variant]
    if OnSetPrizeCollectible then OnSetPrizeCollectible(slot, ctx, collectible) end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param closure Slot.Closure.ExplosionDrops
local function spawn_explosion_loot(slot, ctx, closure)
    local myRng = slot.m_dropRNG
    local randFloat = myRng:RandomFloat()

    local coinsLoot = randFloat < 0.35 -- 35/100
    if coinsLoot then
        local coinCount = myRng:RandomInt(3) + 1
        for i = 1, coinCount, 1 do
            local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, closure.velocityRng)
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
                slot.m_position, velocity, nil,
                0, myRng:Next()
            )
        end

        return
    end

    local heartLoot = randFloat < 0.55 -- 20/100
        and not (closure.daemonsTailRng and PlayerEffects.TryDaemonsTailBlock(closure.daemonsTailRng))
    if heartLoot then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, closure.velocityRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )

        local decreaseLootCount = myRng:RandomInt(2) == 0
        if decreaseLootCount then
            closure.lootCount = closure.lootCount - 1
        end

        return
    end

    local keyLoot = randFloat < 0.7 -- 15/100
    if keyLoot then
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, closure.velocityRng)
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )

        return
    end

    -- bomb loot --30/100
    local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, closure.velocityRng)
    IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB,
        slot.m_position, velocity, nil,
        0, myRng:Next()
    )
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function CreateDropsFromExplosion(slot, ctx)
    local extraRng = RNG(slot.m_initSeed, 3)
    local playerManager = ctx.game.m_playerManager
    local _, daemonsTailRng = IPlayerManager.RandomTrinketOwner(playerManager, ctx, TrinketType.TRINKET_DAEMONS_TAIL, slot.m_initSeed)

    local CustomExplosionDrops = Switch_CustomExplosionDrops[slot.m_variant]
    if CustomExplosionDrops then
        ---@type Slot.Closure.CustomExplosionDrops
        local closure = {daemonsTailRng = daemonsTailRng, extraRng = extraRng}
        CustomExplosionDrops(slot, ctx, closure)
        return
    end

    -- base explosion drops
    local myRng = slot.m_dropRNG
    local rareLoot = myRng:RandomInt(5) == 0

    if rareLoot then
        local trinketReward = myRng:RandomInt(2) == 0
        if trinketReward then
            local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
            velocity = velocity * 0.4
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
                slot.m_position, velocity, nil,
                0, myRng:Next()
            )

            return
        end

        -- pill reward
        local velocity = IEntityPickup.get_random_pickup_velocity(ctx, slot.m_position, ePickVelType.SLOT, extraRng)
        velocity = velocity * 0.4
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL,
            slot.m_position, velocity, nil,
            0, myRng:Next()
        )

        return
    end

    local chestLoot = myRng:RandomFloat() < 0.01
    if chestLoot then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST,
            slot.m_position, VECTOR_ZERO, nil,
            0, myRng:Next()
        )

        return
    end

    local lockedChestLoot = myRng:RandomFloat() < 0.01
    if lockedChestLoot then
        IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST,
            slot.m_position, VECTOR_ZERO, nil,
            0, myRng:Next()
        )

        return
    end

    local lootCount = math.max(myRng:RandomInt(4), 2)
    ---@type Slot.Closure.ExplosionDrops
    local lootCtx = {lootCount = lootCount, daemonsTailRng = daemonsTailRng, velocityRng = extraRng}
    PlayerEffects.LootModifiers_SlotExplosionDrops(slot, ctx, lootCtx)

    local i = 1
    while i <= lootCtx.lootCount do
        spawn_explosion_loot(slot, ctx, lootCtx)
        i = i + 1
    end
end

---@class Gameplay.Slot.Misc
local Module = {}

--#region Module

Module.GetCollectibleSpawnPosition = GetCollectibleSpawnPosition
Module.RandomCoinJamAnim = RandomCoinJamAnim
Module.SetPrizeCollectible = SetPrizeCollectible
Module.CreateDropsFromExplosion = CreateDropsFromExplosion

--#endregion

return Module