--#region Dependencies

local Enums = require("Isaac.Enums")
local Anm2Registry = require("Isaac.Enums.ANM2")
local TableUtils = require("General.Table")
local IManager = require("Isaac.Interface.Manager")
local IPersistentData = require("Isaac.Interface.PersistentGameData")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IItemPool = require("Isaac.Interface.ItemPool")
local ISeeds = require("Isaac.Interface.Seeds")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IsaacUtils = require("Isaac.Utils.Common")

local PickupMechanics = interface("Isaac.Mechanics.PickupMechanics")

--#endregion

local eCardSubType = Enums.eCardSubType

local VECTOR_ZERO = Vector(0, 0)

local PAY_TO_PLAY_CHEST = TableUtils.CreateDictionary({
    PickupVariant.PICKUP_ETERNALCHEST,
    PickupVariant.PICKUP_OLDCHEST,
    PickupVariant.PICKUP_MEGACHEST,
    PickupVariant.PICKUP_LOCKEDCHEST,
})

---@param pickup Component.Entity.Pickup
---@return boolean
local function is_pay_to_play_chest(pickup)
    return PAY_TO_PLAY_CHEST[pickup.m_variant] ~= nil
end

---@param ctx Context.Common
---@param subtype CollectibleType | integer
---@return CollectibleType | integer
local function WaitWhat_Morph(ctx, subtype)
    local persistentData = ctx.manager.m_persistentGameData
    if persistentData.m_itemsCollection[CollectibleType.COLLECTIBLE_BUTTER_BEAN + 1] == false then
        return subtype
    end

    local rng = RNG(ISeeds.GetStartSeed(ctx.game.m_seeds), 77)
    if rng:RandomInt(20) == 0 then -- 1/20
        return CollectibleType.COLLECTIBLE_WAIT_WHAT
    end

    return subtype
end

---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.Init
local function BlueBabyB_BombMorph(ctx, blackboard)
    local canMorph = IPlayerManager.AllPlayerType(ctx.game.m_playerManager, PlayerType.PLAYER_BLUEBABY_B)
        and not PickupMechanics.IsTrollBomb_Type(blackboard.subtype)

    if canMorph then
        blackboard.variant = PickupVariant.PICKUP_POOP
        blackboard.subtype = PoopPickupSubType.POOP_BIG
    end
end

---@param ctx Context.Common
---@param subtype CollectibleType | integer
---@return CollectibleType | integer
local function CollectibleSelectModifiers(ctx, subtype)
    if subtype == CollectibleType.COLLECTIBLE_BUTTER_BEAN then
        subtype = WaitWhat_Morph(ctx, subtype)
    end

    return subtype
end

---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.Init
local function PostPickupSelection(ctx, blackboard)
    if blackboard.variant == PickupVariant.PICKUP_BOMB then
        BlueBabyB_BombMorph(ctx, blackboard)
    end
end

---@param ctx Context.Common
---@param card Card | integer
---@param rng RNG
local function Cantripped_InitCard(ctx, card, rng)
    local CANTRIPPED_MASK = 1 << 15
    local CARD_MASK = CANTRIPPED_MASK - 1
    if card & CANTRIPPED_MASK == 0 or card & CARD_MASK == 0 then -- should init
        card = IItemPool.GetCantrippedItemCard(ctx.game.m_itemPool, ctx, rng:Next())
        card = card | CANTRIPPED_MASK
    end

    return card, eCardSubType.TREASURE_CARD
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function PayToPlay_InitChest(pickup, ctx)
    if IPlayerManager.AnyoneHasCollectible(ctx.game.m_playerManager, ctx, CollectibleType.COLLECTIBLE_PAY_TO_PLAY) then
        return
    end

    if is_pay_to_play_chest(pickup) then
        pickup.m_payToPlay = true
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function PreLoadGraphics(pickup, ctx)
    PayToPlay_InitChest(pickup, ctx)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function GFuel_ReplacePickupGraphics(pickup, ctx)
    if pickup.m_variant == PickupVariant.PICKUP_TROPHY and ISeeds.HasSeedEffect(ctx.game.m_seeds, SeedEffect.SEED_G_FUEL) then
        pickup.m_sprite:Load(Anm2Registry.G_FUEL_TROPHY, true)
    end
end

---@param pickup Component.Entity.Pickup
local function BeastRoom_PickupAppear(pickup)
    pickup.m_sprite:SetLastFrame()
    pickup.m_velocity.Y = pickup.m_velocity.Y - 15.0
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function GFuel_PickupAppear(pickup, ctx)
    local game = ctx.game
    local sprite = pickup.m_sprite

    IGame.ShakeScreen(game, ctx, 10)
    local effect = IGame.Spawn(
        ctx, game,
        EntityType.ENTITY_EFFECT, EffectVariant.POOF01,
        pickup.m_position, VECTOR_ZERO, nil,
        0, IsaacUtils.Random()
    )

    sprite:Load(Anm2Registry.G_FUEL_EXPLOSION_4, true)
    sprite:Play(sprite:GetDefaultAnimationName(), false)
    sprite.FlipX = IsaacUtils.RandomInt(2) == 0
    effect:Update(ctx)

    IManager.PlaySound(ctx, SoundEffect.SOUND_GFUEL_ITEM_APPEAR, 1.0, 2, false, IsaacUtils.RandomFloat() * 0.2 + 0.9)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function OnPickupAppear(pickup, ctx)
    if IRoom.IsBeastRoom(ctx.game.m_level.m_room) then
        BeastRoom_PickupAppear(pickup)
        return
    end

    if IGame.GetGFuelAmount(ctx) >= 2 then
        GFuel_PickupAppear(pickup, ctx)
    end
