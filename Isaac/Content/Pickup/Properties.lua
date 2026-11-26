--#region Dependencies

local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local EntityProperty = require("Isaac.Core.Entity.Misc")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IPlayerManager = require("Isaac.Interface.PlayerManager")

--#endregion

---@param ctx Context.Common
---@return boolean
local function IsIdleAppear(ctx)
    local level = ctx.game.m_level
    local room = level.m_room
    return (not room.m_isFirstVisit and IRoom.GetFrameCount(room) <= 0)
        or (not room.m_isInitialized and ILevel.GetStageID(level) == StbType.HOME)
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@return boolean
local function ItemShouldDuplicate(pickup, ctx)
    return not IEntityPickup.IsShopItem(pickup)
        and IPlayerManager.AnyoneHasCollectible(ctx.game.m_playerManager, ctx, CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
end

---@param pickup Component.Entity.Pickup
---@return boolean
local function ShouldRender(pickup)
    return EntityProperty.ShouldRender(pickup) and pickup.m_dropDelay < 1
end

---@class Mechanics.Pickups.Properties
local Module = {}

--#region Module

Module.IsIdleAppear = IsIdleAppear
Module.ItemShouldDuplicate = ItemShouldDuplicate
Module.ShouldRender = ShouldRender

--#endregion

return Module