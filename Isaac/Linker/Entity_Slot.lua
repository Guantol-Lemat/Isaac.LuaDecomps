---@class Interface.Entity_Slot
local Interface = require("Isaac.Interface.Entity_Slot")

local SlotComponent = require("Isaac.Components.Entity.SlotComponent")
local SlotInit = require("Isaac.Core.Entity.Slot.SlotInit")
local SlotUpdate = require("Isaac.Core.Entity.Slot.SlotUpdate")
local SlotRender = require("Isaac.Core.Entity.Slot.SlotRender")
local SlotCollision = require("Isaac.Core.Entity.Slot.SlotCollision")
local SlotDamage = require("Isaac.Core.Entity.Slot.SlotDamage")
local SlotMisc = require("Isaac.Core.Entity.Slot.SlotMisc")

Interface.New = SlotComponent.New
Interface.RandomCoinJamAnim = SlotMisc.RandomCoinJamAnim
Interface.Init = SlotInit.Init
Interface.Update = SlotUpdate.Update
Interface.handle_collision = SlotCollision.HandleCollision
Interface.CreateDropsFromExplosion = SlotMisc.CreateDropsFromExplosion
Interface.TakeDamage = SlotDamage.TakeDamage
Interface.Render = SlotRender.Render
Interface.get_collectible_spawn_pos = SlotMisc.GetCollectibleSpawnPosition
Interface.SetPrizeCollectible = SlotMisc.SetPrizeCollectible