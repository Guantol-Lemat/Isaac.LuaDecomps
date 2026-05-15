---@class Interface.Entity_Tear
local Interface = require("Isaac.Interface.Entity_Tear")

--#region Stub

local Stub = {}

---@param tear Component.Entity.Tear
---@return BitSet128
function Stub.GetTearFlags(tear) end

---@param param_1 Component.Entity.Tear
---@param param_2 unknown
function Stub.SetTearIdx(param_1, param_2) end

---@param tear Component.Entity.Tear
---@return integer
function Stub.GetTearIndex(tear) end

---@param tear Component.Entity.Tear
---@return number
function Stub.GetRotation(tear) end

---@param tear Component.Entity.Tear
---@param Rotation number
function Stub.SetRotation(tear, Rotation) end

---@param tear Component.Entity.Tear
---@param Mult number
function Stub.SetKnockbackMultiplier(tear, Mult) end

---@param tear Component.Entity.Tear
---@return number
function Stub.GetKnockbackMultiplier(tear) end

---@param tear Component.Entity.Tear
---@param Time integer
function Stub.SetWaitFrames(tear, Time) end

---@param tear Component.Entity.Tear
---@return integer
function Stub.GetWaitFrames(tear) end

---@param tear Component.Entity.Tear
---@param param_1 Vector
function Stub.set_continue_velocity(tear, param_1) end

---@param tear Component.Entity.Tear
---@return Vector
function Stub.get_continue_velocity(tear) end

---@param tear Component.Entity.Tear
---@return number
function Stub.GetDeadEyeIntensity(tear) end

---@param tear Component.Entity.Tear
---@return boolean
function Stub.is_multidimensional_qqq(tear) end

---@param tear Component.Entity.Tear
---@param param_1 boolean
function Stub.set_multidimensional_touched_qqq(tear, param_1) end

---@param tear Component.Entity.Tear
---@return boolean
function Stub.IsPrismTouched(tear) end

---@param tear Component.Entity.Tear
---@param param_2 boolean
function Stub.SetPrismTouched(tear, param_2) end

---@param tear Component.Entity.Tear
function Stub.DisableCanTriggerStreakEnd(tear) end

---@param param_1_00 Component.HitList
---@param param_2 Component.Entity
function Stub.hitlist_something(param_1_00, param_2) end

---@param tear Component.Entity.Tear
---@return Component.Entity.Player?
function Stub.GetPlayer(tear) end

---@param param_1 integer
---@return boolean
function Stub.CheckStrangeAttractorCond(param_1) end

