---@class Interface.RoomMechanics
local Interface = require("Isaac.Interface.Custom.RoomMechanics")

local Misc = require("Isaac.Mechanics.RoomMechanics.Misc")
local Shop = require("Isaac.Mechanics.RoomMechanics.Shop")
local DevilDeal = require("Isaac.Mechanics.RoomMechanics.DevilDeal")


Interface.IsAmbushChallenge = Misc.IsAmbushChallenge
Interface.DevilDeal_PostPlayerCollectPickup = DevilDeal.PostPlayerCollectPickup
Interface.ShouldTriggerRestock = Shop.ShouldTriggerRestock