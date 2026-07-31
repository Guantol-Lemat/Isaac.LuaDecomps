---@class Interface.PlayerEffects
local Interface = require("Isaac.Interface.Custom.PlayerEffects")

local Interactions = require("Isaac.Mechanics.PlayerEffects.Interactions")
local BlockItem = require("Isaac.Mechanics.PlayerEffects.ItemBlock")
local WispAdd = require("Isaac.Mechanics.PlayerEffects.WispAdd")
local LootModifiers = require("Isaac.Mechanics.PlayerEffects.LootModifiers")
local Redemption = require("Isaac.Mechanics.PlayerEffects.Redemption")
local Shop = require("Isaac.Mechanics.PlayerEffects.Shop")

Interface.CouponWisp_AddExtraCoins = Shop.CouponWisp_AddExtraCoins
Interface.CanPickupShopItem = Interactions.CanPickupShopItem
Interface.CanCollectPickup = Interactions.CanCollectPickup
Interface.BabyMagnet_GetEffectTarget = Interactions.BabyMagnet_GetEffectTarget
Interface.BlockItem = BlockItem.BlockItem
Interface.BlockCard = BlockItem.BlockCard
Interface.TryDaemonsTailBlock = LootModifiers.TryDaemonsTailBlock
Interface.LootModifiers_SlotExplosionDrops = LootModifiers.SlotExplosionDrops
Interface.BethsEssence_OnBeggarPay = WispAdd.BethsEssence_OnBeggarPay
Interface.Redemption_TriggerDevilDealCollect = Redemption.TriggerDeviDealCollect