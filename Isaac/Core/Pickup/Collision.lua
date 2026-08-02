--#region Dependencies

local Enums = require("Isaac.Enums")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IScoreSheet = require("Isaac.Interface.ScoreSheet")
local IProceduralItemInventory = require("Isaac.Interface.ProceduralItemInventory")
local IAmbush = require("Isaac.Interface.Ambush")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local LuaCallbacks = require("LuaEngine.Callbacks")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")
local ActorFamiliar = require("Isaac.Interface.Custom.ActorFamiliar")
local ActorPickup = require("Isaac.Interface.Custom.ActorPickup")
local ActorNpc = require("Isaac.Interface.Custom.ActorNpc")
local RoomMechanics = require("Isaac.Interface.Custom.RoomMechanics")

--#endregion

---@class Pickup.Blackboard.HandleCollision
---@field effectTarget Component.Entity.Player?
---@field pickedUp boolean
---@field playPickupSound boolean
---@field triggerAmbush boolean
---@field droppedTrinket Component.Entity.Pickup?

local eShopItemPrice = Enums.eShopItemPrice
local eRoomFlags = Enums.eRoomFlags

local VECTOR_ZERO = Vector(0.0, 0.0)

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param collider Component.Entity
---@param low boolean
---@return boolean?
local function Mechanics_PreCollision(pickup, ctx, collider, low)
    if collider.m_type == EntityType.ENTITY_PLAYER then
        local result = ActorPickup.StickyNickel_HandleCooldownCollision()
        if result ~= nil then return result end

        GameEffects.PickupTimeout_PrePlayerCollision()
        ActorPickup.HantedChest_PrePlayerCollision()
    end

    local result = ActorPickup.StickyNickel_PreCollision()
    if result ~= nil then return result end
end

