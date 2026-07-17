---@class Interface.Entity_Slot
local Interface = require("Isaac.Interface.Entity_Slot")

local SlotComponent = require("Isaac.Components.Entity.SlotComponent")
local SlotInit = require("Isaac.Gameplay.Slot.SlotInit")
local SlotUpdate = require("Isaac.Gameplay.Slot.SlotUpdate")
local SlotRender = require("Isaac.Gameplay.Slot.SlotRender")
local SlotCollision = require("Isaac.Gameplay.Slot.SlotCollision")
local SlotDamage = require("Isaac.Gameplay.Slot.SlotDamage")

--#region Stub

local Stub = {}

---@return string
function Stub.RandomCoinJamAnim() end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
function Stub.CreateDropsFromExplosion(ctx, slot) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@return Vector
function Stub.get_collectible_spawn_pos(ctx, slot) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param Collectible CollectibleType | integer
function Stub.SetPrizeCollectible(ctx, slot, Collectible) end

--endregion

Interface.New = SlotComponent.New
Interface.RandomCoinJamAnim = Stub.RandomCoinJamAnim
Interface.Init = SlotInit.Init
Interface.Update = SlotUpdate.Update
Interface.handle_collision = SlotCollision.HandleCollision
Interface.CreateDropsFromExplosion = Stub.CreateDropsFromExplosion
Interface.TakeDamage = SlotDamage.TakeDamage
Interface.Render = SlotRender.Render
Interface.get_collectible_spawn_pos = Stub.get_collectible_spawn_pos
Interface.SetPrizeCollectible = Stub.SetPrizeCollectible