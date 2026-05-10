---@class Interface.Entity_Laser
local Interface = require("Isaac.Interface.Entity_Laser")

--#region Stub

local Stub = {}

---@param laser Component.Entity.Laser
---@param flags BitSet128
function Stub.SetTearFlags(laser, flags) end

---@param laser Component.Entity.Laser
---@param Timeout integer
function Stub.SetTimeout(laser, Timeout) end

---@param laser Component.Entity.Laser
---@param Distance number
function Stub.SetMaxDistance(laser, Distance) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.IsCircleLaser(laser) end

---@param laser Component.Entity.Laser
---@param value boolean
function Stub.SetDisableFollowParent(laser, value) end

---@param laser Component.Entity.Laser
---@param Type integer
function Stub.SetHomingType(laser, Type) end

---@param laser Component.Entity.Laser
---@param param_1_00 boolean
function Stub.UnknownLaserBoolSet(laser, param_1_00) end

---@param laser Component.Entity.Laser
---@return integer
function Stub.GetTimeout(laser) end

---@param laser Component.Entity.Laser
---@param seed integer
function Stub.SetDropRNGSeed(laser, seed) end

---@param laser Component.Entity.Laser
---@param Value boolean
function Stub.SetOneHit(laser, Value) end

---@param laser Component.Entity.Laser
---@param Value boolean
function Stub.SetMultidimensionalTouched(laser, Value) end

---@param laser Component.Entity.Laser
---@param param_2 unknown
function Stub.SetPrismTouched(laser, param_2) end

---@param laser Component.Entity.Laser
---@param entityType EntityType | integer
function Stub.AddToHitList(laser, entityType) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.GetOneHit(laser) end

---@param laser Component.Entity.Laser
---@param value boolean
function Stub.SetShrink(laser, value) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.GetShrink(laser) end

---@param laser Component.Entity.Laser
---@return integer
function Stub.GetHomingType(laser) end

---@param laser Component.Entity.Laser
---@return number
function Stub.GetMaxDistance(laser) end

---@param laser Component.Entity.Laser
---@param Radius number
function Stub.SetRadius(laser, Radius) end

---@param laser Component.Entity.Laser
---@return number
function Stub.GetRadius(laser) end

---@param laser Component.Entity.Laser
---@param Chance number
function Stub.SetBlackHpDropChance(laser, Chance) end

---@param laser Component.Entity.Laser
---@return number
function Stub.GetBlackHpDropChance(laser) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.GetMultidimensionalTouched(laser) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.IsPrismTouched(laser) end

---@param laser Component.Entity.Laser
---@param offset Vector
function Stub.SetParentOffset(laser, offset) end

---@param laser Component.Entity.Laser
---@return Vector
function Stub.GetEndPoint(laser) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.IsSampleLaser(laser) end