end

---@param ctx Context.Common
---@return integer
local function get_base_cycle_num(ctx)
    local playerManger = ctx.game.m_playerManager
    if IPlayerManager.AnyoneHasCollectible(playerManger, ctx, CollectibleType.COLLECTIBLE_GLITCHED_CROWN) then
        return 4
    end

    if IPlayerManager.AnyoneIsPlayerType(playerManger, PlayerType.PLAYER_ISAAC_B) or IPlayerManager.AnyoneHasBirthright(playerManger, ctx, PlayerType.PLAYER_ISAAC) then
        return 1
    end

    return 0
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param seed integer
local function BingeEater_TryAddOptionCycle(pickup, ctx, seed)
    if not IPlayerManager.AnyoneHasCollectible(ctx.game.m_playerManager, ctx, CollectibleType.COLLECTIBLE_BINGE_EATER) then
        return
    end

    local rng = RNG(seed, 9)
    local foodTaggedItems = IItemConfig.GetTaggedItems(ctx.manager.m_itemConfig, ItemConfig.TAG_FOOD)
    local foodItems = {}

    for i = 1, #foodTaggedItems, 1 do
        local item = foodTaggedItems[i]
        if IItemConfig.Item.IsCollectible(item) then
            table.insert(foodItems, item.m_id)
        end
    end

    local collectible
    if #foodItems == 0 then
        collectible = CollectibleType.COLLECTIBLE_BREAKFAST
    else
        collectible = foodItems[rng:RandomInt(#foodItems) + 1]
    end

    if pickup.m_cycle_cycleNum < 8 then
        pickup.m_cycle_cycleNum = pickup.m_cycle_cycleNum + 1
        pickup.m_cycle_collectibleList[pickup.m_cycle_cycleNum] = collectible
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param seed integer
local function CorruptedData_TryCorrupt(pickup, ctx, seed)
    local room = ctx.game.m_level.m_room
    local hasCorruptedData = (not room.m_isInitialized or IRoom.GetFrameCount(room, ctx) < 2)
        and IPersistentData.Unlocked(ctx.manager.m_persistentGameData, ctx, Achievement.CORRUPTED_DATA)

    if not hasCorruptedData then
        return
    end

    local chance
    if room.m_type == RoomType.ROOM_ERROR then
        chance = 16 -- 1/16
    elseif room.m_type == RoomType.ROOM_SECRET then
        chance = 60 -- 1/60
    end

    if not chance then
        return
    end

    local rng = RNG(seed, 11)
    if rng:RandomInt(chance) == 0 then
        pickup.m_flags = pickup.m_flags | EntityFlag.FLAG_GLITCH
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param seed integer
local function InitCollectibleModifiers(pickup, ctx, seed)
    local baseCycleNum = get_base_cycle_num(ctx)
    if baseCycleNum > 0 then
        IEntityPickup.TryInitOptionCycle(pickup, ctx, baseCycleNum)
    end

    BingeEater_TryAddOptionCycle(pickup, ctx, seed)
    CorruptedData_TryCorrupt(pickup, ctx, seed)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param ignoreModifiers boolean
---@return boolean
local function KeeperB_ForceCollectibleShopItem(pickup, ctx, ignoreModifiers)
    return pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE
        and IPlayerManager.AnyoneIsPlayerType(ctx.game.m_playerManager, PlayerType.PLAYER_KEEPER_B)
        and not ignoreModifiers
        and not IEntityPickup.IsShopItem(pickup)
        and not ctx.game.m_level.m_room.m_isInitialized
        and not IItemConfig.IsQuestItem(ctx, pickup.m_subtype)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@return boolean
local function Seeds_ForceShopItem(pickup, ctx)
    return ISeeds.HasSeedEffect(ctx.game.m_seeds, SeedEffect.SEED_ITEMS_COST_MONEY)
        and (pickup.m_variant ~= PickupVariant.PICKUP_COIN
        and IEntityPickup.CanReroll(pickup, ctx)
        and not IEntityPickup.IsChest(pickup))
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param ignoreModifiers boolean
---@return boolean
local function ShouldForceShopItem(pickup, ctx, ignoreModifiers)
    return KeeperB_ForceCollectibleShopItem(pickup, ctx, ignoreModifiers)
        and Seeds_ForceShopItem(pickup, ctx)
end

---@class Mechanics.Pickup.Effects
local Module = {}

--#region Module

Module.CollectibleSelectModifiers = CollectibleSelectModifiers
Module.PostPickupSelection = PostPickupSelection
Module.Cantripped_InitCard = Cantripped_InitCard
Module.PreLoadGraphics = PreLoadGraphics
Module.GFuel_ReplacePickupGraphics = GFuel_ReplacePickupGraphics
Module.OnPickupAppear = OnPickupAppear
Module.InitCollectibleModifiers = InitCollectibleModifiers
Module.ShouldForceShopItem = ShouldForceShopItem

--#endregion

return Module