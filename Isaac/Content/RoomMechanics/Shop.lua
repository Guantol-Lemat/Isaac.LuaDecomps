--#region Dependencies

local IGame = require("Isaac.Interface.Game")
local IPlayerManager = require("Isaac.Interface.PlayerManager")

--#endregion

---@param room Component.Room
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@return boolean
local function ShouldTriggerRestock(room, ctx, pickup, spentMoney)
    if room.m_type ~= RoomType.ROOM_SHOP then
        return false
    end

    if pickup.m_variant == 100 or spentMoney == 0 then
        return false
    end

    local hasRestock = IPlayerManager.AnyoneHasCollectible(ctx.game.m_playerManager, ctx, CollectibleType.COLLECTIBLE_RESTOCK)
        or IGame.IsGreedMode(ctx.game)

    return hasRestock
end

---@class RoomMechanics.Shop
local Module = {}

--#region Module

Module.ShouldTriggerRestock = ShouldTriggerRestock

--#endregion

return Module