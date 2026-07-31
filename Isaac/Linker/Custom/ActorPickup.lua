---@class Interface.Actor.Pickup
local Interface = require("Isaac.Interface.Custom.ActorPickup")

local Interactions = require("Isaac.Mechanics.Pickup.Interactions")

Interface.NeedsFreePlayer = Interactions.NeedsFreePlayer
Interface.HasCustomCollect = Interactions.HasCustomCollect
Interface.HasPlayerPickupCollect = Interactions.HasPlayerPickupCollect
Interface.SetupPlayerPickupCollect = Interactions.SetupPlayerPickupCollect
Interface.IgnorePhysicsCollision = Interactions.IgnorePhysicsCollision