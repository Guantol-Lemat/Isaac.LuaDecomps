---@class Decomp.Collectible.Dices
local Dices = {}

--#region Dependencies

local Collectibles = {
    BookOfVirtues = require("Items.Collectible.Book_of_Virtues")
}

--#endregion

---@param player Decomp.Object.EntityPlayer
---@param useFlags UseFlag | integer
---@param env Decomp.EnvironmentObject
---@return boolean
local function can_spawn_book_of_virtues_wisp(player, useFlags, env)
    local api = env._API

    if not api.EntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, false) then
        return false
    end

    if not Collectibles.BookOfVirtues.CanSpawnWispOnUse(player, useFlags) then
        return false
    end

    return true
end

---@param source Decomp.EntityObject
---@param env Decomp.EnvironmentObject
local function spawn_poof_effect(source, env)
    local api = env._API
    local game = api.Isaac.GetGame(env)

    local position = api.Entity.GetPosition(source)
    local seed = api.Isaac.RandomInt(env)
    api.Game.Spawn(game, EntityType.ENTITY_EFFECT, EffectVariant.POOF01, position, Vector(0, 0), nil, 0, seed)
end

---@param collectible Decomp.EntityObject
---@param env Decomp.EnvironmentObject
---@return boolean
local function can_reroll_collectible(collectible, env)
    local api = env._API

    if api.Entity.IsDead(collectible) then
        return false
    end

    if api.Entity.GetSubType(collectible) == 0 then
        return false
    end

    local pickup = api.Entity.ToPickup(collectible)
    assert(pickup, "Collectible cannot be converted to Pickup")

    if not api.EntityPickup.CanReroll(pickup) then
        return false
    end

    if api.EntityPickup.GetOptionsPickupIndex(pickup) ~= 0 and api.EntityPickup.GetTimeout(pickup) >= 0 then
        return false
    end

    return true
end

---@param item CollectibleType
---@param collectible Decomp.EntityObject
---@param env Decomp.EnvironmentObject
---@return boolean
local function should_remove_collectible(item, collectible, env)
    local api = env._API

    if item == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
        local seed = api.Entity.GetDropSeed(collectible)
        local rng = RNG(); rng:SetSeed(seed, 44)

        if rng:RandomFloat() <= 0.25 then
            return true
        end
    end

    return false
end

---@param player Decomp.Object.EntityPlayer
---@param item CollectibleType
---@param collectible Decomp.EntityObject
---@param useFlags UseFlag | integer
---@param env Decomp.EnvironmentObject
local function reroll_collectible(player, item, collectible, useFlags, env)
    local api = env._API

    local pickup = api.Entity.ToPickup(collectible)
    assert(pickup, "Collectible cannot be converted to Pickup")

    if should_remove_collectible(item, collectible, env) then
        api.EntityPickup.TryRemoveCollectible(pickup)
        return
    end

    local type = api.Entity.GetType(collectible)
    local variant = api.Entity.GetVariant(collectible)

    api.EntityPickup.Morph(pickup, type, variant, 0, true, false, false)
    api.EntityPickup.SetTouched(pickup, false)

    if item == CollectibleType.COLLECTIBLE_D6 and can_spawn_book_of_virtues_wisp(player, useFlags, env) then
        api.EntityPlayer.AddWisp(player, CollectibleType.COLLECTIBLE_D6, player.m_Position, false, false)
    end
end

---@param player Decomp.Object.EntityPlayer
---@param env Decomp.EnvironmentObject
local function spawn_eternal_d6_wisp(player, env)
    local api = env._API

    local random = api.Isaac.RandomInt(env, 2)
    if random == 0 then
        api.EntityPlayer.AddWisp(player, CollectibleType.COLLECTIBLE_ETERNAL_D6, player.m_Position, false, false)
        return
    end

    local room = api.Isaac.GetRoom(env)
    local entityList = api.Room.GetEntityList(room)
    local wisps = api.EntityList.QueryType(entityList, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, CollectibleType.COLLECTIBLE_ETERNAL_D6, false, false)

    for k, wisp in ipairs(wisps) do
        wisp:Kill()
    end
end

---@param player Decomp.Object.EntityPlayer
---@param item CollectibleType
---@param useFlags UseFlag | integer
---@param env Decomp.EnvironmentObject
local function reroll_collectibles(player, item, useFlags, env)
    local api = env._API

    local itemPool = api.Isaac.GetItemPool(env)
    api.ItemPool.ResetRoomBlacklist(itemPool)

    local room = api.Isaac.GetRoom(env)
    local entityList = api.Room.GetEntityList(room)
    local collectibles = api.EntityList.QueryType(entityList, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)

    for k, collectible in ipairs(collectibles) do
        if can_reroll_collectible(collectible, env) then
            reroll_collectible(player, item, collectible, useFlags, env)
            spawn_poof_effect(collectible, env)
        end
    end

    if item == CollectibleType.COLLECTIBLE_ETERNAL_D6 and can_spawn_book_of_virtues_wisp(player, useFlags, env) then
        spawn_eternal_d6_wisp(player, env)
    end
end

---@param player Decomp.Object.EntityPlayer
---@param item CollectibleType | integer
---@param useFlags UseFlag | integer
---@param activeSlot ActiveSlot
---@param varData integer
local function UseD6(player, item, useFlags, activeSlot, varData)
    local env = player._ENV

    if player.m_Variant == PlayerVariant.PLAYER then
        reroll_collectibles(player, item, useFlags, env)
    end
end

--#region Module

Dices.UseD6 = UseD6

--#endregion

return Dices