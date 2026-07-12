---@class Interface.Entity_Slot
local Interface = require("Isaac.Interface.Entity_Slot")

local SlotComponent = require("Isaac.Components.Entity.SlotComponent")
local SlotInit = require("Isaac.Gameplay.Slot.SlotInit")
local SlotUpdate = require("Isaac.Gameplay.Slot.SlotUpdate")
local SlotRender = require("Isaac.Gameplay.Slot.SlotRender")

--#region Stub

local Stub = {}

---@return string
function Stub.RandomCoinJamAnim() end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param Collider Component.Entity.Player
---@param Low boolean
---@return boolean
function Stub.handle_collision(ctx, slot, Collider, Low) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
function Stub.CreateDropsFromExplosion(ctx, slot) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param Damage number
---@param DamageFlags integer
---@param Source Component.Entity.EntityRef
---@param DamageCountdown integer
---@return boolean
function Stub.TakeDamage(ctx, slot, Damage, DamageFlags, Source, DamageCountdown) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@return Vector
function Stub.get_collectible_spawn_pos(ctx, slot) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param player Component.Entity.Player
function Stub.dress_player(ctx, slot, player) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param Collectible CollectibleType | integer
function Stub.SetPrizeCollectible(ctx, slot, Collectible) end

--endregion

Interface.New = SlotComponent.New
Interface.RandomCoinJamAnim = Stub.RandomCoinJamAnim
Interface.Init = SlotInit.Init
Interface.Update = SlotUpdate.Update
Interface.handle_collision = Stub.handle_collision
Interface.CreateDropsFromExplosion = Stub.CreateDropsFromExplosion
Interface.TakeDamage = Stub.TakeDamage
Interface.Render = SlotRender.Render
Interface.get_collectible_spawn_pos = Stub.get_collectible_spawn_pos
Interface.dress_player = Stub.dress_player
Interface.SetPrizeCollectible = Stub.SetPrizeCollectible