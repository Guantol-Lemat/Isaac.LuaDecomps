---@class Inreface.Entity_NPC
local Interface = require("Isaac.Interface.Entity_NPC")

--#region Stub

local Stub = {}

---@param flags GibFlag | integer
---@param pos integer
---@return boolean
function Stub.HasGibFlags(flags, pos) end

---@param npc Component.Entity.Npc
---@param Value boolean
function Stub.SetCanShutDoors(npc, Value) end

---@param npc Component.Entity.Npc
---@param param_1 integer
function Stub.SetState(npc, param_1) end

---@param npc Component.Entity.Npc
---@return NpcState | integer
function Stub.GetState(npc) end

---@param npc Component.Entity.Npc
---@return Component.Entity.Npc
function Stub.GetParentNPC(npc) end

---@param npc Component.Entity.Npc
---@return number
function Stub.GetScale(npc) end

---@param npc Component.Entity.Npc
---@return Component.Entity.Npc
function Stub.GetChildNPC(npc) end

---@param ctx Context.Common
---@param anm2 Sprite
---@param type EntityType | integer
---@param variant integer
---@param reload boolean
function Stub.DeliriumReplaceGraphics(ctx, anm2, type, variant, reload) end

---@param npc Component.Entity.Npc
---@param param_1 Component.Entity
---@return boolean
function Stub.RequestLock(npc, param_1) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 integer
---@param param_2 integer
function Stub.fire_moms_heart_projectiles(ctx, npc, param_1, param_2) end

---@param ctx Context.Common
---@param pos Vector
---@param targetPos Vector
---@param velocity Vector
---@param yOffset number
---@return Component.Entity.Npc
function Stub.ThrowMaggotAtPos(ctx, pos, targetPos, velocity, yOffset) end

---@param ctx Context.Common
---@param Pos Vector
---@param yOffset number
---@param Velocity Vector
---@param fallSpeed_qqq number
---@return Component.Entity.Npc
function Stub.ThrowMaggot(ctx, Pos, yOffset, Velocity, fallSpeed_qqq) end

---@param ctx Context.Common
---@param Position Vector
---@param yOffset number
---@param targetPos Vector
---@param fallingSpeed number
---@return Component.Entity.Npc
function Stub.ShootMaggotProjectile(ctx, Position, yOffset, targetPos, fallingSpeed) end

---@param npc Component.Entity.Npc
---@return Component.Entity.EntityRef
function Stub.GetEntityRef(npc) end

---@param ctx Context.Common
---@param pos Vector
---@param velocity Vector
---@param spawner Component.Entity
---@param variant_qqq integer
---@param posOffset number
---@return Component.Entity.Npc
function Stub.ThrowRockSpider(ctx, pos, velocity, spawner, variant_qqq, posOffset) end

---@param color Component.EntityConfig.ChampionColor
---@param ret Color
function Stub.GetChampionColor(color, ret) end

---@param ctx Context.Common
---@param pos Vector
---@param target Vector
---@param gridIdx integer
---@return integer
function Stub.find_target_pit(ctx, pos, target, gridIdx) end

---@param ctx Context.Common
---@param param_1_00 Vector
---@param param_2 Component.Entity
---@param param_3 boolean
---@return Component.Entity.Npc
function Stub.SpawnWillo(ctx, param_1_00, param_2, param_3) end

---@param ctx Context.Common
---@param pos Vector
---@param spawner Component.Entity
---@param yOffset number
---@param param_4 Vector
---@param subtype boolean
---@return Component.Entity.Npc
function Stub.ThrowLeech(ctx, pos, spawner, yOffset, param_4, subtype) end

---@param ctx Context.Common
---@param Position Vector
---@param Spawner Component.Entity
---@param TargetPos Vector
---@return Component.Entity.Npc
function Stub.ThrowStrider(ctx, Position, Spawner, TargetPos) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.fissure_update_offsets(ctx, npc) end

