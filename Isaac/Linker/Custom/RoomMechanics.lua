---@class Interface.RoomMechanics
local Interface = require("Isaac.Interface.Custom.RoomMechanics")

local Misc = require("Isaac.Mechanics.RoomMechanics.Misc")
local DevilDeal = require("Isaac.Mechanics.RoomMechanics.DevilDeal")

Interface.IsAmbushChallenge = Misc.IsAmbushChallenge
Interface.DevilDeal_PostPlayerCollectPickup = DevilDeal.PostPlayerCollectPickup
