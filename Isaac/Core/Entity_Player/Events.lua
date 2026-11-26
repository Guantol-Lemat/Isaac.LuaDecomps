--#region Dependencies

local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local GameEffects = require("Isaac.Interface.Custom.GameEffects")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param spentMoney integer
local function TriggerMoneySpent(player, ctx, spentMoney)
    PlayerEffects.KeepersSack_AddSpentCoins(player, ctx, spentMoney)
    GameEffects.Achievement_MemberCard(ctx, spentMoney)
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param pickup Component.Entity.Pickup
---@param price PickupPrice | integer
local function TriggerDevilDealTaken(player, ctx, pickup, price)
    local isDealItem = price ~= 0
        or pickup.m_spawnGridIdx >= 0

    if not isDealItem then
        return
    end

    if price ~= 0 then
        IGame.AddDevilRoomDeal(ctx.game, ctx)
        IPersistentGameData.IncreaseEventCounter(ctx.manager.m_persistentGameData, ctx, EventCounter.DEVIL_DEALS_TAKEN, 1)
    end

    PlayerEffects.Redemption_TriggerDevilDealTaken(player, ctx, pickup)
end

---@class Core.Player.Events
local Module = {}

--#region Module

Module.TriggerMoneySpent = TriggerMoneySpent
Module.TriggerDevilDealTaken = TriggerDevilDealTaken

--#endregion

return Module