---@param tear Component.Entity.Tear
---@return Component.Entity
function Stub.constructor(tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param param_1 boolean
---@return unknown
function Stub.Free(ctx, tear, param_1) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
function Stub.destructor(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param type EntityType | integer
---@param var TearVariant | integer
---@param subtype integer
---@param seed integer
function Stub.Init(ctx, tear, type, var, subtype, seed) end

---@param tear Component.Entity.Tear
function Stub.ClearReferences(tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param param_2 number
function Stub.offset_wiggle_tear(ctx, tear, param_2) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param param_2 number
function Stub.offset_big_spiral_tear(ctx, tear, param_2) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param param_2 number
function Stub.offset_spiral_tear(ctx, tear, param_2) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
function Stub.init_tear(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
function Stub.Update(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param Collider Component.Entity.Npc
---@param Low boolean
---@return boolean
function Stub.handle_collision(ctx, tear, Collider, Low) end

---@param tear Component.Entity.Tear
---@param param_1 number
function Stub.SetCollisionDamage(tear, param_1) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param Height number
function Stub.SetHeight(ctx, tear, Height) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@return number
function Stub.get_render_height(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param Scale number
function Stub.SetScale(ctx, tear, Scale) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param flags BitSet128
function Stub.SetTearFlags(ctx, tear, flags) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param Collider Component.Entity?
function Stub.trigger_collision(ctx, tear, Collider) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
function Stub.ResetSpriteScale(ctx, tear) end

---@param tear Component.Entity.Tear
---@return boolean
function Stub.GetHasParentTear(tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param param_1 boolean
---@return integer
function Stub.explode_balloon_qqq(ctx, tear, param_1) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param offset Vector
function Stub.Render(ctx, tear, offset) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
function Stub.Interpolate(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param Intensity number
function Stub.SetDeadEyeIntensity(ctx, tear, Intensity) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param spawner Component.Entity
---@return Component.Entity.Tear
function Stub.MakeMultidimensionalCopy(ctx, tear, spawner) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param Variant TearVariant | integer
function Stub.ChangeVariant(ctx, tear, Variant) end

---@param tear Component.Entity.Tear
---@return number
function Stub.calc_ludovico_bounce_delay(tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@return Component.Entity.Tear
function Stub.chain_find_link_parent(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@return Component.Entity.Tear
function Stub.chain_find_closest_end_link(ctx, tear) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
function Stub.chain_update(ctx, tear) end

---@param tear Component.Entity.Tear
---@return integer
function Stub.chain_get_link_length(tear) end

---@param tear Component.Entity.Tear
---@param other Component.Entity.Tear
function Stub.chain_insert_link(tear, other) end

---@param param_1 integer
---@return number
function Stub.SizeIdxToScale(param_1) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param position Vector
---@param flags BitSet128
---@param param_4 Component.Entity
---@param param_5 number
function Stub.ApplyTearFlagEffects(ctx, entity, position, flags, param_4, param_5) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param DamageFlags DamageFlags | integer
---@param unused unknown
---@param tearFlags BitSet128
---@param unused2 unknown
---@param source Component.Entity
function Stub.ApplyTearFlagModifiers(ctx, tear, DamageFlags, unused, tearFlags, unused2, source) end

---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 number
---@param param_3 number
---@param param_4 Component.Entity
---@param param_5 BitSet128
function Stub.TearSplashDamage(ctx, param_1, param_2, param_3, param_4, param_5) end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param position Vector
---@return boolean
function Stub.damage_grid(ctx, tear, position) end

---@param variant TearVariant | integer
---@return TearVariant | integer
function Stub.GetBloodTearVariant(variant) end

---@param tear Component.Entity.Tear
function Stub.set_unk_bool_true(tear) end

---@param tear Component.Entity.Tear
---@param Offset Vector
function Stub.SetParentOffset(tear, Offset) end

--endregion

Interface.GetTearFlags = Stub.GetTearFlags
Interface.SetTearIdx = Stub.SetTearIdx
Interface.GetTearIndex = Stub.GetTearIndex
Interface.GetRotation = Stub.GetRotation
Interface.SetRotation = Stub.SetRotation
Interface.SetKnockbackMultiplier = Stub.SetKnockbackMultiplier
Interface.GetKnockbackMultiplier = Stub.GetKnockbackMultiplier
Interface.SetWaitFrames = Stub.SetWaitFrames
Interface.GetWaitFrames = Stub.GetWaitFrames
Interface.set_continue_velocity = Stub.set_continue_velocity
Interface.get_continue_velocity = Stub.get_continue_velocity
Interface.GetDeadEyeIntensity = Stub.GetDeadEyeIntensity
Interface.is_multidimensional_qqq = Stub.is_multidimensional_qqq
Interface.set_multidimensional_touched_qqq = Stub.set_multidimensional_touched_qqq
Interface.IsPrismTouched = Stub.IsPrismTouched
Interface.SetPrismTouched = Stub.SetPrismTouched
Interface.DisableCanTriggerStreakEnd = Stub.DisableCanTriggerStreakEnd
Interface.hitlist_something = Stub.hitlist_something
Interface.GetPlayer = Stub.GetPlayer
Interface.CheckStrangeAttractorCond = Stub.CheckStrangeAttractorCond
Interface.constructor = Stub.constructor
Interface.Free = Stub.Free
Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.ClearReferences = Stub.ClearReferences
Interface.offset_wiggle_tear = Stub.offset_wiggle_tear
Interface.offset_big_spiral_tear = Stub.offset_big_spiral_tear
Interface.offset_spiral_tear = Stub.offset_spiral_tear
Interface.init_tear = Stub.init_tear
Interface.Update = Stub.Update
Interface.handle_collision = Stub.handle_collision
Interface.SetCollisionDamage = Stub.SetCollisionDamage
Interface.SetHeight = Stub.SetHeight
Interface.get_render_height = Stub.get_render_height
Interface.SetScale = Stub.SetScale
Interface.SetTearFlags = Stub.SetTearFlags
Interface.trigger_collision = Stub.trigger_collision
Interface.reset_sprite_scale = Stub.ResetSpriteScale
Interface.IsMainTear = Stub.GetHasParentTear
Interface.explode_balloon_qqq = Stub.explode_balloon_qqq
Interface.Render = Stub.Render
Interface.Interpolate = Stub.Interpolate
Interface.SetDeadEyeIntensity = Stub.SetDeadEyeIntensity
Interface.MakeMultidimensionalCopy = Stub.MakeMultidimensionalCopy
Interface.ChangeVariant = Stub.ChangeVariant
Interface.calc_ludovico_bounce_delay = Stub.calc_ludovico_bounce_delay
Interface.chain_find_link_parent = Stub.chain_find_link_parent
Interface.chain_find_closest_end_link = Stub.chain_find_closest_end_link
Interface.chain_update = Stub.chain_update
Interface.chain_get_link_length = Stub.chain_get_link_length
Interface.chain_insert_link = Stub.chain_insert_link
Interface.SizeIdxToScale = Stub.SizeIdxToScale
Interface.ApplyTearFlagEffects = Stub.ApplyTearFlagEffects
Interface.ApplyTearFlagModifiers = Stub.ApplyTearFlagModifiers
Interface.TearSplashDamage = Stub.TearSplashDamage
Interface.damage_grid = Stub.damage_grid
Interface.GetBloodTearVariant = Stub.GetBloodTearVariant
Interface.set_unk_bool_true = Stub.set_unk_bool_true
Interface.SetParentOffset = Stub.SetParentOffset