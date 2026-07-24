--#region Dependencies

local Enums = require("Isaac.Enums")
local IManager = require("Isaac.Interface.Manager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntityNPC = require("Isaac.Interface.Entity_NPC")
local IsaacUtils = require("Isaac.Utils.Common")
local VectorUtils = require("General.Math.VectorUtils")
local LootList = require("Isaac.Utils.LootList")

--#endregion

---@alias PickupChest.Switch.ResolveLootEntry fun(ctx: PickupChest.Closure.ResolveLootEntry, entry: Component.LootList.Entry, i: integer)

---@class PickupChest.Closure.ResolveLootEntry : Context.Common
---@field pickup Component.Entity.Pickup
---@field player Component.Entity.Player
---@field chestVariant PickupVariant | integer
---@field randomThrowRNG RNG
---@field spawnedPickupsCount integer
---@field isPayToPlay boolean
---@field pushBackPlayer boolean

local ePickVelType = Enums.ePickVelType

local VECTOR_ZERO = Vector(0, 0)
local ANIMATION_OPEN = "Open"
local SOUND_CHEST_OPEN = SoundEffect.SOUND_CHEST_OPEN
local SOUND_CHEST_UNLOCK = SoundEffect.SOUND_UNLOCK00
local COLOR_OPEN_CHEST_POOF = Color(
    1.0, 1.0, 1.0, 0.3,
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0
)

local COLOR_STAGE6_DEVIL_DEAL = Color(
    1.0, 1.0, 1.0, 1.0,
    0.0, 0.0, 0.0,
    2.0, 0.4, 0.4, 1.0
)

local ALTERNATE_PEDESTALS = {
    [PickupVariant.PICKUP_CHEST] = {PedestalType.CHEST},
    [PickupVariant.PICKUP_BOMBCHEST] = {PedestalType.STONE_CHEST},
    [PickupVariant.PICKUP_SPIKEDCHEST] = {PedestalType.SPIKED_CHEST},
    [PickupVariant.PICKUP_ETERNALCHEST] = {PedestalType.ETERNAL_CHEST, PedestalType.ETERNAL_CHEST_COIN_SLOT},
    [PickupVariant.PICKUP_MIMICCHEST] = {PedestalType.SPIKED_CHEST},
    [PickupVariant.PICKUP_OLDCHEST] = {PedestalType.OLD_CHEST, PedestalType.OLD_CHEST_COIN_SLOT},
    [PickupVariant.PICKUP_WOODENCHEST] = {PedestalType.WOODEN_CHEST},
    [PickupVariant.PICKUP_MEGACHEST] = {PedestalType.MEGA_CHEST, PedestalType.MEGA_CHEST_COIN_SLOT},
    [PickupVariant.PICKUP_LOCKEDCHEST] = {PedestalType.GOLDEN_CHEST, PedestalType.GOLDEN_CHEST_COIN_SLOT},
    [PickupVariant.PICKUP_REDCHEST] = {PedestalType.RED_CHEST},
    [PickupVariant.PICKUP_MOMSCHEST] = {PedestalType.MOMS_CHEST},
}

local RESOLVE_DEFAULT = 1
local RESOLVE_COLLECTIBLE = 2
local RESOLVE_DEAL_WARP = 3
local RESOLVE_ENEMY_SPIDER = 4
local RESOLVE_BLUE_FLY = 5
local RESOLVE_BLUE_SPIDER = 6

---@type table<integer, PickupChest.Switch.ResolveLootEntry>
local Switch_ResolveLootEntry = {
    [RESOLVE_DEFAULT] = function (ctx, entry, i)
        local chest_variant = ctx.chestVariant
        local player = ctx.player
        local pickup = ctx.pickup
        local randomThrowRNG = ctx.randomThrowRNG
        local spawnedPickupsCount = ctx.spawnedPickupsCount

        local speedMultiplier = 1.0
        if chest_variant == PickupVariant.PICKUP_MEGACHEST then
            speedMultiplier = math.min(spawnedPickupsCount * 0.05 + 0.4, 1.0)
        end

        local randomVelocity = IEntityPickup.get_random_pickup_velocity(ctx, pickup.m_position, ePickVelType.DEFAULT, randomThrowRNG)
        local velocity = randomVelocity * speedMultiplier
        local spawnOffset = IsaacUtils.RandomVector_Seed(randomThrowRNG:Next())
        local spawnPosition = spawnOffset + pickup.m_position

        local spawn_entity = LootList.Spawn(entry, ctx, spawnPosition, velocity, nil)
        -- they check for the current pickup variant explicitly
        if spawn_entity.m_type == EntityType.ENTITY_PICKUP and pickup.m_variant == PickupVariant.PICKUP_MEGACHEST then
            ---@cast spawn_entity Component.Entity.Pickup
            spawn_entity.m_dropDelay = spawnedPickupsCount // 2
        end

        spawn_entity:Update(ctx)
        ctx.spawnedPickupsCount = spawnedPickupsCount + 1

        if IEntity.IsEnemy(spawn_entity) then
            local enemy_playerDirection = (pickup.m_position - player.m_position):Normalized()
            ctx.pushBackPlayer = true
            spawn_entity.m_position = pickup.m_position + enemy_playerDirection -- nudge towards player
        end

        if spawn_entity.m_type == EntityType.ENTITY_PICKUP and IEntityPickup.IsChest(spawn_entity.m_variant) then
            spawn_entity.m_sprite.Scale = pickup.m_sprite.Scale * 0.8
        end
    end,
    [RESOLVE_COLLECTIBLE] = function (ctx, entry, i)
        local game = ctx.game
        local level = game.m_level
        local pickup = ctx.pickup
        local chest_variant = ctx.chestVariant
        local isPayToPlay = ctx.isPayToPlay

        local unlockedRedKey = chest_variant == PickupVariant.PICKUP_MOMSCHEST and entry.subtype == CollectibleType.COLLECTIBLE_RED_KEY
        if unlockedRedKey then
            IPersistentGameData.TryUnlock(ctx.manager.m_persistentGameData, ctx, Achievement.RED_KEY)
        end

        local alreadyCollectible = pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE
        ---@type Component.Entity.Pickup
        local collectible

        if alreadyCollectible then
            local collectible_entity = IGame.Spawn(
                ctx, game,
                entry.type, entry.variant,
                pickup.m_position, VECTOR_ZERO, nil,
                entry.subtype, entry.seed
            )

            ---@cast collectible_entity Component.Entity.Pickup
            collectible = collectible_entity
        else
            IEntityPickup.Morph(
                ctx, pickup,
                EntityType.ENTITY_PICKUP, entry.variant, entry.subtype,
                false, false, false
            )
            collectible = pickup
        end

        local isStage6DevilDeal = chest_variant == PickupVariant.PICKUP_REDCHEST
            and not IGame.IsGreedMode(game)
            and level.m_stage == LevelStage.STAGE6 and level.m_startingRoomIdx == level.m_roomIdx

        if isStage6DevilDeal then
            IEntityPickup.MakeShopItem(ctx, collectible, -2)

            local poof_entity = IGame.Spawn(
                ctx, game,
                EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
                collectible.m_position, VECTOR_ZERO, nil,
                0, IsaacUtils.Random()
            )

            poof_entity:SetColor(ctx, COLOR_STAGE6_DEVIL_DEAL, -1, -1, false, true)
        end

        -- I doubt there is ever a case where this doesn't happen
        if collectible.m_variant == PickupVariant.PICKUP_COLLECTIBLE then
            collectible.m_targetPosition = VectorUtils.Copy(collectible.m_position)
            local alternatePedestal = ALTERNATE_PEDESTALS[chest_variant]
            if alternatePedestal then
                local pedestalType = (isPayToPlay and alternatePedestal[2])
                    and alternatePedestal[2]
                    or alternatePedestal[1]

                IEntityPickup.SetAlternatePedestal(ctx, pickup, pedestalType)
            end
        end

        ctx.pushBackPlayer = true
    end,
    [RESOLVE_DEAL_WARP] = function (ctx, entry, i)
        local game = ctx.game
        local level = game.m_level
        local player = ctx.player

        ILevel.InitializeDevilAngelRoom(ctx, level, false, false)
        level.m_leaveDoor = DoorSlot.NO_DOOR_SLOT
        IGame.StartRoomTransition(
            ctx, game,
            GridRooms.ROOM_DEVIL_IDX, Direction.NO_DIRECTION,
            RoomTransitionAnim.TELEPORT, player, Dimension.CURRENT
        )
    end,
    [RESOLVE_ENEMY_SPIDER] = function (ctx, entry, i)
        local pickup = ctx.pickup
        local player = ctx.player

        local isFirstSpider = i == 1
        if isFirstSpider then
            local spiderTarget = IEntityPlayer.GetNPCTarget(player)
            local baseTargetPosition = (spiderTarget.m_position + pickup.m_position) * 0.5
            local targetPosition = IRoom.FindFreePickupSpawnPosition(ctx.game.m_level.m_room, baseTargetPosition, 70.0, false, false)
            IEntityNPC.ThrowSpider(ctx, pickup.m_position, pickup, targetPosition, false, -30.0)
        else
            IEntityNPC.ThrowSpider(ctx, pickup.m_position, pickup, VECTOR_ZERO, false, -30.0)
        end
    end,
    [RESOLVE_BLUE_FLY] = function (ctx, entry, i)
        IEntityPlayer.AddBlueFlies(ctx, ctx.player, 1, ctx.pickup.m_position, nil)
    end,
    [RESOLVE_BLUE_SPIDER] = function (ctx, entry, i)
        IEntityPlayer.ThrowBlueSpider(ctx, ctx.player, ctx.pickup.m_position, VECTOR_ZERO)
    end
}

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param lootList Component.LootList
---@param player Component.Entity.Player
local function resolve_loot_list(pickup, ctx, lootList, player)
    local chest_variant = pickup.m_variant

    local eternalChest_fail = chest_variant == PickupVariant.PICKUP_ETERNALCHEST and #lootList == 0
    if eternalChest_fail then
        pickup.m_eternalChest_reCloseCountdown = 0
        return
    end

    ---@type PickupChest.Closure.ResolveLootEntry
    local closure = {
        manager = ctx.manager,
        game = ctx.game,
        chestVariant = chest_variant,
        isPayToPlay = pickup.m_payToPlay,
        pickup = pickup,
        player = player,
        randomThrowRNG = RNG(pickup.m_dropRNG:GetSeed(), 12),
        spawnedPickupsCount = 0,
        pushBackPlayer = false,
    }

    for i = 1, #lootList, 1 do
        local entry = lootList[i]
        local entryHandler = RESOLVE_DEFAULT

        if entry.type == EntityType.ENTITY_PICKUP and entry.variant == PickupVariant.PICKUP_COLLECTIBLE then
            entryHandler = RESOLVE_COLLECTIBLE
        elseif entry.type == EntityType.ENTITY_NULL and entry.variant == 1 then
            entryHandler = RESOLVE_DEAL_WARP
        elseif entry.type == EntityType.ENTITY_SPIDER then
            entryHandler = RESOLVE_ENEMY_SPIDER
        elseif entry.type == EntityType.ENTITY_FAMILIAR then
            if entry.variant == FamiliarVariant.BLUE_FLY then
                entryHandler = RESOLVE_BLUE_FLY
            elseif entry.variant == FamiliarVariant.BLUE_SPIDER then
                entryHandler = RESOLVE_BLUE_SPIDER
            end
        end

        local resolveLootEntry = Switch_ResolveLootEntry[entryHandler]
        resolveLootEntry(closure, entry, i)
    end

    if closure.pushBackPlayer then
        local playerDisplacement = pickup.m_position - player.m_position
        -- player is close enough
        local playerDistance = playerDisplacement:Length()
        if playerDistance < 40.0 then
            local playerDirection = playerDisplacement:Normalized()
            local pushStrength = (40.0 - playerDistance) * 0.4
            player.m_velocity = (player.m_velocity - playerDirection * pushStrength) * 0.5
        end

        -- this is for collectibles, even though this branch can be entered
        -- if a collectible is not spawned
        pickup.m_wait = 20
    end

    if pickup.m_variant == PickupVariant.PICKUP_ETERNALCHEST then
        pickup.m_eternalChest_reCloseCountdown = 60
    end
end

---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param player Component.Entity.Player?
---@return boolean
local function TryOpenChest(ctx, pickup, player)
    -- get player
    if not player then
        player = IGame.GetNearestPlayerEx(ctx, pickup.m_position, true, false, false)
        if not player then
            player = IGame.GetPlayer(ctx.game, 0)
        end
    end

    if pickup.m_subtype == 0 then
        return false
    end

    pickup.m_sprite:Play(ANIMATION_OPEN, true)
    IManager.PlaySound(ctx, SOUND_CHEST_OPEN, 1.0, 2, false, 1.0)

    local myVariant = pickup.m_variant
    local isUnlocked = myVariant == PickupVariant.PICKUP_LOCKEDCHEST
        or myVariant == PickupVariant.PICKUP_ETERNALCHEST
        or myVariant == PickupVariant.PICKUP_OLDCHEST

    if isUnlocked then
        IManager.PlaySound(ctx, SOUND_CHEST_UNLOCK, 1.0, 2, false, 1.0)
        IPersistentGameData.IncreaseEventCounter(ctx.manager.m_persistentGameData, ctx, EventCounter.CHESTS_OPENED_WITH_KEY, 1)
    end

    local poof_entity = IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
        pickup.m_position, VECTOR_ZERO, nil,
        2, IsaacUtils.Random()
    )

    local mySprite = pickup.m_sprite
    local myScale = mySprite.Scale
    poof_entity.m_positionOffset = Vector(myScale.X * -10.0, 0.0)
    poof_entity.m_sprite.Scale = myScale * 0.8
    poof_entity.m_sprite.Color = COLOR_OPEN_CHEST_POOF
    poof_entity.m_depthOffset = 4.0

    local lootList = IEntityPickup.GetLootList(ctx, pickup, true)
    pickup.m_subtype = 0 -- set as open

    resolve_loot_list(pickup, ctx, lootList, player)

    ctx.game.m_level.m_room.m_pickupVision_invalidate = true
    return true
end

---@class Gameplay.Pickup.Chest
local Module = {}

--#region Module

Module.TryOpenChest = TryOpenChest

--#endregion

return Module