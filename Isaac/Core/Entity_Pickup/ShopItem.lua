--#region Dependencies

local Enums = require("Isaac.Enums")
local IEntityList = require("Isaac.Interface.EntityList")
local IEntity = require("Isaac.Interface.Entity")
local IRoom = require("Isaac.Interface.Room")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local GameEffects = require("Isaac.Interface.Custom.GameEffects")
local RoomMechanics = require("Isaac.Interface.Custom.RoomMechanics")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

---@class Pickup.Blackboard.PaySpecialPrice
---@field noHealth_isFree boolean

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param player Component.Entity.Player
local function CanPickupShopItem(pickup, ctx, player)
    local price = pickup.m_price
    if price < 0 then
        return PlayerEffects.SpecialPrice_CanPickup(player, ctx, price)
    end

    local totalCoins = player.m_numCoins + PlayerEffects.CouponWisp_GetExtraShopCoins_NoDecrease(ctx.game.m_level.m_room.m_entityList)
    return price <= totalCoins
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param spentMoney integer
---@return integer
local function Mechanics_PreSpentCoins(player, ctx, spentMoney)
    return spentMoney - PlayerEffects.CouponWisp_GetExtraShopCoins(ctx.game.m_level.m_room.m_entityList, ctx, spentMoney)
end

---@param player Component.Entity.Player
---@param ctx Context.Common
---@param spentMoney eShopItemPrice | integer
---@param boughtPickup Component.Entity.Pickup
---@return integer spentMoney
local function spend_money(player, ctx, spentMoney, boughtPickup)
    if spentMoney == 0 then
        return spentMoney
    end

    if spentMoney < 0 then
        PlayerEffects.SpecialPrice_Pay(player, ctx, spentMoney, boughtPickup)
        return spentMoney
    end

    spentMoney = Mechanics_PreSpentCoins(player, ctx, spentMoney)
    spentMoney = math.max(spentMoney, 0)

    IEntityPlayer.AddCoins(player, ctx, -spentMoney)
    IEntityPlayer.TriggerMoneySpent(player, ctx, spentMoney)
    return spentMoney
end

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param spentMoney eShopItemPrice | integer
local function TriggerShopPurchase(pickup, ctx, player, spentMoney)
    if spentMoney == 0 then
        spentMoney = pickup.m_price
    end

    pickup.m_priceANM2:Reset()

    spentMoney = spend_money(player, ctx, spentMoney, pickup)

    local room = ctx.game.m_level.m_room
    if RoomMechanics.ShouldTriggerRestock(room, ctx, pickup, spentMoney) then
        IRoom.TriggerRestock(room, IRoom.GetGridIndex(room, pickup.m_position), pickup.m_shopItemId)
    end
end

---@class Core.Pickup.ShopItem
local Module = {}

--#region Module

Module.CanPickupShopItem = CanPickupShopItem
Module.TriggerShopPurchase = TriggerShopPurchase

--#endregion

return Module