---@class Interface.PlayerEffects
local Interface = require("Isaac.Interface.Custom.PlayerEffects")

local WispAdd = require("Isaac.PlayerEffects.WispAdd")
local LootModifiers = require("Isaac.PlayerEffects.LootModifiers")

Interface.TryDaemonsTailBlock = LootModifiers.TryDaemonsTailBlock
Interface.LootModifiers_SlotExplosionDrops = LootModifiers.SlotExplosionDrops
Interface.BethsEssence_OnBeggarPay = WispAdd.BethsEssence_OnBeggarPay