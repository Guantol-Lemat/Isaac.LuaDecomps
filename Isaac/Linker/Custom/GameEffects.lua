---@class Interface.GameEffects
local Interface = require("Isaac.Interface.Custom.GameEffects")

local Achievement = require("Isaac.Mechanics.GameEffects.Achievement")
local ItemBlock = require("Isaac.Mechanics.GameEffects.ItemBlock")
local ItemExtraParams = require("Isaac.Mechanics.GameEffects.ItemExtraParams")
local GFuel = require("Isaac.Mechanics.GameEffects.GFuel")

Interface.Achievement_MemberCard = Achievement.MemberCard
Interface.BlockItem_Mode = ItemBlock.BlockItem_Mode
Interface.BlockItem_Modifier = ItemBlock.BlockItem_Modifier
Interface.BlockTrinket = ItemBlock.BlockTrinket
Interface.BanActiveFromProceduralPool = ItemExtraParams.BanActiveFromProceduralPool
Interface.GFuel_CreateGFuelItem = GFuel.CreateGFuelItem