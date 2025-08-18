--#region Dependencies

local PlayerManagerUtils = require("PlayerManager.Utils")
local EntityPickupRules = require("Entity.Pickup.Rules")
local CollectiblePool = require("Game.Pools.ItemPool.CollectiblePool")

--#endregion

---@class CoopExtraItemLogic
local Module = {}

---@param pickup EntityPickupComponent
local function MakePickupCoopExtra(pickup)
    pickup.m_collectedCoopItems = 0
end

---@param context Context
---@param pickup EntityPickupComponent
local function grant_extra_item(context, pickup)
    local itemPool = context:GetItemPool()
    local seed = pickup.m_dropRNG:Next()
    local collectible = CollectiblePool.GetCollectible(context, itemPool, ItemPoolType.POOL_BOSS, seed, 0, CollectibleType.COLLECTIBLE_NULL)
    EntityPickupRules.Morph(context, pickup, pickup.m_type, pickup.m_variant, collectible, true, true, true)
end

---@param context Context
---@param pickup EntityPickupComponent
local function HandleGrantExtraItem(context, pickup)
    local playerManager = context:GetPlayerManager()
    if not PlayerManagerUtils.IsCoopPlay(playerManager) or pickup.m_subtype ~= CollectibleType.COLLECTIBLE_NULL then
        return
    end

    if pickup.m_collectedCoopItems == -1 then
        return
    end

    pickup.m_collectedCoopItems = pickup.m_collectedCoopItems + 1
    local numCoopPlayers = PlayerManagerUtils.GetNumCoopPlayers(playerManager)

    if pickup.m_collectedCoopItems >= numCoopPlayers then
        return
    end

    grant_extra_item(context, pickup)
end

--#region Module

Module.MakePickupCoopExtra = MakePickupCoopExtra
Module.HandleGrantExtraItem = HandleGrantExtraItem

--#endregion

return Module