---@param npc Component.Entity.Npc
---@param param_1 Component.Entity.Familiar
function Stub.handle_familiar_movement(npc, param_1) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.create_bling(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param count integer
function Stub.create_gold_particles(ctx, npc, count) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 Component.Entity
---@param param_2 boolean
function Stub.visage_on_collide(ctx, npc, param_1, param_2) end

---@param npc Component.Entity.Npc
---@param param_1_00 integer
function Stub.SetControllerIndex(npc, param_1_00) end

---@param npc Component.Entity.Npc
---@return integer
function Stub.GetChampionColorIdx(npc) end

---@param npc Component.Entity.Npc
function Stub.ResetPathFinderTarget(npc) end

---@param npc Component.Entity.Npc
---@return boolean
function Stub.CanShutDoors(npc) end

---@param npc Component.Entity.Npc
---@return boolean
function Stub.IsBoss(npc) end

---@param npc Component.Entity.Npc
---@return boolean
function Stub.IsChampion(npc) end

---@param npc Component.Entity.Npc
---@return Component.Entity.Npc
function Stub.Constructor(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.Free(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.destructor(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 integer
---@param param_2 integer
---@param param_3 integer
---@param param_4 integer
function Stub.Init(ctx, npc, param_1, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.Remove(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.ClearReferences(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Pos Vector
---@param Margin number
---@return boolean
function Stub.CheckPlayerProximity(ctx, npc, Pos, Margin) end

---@param npc Component.Entity.Npc
---@param target Component.Entity
---@param duration_qqq integer
---@return boolean
function Stub.TryForceTarget(npc, target, duration_qqq) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@return number
function Stub.get_time_scale(ctx, npc) end

---@param ctx Context.Common
---@param param_1_00 string
---@param param_2_00 string
---@param param_3 string
---@param param_4 string
---@param param_5 boolean
function Stub.translate_gfx_path_hell(ctx, param_1_00, param_2_00, param_3, param_4, param_5) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param retString string
---@param inputString string
function Stub.translate_gfx_path(ctx, npc, retString, inputString) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param string string
---@return boolean
function Stub.try_load_alt_anim(ctx, npc, string) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Init_qqq boolean
function Stub.load_graphics(ctx, npc, Init_qqq) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.load_entity_config(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.deathspawn_kill(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.Kill(ctx, npc) end

---@param npc Component.Entity.Npc
function Stub.KillUnique(npc) end

---@param npc Component.Entity.Npc
---@param param_1 Component.Entity
---@return boolean
function Stub.IsHostileTarget(npc, param_1) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@return Component.Entity
function Stub.GetPlayerTarget(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param DistanceLimit number
---@return Vector
function Stub.CalcTargetPosition(ctx, npc, DistanceLimit) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.deathspawn_champion(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param immediate boolean
function Stub.update_dirt_color(ctx, npc, immediate) end

---@param ctx Context.Common
---@param EntityType EntityType | integer
---@param EntityVariant integer
---@return boolean
function Stub.Redirect(ctx, EntityType, EntityVariant) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param EntityType EntityType | integer
---@param Variant integer
---@param Subtype integer
---@param ChampionId ChampionColor | integer
---@return boolean
function Stub.Morph(ctx, npc, EntityType, Variant, Subtype, ChampionId) end

---@param npc Component.Entity.Npc
function Stub.reset_color(npc) end

---@param npc Component.Entity.Npc
---@param HorizontalAnim string
---@param VerticalAnim string
---@param SpeedThreshold number
function Stub.anim_walkframe_HorizVert(npc, HorizontalAnim, VerticalAnim, SpeedThreshold) end

---@param npc Component.Entity.Npc
---@param HorizontalAnim string
---@param UpAnim string
---@param DownAnim string
---@param SpeedThreshold number
function Stub.anim_walkframe_UpDown(npc, HorizontalAnim, UpAnim, DownAnim, SpeedThreshold) end

---@param npc Component.Entity.Npc
---@param LeftAnim string
---@param RightAnim string
---@param UpAnim string
---@param DownAnim string
---@param SpeedThreshold number
function Stub.anim_walkframe_Cardinal(npc, LeftAnim, RightAnim, UpAnim, DownAnim, SpeedThreshold) end

---@param ctx Context.Common
---@param Position Vector
---@param Spawner Component.Entity
---@param TargetPos Vector
---@param Big boolean
---@param yOffset number
---@return Component.Entity.Npc
function Stub.ThrowSpider(ctx, Position, Spawner, TargetPos, Big, yOffset) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.update_ai(ctx, npc) end

---@param npc Component.Entity.Npc
---@return boolean
function Stub.IsFrozen(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.PreUpdate(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.Update(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.update_frozen(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_2 number
---@param param_3 boolean
---@param param_4 integer
---@return boolean
function Stub.can_shoot_player(ctx, npc, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@param championid ChampionColor | integer
---@param scale number
---@param flags integer
---@param spawner Component.Entity
function Stub.apply_projectile_modifiers(ctx, projectile, championid, scale, flags, spawner) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param projectile Component.Entity.Projectile
function Stub.apply_projectile_modifiers_wrapper(ctx, npc, projectile) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Pos Vector
---@param Velocity Vector
---@param Mode ProjectileMode | integer
---@param Params Component.Npc.ProjectileParams
---@return Component.Entity.Projectile
function Stub.fire_projectiles(ctx, npc, Pos, Velocity, Mode, Params) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param NumProjectiles integer
---@param TargetPos Vector
---@param TrajectoryModifier number
---@param Params Component.Npc.ProjectileParams
---@return Component.Entity.Projectile
function Stub.fire_boss_projectiles(ctx, npc, NumProjectiles, TargetPos, TrajectoryModifier, Params) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param collider Component.Entity
---@param low boolean
---@return boolean
function Stub.handle_collision(ctx, npc, collider, low) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 integer
function Stub.SetBossColorIdx(ctx, npc, param_1) end

---@param npc Component.Entity.Npc
---@param param_1 Component.Entity.EntityDesc
function Stub.ToEntityDesc(npc, param_1) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Seed integer
---@param ChampionColorIdx ChampionColor | integer
---@param Init boolean
function Stub.MakeChampion(ctx, npc, Seed, ChampionColorIdx, Init) end

---@param npc Component.Entity.Npc
---@param Ref Component.Entity
function Stub.SetEntityRef(npc, Ref) end

---@param ctx Context.Common
---@param Type EntityType | integer
---@param Variant integer
---@return Component.EntityList.EL
function Stub.query_npcs_type(ctx, Type, Variant) end

---@param ctx Context.Common
---@param SpawnerType EntityType | integer
---@param Type EntityType | integer
---@param OnlyEnemies boolean
---@return Component.EntityList.EL
function Stub.query_npcs_spawnertype(ctx, SpawnerType, Type, OnlyEnemies) end

---@param ctx Context.Common
---@param GroupIdx integer
---@return Component.EntityList.EL
function Stub.query_npcs_group(ctx, GroupIdx) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.Interpolate(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Offset Vector
function Stub.Render(ctx, npc, Offset) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 Vector
function Stub.RenderShadowLayer(ctx, npc, param_1) end

---@param npc Component.Entity.Npc
---@return Vector
function Stub.GetForwardVector(npc) end

---@param npc Component.Entity.Npc
---@param Velocity Vector
---@return boolean
function Stub.CanBeDamagedFromVelocity(npc, Velocity) end

---@param npc Component.Entity.Npc
---@return boolean
function Stub.CanReroll(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.spawn_blood_splash(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.trigger_death_remove(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param amount number
---@param flagsL DamageFlags | integer
---@param flagsH DamageFlags | integer
---@param ref Component.Entity.EntityRef
---@param cooldown integer
---@return boolean
function Stub.TakeDamage(ctx, npc, amount, flagsL, flagsH, ref, cooldown) end

---@param npc Component.Entity.Npc
---@param Scale number
function Stub.SetScale(npc, Scale) end

---@param npc Component.Entity.Npc
function Stub.UpdateSpriteShrinkScale(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param ID SoundEffect | integer
---@param Volume number
---@param FrameDelay integer
---@param Loop boolean
---@param Pitch number
function Stub.play_sound(ctx, npc, ID, Volume, FrameDelay, Loop, Pitch) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@return integer
function Stub.get_alive_enemy_count(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.TriggerNewRoom(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.update_spider_mod(ctx, npc) end

---@param npc Component.Entity.Npc
function Stub.update_damage_shield(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 unknown
function Stub.update_death_blood(ctx, npc, param_1) end

---@param ctx Context.Common
---@param subtype integer
---@param pos Vector
---@param offset Vector
---@param color Color
---@param velocity Vector
---@return Component.Entity.Effect
function Stub.MakeBloodEffect(ctx, subtype, pos, offset, color, velocity) end

---@param npc Component.Entity.Npc
---@param Target Component.Entity
---@return boolean
function Stub.IsEnemyTarget(npc, Target) end

---@param npc Component.Entity.Npc
---@param param_2 number
---@param param_3 number
---@param param_4 boolean
function Stub.update_chain_movement(npc, param_2, param_3, param_4) end

---@param npc Component.Entity.Npc
function Stub.clear_extra_entity_refs(npc) end

---@param ctx Context.Common
---@return Difficulty | integer
function Stub.GetDifficulty(ctx) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Action ButtonAction | integer
---@return boolean
function Stub.IsActionPressed(ctx, npc, Action) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param Action ButtonAction | integer
---@return boolean
function Stub.IsActionTriggered(ctx, npc, Action) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param unk number
---@return Vector
function Stub.GetMovementInput(ctx, npc, unk) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param unk2 number
---@return Vector
function Stub.GetShootingInput(ctx, npc, unk2) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 Component.Entity.Npc
function Stub.TransferPlayerControl(ctx, npc, param_1) end

---@param npc Component.Entity.Npc
---@return boolean
function Stub.CanPlayerControl(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_2 unknown
---@param param_3 number
function Stub.ControlCrosshair(ctx, npc, param_2, param_3) end

---@param npc Component.Entity.Npc
function Stub.ClearCrosshair(npc) end

---@param npc Component.Entity.Npc
---@return Vector
function Stub.GetCrosshairPos(npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@return boolean
function Stub.IsCrosshairReleased(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@return boolean
function Stub.IsLocalPlayer(ctx, npc) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_2 boolean
---@param param_3 number
---@param param_4 number
---@param param_5 number
function Stub.SetChargeBar(ctx, npc, param_2, param_3, param_4, param_5) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_2 boolean
function Stub.update_player_aim(ctx, npc, param_2) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_1 boolean
function Stub.update_player_crosshair(ctx, npc, param_1) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param param_2 number
---@param param_3 number
---@param param_4 number
function Stub.player_move_leaping(ctx, npc, param_2, param_3, param_4) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param thrower Component.Entity.EntityRef
---@param velocity Vector
---@param v1Y number
---@return boolean
function Stub.TryThrow(ctx, npc, thrower, velocity, v1Y) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param anm2 Sprite
---@param desc Component.GridEntityDesc
---@param velocity Vector
---@param backdropType BackdropType | integer
---@return Component.Entity.Projectile
function Stub.fire_grid_entity(ctx, npc, anm2, desc, velocity, backdropType) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param defaultDamage number
---@param source Component.Entity.EntityRef
---@param doScreenEffects boolean
---@return boolean
function Stub.TrySplit(ctx, npc, defaultDamage, source, doScreenEffects) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.UpdatePickupGhosts(ctx, npc) end

---@param npc Component.Entity.Npc
---@return integer
function Stub.GetBossColorIdx(npc) end

--endregion

Interface.HasGibFlags = Stub.HasGibFlags
Interface.SetCanShutDoors = Stub.SetCanShutDoors
Interface.SetState = Stub.SetState
Interface.GetState = Stub.GetState
Interface.GetParentNPC = Stub.GetParentNPC
Interface.GetScale = Stub.GetScale
Interface.GetChildNPC = Stub.GetChildNPC
Interface.DeliriumReplaceGraphics = Stub.DeliriumReplaceGraphics
Interface.RequestLock = Stub.RequestLock
Interface.ThrowMaggotAtPos = Stub.ThrowMaggotAtPos
Interface.ThrowMaggot = Stub.ThrowMaggot
Interface.ShootMaggotProjectile = Stub.ShootMaggotProjectile
Interface.GetEntityRef = Stub.GetEntityRef
Interface.ThrowRockSpider = Stub.ThrowRockSpider
Interface.GetChampionColor = Stub.GetChampionColor
Interface.find_target_pit = Stub.find_target_pit
Interface.SpawnWillo = Stub.SpawnWillo
Interface.ThrowLeech = Stub.ThrowLeech
Interface.ThrowStrider = Stub.ThrowStrider
Interface.fissure_update_offsets = Stub.fissure_update_offsets
Interface.handle_familiar_movement = Stub.handle_familiar_movement
Interface.create_bling = Stub.create_bling
Interface.create_gold_particles = Stub.create_gold_particles
Interface.SetControllerIndex = Stub.SetControllerIndex
Interface.GetChampionColorIdx = Stub.GetChampionColorIdx
Interface.ResetPathFinderTarget = Stub.ResetPathFinderTarget
Interface.CanShutDoors = Stub.CanShutDoors
Interface.IsBoss = Stub.IsBoss
Interface.IsChampion = Stub.IsChampion
Interface.Constructor = Stub.Constructor
Interface.Free = Stub.Free
Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.Remove = Stub.Remove
Interface.ClearReferences = Stub.ClearReferences
Interface.CheckPlayerProximity = Stub.CheckPlayerProximity
Interface.TryForceTarget = Stub.TryForceTarget
Interface.get_time_scale = Stub.get_time_scale
Interface.translate_gfx_path_hell = Stub.translate_gfx_path_hell
Interface.translate_gfx_path = Stub.translate_gfx_path
Interface.try_load_alt_anim = Stub.try_load_alt_anim
Interface.load_graphics = Stub.load_graphics
Interface.load_entity_config = Stub.load_entity_config
Interface.deathspawn_kill = Stub.deathspawn_kill
Interface.Kill = Stub.Kill
Interface.KillUnique = Stub.KillUnique
Interface.IsHostileTarget = Stub.IsHostileTarget
Interface.GetPlayerTarget = Stub.GetPlayerTarget
Interface.CalcTargetPosition = Stub.CalcTargetPosition
Interface.deathspawn_champion = Stub.deathspawn_champion
Interface.update_dirt_color = Stub.update_dirt_color
Interface.Redirect = Stub.Redirect
Interface.Morph = Stub.Morph
Interface.reset_color = Stub.reset_color
Interface.anim_walkframe_HorizVert = Stub.anim_walkframe_HorizVert
Interface.anim_walkframe_UpDown = Stub.anim_walkframe_UpDown
Interface.anim_walkframe_Cardinal = Stub.anim_walkframe_Cardinal
Interface.ThrowSpider = Stub.ThrowSpider
Interface.update_ai = Stub.update_ai
Interface.IsFrozen = Stub.IsFrozen
Interface.PreUpdate = Stub.PreUpdate
Interface.Update = Stub.Update
Interface.update_frozen = Stub.update_frozen
Interface.can_shoot_player = Stub.can_shoot_player
Interface.apply_projectile_modifiers = Stub.apply_projectile_modifiers
Interface.apply_projectile_modifiers_wrapper = Stub.apply_projectile_modifiers_wrapper
Interface.fire_projectiles = Stub.fire_projectiles
Interface.fire_boss_projectiles = Stub.fire_boss_projectiles
Interface.handle_collision = Stub.handle_collision
Interface.SetBossColorIdx = Stub.SetBossColorIdx
Interface.ToEntityDesc = Stub.ToEntityDesc
Interface.MakeChampion = Stub.MakeChampion
Interface.SetEntityRef = Stub.SetEntityRef
Interface.query_npcs_type = Stub.query_npcs_type
Interface.query_npcs_spawnertype = Stub.query_npcs_spawnertype
Interface.query_npcs_group = Stub.query_npcs_group
Interface.Interpolate = Stub.Interpolate
Interface.Render = Stub.Render
Interface.RenderShadowLayer = Stub.RenderShadowLayer
Interface.GetForwardVector = Stub.GetForwardVector
Interface.CanBeDamagedFromVelocity = Stub.CanBeDamagedFromVelocity
Interface.CanReroll = Stub.CanReroll
Interface.spawn_blood_splash = Stub.spawn_blood_splash
Interface.trigger_death_remove = Stub.trigger_death_remove
Interface.TakeDamage = Stub.TakeDamage
Interface.SetScale = Stub.SetScale
Interface.UpdateSpriteShrinkScale = Stub.UpdateSpriteShrinkScale
Interface.play_sound = Stub.play_sound
Interface.get_alive_enemy_count = Stub.get_alive_enemy_count
Interface.TriggerNewRoom = Stub.TriggerNewRoom
Interface.update_spider_mod = Stub.update_spider_mod
Interface.update_damage_shield = Stub.update_damage_shield
Interface.update_death_blood = Stub.update_death_blood
Interface.MakeBloodEffect = Stub.MakeBloodEffect
Interface.IsEnemyTarget = Stub.IsEnemyTarget
Interface.update_chain_movement = Stub.update_chain_movement
Interface.clear_extra_entity_refs = Stub.clear_extra_entity_refs
Interface.GetDifficulty = Stub.GetDifficulty
Interface.IsActionPressed = Stub.IsActionPressed
Interface.IsActionTriggered = Stub.IsActionTriggered
Interface.GetMovementInput = Stub.GetMovementInput
Interface.GetShootingInput = Stub.GetShootingInput
Interface.TransferPlayerControl = Stub.TransferPlayerControl
Interface.CanPlayerControl = Stub.CanPlayerControl
Interface.ControlCrosshair = Stub.ControlCrosshair
Interface.ClearCrosshair = Stub.ClearCrosshair
Interface.GetCrosshairPos = Stub.GetCrosshairPos
Interface.IsCrosshairReleased = Stub.IsCrosshairReleased
Interface.IsLocalPlayer = Stub.IsLocalPlayer
Interface.SetChargeBar = Stub.SetChargeBar
Interface.update_player_aim = Stub.update_player_aim
Interface.update_player_crosshair = Stub.update_player_crosshair
Interface.player_move_leaping = Stub.player_move_leaping
Interface.TryThrow = Stub.TryThrow
Interface.fire_grid_entity = Stub.fire_grid_entity
Interface.TrySplit = Stub.TrySplit
Interface.UpdatePickupGhosts = Stub.UpdatePickupGhosts
Interface.GetBossColorIdx = Stub.GetBossColorIdx