---@param laser Component.Entity.Laser
---@param laser Component.Entity.Laser
---@return Component.Entity.Laser
function Stub.Constructor(laser, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param param_1 boolean
function Stub.Free(ctx, laser, param_1) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.destructor(ctx, laser) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.is_brimstone_laser(laser) end

---@param laser Component.Entity.Laser
---@return Component.HitList
function Stub.get_hit_entities(laser) end

---@param laser Component.Entity.Laser
---@param Angle number
function Stub.SetAngle(laser, Angle) end

---@param laser Component.Entity.Laser
---@return integer
function Stub.GetRenderZ(laser) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.BelongsToPlayer(laser) end

---@param laser Component.Entity.Laser
---@param param_1 Component.Entity
---@return boolean
function Stub.CanDamageEntity(laser, param_1) end

---@param laser Component.Entity.Laser
---@param param_2 Vector
---@return Vector
function Stub.get_position_from_distance(laser, param_2) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param param_1 Vector
---@param param_2 number
function Stub.trigger_collision(ctx, laser, param_1, param_2) end

---@param laser Component.Entity.Laser
---@return Color
function Stub.calculate_tear_color(laser) end

---@param laser Component.Entity.Laser
---@param param_1 Component.Entity.Laser
---@param param_2 boolean
function Stub.Copy(laser, param_1, param_2) end

---@param ctx Context.Common
---@param Variant LaserVariant | integer
---@param SourcePos Vector
---@param AngleDegrees number
---@param Timeout integer
---@param PosOffset Vector
---@param Source Component.Entity?
---@param Force boolean
---@return Component.Entity.Laser?
function Stub.ShootAngle(ctx, Variant, SourcePos, AngleDegrees, Timeout, PosOffset, Source, Force) end

---@param laser Component.Entity.Laser
---@param Delay integer
---@param AngleDegrees number
---@param RotationSpd number
---@param TimeoutComplete boolean
function Stub.SetActiveRotation(laser, Delay, AngleDegrees, RotationSpd, TimeoutComplete) end

---@param laser Component.Entity.Laser
---@param param_2 number
---@param param_3 number
function Stub.RotateToAngle(laser, param_2, param_3) end

---@param laser Component.Entity.Laser
function Stub.ClearLaserSamples(laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param type integer
---@param var integer
---@param subtype integer
---@param seed integer
function Stub.Init(ctx, laser, type, var, subtype, seed) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.play_sound(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param Start Vector
---@param Dir Vector
---@return Vector
function Stub.CalculateEndPoint(ctx, laser, Start, Dir) end

---@param ctx Context.Common
---@param Start Vector
---@param Dir Vector
---@param PositionOffset Vector
---@param Parent Component.Entity
---@param Margin number
---@return Vector
function Stub.CalculateEndPosition(ctx, Start, Dir, PositionOffset, Parent, Margin) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.init_laser(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param param_1 integer
---@param param_2 Vector
function Stub.damage_grid(ctx, laser, param_1, param_2) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param param_1 integer
---@param param_2 Vector
---@return integer
function Stub.do_damage_grid(ctx, laser, param_1, param_2) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.damage_entities(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.damage(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.update_hitparams(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.update_laser(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.Update(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param Pos Vector
function Stub.Render(ctx, laser, Pos) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.update_circle_laser(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param Pos Vector
---@return boolean
function Stub.RenderShadowLayer(ctx, laser, Pos) end

---@param laser Component.Entity.Laser
---@return Vector[],
function Stub.GetSamples(laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
---@param param_1 Component.Entity
---@param param_2 number
function Stub.do_damage(ctx, laser, param_1, param_2) end

---@param laser Component.Entity.Laser
---@return Vector[],
function Stub.GetNonOptimizedSamples(laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.Interpolate(ctx, laser) end

---@param laser Component.Entity.Laser
---@return boolean
function Stub.CanOverwrite(laser) end

---@param laser Component.Entity.Laser
function Stub.ClearReferences(laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.Remove(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.PostRender(ctx, laser) end

---@param ctx Context.Common
---@param laser Component.Entity.Laser
function Stub.spawn_impact(ctx, laser) end

---@param laser Component.Entity.Laser
function Stub.reset_sprite_scale(laser) end

---@param laser Component.Entity.Laser
---@param scale number
function Stub.SetScale(laser, scale) end

---@param laser Component.Entity.Laser
---@param param_1 boolean
function Stub.update_impact(laser, param_1) end

--endregion

Interface.SetTearFlags = Stub.SetTearFlags
Interface.SetTimeout = Stub.SetTimeout
Interface.SetMaxDistance = Stub.SetMaxDistance
Interface.IsCircleLaser = Stub.IsCircleLaser
Interface.SetDisableFollowParent = Stub.SetDisableFollowParent
Interface.SetHomingType = Stub.SetHomingType
Interface.UnknownLaserBoolSet = Stub.UnknownLaserBoolSet
Interface.GetTimeout = Stub.GetTimeout
Interface.SetDropRNGSeed = Stub.SetDropRNGSeed
Interface.SetOneHit = Stub.SetOneHit
Interface.SetMultidimensionalTouched = Stub.SetMultidimensionalTouched
Interface.SetPrismTouched = Stub.SetPrismTouched
Interface.AddToHitList = Stub.AddToHitList
Interface.GetOneHit = Stub.GetOneHit
Interface.SetShrink = Stub.SetShrink
Interface.GetShrink = Stub.GetShrink
Interface.GetHomingType = Stub.GetHomingType
Interface.GetMaxDistance = Stub.GetMaxDistance
Interface.SetRadius = Stub.SetRadius
Interface.GetRadius = Stub.GetRadius
Interface.SetBlackHpDropChance = Stub.SetBlackHpDropChance
Interface.GetBlackHpDropChance = Stub.GetBlackHpDropChance
Interface.GetMultidimensionalTouched = Stub.GetMultidimensionalTouched
Interface.IsPrismTouched = Stub.IsPrismTouched
Interface.SetParentOffset = Stub.SetParentOffset
Interface.GetEndPoint = Stub.GetEndPoint
Interface.IsSampleLaser = Stub.IsSampleLaser
Interface.Constructor = Stub.Constructor
Interface.Free = Stub.Free
Interface.destructor = Stub.destructor
Interface.is_brimstone_laser = Stub.is_brimstone_laser
Interface.get_hit_entities = Stub.get_hit_entities
Interface.SetAngle = Stub.SetAngle
Interface.GetRenderZ = Stub.GetRenderZ
Interface.BelongsToPlayer = Stub.BelongsToPlayer
Interface.CanDamageEntity = Stub.CanDamageEntity
Interface.get_position_from_distance = Stub.get_position_from_distance
Interface.trigger_collision = Stub.trigger_collision
Interface.calculate_tear_color = Stub.calculate_tear_color
Interface.Copy = Stub.Copy
Interface.ShootAngle = Stub.ShootAngle
Interface.SetActiveRotation = Stub.SetActiveRotation
Interface.RotateToAngle = Stub.RotateToAngle
Interface.ClearLaserSamples = Stub.ClearLaserSamples
Interface.Init = Stub.Init
Interface.play_sound = Stub.play_sound
Interface.CalculateEndPoint = Stub.CalculateEndPoint
Interface.CalculateEndPosition = Stub.CalculateEndPosition
Interface.init_laser = Stub.init_laser
Interface.damage_grid = Stub.damage_grid
Interface.do_damage_grid = Stub.do_damage_grid
Interface.damage_entities = Stub.damage_entities
Interface.damage = Stub.damage
Interface.update_hitparams = Stub.update_hitparams
Interface.update_laser = Stub.update_laser
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.update_circle_laser = Stub.update_circle_laser
Interface.RenderShadowLayer = Stub.RenderShadowLayer
Interface.GetSamples = Stub.GetSamples
Interface.do_damage = Stub.do_damage
Interface.GetNonOptimizedSamples = Stub.GetNonOptimizedSamples
Interface.Interpolate = Stub.Interpolate
Interface.CanOverwrite = Stub.CanOverwrite
Interface.ClearReferences = Stub.ClearReferences
Interface.Remove = Stub.Remove
Interface.PostRender = Stub.PostRender
Interface.spawn_impact = Stub.spawn_impact
Interface.reset_sprite_scale = Stub.reset_sprite_scale
Interface.SetScale = Stub.SetScale
Interface.update_impact = Stub.update_impact