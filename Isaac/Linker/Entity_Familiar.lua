---@class Interface.Entity_Familiar
local Interface = require("Isaac.Interface.Entity_Familiar")

--#region Stub

local Stub = {}

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.umbilical_baby_load_graphics(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param offset Vector
---@param mode_qqq integer
function Stub.umbilical_baby_render_cord(ctx, familiar, offset, mode_qqq) end

---@param familiar Component.Entity.Familiar
---@return Component.Entity.Player
function Stub.GetPlayer(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return Component.ItemConfig.Wisp
function Stub.GetWispConfig(ctx, familiar) end

---@param ctx Context.Common
---@param id CollectibleType | integer
---@return Component.ItemConfig.Wisp
function Stub.GetWispConfigForType(ctx, id) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.wisp_init(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.wisp_kill(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 number
---@param param_2 number
function Stub.wisp_fire_projectiles(ctx, familiar, param_1, param_2) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 number
---@param param_2 DamageFlags | integer
---@param param_3 Component.Entity.EntityRef
---@return boolean
function Stub.wisp_take_damage(ctx, familiar, param_1, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 CollectibleType | integer
function Stub.WispMorph(ctx, familiar, param_1) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 RNG
function Stub.WispRerollRandomly(ctx, familiar, param_1) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.WispTrySlash(ctx, familiar) end

---@param ctx Context.Common
---@param param_1 RNG
---@return CollectibleType | integer
function Stub.GetRandomWisp(ctx, param_1) end

---@param familiar Component.Entity.Familiar
---@param Keys_qqq integer
function Stub.SetKeys(familiar, Keys_qqq) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.IsLilDelirium(familiar) end

---@param familiar Component.Entity.Familiar
function Stub.SetUnkWispBool(familiar) end

---@param param_1 Component.Entity.Familiar
---@param param_2 number
function Stub.SetUnkWispHealthRelated(param_1, param_2) end

---@param ctx Context.Common
---@param unusedCollectibleType integer
function Stub.TriggerMegaBeanWispsCrackWave(ctx, unusedCollectibleType) end

---@param familiar Component.Entity.Familiar
---@return integer
function Stub.orbit_getter(familiar) end

---@param familiar Component.Entity.Familiar
---@param param_1_00 Component.ItemConfig.Item
function Stub.SetItemConfig(familiar, param_1_00) end

---@param familiar Component.Entity.Familiar
---@return Component.Entity
function Stub.constructor(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 boolean
function Stub.Free(ctx, familiar, param_1) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.destructor(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return integer
function Stub.GetCollisionInterval(ctx, familiar) end

---@param familiar Component.Entity.Familiar
---@return integer
function Stub.GetRemovePriority(familiar) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.CanBeDamagedByEnemy(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.CanBlockProjectiles(ctx, familiar) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.CanShutDoors(familiar) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.CanCharm(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return number
function Stub.GetMultiplier(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param type EntityType | integer
---@param variant FamiliarVariant | integer
---@param subtype integer
---@param seed integer
function Stub.Init(ctx, familiar, type, variant, subtype, seed) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.Remove(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.Kill(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.ClearReferences(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return Component.Entity
function Stub.get_orbit_target(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Layer integer
---@param Add boolean
---@return integer
function Stub.recalc_orbit_layer_offsets(ctx, familiar, Layer, Add) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Layer integer
function Stub.add_to_orbit(ctx, familiar, Layer) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.remove_from_orbit(ctx, familiar) end

---@param buffer Vector
---@param Layer integer
function Stub.get_orbit_distance(buffer, Layer) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.IsFollowing(familiar) end

---@param familiar Component.Entity.Familiar
---@return integer
function Stub.GetFollowerPriority(familiar) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.ShouldAddToOffsensiveFormation(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.ShouldAddToConjoinedGello(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return Component.Entity.Familiar
function Stub.GetConjoinedGello(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.follow_parent(ctx, familiar) end

---@param familiar Component.Entity.Familiar
---@param Pos Vector
function Stub.follow_position(familiar, Pos) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Pos Vector
---@return Vector
function Stub.get_orbit_position(ctx, familiar, Pos) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 Vector
---@return Component.Entity.Laser
function Stub.fire_laser(ctx, familiar, param_1) end

---@param familiar Component.Entity.Familiar
---@param Direction integer
function Stub.play_float_anim(familiar, Direction) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.add_to_delayed(ctx, familiar) end

---@param familiar Component.Entity.Familiar
function Stub.RemoveFromDelayed(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Direction integer
function Stub.play_charge_anim(ctx, familiar, Direction) end

---@param familiar Component.Entity.Familiar
---@param Direction integer
function Stub.play_shoot_anim(familiar, Direction) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param AimDirection Vector
---@param eDirection integer
---@param targetPosBuffer Vector
---@return boolean
function Stub.try_aim_at_marked_target(ctx, familiar, AimDirection, eDirection, targetPosBuffer) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.shoot(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param MaxDistance number
---@param FrameInterval integer
---@param Flags eEnemyTargetFlags | integer
---@param ConeDir Vector
---@param ConeAngle number
function Stub.pick_enemy_target(ctx, familiar, MaxDistance, FrameInterval, Flags, ConeDir, ConeAngle) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param radius_qqq number
---@param unused_qqq unknown
---@param flags_qqq integer
function Stub.pick_tear_target(ctx, familiar, radius_qqq, unused_qqq, flags_qqq) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.Update(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.Interpolate(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param offset Vector
---@return boolean
function Stub.RenderShadowLayer(ctx, familiar, offset) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param offset Vector
function Stub.Render(ctx, familiar, offset) end

---@param familiar Component.Entity.Familiar
---@param collider Component.Entity
---@param low boolean
---@return boolean
function Stub.handle_collision(familiar, collider, low) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.player_can_fire(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Coins integer
function Stub.AddCoins(ctx, familiar, Coins) end

---@param familiar Component.Entity.Familiar
---@param Hearts integer
function Stub.AddHearts(familiar, Hearts) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.TriggerRoomClear(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.TriggerNewStage(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 integer
---@param param_2 unknown
---@param param_3 integer
function Stub.TriggerPlayerDamaged(ctx, familiar, param_1, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.TriggerNewRoom(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.TriggerPillUsed(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 number
---@param param_2 integer
---@param param_3 Component.Entity.EntityRef
---@param param_4 integer
---@param unk integer
---@return boolean
function Stub.TakeDamage(ctx, familiar, param_1, param_2, param_3, param_4, unk) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.increase_mongo_idx(ctx, familiar) end

---@param familiar Component.Entity.Familiar
function Stub.remove_from_followers(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.add_to_followers(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Player Component.Entity.Player
function Stub.SetPlayer(ctx, familiar, Player) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param data Component.GameStatePlayer.FamiliarData
function Stub.RestoreState(ctx, familiar, data) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param NumFrames integer
function Stub.move_delayed(ctx, familiar, NumFrames) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Speed number
function Stub.move_diagonally(ctx, familiar, Speed) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.move_taped(ctx, familiar) end

---@param param_2 integer
---@param param_3 Vector
---@return Vector
function Stub.get_laser_offset(param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.delirium_morph(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.init_harbinger(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 Vector
function Stub.render_chargebar(ctx, familiar, param_1) end

---@param familiar Component.Entity.Familiar
---@param rng RNG
---@param retVariant integer
---@param params BitSet128
function Stub.get_buddy_tear_params(familiar, rng, retVariant, params) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 Vector
---@param param_2 boolean
---@return Component.Entity.Laser
function Stub.fire_brimstone(ctx, familiar, param_1, param_2) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.SetDelirium(ctx, familiar) end

---@param ctx Context.Common
---@param Position Vector
---@param Spawner Component.Entity
---@param Target number
function Stub.ThrowBlueSpider(ctx, Position, Spawner, Target) end

---@param ctx Context.Common
---@param Subtype eDipSubType | integer
---@param Position Vector
---@param Spawner Component.Entity
function Stub.SpawnDip(ctx, Subtype, Position, Spawner) end

---@param ctx Context.Common
---@param param_1 integer
---@param param_2 integer
---@param param_3 Vector
---@param param_4 Vector
---@param param_5 integer
---@param param_6 number
---@param param_7 number
---@param param_8 number
---@param param_9 integer
---@param param_10 integer
---@param param_11 Component.Entity
---@param param_12 number
function Stub.ShootSpewerCreep(ctx, param_1, param_2, param_3, param_4, param_5, param_6, param_7, param_8, param_9, param_10, param_11, param_12) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Dir Vector
---@param unk boolean
---@return Component.Entity.Tear
function Stub.fire_projectile(ctx, familiar, Dir, unk) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_2 number
---@param param_3 number
function Stub.sprinkler_brimstone(ctx, familiar, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_2 number
---@param param_3 number
function Stub.sprinkler_tech(ctx, familiar, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_2 number
---@param param_3 number
---@return Component.Entity.Knife
function Stub.sprinkler_knife(ctx, familiar, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.update_spewer_gfx(ctx, familiar) end

---@param familiar Component.Entity.Familiar
function Stub.update_my_shadow_scale(familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param unk boolean
---@return Vector
function Stub.GetSpawnPos(ctx, familiar, unk) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param unusedRemoveFamiliar boolean
function Stub.RemoveFromPlayer(ctx, familiar, unusedRemoveFamiliar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param Layer integer
function Stub.SetOrbitLayer(ctx, familiar, Layer) end

---@param familiar Component.Entity.Familiar
---@param param_1 Component.Entity.EntityRef
---@param param_2 Vector
---@param param_3 number
---@return boolean
function Stub.TryThrow(familiar, param_1, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.minisaac_update_shoot(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 Vector
---@param param_2 number
---@return Vector
function Stub.minisaac_compute_target_pos(ctx, familiar, param_1, param_2) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.minisaac_update_move(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.minisaac_update_target(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.blood_oath_apply_effects(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.paschal_candle_apply_effect(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@return Component.ItemConfig.Wisp
function Stub.GetLocustConfig(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param tearflags BitSet128
---@param entity Component.Entity
function Stub.trigger_locust_collision(ctx, familiar, tearflags, entity) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 Component.Entity
---@param param_2 Component.Entity.Player
function Stub.SetSirenCharm(ctx, familiar, param_1, param_2) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.RemoveCharm(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 Component.Entity.Npc
---@return Component.Entity.Npc
function Stub.try_convert_charmed_spawn(ctx, familiar, param_1) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param unusedBool boolean
function Stub.update_dirt_color(ctx, familiar, unusedBool) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param alwaysFalse boolean
function Stub.north_star_update_speed(ctx, familiar, alwaysFalse) end

---@param ctx Context.Common
---@return integer
function Stub.north_star_destination_idx(ctx) end

---@param buffer Vector
---@param param_2 integer
---@param param_3 integer
---@return Vector
function Stub.northstar_vector2_constructor(buffer, param_2, param_3) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
function Stub.move_rc(ctx, familiar) end

---@param ctx Context.Common
---@param familiar Component.Entity.Familiar
---@param param_1 integer
---@return integer
function Stub.GetModifiedFireRate(ctx, familiar, param_1) end

---@param familiar Component.Entity.Familiar
function Stub.TriggerGlowingHourglass(familiar) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.GetUnkWispBool(familiar) end

---@param familiar Component.Entity.Familiar
---@return boolean
function Stub.CanOverwrite(familiar) end

--#endregion

Interface.umbilical_baby_load_graphics = Stub.umbilical_baby_load_graphics
Interface.umbilical_baby_render_cord = Stub.umbilical_baby_render_cord
Interface.GetPlayer = Stub.GetPlayer
Interface.GetWispConfig = Stub.GetWispConfig
Interface.GetWispConfigForType = Stub.GetWispConfigForType
Interface.wisp_init = Stub.wisp_init
Interface.wisp_kill = Stub.wisp_kill
Interface.wisp_fire_projectiles = Stub.wisp_fire_projectiles
Interface.wisp_take_damage = Stub.wisp_take_damage
Interface.WispMorph = Stub.WispMorph
Interface.WispRerollRandomly = Stub.WispRerollRandomly
Interface.WispTrySlash = Stub.WispTrySlash
Interface.GetRandomWisp = Stub.GetRandomWisp
Interface.SetKeys = Stub.SetKeys
Interface.IsLilDelirium = Stub.IsLilDelirium
Interface.SetUnkWispBool = Stub.SetUnkWispBool
Interface.SetUnkWispHealthRelated = Stub.SetUnkWispHealthRelated
Interface.TriggerMegaBeanWispsCrackWave = Stub.TriggerMegaBeanWispsCrackWave
Interface.orbit_getter = Stub.orbit_getter
Interface.SetItemConfig = Stub.SetItemConfig
Interface.constructor = Stub.constructor
Interface.Free = Stub.Free
Interface.destructor = Stub.destructor
Interface.GetCollisionInterval = Stub.GetCollisionInterval
Interface.GetRemovePriority = Stub.GetRemovePriority
Interface.CanBeDamagedByEnemy = Stub.CanBeDamagedByEnemy
Interface.CanBlockProjectiles = Stub.CanBlockProjectiles
Interface.CanShutDoors = Stub.CanShutDoors
Interface.CanCharm = Stub.CanCharm
Interface.GetMultiplier = Stub.GetMultiplier
Interface.Init = Stub.Init
Interface.Remove = Stub.Remove
Interface.Kill = Stub.Kill
Interface.ClearReferences = Stub.ClearReferences
Interface.get_orbit_target = Stub.get_orbit_target
Interface.recalc_orbit_layer_offsets = Stub.recalc_orbit_layer_offsets
Interface.add_to_orbit = Stub.add_to_orbit
Interface.remove_from_orbit = Stub.remove_from_orbit
Interface.get_orbit_distance = Stub.get_orbit_distance
Interface.IsFollowing = Stub.IsFollowing
Interface.GetFollowerPriority = Stub.GetFollowerPriority
Interface.ShouldAddToOffsensiveFormation = Stub.ShouldAddToOffsensiveFormation
Interface.ShouldAddToConjoinedGello = Stub.ShouldAddToConjoinedGello
Interface.GetConjoinedGello = Stub.GetConjoinedGello
Interface.follow_parent = Stub.follow_parent
Interface.follow_position = Stub.follow_position
Interface.get_orbit_position = Stub.get_orbit_position
Interface.fire_laser = Stub.fire_laser
Interface.play_float_anim = Stub.play_float_anim
Interface.add_to_delayed = Stub.add_to_delayed
Interface.RemoveFromDelayed = Stub.RemoveFromDelayed
Interface.play_charge_anim = Stub.play_charge_anim
Interface.play_shoot_anim = Stub.play_shoot_anim
Interface.try_aim_at_marked_target = Stub.try_aim_at_marked_target
Interface.shoot = Stub.shoot
Interface.pick_enemy_target = Stub.pick_enemy_target
Interface.pick_tear_target = Stub.pick_tear_target
Interface.Update = Stub.Update
Interface.Interpolate = Stub.Interpolate
Interface.RenderShadowLayer = Stub.RenderShadowLayer
Interface.Render = Stub.Render
Interface.handle_collision = Stub.handle_collision
Interface.player_can_fire = Stub.player_can_fire
Interface.AddCoins = Stub.AddCoins
Interface.AddHearts = Stub.AddHearts
Interface.TriggerRoomClear = Stub.TriggerRoomClear
Interface.TriggerNewStage = Stub.TriggerNewStage
Interface.TriggerPlayerDamaged = Stub.TriggerPlayerDamaged
Interface.TriggerNewRoom = Stub.TriggerNewRoom
Interface.TriggerPillUsed = Stub.TriggerPillUsed
Interface.TakeDamage = Stub.TakeDamage
Interface.increase_mongo_idx = Stub.increase_mongo_idx
Interface.remove_from_followers = Stub.remove_from_followers
Interface.add_to_followers = Stub.add_to_followers
Interface.SetPlayer = Stub.SetPlayer
Interface.RestoreState = Stub.RestoreState
Interface.move_delayed = Stub.move_delayed
Interface.move_diagonally = Stub.move_diagonally
Interface.move_taped = Stub.move_taped
Interface.get_laser_offset = Stub.get_laser_offset
Interface.delirium_morph = Stub.delirium_morph
Interface.init_harbinger = Stub.init_harbinger
Interface.render_chargebar = Stub.render_chargebar
Interface.get_buddy_tear_params = Stub.get_buddy_tear_params
Interface.fire_brimstone = Stub.fire_brimstone
Interface.SetDelirium = Stub.SetDelirium
Interface.ThrowBlueSpider = Stub.ThrowBlueSpider
Interface.SpawnDip = Stub.SpawnDip
Interface.ShootSpewerCreep = Stub.ShootSpewerCreep
Interface.fire_projectile = Stub.fire_projectile
Interface.sprinkler_brimstone = Stub.sprinkler_brimstone
Interface.sprinkler_tech = Stub.sprinkler_tech
Interface.sprinkler_knife = Stub.sprinkler_knife
Interface.update_spewer_gfx = Stub.update_spewer_gfx
Interface.update_my_shadow_scale = Stub.update_my_shadow_scale
Interface.GetSpawnPos = Stub.GetSpawnPos
Interface.RemoveFromPlayer = Stub.RemoveFromPlayer
Interface.SetOrbitLayer = Stub.SetOrbitLayer
Interface.TryThrow = Stub.TryThrow
Interface.minisaac_update_shoot = Stub.minisaac_update_shoot
Interface.minisaac_compute_target_pos = Stub.minisaac_compute_target_pos
Interface.minisaac_update_move = Stub.minisaac_update_move
Interface.minisaac_update_target = Stub.minisaac_update_target
Interface.blood_oath_apply_effects = Stub.blood_oath_apply_effects
Interface.paschal_candle_apply_effect = Stub.paschal_candle_apply_effect
Interface.GetLocustConfig = Stub.GetLocustConfig
Interface.trigger_locust_collision = Stub.trigger_locust_collision
Interface.SetSirenCharm = Stub.SetSirenCharm
Interface.RemoveCharm = Stub.RemoveCharm
Interface.try_convert_charmed_spawn = Stub.try_convert_charmed_spawn
Interface.update_dirt_color = Stub.update_dirt_color
Interface.north_star_update_speed = Stub.north_star_update_speed
Interface.north_star_destination_idx = Stub.north_star_destination_idx
Interface.northstar_vector2_constructor = Stub.northstar_vector2_constructor
Interface.move_rc = Stub.move_rc
Interface.GetModifiedFireRate = Stub.GetModifiedFireRate
Interface.TriggerGlowingHourglass = Stub.TriggerGlowingHourglass
Interface.GetUnkWispBool = Stub.GetUnkWispBool
Interface.CanOverwrite = Stub.CanOverwrite