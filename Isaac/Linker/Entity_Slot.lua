---@class Interface.Entity_Slot
local Interface = require("Isaac.Interface.Entity_Slot")

--#region Stub

local Stub = {}

---@param slot Component.Entity.Slot
---@return Component.Entity.Slot
function Stub.Constructor(slot) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param param_1 integer
function Stub.destructor(ctx, slot, param_1) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param param_1 Component.Entity
function Stub.destructor_2(ctx, slot, param_1) end

---@return string
function Stub.RandomCoinJamAnim() end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
---@param Type integer
---@param Variant integer
---@param SubType integer
---@param Seed integer
function Stub.Init(ctx, slot, Type, Variant, SubType, Seed) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.battery_bum_award_charge(ctx, timer) end

---@param ctx Context.Common
---@param slot Component.Entity.Slot
function Stub.Update(ctx, slot) end

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
---@param offset Vector
function Stub.Render(ctx, slot, offset) end

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

Interface.Constructor = Stub.Constructor
Interface.destructor = Stub.destructor
Interface.destructor_2 = Stub.destructor_2
Interface.RandomCoinJamAnim = Stub.RandomCoinJamAnim
Interface.Init = Stub.Init
Interface.battery_bum_award_charge = Stub.battery_bum_award_charge
Interface.Update = Stub.Update
Interface.handle_collision = Stub.handle_collision
Interface.CreateDropsFromExplosion = Stub.CreateDropsFromExplosion
Interface.TakeDamage = Stub.TakeDamage
Interface.Render = Stub.Render
Interface.get_collectible_spawn_pos = Stub.get_collectible_spawn_pos
Interface.dress_player = Stub.dress_player
Interface.SetPrizeCollectible = Stub.SetPrizeCollectible