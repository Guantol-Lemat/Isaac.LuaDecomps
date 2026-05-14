---@class Interface.Entity
local Interface = require("Isaac.Interface.Entity")

--#region Stub

local Stub = {}

---@param entity Component.Entity
---@return EntityType | integer
function Stub.GetType(entity) end

---@param entity Component.Entity
---@return integer
function Stub.GetVariant(entity) end

---@param entity Component.Entity
---@return integer
function Stub.GetSubType(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetPosition(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetPreUpdatePosition(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetVelocity(entity) end

---@param entity Component.Entity
---@param Offset Vector
function Stub.SetPositionOffset(entity, Offset) end

---@param entity Component.Entity
---@return Vector
function Stub.GetPositionOffset(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetSpriteScale(entity) end

---@param entity Component.Entity
---@return number
function Stub.GetSize(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetSizeMulti(entity) end

---@param entity Component.Entity
---@return number
function Stub.GetMaxHitPoints(entity) end

---@param entity Component.Entity
---@return number
function Stub.GetHitPoints(entity) end

---@param entity Component.Entity
---@return EntityCollisionClass | integer
function Stub.GetEntityCollisionClass(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsPlayer(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsBomb(entity) end

---@param entity Component.Entity
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@return boolean
function Stub.EntityIsTypeVarSubtype(entity, type, variant, subtype) end

---@param entity Component.Entity
---@param l EntityFlags | integer
---@param h EntityFlags | integer
function Stub.AddEntityFlags(entity, l, h) end

---@param entity Component.Entity
---@param flags integer
function Stub.ClearEntityFlags(entity, flags) end

---@param entity Component.Entity
---@return integer
function Stub.GetEntityFlags(entity) end

---@param entity Component.Entity
---@param flagsL EntityFlags | integer
---@param flagsH EntityFlags | integer
---@return boolean
function Stub.HasEntityFlags(entity, flagsL, flagsH) end

---@param entity Component.Entity
---@return boolean
function Stub.Exists(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsDead(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.GetIsVisible(entity) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetSpawnerEntity(entity) end

---@param entity Component.Entity
---@return RNG
function Stub.GetDropRNG(entity) end

---@param entity Component.Entity
---@return EntityType | integer
function Stub.GetSpawnerType(entity) end

---@param entity Component.Entity
---@param Velocity Vector
function Stub.SetVelocity(entity, Velocity) end

---@param entity Component.Entity
---@param velocity Vector
---@param ignoreTimeScale boolean
function Stub.AddVelocity_NoFriction(entity, velocity, ignoreTimeScale) end

---@param entity Component.Entity
---@param velocity Vector
---@param ignoreTimeScale boolean
function Stub.AddVelocity(entity, velocity, ignoreTimeScale) end

---@param entity Component.Entity
---@return number
function Stub.GetMass(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsTear(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsProjectile(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsPickup(entity) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetParent(entity) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetChild(entity) end

---@param entity Component.Entity
---@param SubType integer
function Stub.SetSubType(entity, SubType) end

---@param entity Component.Entity
---@param Position Vector
function Stub.SetPosition(entity, Position) end

---@param entity Component.Entity.Pickup
---@return number
function Stub.GetFriction(entity) end

---@param entity Component.Entity
---@param Scale Vector
function Stub.SetSpriteScale(entity, Scale) end

---@param entity Component.Entity
---@param HitPoints number
function Stub.SetHitPoints(entity, HitPoints) end

---@param entity Component.Entity
---@param HitPoints number
function Stub.SetMaxHitPoints(entity, HitPoints) end

---@param entity Component.Entity
---@param position Vector
function Stub.SetTargetPosition(entity, position) end

---@param entity Component.Entity
---@param Class EntityCollisionClass | integer
function Stub.SetEntityCollisionClass(entity, Class) end

---@param entity Component.Entity
---@return boolean
function Stub.IsFamiliar(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsSlot(entity) end

---@param entity Component.Entity
---@return Sprite
function Stub.GetSprite(entity) end

---@param entity Component.Entity
---@return Component.Entity.Familiar?
function Stub.ToFamiliar(entity) end

---@param entity Component.Entity
---@return Component.Entity.Laser?
function Stub.ToLaser(entity) end

---@param entity Component.Entity
---@return Component.Entity.Npc?
function Stub.ToNPC(entity) end

---@param entity Component.Entity
---@return Component.Entity.Pickup?
function Stub.ToPickup(entity) end

---@param entity Component.Entity
---@return Component.Entity.Tear?
function Stub.ToTear(entity) end

---@param entity Component.Entity
---@param Rotation number
function Stub.SetSpriteRotation(entity, Rotation) end

---@param entity Component.Entity
---@param Offset integer
function Stub.SetRenderZOffset(entity, Offset) end

---@param entity Component.Entity
---@return EntityGridCollisionClass | integer
function Stub.GetGridCollisionClass(entity) end

---@param entity Component.Entity
function Stub.Die(entity) end

---@param entity Component.Entity
---@param Mass number
function Stub.SetMass(entity, Mass) end

---@param entity Component.Entity
---@param Value boolean
function Stub.SetIsVisible(entity, Value) end

---@param entity Component.Entity
---@param Class EntityGridCollisionClass | integer
function Stub.SetGridCollisionClass(entity, Class) end

---@param entity Component.Entity
---@param Type EntityType | integer
function Stub.SetSpawnerType(entity, Type) end

---@param entity Component.Entity
---@param Color Color
function Stub.SetSplatColor(entity, Color) end

---@param entity Component.Entity
---@param Offset Vector
function Stub.SetSpriteOffset(entity, Offset) end

---@param entity Component.Entity
---@return integer
function Stub.GetIndex(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsFriendly(entity) end

---@param entity Component.Entity
---@return Component.Entity.Player?
function Stub.ToPlayer(entity) end

---@param entity Component.Entity
---@return Component.Entity.Effect?
function Stub.ToEffect(entity) end

---@param entity Component.Entity
---@return number
function Stub.GetLocalFrame(entity) end

---@param entity Component.Entity
---@return number
function Stub.GetFrameDelta(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetTargetPosition(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsEffect(entity) end

---@param entity Component.Entity
---@return Component.Entity.Projectile?
function Stub.ToProjectile(entity) end

---@param entity Component.Entity
---@param Variant integer
function Stub.SetSpawnerVariant(entity, Variant) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetTarget(entity) end

---@param entity Component.Entity
---@param param_2 number
function Stub.SetFriction(entity, param_2) end

---@param entity Component.Entity
---@return number
function Stub.GetTimeScale(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsKnife(entity) end

---@param entity Component.Entity
---@return Color
function Stub.GetSplatColor(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.HasMinecart(entity) end

---@param ctx Context.Common
---@param pos Vector
---@param resDistance number
---@param hasDamageFlag boolean
---@return Component.Entity
function Stub.FindClosestBishop(ctx, pos, resDistance, hasDamageFlag) end

---@param entity Component.Entity
---@return Color
function Stub.GetColor(entity) end

---@param entity Component.Entity
---@return integer
function Stub.GetInitSeed(entity) end

---@param entity Component.Entity
---@return SortingLayer | integer
function Stub.GetSortingLayer(entity) end

---@param entity Component.Entity
---@param value number
function Stub.MultiplyFriction(entity, value) end

---@param entity Component.Entity
---@return number
function Stub.GetCollisionDamage(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsInvincible(entity) end

---@param entity Component.Entity
---@return integer
function Stub.GetDropSeed(entity) end

---@param entity Component.Entity
---@param param_1 number
function Stub.SetCollisionDamage(entity, param_1) end

---@param entity Component.Entity
---@return Component.Entity.Knife?
function Stub.ToKnife(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.CollidesWithGrid(entity) end

---@param dir Vector
---@return Direction | integer
function Stub.get_movement_direction_vector(dir) end

---@param entity Component.Entity
function Stub.constructor(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param param_1 integer
---@return Component.Entity
function Stub.destructor(ctx, entity, param_1) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetLastParent(entity) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetLastChild(entity) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetLastSpawner(entity) end

---@param entity Component.Entity
---@return Component.Entity
function Stub.GetStatusEffectTarget(entity) end

---@param entity Component.Entity
function Stub.UpdateChildStatusEffects(entity) end

---@param entity Component.Entity
---@param other Component.Entity
---@return boolean
function Stub.HasCommonParentWithEntity(entity, other) end

---@param entity Component.Entity
---@param param_1 Component.Entity
---@return boolean
function Stub.IsEntityConnected(entity, param_1) end

---@param entity Component.Entity
---@return boolean
function Stub.DoesEntityShareStatus(entity) end

---@param entity Component.Entity
---@param param_1 Component.Entity
---@return boolean
function Stub.IsValidTarget(entity, param_1) end

---@param entity Component.Entity
---@param unused Component.Entity
---@return boolean
function Stub.CanInstakillOnBossDeath(entity, unused) end

---@param entity Component.Entity
---@return boolean
function Stub.CanDevolve(entity) end

---@param entityPtr Component.EntityPtr
---@param entity Component.Entity?
function Stub.set_entity_ref(entityPtr, entity) end

---@param entity Component.Entity
---@param Parent Component.Entity?
function Stub.SetParent(entity, Parent) end

---@param entity Component.Entity
---@param Child Component.Entity?
function Stub.SetChild(entity, Child) end

---@param entity Component.Entity
---@param Target Component.Entity?
function Stub.SetTarget(entity, Target) end

---@param entity Component.Entity
---@param Spawner Component.Entity?
function Stub.SetSpawnerEntity(entity, Spawner) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param type EntityType | integer
---@param variant integer
---@param subtype integer
---@param initSeed integer
function Stub.Init(ctx, entity, type, variant, subtype, initSeed) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.load_entity_config(ctx, entity) end

---@param entity Component.Entity
---@param offset_qqq Vector
---@return Component.Capsule
function Stub.GetCollisionCapsule(entity, offset_qqq) end

---@param ctx Context.Common
---@param entity Component.Entity
---@return integer
function Stub.GetFrameCount(ctx, entity) end

---@param entity Component.Entity
---@return boolean
function Stub.HasFullHealth(entity) end

---@param entity Component.Entity
---@param HitPoints number
function Stub.AddHealth(entity, HitPoints) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param interpolate boolean
function Stub.CollideWithGrid(ctx, entity, interpolate) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param pos Vector
---@return boolean
function Stub.WillPlayerCollideWithGrid(ctx, entity, pos) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param forceNoCollide boolean
function Stub.PlayerCollideWithGrid(ctx, entity, forceNoCollide) end

---@param entity Component.Entity
---@param size number
---@param sizeMulti Vector
---@param numGridCollisionPoints integer
function Stub.SetSize(entity, size, sizeMulti, numGridCollisionPoints) end

---@param entity Component.Entity
---@return boolean
function Stub.IsEnemy(entity) end

---@param entity Component.Entity
---@param targetee_qqq Component.Entity?
---@return boolean
function Stub.IsVulnerableEnemy(entity, targetee_qqq) end

---@param entity Component.Entity
---@return boolean
function Stub.IsObstacle(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.IsFlying(entity) end

---@param entity Component.Entity
function Stub.reset_color(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param Frame integer
---@param Offset integer
---@return boolean
function Stub.IsFrame(ctx, entity, Frame, Offset) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param frame number
---@param offset number
---@return integer
function Stub.IsTimeScaledFrame(ctx, entity, frame, offset) end

---@param entity Component.Entity
---@return Direction | integer
function Stub.get_movement_direction_velocity(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.Kill(ctx, entity) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.Remove(ctx, entity) end

---@param entity Component.Entity
function Stub.ClearReferences(entity) end

---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@return boolean
function Stub.IgnoreEffectFromFriendly(entity, source) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param Damage number
---@param DamageFlagsL DamageFlags | integer
---@param DamageFlagsH DamageFlags | integer
---@param Source Component.Entity.EntityRef
---@param DamageCountdown integer
---@return boolean
function Stub.TakeDamage(ctx, entity, Damage, DamageFlagsL, DamageFlagsH, Source, DamageCountdown) end

---@param entity Component.Entity
---@return boolean
function Stub.HasMortalDamage(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param intDuration integer
---@param Source Component.Entity.EntityRef
---@return integer
function Stub.compute_status_effect_duration(ctx, entity, intDuration, Source) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@param duration integer
function Stub.AddFreeze(ctx, entity, source, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param Source Component.Entity.EntityRef
---@param Duration integer
---@param Damage number
function Stub.AddPoison(ctx, entity, Source, Duration, Damage) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@param duration integer
---@param amount number
---@param slowColor Color
function Stub.AddSlowing(ctx, entity, source, duration, amount, slowColor) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param sourceEntity Component.Entity.EntityRef
---@param duration integer
function Stub.AddCharmed(ctx, entity, sourceEntity, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@param duration integer
---@param ignoreBosses boolean
function Stub.AddConfusion(ctx, entity, source, duration, ignoreBosses) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@param duration integer
function Stub.AddMidasFreeze(ctx, entity, source, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@param duration integer
function Stub.AddFear(ctx, entity, source, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param source Component.Entity.EntityRef
---@param duration integer
---@param damage number
function Stub.AddBurn(ctx, entity, source, duration, damage) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param duration integer
function Stub.AddBleeding(ctx, entity, ref, duration) end

---@param entity Component.Entity
function Stub.RemoveStatusEffects(entity) end

---@param entity Component.Entity
function Stub.PreUpdate(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.Update(ctx, entity) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.Interpolate(ctx, entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@return integer
function Stub.GetRenderZ(ctx, entity) end

---@param entity Component.Entity
---@return boolean
function Stub.CanOverwrite(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param offset Vector
function Stub.Render(ctx, entity, offset) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.PostRender(ctx, entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param offset Vector
---@return boolean
function Stub.RenderShadowLayer(ctx, entity, offset) end

---@param ctx Context.Common
---@param entity Component.Entity.Player
---@param collider Component.Entity
---@return number
function Stub.get_collision_mass(ctx, entity, collider) end

---@param entity Component.Entity
---@return boolean
function Stub.should_ignore_collision(entity) end

---@param param_1 Component.Entity
---@param param_2 Component.Entity
---@return boolean
function Stub.handle_collisions(param_1, param_2) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param collider Component.Entity
---@return boolean
function Stub.collide_capsules(ctx, entity, collider) end

---@param ctx Context.Common
---@param param_1 Component.Entity
---@param param_2 Component.Entity
---@return boolean
function Stub.collide_circles(ctx, param_1, param_2) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param collider Component.Entity
function Stub.Collide(ctx, entity, collider) end

---@param param_1_00 Component.Entity
---@param param_2 Component.Entity
---@param param_3 boolean
---@return boolean
function Stub.ForceCollide(param_1_00, param_2, param_3) end

---@param entity Component.Entity
---@param color Color
---@param Duration integer
---@param Priority integer
---@param Fadeout boolean
---@param Shared boolean
function Stub.SetColor(entity, color, Duration, Priority, Fadeout, Shared) end

---@param ctx Context.Common
---@param pos Vector
---@param count integer
---@param flags GibFlag | integer
---@param offsetMult_qqq number
---@param spawner Component.Entity
---@param color Color
---@param velocity Vector
---@param velocityMult_qqq number
function Stub.SpawnGibs(ctx, pos, count, flags, offsetMult_qqq, spawner, color, velocity, velocityMult_qqq) end

---@param ctx Context.Common
---@param entity Component.Entity
function Stub.BloodExplode(ctx, entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param param_1 boolean
function Stub.TeleportToRandomPosition(ctx, entity, param_1) end

---@param entity Component.Entity
---@param includeDead boolean
---@return boolean
function Stub.IsActiveEnemy(entity, includeDead) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param duration integer
function Stub.AddShrink(ctx, entity, ref, duration) end

---@param entity Component.Entity
---@param param_1 integer
---@param param_2 Vector
function Stub.SetStop(entity, param_1, param_2) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param param_1 unknown
---@return unknown
function Stub.GetData(ctx, entity, param_1) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param param_1 boolean
---@return Component.DebugRenderer.Shape
function Stub.GetDebugShape(ctx, entity, param_1) end

---@param entity Component.Entity
function Stub.ShrinkEnd(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param pos Vector
---@return GridCollisionClass | integer
function Stub.get_special_grid_collision(ctx, entity, pos) end

---@param entity Component.Entity
---@return unknown
function Stub.get_hit_list_index(entity) end

---@param entity Component.Entity
---@return Vector
function Stub.GetForwardVector(entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param Size number
---@return Component.Entity.Effect
function Stub.make_splat(ctx, entity, Size) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param param_2 Vector
---@param param_3 Color
---@param param_4 number
---@return Component.Entity.Effect
function Stub.make_ground_poof(ctx, entity, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param param_2 Vector
---@param param_3 Color
---@param param_4 number
---@return Component.Entity
function Stub.make_blood_poof(ctx, entity, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param entity Component.Entity.Npc
---@param param_2 Color
---@param Scale number
function Stub.make_blood_poof_wrapper(ctx, entity, param_2, Scale) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param Position Vector
---@param Color Color
---@return Component.Entity.Effect
function Stub.make_blood_cloud(ctx, entity, Position, Color) end

---@param ctx Context.Common
---@param pos Vector
---@param velocity Vector
---@param strength number
---@return Component.Entity.Effect
function Stub.do_ground_impact_effects(ctx, pos, velocity, strength) end

---@param entity Component.Entity
---@param nullLayerName string
---@return Vector
function Stub.get_null_offset(entity, nullLayerName) end

---@param entity Component.Entity
---@param nullLayerName string
---@return Component.Capsule
function Stub.get_null_capsule(entity, nullLayerName) end

---@param entity Component.Entity
function Stub.apply_null_transform(entity) end

---@param entity Component.Entity
---@param target Component.Entity
---@param multiplier number
---@return Vector
function Stub.get_predicted_target_pos(entity, target, multiplier) end

---@param ctx Context.Common
---@param entity Component.Entity
---@return Component.WaterClipInfo
function Stub.GetWaterClipInfo(ctx, entity) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param duration integer
function Stub.AddMagnetized(ctx, entity, ref, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param duration integer
function Stub.AddBaited(ctx, entity, ref, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param Source Component.Entity.EntityRef
---@param inlinedDuration integer
function Stub.AddWeakness(ctx, entity, Source, inlinedDuration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param duration integer
function Stub.AddBrimstoneMark(ctx, entity, ref, duration) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param duration integer
function Stub.AddIce(ctx, entity, ref, duration) end

---@param entity Component.Entity
---@param ref Component.Entity.EntityRef
---@param pushDirection Vector
---@param duration integer
---@param takeImpactDamage boolean
function Stub.AddKnockback(entity, ref, pushDirection, duration, takeImpactDamage) end

---@param ctx Context.Common
---@param entity Component.Entity
---@param pos Vector
---@param vel Vector
---@return Component.Entity.Minecart
function Stub.GiveMinecart(ctx, entity, pos, vel) end

---@param entity Component.Entity
---@return BossType | integer
function Stub.GetBossID(entity) end

---@param entity Component.Entity
---@return boolean
function Stub.GetFlipX(entity) end

---@param entity Component.Entity
---@param animationName string
---@param frameNum integer
function Stub.SetSpriteFrame(entity, animationName, frameNum) end

---@param entity Component.Entity
---@param FrameNum string
---@param param_2 number
function Stub.SetSpriteOverlayFrame(entity, FrameNum, param_2) end

---@param entity Component.Entity
---@return boolean
function Stub.CanShutDoors(entity) end

--endregion

Interface.GetType = Stub.GetType
Interface.GetVariant = Stub.GetVariant
Interface.GetSubType = Stub.GetSubType
Interface.GetPosition = Stub.GetPosition
Interface.GetPreUpdatePosition = Stub.GetPreUpdatePosition
Interface.GetVelocity = Stub.GetVelocity
Interface.SetPositionOffset = Stub.SetPositionOffset
Interface.GetPositionOffset = Stub.GetPositionOffset
Interface.GetSpriteScale = Stub.GetSpriteScale
Interface.GetSize = Stub.GetSize
Interface.GetSizeMulti = Stub.GetSizeMulti
Interface.GetMaxHitPoints = Stub.GetMaxHitPoints
Interface.GetHitPoints = Stub.GetHitPoints
Interface.GetEntityCollisionClass = Stub.GetEntityCollisionClass
Interface.IsPlayer = Stub.IsPlayer
Interface.IsBomb = Stub.IsBomb
Interface.EntityIsTypeVarSubtype = Stub.EntityIsTypeVarSubtype
Interface.AddEntityFlags = Stub.AddEntityFlags
Interface.ClearEntityFlags = Stub.ClearEntityFlags
Interface.GetEntityFlags = Stub.GetEntityFlags
Interface.HasEntityFlags = Stub.HasEntityFlags
Interface.Exists = Stub.Exists
Interface.IsDead = Stub.IsDead
Interface.GetIsVisible = Stub.GetIsVisible
Interface.GetSpawnerEntity = Stub.GetSpawnerEntity
Interface.GetDropRNG = Stub.GetDropRNG
Interface.GetSpawnerType = Stub.GetSpawnerType
Interface.SetVelocity = Stub.SetVelocity
Interface.AddVelocity_NoFriction = Stub.AddVelocity_NoFriction
Interface.AddVelocity = Stub.AddVelocity
Interface.GetMass = Stub.GetMass
Interface.IsTear = Stub.IsTear
Interface.IsProjectile = Stub.IsProjectile
Interface.IsPickup = Stub.IsPickup
Interface.GetParent = Stub.GetParent
Interface.GetChild = Stub.GetChild
Interface.SetSubType = Stub.SetSubType
Interface.SetPosition = Stub.SetPosition
Interface.GetFriction = Stub.GetFriction
Interface.SetSpriteScale = Stub.SetSpriteScale
Interface.SetHitPoints = Stub.SetHitPoints
Interface.SetMaxHitPoints = Stub.SetMaxHitPoints
Interface.SetTargetPosition = Stub.SetTargetPosition
Interface.SetEntityCollisionClass = Stub.SetEntityCollisionClass
Interface.IsFamiliar = Stub.IsFamiliar
Interface.IsSlot = Stub.IsSlot
Interface.GetSprite = Stub.GetSprite
Interface.ToFamiliar = Stub.ToFamiliar
Interface.ToLaser = Stub.ToLaser
Interface.ToNPC = Stub.ToNPC
Interface.ToPickup = Stub.ToPickup
Interface.ToTear = Stub.ToTear
Interface.SetSpriteRotation = Stub.SetSpriteRotation
Interface.SetRenderZOffset = Stub.SetRenderZOffset
Interface.GetGridCollisionClass = Stub.GetGridCollisionClass
Interface.Die = Stub.Die
Interface.SetMass = Stub.SetMass
Interface.SetIsVisible = Stub.SetIsVisible
Interface.SetGridCollisionClass = Stub.SetGridCollisionClass
Interface.SetSpawnerType = Stub.SetSpawnerType
Interface.SetSplatColor = Stub.SetSplatColor
Interface.SetSpriteOffset = Stub.SetSpriteOffset
Interface.GetIndex = Stub.GetIndex
Interface.IsFriendly = Stub.IsFriendly
Interface.ToPlayer = Stub.ToPlayer
Interface.ToEffect = Stub.ToEffect
Interface.GetLocalFrame = Stub.GetLocalFrame
Interface.GetFrameDelta = Stub.GetFrameDelta
Interface.GetTargetPosition = Stub.GetTargetPosition
Interface.IsEffect = Stub.IsEffect
Interface.ToProjectile = Stub.ToProjectile
Interface.SetSpawnerVariant = Stub.SetSpawnerVariant
Interface.GetTarget = Stub.GetTarget
Interface.SetFriction = Stub.SetFriction
Interface.GetTimeScale = Stub.GetTimeScale
Interface.IsKnife = Stub.IsKnife
Interface.GetSplatColor = Stub.GetSplatColor
Interface.HasMinecart = Stub.HasMinecart
Interface.FindClosestBishop = Stub.FindClosestBishop
Interface.GetColor = Stub.GetColor
Interface.GetInitSeed = Stub.GetInitSeed
Interface.GetSortingLayer = Stub.GetSortingLayer
Interface.MultiplyFriction = Stub.MultiplyFriction
Interface.GetCollisionDamage = Stub.GetCollisionDamage
Interface.IsInvincible = Stub.IsInvincible
Interface.GetDropSeed = Stub.GetDropSeed
Interface.SetCollisionDamage = Stub.SetCollisionDamage
Interface.ToKnife = Stub.ToKnife
Interface.CollidesWithGrid = Stub.CollidesWithGrid
Interface.get_movement_direction_vector = Stub.get_movement_direction_vector
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.GetLastParent = Stub.GetLastParent
Interface.GetLastChild = Stub.GetLastChild
Interface.GetLastSpawner = Stub.GetLastSpawner
Interface.GetStatusEffectTarget = Stub.GetStatusEffectTarget
Interface.UpdateChildStatusEffects = Stub.UpdateChildStatusEffects
Interface.HasCommonParentWithEntity = Stub.HasCommonParentWithEntity
Interface.IsEntityConnected = Stub.IsEntityConnected
Interface.DoesEntityShareStatus = Stub.DoesEntityShareStatus
Interface.IsValidTarget = Stub.IsValidTarget
Interface.CanInstakillOnBossDeath = Stub.CanInstakillOnBossDeath
Interface.CanDevolve = Stub.CanDevolve
Interface.set_entity_ref = Stub.set_entity_ref
Interface.SetParent = Stub.SetParent
Interface.SetChild = Stub.SetChild
Interface.SetTarget = Stub.SetTarget
Interface.SetSpawnerEntity = Stub.SetSpawnerEntity
Interface.Init = Stub.Init
Interface.load_entity_config = Stub.load_entity_config
Interface.GetCollisionCapsule = Stub.GetCollisionCapsule
Interface.GetFrameCount = Stub.GetFrameCount
Interface.HasFullHealth = Stub.HasFullHealth
Interface.AddHealth = Stub.AddHealth
Interface.CollideWithGrid = Stub.CollideWithGrid
Interface.WillPlayerCollideWithGrid = Stub.WillPlayerCollideWithGrid
Interface.PlayerCollideWithGrid = Stub.PlayerCollideWithGrid
Interface.SetSize = Stub.SetSize
Interface.IsEnemy = Stub.IsEnemy
Interface.IsVulnerableEnemy = Stub.IsVulnerableEnemy
Interface.IsObstacle = Stub.IsObstacle
Interface.IsFlying = Stub.IsFlying
Interface.reset_color = Stub.reset_color
Interface.IsFrame = Stub.IsFrame
Interface.IsTimeScaledFrame = Stub.IsTimeScaledFrame
Interface.get_movement_direction_velocity = Stub.get_movement_direction_velocity
Interface.Kill = Stub.Kill
Interface.Remove = Stub.Remove
Interface.ClearReferences = Stub.ClearReferences
Interface.IgnoreEffectFromFriendly = Stub.IgnoreEffectFromFriendly
Interface.TakeDamage = Stub.TakeDamage
Interface.HasMortalDamage = Stub.HasMortalDamage
Interface.compute_status_effect_duration = Stub.compute_status_effect_duration
Interface.AddFreeze = Stub.AddFreeze
Interface.AddPoison = Stub.AddPoison
Interface.AddSlowing = Stub.AddSlowing
Interface.AddCharmed = Stub.AddCharmed
Interface.AddConfusion = Stub.AddConfusion
Interface.AddMidasFreeze = Stub.AddMidasFreeze
Interface.AddFear = Stub.AddFear
Interface.AddBurn = Stub.AddBurn
Interface.AddBleeding = Stub.AddBleeding
Interface.RemoveStatusEffects = Stub.RemoveStatusEffects
Interface.PreUpdate = Stub.PreUpdate
Interface.Update = Stub.Update
Interface.Interpolate = Stub.Interpolate
Interface.GetRenderZ = Stub.GetRenderZ
Interface.CanOverwrite = Stub.CanOverwrite
Interface.Render = Stub.Render
Interface.PostRender = Stub.PostRender
Interface.RenderShadowLayer = Stub.RenderShadowLayer
Interface.get_collision_mass = Stub.get_collision_mass
Interface.should_ignore_collision = Stub.should_ignore_collision
Interface.handle_collisions = Stub.handle_collisions
Interface.collide_capsules = Stub.collide_capsules
Interface.collide_circles = Stub.collide_circles
Interface.Collide = Stub.Collide
Interface.ForceCollide = Stub.ForceCollide
Interface.SetColor = Stub.SetColor
Interface.SpawnGibs = Stub.SpawnGibs
Interface.BloodExplode = Stub.BloodExplode
Interface.TeleportToRandomPosition = Stub.TeleportToRandomPosition
Interface.IsActiveEnemy = Stub.IsActiveEnemy
Interface.AddShrink = Stub.AddShrink
Interface.SetStop = Stub.SetStop
Interface.GetData = Stub.GetData
Interface.GetDebugShape = Stub.GetDebugShape
Interface.ShrinkEnd = Stub.ShrinkEnd
Interface.get_special_grid_collision = Stub.get_special_grid_collision
Interface.get_hit_list_index = Stub.get_hit_list_index
Interface.GetForwardVector = Stub.GetForwardVector
Interface.make_splat = Stub.make_splat
Interface.make_ground_poof = Stub.make_ground_poof
Interface.make_blood_poof = Stub.make_blood_poof
Interface.make_blood_poof_wrapper = Stub.make_blood_poof_wrapper
Interface.make_blood_cloud = Stub.make_blood_cloud
Interface.do_ground_impact_effects = Stub.do_ground_impact_effects
Interface.get_null_offset = Stub.get_null_offset
Interface.get_null_capsule = Stub.get_null_capsule
Interface.apply_null_transform = Stub.apply_null_transform
Interface.get_predicted_target_pos = Stub.get_predicted_target_pos
Interface.GetWaterClipInfo = Stub.GetWaterClipInfo
Interface.AddMagnetized = Stub.AddMagnetized
Interface.AddBaited = Stub.AddBaited
Interface.AddWeakness = Stub.AddWeakness
Interface.AddBrimstoneMark = Stub.AddBrimstoneMark
Interface.AddIce = Stub.AddIce
Interface.AddKnockback = Stub.AddKnockback
Interface.GiveMinecart = Stub.GiveMinecart
Interface.GetBossID = Stub.GetBossID
Interface.GetFlipX = Stub.GetFlipX
Interface.SetSpriteFrame = Stub.SetSpriteFrame
Interface.SetSpriteOverlayFrame = Stub.SetSpriteOverlayFrame
Interface.CanShutDoors = Stub.CanShutDoors