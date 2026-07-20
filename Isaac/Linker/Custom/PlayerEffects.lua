---@class Interface.PlayerEffects
local Interface = require("Isaac.Interface.Custom.PlayerEffects")

local BlockItem = require("Isaac.Mechanics.PlayerEffects.ItemBlock")
local WispAdd = require("Isaac.Mechanics.PlayerEffects.WispAdd")
local LootModifiers = require("Isaac.Mechanics.PlayerEffects.LootModifiers")

Interface.BlockItem = BlockItem.BlockItem
Interface.BlockCard = BlockItem.BlockCard
Interface.TryDaemonsTailBlock = LootModifiers.TryDaemonsTailBlock
Interface.LootModifiers_SlotExplosionDrops = LootModifiers.SlotExplosionDrops
Interface.BethsEssence_OnBeggarPay = WispAdd.BethsEssence_OnBeggarPay