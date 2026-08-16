--#region Dependencies

local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IPlayerManager = require("Isaac.Interface.PlayerManager")

--#endregion

---@param ctx Context.Common
---@return boolean
local function IsIdleAppear(ctx)
    local level = ctx.game.m_level
    local room = level.m_room
    return (not room.m_isFirstVisit and IRoom.GetFrameCount(room, ctx) <= 0)
        or (not room.m_isInitialized and ILevel.GetStageID(level, ctx) == StbType.HOME)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@return boolean
local function ItemShouldDuplicate(pickup, ctx)
    return not IEntityPickup.IsShopItem(pickup)
        and IPlayerManager.AnyoneHasCollectible(ctx.game.m_playerManager, ctx, CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
end

---@class Mechanics.Pickups.Properties
local Module = {}

--#region Module

Module.IsIdleAppear = IsIdleAppear
Module.ItemShouldDuplicate = ItemShouldDuplicate

--#endregion

return Module