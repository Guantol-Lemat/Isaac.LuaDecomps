---@class Interface.Entity_Effect
local Interface = require("Isaac.Interface.Entity_Effect")

--#region Stub

local Stub = {}

---@param effect Component.Entity.Effect
---@param Timeout integer
function Stub.SetTimeout(effect, Timeout) end

---@param effect Component.Entity.Effect
---@param Rotation number
function Stub.SetRotation(effect, Rotation) end

---@param effect Component.Entity.Effect
---@param Scale number
function Stub.SetScale(effect, Scale) end

---@param effect Component.Entity.Effect
---@param Min number
---@param Max number
function Stub.SetRadii(effect, Min, Max) end

---@param effect Component.Entity.Effect
---@param Parent Component.Entity
function Stub.FollowParent(effect, Parent) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.update_hornfel_room_controller(ctx, effect) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.SpawnAlabasterBoxItems(ctx, timer) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.TriggerPlumFlute(ctx, timer) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.EverythingJarSpawnFliesSpidersDips(ctx, timer) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.EverythingJarSpawnShopkeeper(ctx, timer) end

---@param effect Component.Entity.Effect
---@return Component.Entity
function Stub.constructor(effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
---@param param_1 integer
function Stub.destructor(ctx, effect, param_1) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.destructor_2(ctx, effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
---@param Type EntityType | integer
---@param Variant EffectVariant | integer
---@param Subtype integer
---@param Seed integer
function Stub.Init(ctx, effect, Type, Variant, Subtype, Seed) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.Interpolate(ctx, effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.update_particle_physics(ctx, effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.ai_mr_me(ctx, effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.update_spewer_creep(ctx, effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.Update(ctx, effect) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.AddLunaEffect(ctx, timer) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
---@param offset Vector
function Stub.Render(ctx, effect, offset) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
function Stub.ClearReferences(ctx, effect) end

---@param Variant EffectVariant | integer
---@return boolean
function Stub.IsPlayerCreep(Variant) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
---@param param_2 Vector
---@return Vector
function Stub.get_wall_coords(ctx, effect, param_2) end

---@param ctx Context.Common
---@param func function
---@param delay integer
---@param times integer
---@param persistent boolean
---@return Component.Entity.Effect
function Stub.CreateTimer(ctx, func, delay, times, persistent) end

---@param ctx Context.Common
---@param Pos Vector
---@param Color Color
---@param lifespan integer
---@param state integer
---@return Component.Entity.Effect
function Stub.CreateLight(ctx, Pos, Color, lifespan, state) end

---@param effect Component.Entity.Effect
---@param interpolate boolean
function Stub.update_urn_of_souls(effect, interpolate) end

---@param ctx Context.Common
---@param list Component.LootList
---@param pos Vector
---@param owner Component.Entity
---@param effect Component.Entity.Effect
---@return Component.Entity.Effect
function Stub.CreateLootPreview(ctx, list, pos, owner, effect) end

---@param ctx Context.Common
---@param effect Component.Entity.Effect
---@param loot Component.LootList
function Stub.init_loot_preview(ctx, effect, loot) end

---@param effect Component.Entity.Effect
function Stub.TriggerGlowingHourglass(effect) end

---@param effect Component.Entity.Effect
---@param EntityType integer
function Stub.SetDamageSource(effect, EntityType) end

---@param effect Component.Entity.Effect
---@param flags BitSet128
function Stub.AddTearFlags(effect, flags) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.TriggerHighPriestess(ctx, timer) end

--#endregion

Interface.SetTimeout = Stub.SetTimeout
Interface.SetRotation = Stub.SetRotation
Interface.SetScale = Stub.SetScale
Interface.SetRadii = Stub.SetRadii
Interface.FollowParent = Stub.FollowParent
Interface.update_hornfel_room_controller = Stub.update_hornfel_room_controller
Interface.SpawnAlabasterBoxItems = Stub.SpawnAlabasterBoxItems
Interface.TriggerPlumFlute = Stub.TriggerPlumFlute
Interface.EverythingJarSpawnFliesSpidersDips = Stub.EverythingJarSpawnFliesSpidersDips
Interface.EverythingJarSpawnShopkeeper = Stub.EverythingJarSpawnShopkeeper
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.destructor_2 = Stub.destructor_2
Interface.Init = Stub.Init
Interface.Interpolate = Stub.Interpolate
Interface.update_particle_physics = Stub.update_particle_physics
Interface.ai_mr_me = Stub.ai_mr_me
Interface.update_spewer_creep = Stub.update_spewer_creep
Interface.Update = Stub.Update
Interface.AddLunaEffect = Stub.AddLunaEffect
Interface.Render = Stub.Render
Interface.ClearReferences = Stub.ClearReferences
Interface.IsPlayerCreep = Stub.IsPlayerCreep
Interface.get_wall_coords = Stub.get_wall_coords
Interface.CreateTimer = Stub.CreateTimer
Interface.CreateLight = Stub.CreateLight
Interface.update_urn_of_souls = Stub.update_urn_of_souls
Interface.CreateLootPreview = Stub.CreateLootPreview
Interface.init_loot_preview = Stub.init_loot_preview
Interface.TriggerGlowingHourglass = Stub.TriggerGlowingHourglass
Interface.SetDamageSource = Stub.SetDamageSource
Interface.AddTearFlags = Stub.AddTearFlags
Interface.TriggerHighPriestess = Stub.TriggerHighPriestess