---This kind of check is unique to pickup collision
---due to not checking for the treasure room type
---@param game Component.Game
---@return boolean
local function is_devil_deal(game)
    local level = game.m_level
    local room = level.m_room
    local roomType = room.m_type

    return roomType == RoomType.ROOM_DEVIL
        or room.m_roomDescriptor.m_flags & eRoomFlags.FLAG_DEVIL_TREASURE ~= 0 -- bug?: not checking if treasure
        or (roomType == RoomType.ROOM_BOSS and ILevel.GetStateFlag(level, LevelStateFlag.STATE_SATANIC_BIBLE_USED))
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.HandleCollision
---@param collider Component.Entity.Player
---@param low boolean
---@return boolean?
local function player_handle_pickup(pickup, ctx, blackboard, collider, low)
    if low then
        return
    end

    local player = IEntityPlayer.GetEffectTarget(collider)
    local canPickupItem = not IEntityPlayer.CanPickupItem(player)
        and not ActorPickup.NeedsFreePlayer(pickup, ctx)

    if not canPickupItem and not player.m_isDead then
        return IEntityPickup.IsShopItem(pickup)
    end

    local canCollect = PlayerEffects.CanCollectPickup(player, ctx, pickup)
        and pickup.m_wait <= 0

    if not canCollect then
        return
    end

    if player.m_variant == PlayerVariant.CO_OP_BABY then
        player = PlayerEffects.BabyMagnet_GetEffectTarget(ctx, pickup)
    end

    local isShopItem = IEntityPickup.IsShopItem(pickup)
    if isShopItem and not PlayerEffects.CanPickupShopItem(player, ctx, pickup) then
        return true
    end

    if pickup.m_variant == PickupVariant.PICKUP_HEART then
        
    elseif pickup.m_variant == PickupVariant.PICKUP_COIN then
    elseif pickup.m_variant == PickupVariant.PICKUP_KEY then
    elseif pickup.m_variant == PickupVariant.PICKUP_BOMB then
    elseif pickup.m_variant == PickupVariant.PICKUP_LIL_BATTERY then
    elseif ActorPickup.IsOpenedOnContactChest() then
    elseif pickup.m_variant == PickupVariant.PICKUP_MEGACHEST then
    elseif ActorPickup.IsCollectible() and pickup.m_subtype ~= 0 then
    elseif ActorPickup.IsPocketItem() then
    elseif pickup.m_variant == PickupVariant.PICKUP_TRINKET then
    elseif pickup.m_variant == PickupVariant.PICKUP_BIGCHEST then
    elseif pickup.m_variant == PickupVariant.PICKUP_TROPHY then
    elseif pickup.m_variant == PickupVariant.PICKUP_BED then
    elseif pickup.m_variant == PickupVariant.PICKUP_GRAB_BAG then
    elseif pickup.m_variant == PickupVariant.PICKUP_POOP then
    elseif pickup.m_variant == PickupVariant.PICKUP_THROWABLEBOMB then

    end

    -- post player collect pickup
    if pickup.m_price == eShopItemPrice.STORE_CREDIT and blackboard.pickedUp then
        PlayerEffects.StoreCredit_Pay(player, ctx, blackboard)
    end

    if blackboard.pickedUp or blackboard.triggerAmbush then -- meaningful interaction
        IEntityPickup.TriggerTheresOptionsPickup(pickup, ctx)

        if is_devil_deal(ctx.game) then
            IEntityPlayer.TriggerDevilDealTaken(player, ctx, pickup, pickup.m_price)
        end
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param collisionParams Pickup.Blackboard.HandleCollision
---@param collider Component.Entity
---@param low boolean
---@return boolean?
local function non_player_handle_pickup(pickup, ctx, collisionParams, collider, low)
    local result

    if collider.m_type == EntityType.ENTITY_FAMILIAR then
        ---@cast collider Component.Entity.Familiar
        result = ActorFamiliar.HandlePickup(collider, ctx, pickup, collisionParams, low)
    elseif IEntity.IsEnemy(collider) then
        ---@cast collider Component.Entity.Npc
        result = ActorNpc.HandlePickup(collider, ctx, pickup, collisionParams, low)
    end

    if collisionParams.pickedUp then
        IEntityPickup.TriggerTheresOptionsPickup(pickup, ctx)
    end

    return result
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param custom boolean
local function player_pickup_collect(pickup, ctx, player, custom)
    if not custom then
        ActorPickup.SetupPlayerPickupCollect(pickup, ctx)
        IEntityPlayer.AnimatePickup(player, pickup.m_sprite, false, "Pickup")
    end

    -- Shop purchase may trigger some player animations, mainly relating to death
    -- so we trigger it here, after AnimatePickup.
    -- There's technically no reason to have it here and not after either the collection
    -- handlers have run
    if IEntityPickup.IsShopItem(pickup) then
        IEntityPickup.TriggerShopPurchase(pickup, ctx, player, pickup.m_price)
    end

    if not custom then
        pickup:Remove(ctx)
        IEntityPickup.UpdatePickupGhosts(pickup, ctx)
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param custom boolean
local function collect(pickup, ctx, custom)
    if custom then
        return
    end

    pickup.m_velocity = Vector(0, 0)
    pickup.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

    pickup.m_sprite:Play("Collect", false)
    pickup.m_isDead = true

    IEntityPickup.UpdatePickupGhosts(pickup, ctx)

    ActorPickup.GoldPenny_TryReappear()
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.HandleCollision
---@param player Component.Entity.Player?
local function do_pickup(pickup, ctx, blackboard, player)
    IScoreSheet.AddPickup(ctx.game.m_scoreSheet, ctx, pickup.m_variant, pickup.m_subtype, pickup.m_position)

    if blackboard.playPickupSound then
        IEntityPickup.PlayPickupSound(pickup, ctx)
    end

    if player then
        IProceduralItemInventory.TriggerEffects(
            player.m_proceduralItemInventory, ctx,
            ProceduralEffectConditionType.PICKUP_COLLECTED, player,
            player.m_position, VECTOR_ZERO
        )
    end

    local customCollect = ActorPickup.HasCustomCollect(pickup, ctx)
    if ActorPickup.HasPlayerPickupCollect(pickup, ctx) and player then
        player_pickup_collect(pickup, ctx, player, customCollect)
    else
        collect(pickup, ctx, customCollect)
    end

    -- post collect
    if pickup.m_variant == PickupVariant.PICKUP_HEART or pickup.m_variant == PickupVariant.PICKUP_COIN or pickup.m_variant == PickupVariant.PICKUP_BOMB then
        IGame.SetStateFlag(ctx.game, GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)
    end

    if IEntityPickup.IsShopItem(pickup) then
        IPersistentGameData.IncreaseEventCounter(ctx.manager.m_persistentGameData, ctx, EventCounter.SHOP_ITEMS_BOUGHT, 1)
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param blackboard Pickup.Blackboard.HandleCollision
---@param collider Component.Entity
---@param low boolean
---@return boolean? ignoreCollision
local function try_collect_pickup(pickup, ctx, blackboard, collider, low)
    local result

    if collider.m_type == EntityType.ENTITY_PLAYER then
        ---@cast collider Component.Entity.Player
        result = player_handle_pickup(pickup, ctx, blackboard, collider, low)
    else
        result = non_player_handle_pickup(pickup, ctx, blackboard, collider, low)
    end

    if result ~= nil then return result end

    if blackboard.pickedUp then
        do_pickup(pickup, ctx, blackboard, blackboard.effectTarget)
    end

    if blackboard.triggerAmbush and RoomMechanics.IsAmbushChallenge(ctx.game.m_level.m_room) then
        IAmbush.StartChallenge(ctx.game.m_ambush, ctx)
    end
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param collider Component.Entity
---@param low boolean
---@return boolean ignoreCollision
local function HandleCollision(pickup, ctx, collider, low)
    local result = ActorPickup.MegaChest_HandleCollision()
    if result ~= nil then return result end

    result = LuaCallbacks.PrePickupCollision(pickup, collider, low)
    if result ~= nil then return result end

    result = Mechanics_PreCollision(pickup, ctx, collider, low)
    if result ~= nil then return result end

    ---@type Pickup.Blackboard.HandleCollision
    local collectResults = {pickedUp = false, playPickupSound = false, triggerAmbush = false}
    result = try_collect_pickup(pickup, ctx, collectResults, collider, low)
    if result ~= nil then return result end

    GameEffects.CoopPlay_ExtraCollectible()
    local ignoreCollision = ActorPickup.IgnorePhysicsCollision(pickup, ctx, collider, collectResults)
    return ignoreCollision
end

---@class Core.Pickup.Collision
local Module = {}

--#region Module

Module.HandleCollision = HandleCollision

--#endregion

return Module