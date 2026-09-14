---@class Interface.RoomMechanics
local Interface = require("Isaac.Interface.Custom.RoomMechanics")

local Misc = require("Isaac.Content.RoomMechanics.Misc")
local Shop = require("Isaac.Content.RoomMechanics.Shop")


Interface.IsAmbushChallenge = Misc.IsAmbushChallenge
Interface.ShouldTriggerRestock = Shop.ShouldTriggerRestock