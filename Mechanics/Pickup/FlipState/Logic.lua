--#region Dependencies

local RoomRules = require("Room.Rules")
local RoomEntitySaveRules = require("Room.SaveState.EntityRules")
local PickupUtils = require("Entity.Pickup.Utils")
local PickupRules = require("Entity.Pickup.Rules")
local PickupSaveStateComponent = require("Entity.Pickup.SaveState.Component")

--#endregion

---@class FlipStateLogic
local Module = {}

---@param context Context
---@param pickup EntityPickupComponent
local function InitFlipState(context, pickup)
    pickup.m_flipCollectibleSprite:Reset()

    if pickup.m_isDead then
        return
    end

    if not PickupRules.CanReroll(context, pickup.m_variant, pickup.m_subtype) then
        return
    end

    if PickupUtils.IsChest(pickup.m_variant) then
        return
    end

    if pickup.m_variant ~= PickupVariant.PICKUP_COLLECTIBLE or pickup.m_subtype == CollectibleType.COLLECTIBLE_NULL then
        return
    end

    local flipState = PickupSaveStateComponent.Create()
    pickup.m_flipState = flipState

    flipState.type = pickup.m_type
    flipState.variant = pickup.m_variant

    local rng = RNG(); rng:SetSeed(pickup.m_initSeed, 39)
    local seed = rng:Next()

    local collectible RoomRules.GetSeededCollectible(context, seed, true)
    flipState.subtype = collectible
    flipState.initSeed = seed
end

---@param context Context
---@param pickup EntityPickupComponent
---@return boolean
local function TryFlip(context, pickup)
    local oldFlipState = pickup.m_flipState
    local newFlipState = nil
    if not oldFlipState or pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE then
        return false
    end

    local room = context:GetRoom()
    local saveState = RoomEntitySaveRules.SaveEntity(context, room, pickup, false)
    ---@cast saveState PickupSaveStateComponent
    assert(saveState, "Flip save entity failed, when it should have succeeded")

    pickup.m_initSeed = oldFlipState.initSeed
    pickup.m_dropRNG:SetSeed(oldFlipState.dropSeed, 35)
    PickupRules.Morph(context, pickup, oldFlipState.type, oldFlipState.variant, oldFlipState.subtype, true, true, true)

    pickup.m_touched = oldFlipState.touched
    -- restore cycle pedestals

    if saveState.subtype ~= CollectibleType.COLLECTIBLE_NULL then
        newFlipState = saveState
    end

    pickup.m_flipState = newFlipState
    pickup.m_flipCollectibleSprite:Reset()
    return true
end

--#region Module

Module.InitFlipState = InitFlipState
Module.TryFlip = TryFlip

--#endregion

return Module