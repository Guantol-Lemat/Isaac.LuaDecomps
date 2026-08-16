--#region Dependencies

local Log = require("General.Log")
local Enums = require("Isaac.Enums")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local Callbacks = require("LuaEngine.Callbacks")

local PickupMechanics = interface("Isaac.Mechanics.PickupMechanics")
local IEntityPtr = IEntity.EntityPtr

--#endregion

local eCardSubType = Enums.eCardSubType

local ANIMATION_IDLE = "Idle"
local ANIMATION_APPEAR = "Appear"

local VECTOR_ZERO = Vector(0, 0)

---@class Pickup.Blackboard.Init: Pickup.IO.SelectPickupType, Room.IO.MakeShopItem

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.Init
---@param seed integer
local function init_shop_item(pickup, ctx, blackboard, seed)
    local room = ctx.game.m_level.m_room

    pickup.m_shopItemId = IRoom.MakeShopItem(room, ctx, blackboard, seed)
    pickup.m_price = blackboard.price

    local currentVariant, currentSubtype = blackboard.variant, blackboard.subtype
    local success = IEntityPickup.SelectPickupType(ctx, seed, blackboard, true, true)
    if success and (currentVariant ~= blackboard.variant or currentSubtype ~= blackboard.subtype) then
        local price = IRoom.GetShopItemPrice(room, ctx, blackboard.variant, blackboard.subtype, pickup.m_shopItemId)
        pickup.m_price = IRoom.TryGetShopDiscount(room, ctx, pickup.m_shopItemId, price)
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.Init
---@param rng RNG
---@param ignoreModifiers boolean
local function init_collectible(pickup, ctx, blackboard, rng, ignoreModifiers)
    local itemConfig = ctx.manager.m_itemConfig

    local collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, blackboard.subtype)
    if not collectibleConfig then
        blackboard.subtype = IRoom.GetSeededCollectible(ctx.game.m_level.m_room, ctx, rng:Next(), false)
        collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, blackboard.subtype)
    end

    if not IEntityPickup.IgnoreModifiers() then
        local modifiedSubtype = PickupMechanics.Effects_CollectibleSelectModifiers(ctx, blackboard.subtype)
        if modifiedSubtype ~= blackboard.subtype then
            blackboard.subtype = modifiedSubtype
            collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, modifiedSubtype)
        end
    end

    ---@cast collectibleConfig Component.ItemConfig.Item
    pickup.m_charge = collectibleConfig.m_initCharge >= 0
        and collectibleConfig.m_initCharge
        or collectibleConfig.m_maxCharges

    pickup.m_wait = 20
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function init_broken_shovel(pickup, ctx)
    local itemConfig = ctx.manager.m_itemConfig
    local collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1)
    ---@cast collectibleConfig Component.ItemConfig.Item
    pickup.m_charge = collectibleConfig.m_maxCharges
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function pickup_appear(pickup, ctx)
    local sprite = pickup.m_sprite
    if not sprite:IsLoaded() then
        Log.LogMessage(0, "[warn] No sprite for Pickup variant %d\n")
        return
    end

    if PickupMechanics.IsIdleAppear(ctx) then
        sprite:Play(ANIMATION_IDLE, false)
        pickup.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        return
    end

    sprite:Play(ANIMATION_APPEAR, false)
    pickup.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    PickupMechanics.Effects_OnPickupAppear(pickup, ctx)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param seed integer
