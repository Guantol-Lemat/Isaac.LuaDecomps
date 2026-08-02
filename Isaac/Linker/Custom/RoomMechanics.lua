---@class Interface.RoomMechanics
local Interface = require("Isaac.Interface.Custom.RoomMechanics")

local Misc = require("Isaac.Mechanics.RoomMechanics.Misc")
local Shop = require("Isaac.Mechanics.RoomMechanics.Shop")


Interface.IsAmbushChallenge = Misc.IsAmbushChallenge
Interface.ShouldTriggerRestock = Shop.ShouldTriggerRestock