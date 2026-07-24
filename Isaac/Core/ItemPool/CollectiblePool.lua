--#region Dependencies

local IItemConfig = require("Isaac.Interface.ItemConfig")

--#endregion

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param collectible CollectibleType | integer
---@param checkIfAvailable boolean
---@param noRemove boolean -- simply checks if the collectible is available in the pool, but does not remove it
---@return boolean removed
local function RemoveCollectible(itemPool, ctx, collectible, checkIfAvailable, noRemove)
    local glitchedItem = collectible < CollectibleType.COLLECTIBLE_NULL
    if glitchedItem then
        return true
    end

    if checkIfAvailable then
        local config = IItemConfig.GetCollectible(ctx.manager.m_itemConfig, ctx, collectible)
        local isAvailable = config and IItemConfig.Item.IsAvailable(config, ctx, false)

        if not isAvailable then
            return false
        end
    end

    local game = ctx.game
    if game.m_challenge == Challenge.CHALLENGE_CANTRIPPED then
        return false
    end

    if collectible == CollectibleType.COLLECTIBLE_WAIT_WHAT and not noRemove then
        RemoveCollectible(itemPool, ctx, CollectibleType.COLLECTIBLE_BUTTER_BEAN, false, false)
    end

    local removed = itemPool.m_removedCollectibles[collectible + 1] == false
    if not noRemove then
        itemPool.m_removedCollectibles[collectible + 1] = true
    end

    return removed
end

---@class Gameplay.ItemPool.CollectiblePool
local Module = {}

--#region Module

Module.RemoveCollectible = RemoveCollectible

--#endregion

return Module