---@param ignoreModifiers boolean
local function collectible_appear(pickup, ctx, seed, ignoreModifiers)
    local room = ctx.game.m_level.m_room

    pickup.m_sprite:Play(ANIMATION_IDLE, false)
    IEntityPickup.SetAlternatePedestal(pickup, ctx, PedestalType.DEFAULT)

    if not ignoreModifiers and PickupMechanics.ItemShouldDuplicate(pickup, ctx) then
        pickup.m_flags = pickup.m_flags | EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE
        IRoom.TriggerDamoclesItemSpawned(room)
    end

    pickup.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    if IRoom.IsDungeon(room) then
        pickup.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    end

    if not ignoreModifiers and IEntityPickup.CanReroll(pickup, ctx) then
        PickupMechanics.Effects_InitCollectibleModifiers(pickup, ctx, seed)
    end

    local shouldAnimateAppear = room.m_isInitialized and IRoom.GetFrameCount(room, ctx) > 1

    if shouldAnimateAppear then
        pickup.m_visible = false
        pickup.m_flags = pickup.m_flags | EntityFlag.FLAG_APPEAR
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param type EntityType | integer
---@param variant PickupVariant | integer
---@param subtype integer
---@param seed integer
local function Init(pickup, ctx, type, variant, subtype, seed)
    local ignoreModifiers = IEntityPickup.IgnoreModifiers()

    pickup.m_isSpriteBatched_qqq = true
    pickup.m_coopExtra_collectedItems = -1
    pickup.m_price = 0
    pickup.m_shopItemId = 0
    pickup.m_timeout = -1
    pickup.m_wait = 0
    pickup.m_eternalChest_reCloseCountdown = 0
    pickup.m_touched = false
    pickup.m_probablyUnkBool = false
    pickup.m_isBlind = false
    pickup.m_payToPlay = false
    pickup.m_stickyNickelRelated = 0
    pickup.field_49c = 0
    pickup.m_camoColor_qqq = Color(0, 0, 0, 0)
    pickup.m_state = 0
    pickup.m_autoUpdatePrice = true
    IEntityPtr.SetReference(pickup.m_unkEntRef3_qqq, nil)

    if pickup.m_pickupGhost_qqq.ref then
        pickup.m_pickupGhost_qqq.ref:Remove(ctx)
        IEntityPtr.SetReference(pickup.m_pickupGhost_qqq, nil)
    end

    IEntityPtr.SetReference(pickup.m_megaChestCollectible[1], nil)
    IEntityPtr.SetReference(pickup.m_megaChestCollectible[2], nil)

    pickup.m_throw_height = 0.0
    pickup.m_throw_speed = 0.0
    pickup.m_flip_saveState = nil
    pickup.m_dropDelay = 0
    pickup.m_cycle_cycleNum = 0
    pickup.m_visibilityDelayTimer_qqq = 0
    pickup.m_charge = 0
    pickup.m_activeVarData = 0

    local rng = RNG(seed, 35)

    ---@type Pickup.Blackboard.Init
    local blackboard = {variant = variant, subtype = subtype, price = 0}
    local success = IEntityPickup.SelectPickupType(ctx, seed, blackboard, true, false)
    if not success then
        if blackboard.variant == -1 then
            IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_FLY, 0,
                pickup.m_position, VECTOR_ZERO, nil,
                0, pickup.m_dropRNG:Next()
            )
        end

        return
    end

    if blackboard.variant == PickupVariant.PICKUP_SHOPITEM then
        init_shop_item(pickup, ctx, blackboard, rng:Next())
    end

    if variant == PickupVariant.PICKUP_COLLECTIBLE then
        init_collectible(pickup, ctx, blackboard, rng, ignoreModifiers)
    elseif variant == PickupVariant.PICKUP_BROKEN_SHOVEL then
        init_broken_shovel(pickup, ctx)
    end

    blackboard.variant, blackboard.subtype = Callbacks.PostPickupSelection(pickup, blackboard.variant, blackboard.subtype)
    PickupMechanics.Effects_PostPickupSelect(ctx, blackboard)

    -- init entity config
    if variant == PickupVariant.PICKUP_TAROTCARD then
        local card = subtype
        if ctx.game.m_challenge == Challenge.CHALLENGE_CANTRIPPED then
            card, subtype = PickupMechanics.Cantripped_InitCard(ctx, card, rng)
        else
            local config = IItemConfig.GetCard(ctx.manager.m_itemConfig, card)
            subtype = config and config.m_pickupSubtype or eCardSubType.SUIT_CARD
        end

        IEntity.Init(pickup, ctx, type, PickupVariant.PICKUP_TAROTCARD, subtype, seed)
        pickup.m_variant = PickupVariant.PICKUP_TAROTCARD
        pickup.m_subtype = card
    else
        IEntity.Init(pickup, ctx, type, variant, subtype, seed)
    end

    PickupMechanics.Effects_PreLoadGraphics(pickup, ctx)

    if pickup.m_config ~= nil then
        pickup.m_sprite:Load(pickup.m_config.anm2Path, false)
        IEntityPickup.ReloadGraphics(pickup, ctx, false)
    end

    if PickupMechanics.IsNoKnockback(pickup) then
        pickup.m_flags = pickup.m_flags | EntityFlag.FLAG_NO_KNOCKBACK
    end

    if PickupMechanics.IsNoOverwrite(pickup) then
        pickup.m_flags = pickup.m_flags | EntityFlag.FLAG_DONT_OVERWRITE
        pickup.m_stickyNickelRelated = 10
    end

    PickupMechanics.GFuel_ReplacePickupGraphics(pickup, ctx)

    if variant == PickupVariant.PICKUP_COLLECTIBLE then
        collectible_appear(pickup, ctx, seed, ignoreModifiers)
    elseif variant == PickupVariant.PICKUP_BED then
        -- bed appear
        pickup.m_sprite:Play(ANIMATION_IDLE, false)
        pickup.m_flags = pickup.m_flags | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK
    else
        pickup_appear(pickup, ctx)
    end

    pickup.m_optionsPickupIndex = 0

    if PickupMechanics.Effects_ShouldForceShopItem(pickup, ctx, ignoreModifiers) then
        local room = ctx.game.m_level.m_room

        pickup.m_shopItemId = -1
        local price =IRoom.GetShopItemPrice(room, ctx, pickup.m_variant, pickup.m_subtype, -1)
        pickup.m_price = IRoom.TryGetShopDiscount(room, ctx, pickup.m_shopItemId, price)
    end

    IEntityPickup.SetPrice(pickup, ctx, pickup.m_price)

    PickupMechanics.PostPickupInit(pickup, ctx)
    IEntityPickup.UpdatePickupGhosts(pickup, ctx)
    Callbacks.PostPickupInit(pickup)
end

---@class Core.Pickup.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module