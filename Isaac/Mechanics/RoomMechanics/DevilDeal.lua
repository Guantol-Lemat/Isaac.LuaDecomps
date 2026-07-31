--#region Dependencies

local Enums = require("Isaac.Enums")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

local eRoomFlags = Enums.eRoomFlags

---@param room Component.Room
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param pickup Component.Entity.Pickup
local function PostPlayerCollectPickup(room, ctx, player, pickup)
    local game = ctx.game
    local roomType = room.m_type

    local isDevilDeal = roomType == RoomType.ROOM_DEVIL
        or room.m_roomDescriptor & eRoomFlags.FLAG_DEVIL_TREASURE ~= 0 -- bug: not checking if treasure
        or (roomType == RoomType.ROOM_BOSS and ILevel.GetStateFlag(game.m_level, LevelStateFlag.STATE_SATANIC_BIBLE_USED))

    if not isDevilDeal then
        return
    end

    local isDeal = IEntityPickup.IsShopItem(pickup)
    if isDeal then
        IGame.AddDevilRoomDeal(game, ctx)
        IPersistentGameData.IncreaseEventCounter(ctx.manager.m_persistentGameData, ctx, EventCounter.DEVIL_DEALS_TAKEN, 1)
    end

    PlayerEffects.Redemption_TriggerDevilDealCollect(player, ctx, pickup)
end

---@class Mechanics.Room.DevilDeal
local Module = {}

--#region Module

Module.PostPlayerCollectPickup = PostPlayerCollectPickup

--#endregion

return Module