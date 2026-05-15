---@class Interface.EntityPlayer
local Interface = require("Isaac.Interface.Entity_Player")

--#region Stub

local Stub = {}

---@param player Component.Entity.Player
---@return boolean
function Stub.IsActive(player) end

---@param player Component.Entity.Player
---@param param_1 unknown
function Stub.SetValid(player, param_1) end

---@param player Component.Entity.Player
---@return Component.Entity.Player
function Stub.GetMainTwin(player) end

---@param player Component.Entity.Player
---@return Component.Entity.Player
function Stub.GetOtherTwin(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetFireDirection(player) end

---@param player Component.Entity.Player
---@return Vector
function Stub.GetAimDirection(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetPlayerType(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumBlueFlies(player) end

---@param player Component.Entity.Player
---@param flags integer
function Stub.AddCacheFlags(player, flags) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetHeadDirection(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.AreOpposingShootDirectionsPressed(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetShotSpeed(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetTearPoisonDamage(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetItemState(player) end

---@param player Component.Entity.Player
---@return Component.TemporaryEffects
function Stub.GetEffects(player) end

---@param player Component.Entity.Player
---@param DamageCooldown integer
function Stub.SetMinDamageCooldown(player, DamageCooldown) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumCoins(player) end

---@param player Component.Entity.Player
---@return Direction | integer
function Stub.GetMovementDirection(player) end

---@param player Component.Entity.Player
---@param slot integer
---@return integer
function Stub.GetActiveItem(player, slot) end

---@param player Component.Entity.Player
---@param ActiveSlot integer
---@return integer
function Stub.GetActiveCharge(player, ActiveSlot) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetWeaponFireDelay(player) end

---@param player Component.Entity.Player
---@param param_1 integer
---@return boolean
function Stub.AreControlsEnabled(player, param_1) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsItemQueueEmpty(player) end

---@param player Component.Entity.Player
function Stub.StopExtraAnimation(player) end

---@param player Component.Entity.Player
---@param CollectibleID CollectibleType | integer
---@return integer
function Stub.GetActiveItemSlot(player, CollectibleID) end

---@param player Component.Entity.Player
---@param activeItemIndex integer
---@return unknown
function Stub.GetVarData(player, activeItemIndex) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumKeys(player) end

---@param player Component.Entity.Player
---@param WeaponType WeaponType | integer
---@return boolean
function Stub.HasWeaponType(player, WeaponType) end

---@param player Component.Entity.Player
---@param Value boolean
function Stub.SetControlsEnabled(player, Value) end

---@param player Component.Entity.Player
---@param Cooldown integer
function Stub.SetControlsCooldown(player, Cooldown) end

---@param player Component.Entity.Player
---@param ID CollectibleType | integer
---@return RNG
function Stub.GetCollectibleRNG(player, ID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.use_moms_bracelet(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.use_red_key(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity
---@param subtype integer
---@param position Vector
function Stub.spawn_locust(ctx, player, subtype, position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type CollectibleType | integer
---@param UseFlags UseFlag | integer
---@param Slot ActiveSlot | integer
---@param CustomVarData integer
---@return integer resultFlags
function Stub.UseActiveItem(ctx, player, Type, UseFlags, Slot, CustomVarData) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.TriggerForgetMeNow(ctx, timer) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerCrackTheSky(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param rng RNG
---@param includeActiveItems boolean
function Stub.RerollAllCollectibles(ctx, player, rng, includeActiveItems) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Component.Entity
function Stub.get_stitches_familiar(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 CollectibleType | integer
---@param Position Vector
---@param AdjustOrbitLayer boolean
---@param DontUpdate boolean
---@return Component.Entity.Familiar
function Stub.AddWisp(ctx, player, param_1, Position, AdjustOrbitLayer, DontUpdate) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Collectible integer
---@param Position Vector
---@param AdjustOrbitLayer boolean
function Stub.AddItemWisp(ctx, player, Collectible, Position, AdjustOrbitLayer) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 CollectibleType | integer
---@param param_2 integer
function Stub.TriggerBookOfBelial(ctx, player, param_1, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type CollectibleType | integer
---@param Charge integer
function Stub.TriggerBookOfVirtues(ctx, player, Type, Charge) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@param slot ActiveSlot | integer
---@return boolean
function Stub.CanUseCollectible(ctx, player, collectible, slot) end

---@param list RNG[]
---@param id CollectibleType | integer
---@return RNG
function Stub.GetItemRNGByID(list, id) end

---@param player Component.Entity.Player
---@return Vector
function Stub.GetLastDirection(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetMaxFireDelay(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetMoveSpeed(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetTearHeight(player) end

---@param player Component.Entity.Player
---@param param_2 Vector
function Stub.SetForcedTargetPosition(player, param_2) end

---@param player Component.Entity.Player
---@param Enemy Component.Entity.EntityDesc
function Stub.SetFriendBallEnemy(player, Enemy) end

---@param player Component.Entity.Player
---@return Component.Entity.EntityDesc
function Stub.GetFriendBallEnemy(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 unknown
---@return Vector
function Stub.get_shooting_input_wrapper(ctx, player, param_1) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetBoneHearts(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetDamage(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetSoulHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumBlueSpiders(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetControllerIndex(player) end

---@param player Component.Entity.Player
---@return unknown
function Stub.GetDamageCooldown(player) end

---@param player Component.Entity.Player
function Stub.ResetDamageCooldown(player) end

---@param player Component.Entity.Player
---@param buffer Vector
---@return Vector
function Stub.GetSpriteScale(player, buffer) end

---@param player Component.Entity.Player
---@return Component.Weapon
function Stub.GetMainWeapon(player) end

---@param ctx Context.Common
---@param subtype integer
---@param position Vector
---@param player Component.Entity.Player
---@param param_4 Vector
function Stub.ThrowFriendlyDip(ctx, subtype, position, player, param_4) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetBrokenHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumBombs(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsP2Appearing(player) end

---@param player Component.Entity.Player
---@param TrinketID integer
---@return RNG
function Stub.GetTrinketRNG(player, TrinketID) end

---@param player Component.Entity.Player
---@return number
function Stub.GetLuck(player) end

---@param player Component.Entity.Player
---@return Component.Entity.Laser
function Stub.GetTractorBeam(player) end

---@param player Component.Entity.Player
---@return Color
function Stub.GetLaserColor(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.GetControlsEnabled(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasFullHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetJarHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetSoulCharge(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetBloodCharge(player) end

---@param player Component.Entity.Player
---@param ActiveSlot integer
---@return integer
function Stub.GetBatteryCharge(player, ActiveSlot) end

---@param player Component.Entity.Player
---@return Vector
function Stub.GetVelocityBeforeUpdate(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetMaxHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetEternalHearts(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasGoldenKey(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetBabySkin(player) end

---@param player Component.Entity.Player
---@return Component.Entity.Player
function Stub.GetSubPlayer(player) end

---@param player Component.Entity.Player
---@param Amount unknown
function Stub.SetSoulCharge(player, Amount) end

---@param player Component.Entity.Player
---@param Amount unknown
function Stub.SetBloodCharge(player, Amount) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsCoopGhost(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param itemToRemove integer
---@param trinketToRemove integer
function Stub.TryOpenStrangeDoor(ctx, player, itemToRemove, trinketToRemove) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetRottenHearts(player) end

---@param player Component.Entity.Player
---@param slot integer
---@return Component.PocketItem
function Stub.GetPocketItem(player, slot) end

---@param player Component.Entity.Player
---@param param_1 integer
---@return Vector
function Stub.GetTearsOffset(player, param_1) end

---@param player Component.Entity.Player
---@return Vector
function Stub.GetLastBufferedDirection(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetGoldenHearts(player) end

---@param player Component.Entity.Player
---@param weaponType WeaponType | integer
---@param value boolean
function Stub.SetWeaponTypeEnabled(player, weaponType, value) end

---@param player Component.Entity.Player
function Stub.reset_weapons(player) end

---@param player Component.Entity.Player
function Stub.QueueExtraAnimation(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.CanShoot(player) end

---@param player Component.Entity.Player
---@param ID integer
---@return RNG
function Stub.GetPillRNG(player, ID) end

---@param player Component.Entity.Player
---@param ID integer
---@return RNG
function Stub.GetCardRNG(player, ID) end

---@param player Component.Entity.Player
---@param param_1 integer
---@return boolean
function Stub.IsSubPlayer(player, param_1) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetPoopMana(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasCurseMistEffect(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Component.Entity.Player
function Stub.constructor(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 boolean
function Stub.Free(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.destructor(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param type integer
---@param variant integer
---@param subtype integer
---@param initSeed integer
function Stub.Init(ctx, player, type, variant, subtype, initSeed) end

---@param player Component.Entity.Player
---@param param_1 Color
---@return Color
function Stub.get_default_color(player, param_1) end

---@param player Component.Entity.Player
function Stub.reset_color(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_2 number
---@return number
function Stub.get_time_scale(ctx, player, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.ClearReferences(ctx, player) end

---@param player Component.Entity.Player
---@param param_1 Component.Entity
---@return boolean
function Stub.IsValidTarget(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param PlayerModified boolean
function Stub.clear_references(ctx, player, PlayerModified) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.InvalidateCoPlayerItems(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.IsPacifist(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.PossessorProcessInput(ctx, player) end

---@param player Component.Entity.Player
---@param removed integer
function Stub.trigger_max_hearts_removed(player, removed) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param MaxHearts integer
---@param IgnoreKeeper boolean
function Stub.AddMaxHearts(ctx, player, MaxHearts, IgnoreKeeper) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Hearts integer
---@param param_2 boolean
function Stub.AddHearts(ctx, player, Hearts, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.eternal_heart_show_overlay(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param EternalHearts integer
function Stub.AddEternalHearts(ctx, player, EternalHearts) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param SoulHearts integer
---@return integer
function Stub.AddSoulHearts(ctx, player, SoulHearts) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param BlackHearts integer
function Stub.AddBlackHearts(ctx, player, BlackHearts) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param BlackHeart integer
function Stub.RemoveBlackHeart(ctx, player, BlackHeart) end

---@param player Component.Entity.Player
---@param Heart integer
---@return boolean
function Stub.IsBlackHeart(player, Heart) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumBlackHearts(player) end

---@param player Component.Entity.Player
function Stub.AdjustBlackHearts(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount integer
function Stub.AddJarHearts(ctx, player, amount) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount integer
function Stub.AddCoins(ctx, player, amount) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount unknown
function Stub.AddBombs(ctx, player, amount) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount integer
function Stub.AddKeys(ctx, player, amount) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AddGoldenKey(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.RemoveGoldenKey(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param right Component.Entity.Player
---@param flags eConsumableCache | integer
function Stub.sync_consumable_counts(ctx, player, right, flags) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param flag eConsumableCache | integer
function Stub.consumable_count_changed(ctx, player, flag) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 Component.GameStatePlayer.ConsumableData
function Stub.restore_consumable_data(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Amount integer
---@param Position Vector
---@param Target Component.Entity
---@return Component.Entity
function Stub.AddBlueFlies(ctx, player, Amount, Position, Target) end

---@param player Component.Entity.Player
function Stub.RemoveBlueFly(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AddLeprocy(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
function Stub.AddBoneOrbital(ctx, player, Position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@return integer
function Stub.AddSwarmFlyOrbital(ctx, player, Position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.TryUseKey(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param item CollectibleType | integer
---@param checkBodyLayer boolean
---@param param_3 string
---@param param_4 integer
---@param unused boolean
function Stub.play_item_anim_collectible(ctx, player, item, checkBodyLayer, param_3, param_4, unused) end

---@param costume Component.Entity.Player.CostumeSpriteDesc
---@param anim string
---@param item Component.ItemConfig.Item
---@return boolean
function Stub.weapon_item_anim_filter(costume, anim, item) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param NullItemID integer
---@param param_3 string
---@param param_4 integer
function Stub.play_item_anim_nullItem(ctx, player, NullItemID, param_3, param_4) end

---@param player Component.Entity.Player
---@param item Component.ItemConfig.Item
---@param anim string
---@param pos number
function Stub.play_item_anim_constDesc(player, item, anim, pos) end

---@param player Component.Entity.Player
---@param param_1 unknown
---@param param_2 unknown
---@param param_3 unknown
---@param param_4 string
---@param param_5 integer
function Stub.set_item_anim_frame(player, param_1, param_2, param_3, param_4, param_5) end

---@param player Component.Entity.Player
---@param NullFrameName string
---@param HeadScale boolean
---@param Direction Vector
---@return Vector
function Stub.get_costume_null_pos(player, NullFrameName, HeadScale, Direction) end

---@param ctx Context.Common
---@param param_1 string
---@param param_2 string
---@param SkinColor integer
---@param PlayerType integer
---@param extraReturn boolean
---@param extraReturn1 boolean
function Stub.translate_costume_sprite_path(ctx, param_1, param_2, SkinColor, PlayerType, extraReturn, extraReturn1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.rebuild_costume_map(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param item Component.ItemConfig.Item
---@param itemStateOnly boolean
function Stub.AddCostume(ctx, player, item, itemStateOnly) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param NullId integer
function Stub.AddNullCostume(ctx, player, NullId) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Item Component.ItemConfig.Item
function Stub.RemoveCostume(ctx, player, Item) end

---@param player Component.Entity.Player
---@param item Component.ItemConfig.Item
---@param PlayerSpriteLayerID integer
---@return boolean
function Stub.IsItemCostumeVisible(player, item, PlayerSpriteLayerID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param NullItemID integer
---@param PlayerSpriteLayerID integer
---@return boolean
function Stub.IsNullItemCostumeVisible(ctx, player, NullItemID, PlayerSpriteLayerID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param CollectibleID CollectibleType | integer
---@param PlayerSpriteLayerID integer
---@return boolean
function Stub.IsCollectibleCostumeVisible(ctx, player, CollectibleID, PlayerSpriteLayerID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.ShuffleCostumes(ctx, player, param_1) end

---@param player Component.Entity.Player
function Stub.ClearCostumes(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Item Component.ItemConfig.Item
---@param Charge integer
---@param Flags integer
---@param VarData integer
function Stub.QueueItem(ctx, player, Item, Charge, Flags, VarData) end

---@param player Component.Entity.Player
function Stub.DestroyQueueItem(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.FlushQueueItem(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ePlayerForm PlayerForm | integer
---@param num integer
function Stub.increment_player_form_counter(ctx, player, ePlayerForm, num) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Form PlayerForm | integer
function Stub.add_player_form_costume(ctx, player, Form) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
function Stub.set_itemstate(ctx, player, collectible) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Pos Vector
function Stub.render_chargebar(ctx, player, Pos) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetCollectibleCount(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param flags integer
---@return integer
function Stub.CountTaggedCollectibles(ctx, player, flags) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param id CollectibleType | integer
---@param charge integer
---@param firsttime boolean
---@param slot ActiveSlot | integer
---@param vardata integer
function Stub.AddCollectible(ctx, player, id, charge, firsttime, slot, vardata) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.check_lachryphagry(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param FamiliarVariant FamiliarVariant | integer
---@param TargetCount integer
---@param rng RNG
---@param Item Component.ItemConfig.Item
---@param FamiliarSubType integer
function Stub.check_familiar(ctx, player, FamiliarVariant, TargetCount, rng, Item, FamiliarSubType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.EvaluateItems(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.RespawnFamiliars(ctx, player) end

---@param player Component.Entity.Player
---@return Component.Entity
function Stub.GetNPCTarget(player) end

---@param player Component.Entity.Player
---@param param_1 Vector
function Stub.SetAimDirection(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param type CollectibleType | integer
---@param ignoreModifiers boolean
---@return boolean
function Stub.HasCollectible(ctx, player, type, ignoreModifiers) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type CollectibleType | integer
---@param OnlyCountTrueItems boolean
---@return integer
function Stub.NumCollectibleHeld(ctx, player, Type, OnlyCountTrueItems) end

---@param player Component.Entity.Player
---@param param_1 CollectibleType | integer
---@return boolean
function Stub.VoidHasCollectible(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type TrinketType | integer
---@param ignoreModifiers boolean
---@return boolean
function Stub.HasTrinket(ctx, player, Type, ignoreModifiers) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param id TrinketType | integer
---@return boolean
function Stub.HasGoldenTrinket(ctx, player, id) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type TrinketType | integer
---@return boolean
function Stub.TryHoldTrinket(ctx, player, Type) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetMaxTrinkets(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param DropPos Vector
---@param ReplaceTick boolean
---@return integer
function Stub.DropTrinket(ctx, player, DropPos, ReplaceTick) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type TrinketType | integer
---@param FirstTimePickingUp boolean
function Stub.AddTrinket(ctx, player, Type, FirstTimePickingUp) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type TrinketType | integer
---@return boolean
function Stub.TryRemoveTrinket(ctx, player, Type) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param trinketType TrinketType | integer
---@return boolean
function Stub.TryRemoveSmeltedTrinket(ctx, player, trinketType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TryReplaceTrinket(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Damage number
---@param DamageFlags DamageFlags | integer
---@param Source Component.Entity.EntityRef
---@param DamageCountdown integer
---@return boolean
function Stub.TakeDamage(ctx, player, Damage, DamageFlags, Source, DamageCountdown) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.SetFullHearts(ctx, player) end

---@param player Component.Entity.Player
---@param X number
---@param Y number
function Stub.SetTearsOffset(player, X, Y) end

---@param player Component.Entity.Player
---@return Component.Entity
function Stub.GetFocusEntity(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Vector
function Stub.get_movement_input(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Vector
function Stub.get_shooting_input(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Vector
function Stub.get_body_move_dir(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.get_weapon_modifiers(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.control_movement(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.control_shooting(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_2 boolean
---@return BitSet128
function Stub.GetBombFlags(ctx, player, param_2) end

---@param player Component.Entity.Player
---@param TearFlags BitSet128
---@param ForceSmallBomb boolean
---@return integer
function Stub.GetBombVariant(player, TearFlags, ForceSmallBomb) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param flags BitSet128
---@return number
function Stub.GetBombScale(ctx, player, flags) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.control_bombs(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param weaponType WeaponType | integer
---@return Component.Weapon.MultiShotParams
function Stub.GetMultiShotParams(ctx, player, weaponType) end

---@param loopIndex integer
---@param weaponType WeaponType | integer
---@param shotDirection Component.XY
---@param shotSpeed number
---@param multiShotParams Component.Weapon.MultiShotParams
---@return Component.PosVel
function Stub.GetMultiShotPositionVelocity(loopIndex, weaponType, shotDirection, shotSpeed, multiShotParams) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Vector
function Stub.GetFlyingOffset(ctx, player) end

---@param player Component.Entity.Player
---@return Component.Entity.Effect
function Stub.GetMarkedTarget(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ShotPos Vector
---@param IsShooting boolean
function Stub.fire(ctx, player, ShotPos, IsShooting) end

---@param player Component.Entity.Player
---@return string
function Stub.get_death_anim(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.sync_coplayer(ctx, player) end

---@param player Component.Entity.Player
---@return Component.Entity
function Stub.GetActiveWeaponEntity(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.CanTurnHead(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetFireDelay(player) end

---@param player Component.Entity.Player
---@param Delay number
function Stub.SetFireDelay(player, Delay) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.Update(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.IsHeadless(ctx, player) end

---@param param_1 Sprite
---@param param_2 Sprite
function Stub.render_player_sprite_helper(param_1, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Pos Vector
---@param param_2 boolean
function Stub.render_player_sprite(ctx, player, Pos, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param offset Vector
function Stub.Render(ctx, player, offset) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Pos Vector
---@return boolean
function Stub.RenderShadowLayer(ctx, player, Pos) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param offset Vector
function Stub.RenderGlow(ctx, player, offset) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param position Vector
function Stub.RenderBody(ctx, player, position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param position Vector
function Stub.RenderHead(ctx, player, position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param offset Vector
function Stub.RenderHeadBack(ctx, player, offset) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param offset Vector
function Stub.RenderTop(ctx, player, offset) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param collider Component.Entity
---@param low boolean
function Stub.handle_collision(ctx, player, collider, low) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type CollectibleType | integer
---@param IgnoreModifiers boolean
---@param ActiveSlot ActiveSlot | integer
---@param RemoveFromPlayerForm boolean
function Stub.RemoveCollectible(ctx, player, Type, IgnoreModifiers, ActiveSlot, RemoveFromPlayerForm) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param index integer
function Stub.RemoveCollectibleByHistoryIndex(ctx, player, index) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param collectibleType CollectibleType | integer
function Stub.TriggerCollectibleRemoved(ctx, player, collectibleType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@param existingCollectible Component.Entity.Pickup
---@param RemoveFromPlayerForm boolean
---@return Component.Entity.Pickup
function Stub.DropCollectible(ctx, player, collectible, existingCollectible, RemoveFromPlayerForm) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param index integer
---@param param_2 Component.Entity.Pickup
---@return Component.Entity.Pickup
function Stub.DropCollectibleByHistoryIndex(ctx, player, index, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.ClearTemporaryEffects(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param Velocity Vector
---@param flags eFireTearFlags | integer
---@param source Component.Entity?
---@param DamageMultiplier number
---@return Component.Entity.Tear
function Stub.FireTear(ctx, player, Position, Velocity, flags, source, DamageMultiplier) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param slot ActiveSlot | integer
---@return integer
function Stub.GetTotalActiveCharge(ctx, player, slot) end

---@param player Component.Entity.Player
---@param vardata integer
---@param slot integer
function Stub.SetActiveVarData(player, vardata, slot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@param vardata integer
---@return integer
function Stub.GetActiveMaxCharge(ctx, player, collectible, vardata) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param slot ActiveSlot | integer
---@return integer
function Stub.GetActiveMaxChargeWrapper(ctx, player, slot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param slot ActiveSlot | integer
---@return integer
function Stub.GetActiveMinUsableCharge(ctx, player, slot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Charge integer
---@param ActiveSlot ActiveSlot | integer
function Stub.SetActiveCharge(ctx, player, Charge, ActiveSlot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param charge integer
---@param slot ActiveSlot | integer
---@param flashHUD boolean
---@param overcharge boolean
---@param force boolean
---@return integer
function Stub.AddActiveCharge(ctx, player, charge, slot, flashHUD, overcharge, force) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param slot_qqq ActiveSlot | integer
function Stub.control_active_item(ctx, player, slot_qqq) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.HasTimedItem(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param effect Component.ItemConfig.Item
function Stub.TriggerEffectRemoved(ctx, player, effect) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_effects(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_ladder(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param npc Component.Entity.Npc
function Stub.TriggerEnemyDeath(ctx, player, npc) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param Velocity Vector
---@param Source Component.Entity
---@return Component.Entity.Bomb
function Stub.FireBomb(ctx, player, Position, Velocity, Source) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Direction Vector
---@param Source Component.Entity
---@param DamageMultiplier number
---@return Component.Entity.Laser
function Stub.FireBrimstone(ctx, player, Direction, Source, DamageMultiplier) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param checkOnly boolean
---@return boolean
function Stub.TriggerDeath(ctx, player, checkOnly) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.Revive(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param item CollectibleType | integer
---@param ownedByThisPlayer boolean
function Stub.ReviveFromCollectible(ctx, player, item, ownedByThisPlayer) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param trinket TrinketType | integer
function Stub.ReviveFromTrinket(ctx, player, trinket) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.MergeTwins(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param id integer
---@param pocketItemType integer
function Stub.add_pocketitem(ctx, player, id, pocketItemType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ID Card | integer
function Stub.AddCard(ctx, player, ID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param PillColor integer
function Stub.AddPill(ctx, player, PillColor) end

---@param player Component.Entity.Player
---@param SlotId integer
---@return Card | integer
function Stub.GetCard(player, SlotId) end

---@param player Component.Entity.Player
---@param SlotId integer
---@return integer
function Stub.GetPill(player, SlotId) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param SlotId integer
---@param ID Card | integer
function Stub.SetCard(ctx, player, SlotId, ID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param SlotId integer
---@param Pill integer
function Stub.SetPill(ctx, player, SlotId, Pill) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.control_pocket_item(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.control_drop_pocket_items(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.SwapActiveItems(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param slot integer
function Stub.RemovePocketItem(ctx, player, slot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param slot integer
---@param pos Vector
function Stub.DropPocketItem(ctx, player, slot, pos) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.try_spawn_pee_puddle(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param FromPlayerUpdate boolean
function Stub.TriggerNewStage(ctx, player, FromPlayerUpdate) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerFart(ctx, player) end

---@param player Component.Entity.Player
---@param TrinketSlot integer
---@return Component.ItemConfig.Item
function Stub.GetTrinket(player, TrinketSlot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param newIdx integer
---@param includePlayerOwned boolean
function Stub.SetControllerIndex(ctx, player, newIdx, includePlayerOwned) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 boolean
function Stub.TriggerRoomExit(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerNewRoom(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerNewRoom_TemporaryEffects(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerRoomClear(ctx, player) end

---@param player Component.Entity.Player
---@param param_1 PlayerForm | integer
---@return boolean
function Stub.HasPlayerForm(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type CollectibleType | integer
---@return boolean
function Stub.CanAddCollectible(ctx, player, Type) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param res Vector
---@param ID eLaserOffset | integer
---@param Direction Vector
function Stub.get_laser_offset(ctx, player, res, ID, Direction) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param OffsetID eLaserOffset | integer
---@param Direction Vector
---@param LeftEye boolean
---@param OneHit boolean
---@param Source Component.Entity
---@param DamageScale number
---@return Component.Entity.Laser
function Stub.FireTechLaser(ctx, player, Position, OffsetID, Direction, LeftEye, OneHit, Source, DamageScale) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ShotDirection Vector
---@param param_3 boolean
---@return Vector
function Stub.get_tear_movement_inheritance(ctx, player, ShotDirection, param_3) end

---@param player Component.Entity.Player
---@return boolean
function Stub.CanEnterTrapDoor(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsExtraAnimationFinished(player) end

---@param player Component.Entity.Player
---@param sprite Sprite
---@param HideShadow boolean
---@param AnimName string
function Stub.AnimatePickup(player, sprite, HideShadow, AnimName) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Collectible CollectibleType | integer
---@param AnimName string
---@param SpriteAnimName string
function Stub.AnimateCollectible(ctx, player, Collectible, AnimName, SpriteAnimName) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Trinket TrinketType | integer
---@param AnimName string
---@param SpriteAnimName string
function Stub.AnimateTrinket(ctx, player, Trinket, AnimName, SpriteAnimName) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ID Card | integer
---@param AnimName string
function Stub.AnimateCard(ctx, player, ID, AnimName) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Pill integer
---@param AnimName string
function Stub.AnimatePill(ctx, player, Pill, AnimName) end

---@param player Component.Entity.Player
function Stub.AnimateTrapdoor(player) end

---@param player Component.Entity.Player
function Stub.AnimateLightTravel(player) end

---@param player Component.Entity.Player
---@param param_1 boolean
function Stub.AnimatePitfallIn(player, param_1) end

---@param player Component.Entity.Player
function Stub.AnimatePitfallOut(player) end

---@param player Component.Entity.Player
function Stub.AnimateAppear(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Up boolean
function Stub.AnimateTeleport(ctx, player, Up) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AnimateHappy(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AnimateSad(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AddPrettyFly(ctx, player) end

---@param player Component.Entity.Player
---@param Animation string
function Stub.PlayExtraAnimation(player, Animation) end

---@param player Component.Entity.Player
---@param param_1 string
function Stub.PlayItemNullAnimation(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param activeSlot ActiveSlot | integer
---@param param_2 boolean
---@param charge integer
function Stub.TriggerActiveItemUsed(ctx, player, activeSlot, param_2, charge) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ActiveSlot ActiveSlot | integer
---@param unk boolean
function Stub.DischargeActiveItem(ctx, player, ActiveSlot, unk) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Collectible CollectibleType | integer
---@param KeepPersistent boolean
function Stub.TryRemoveCollectibleCostume(ctx, player, Collectible, KeepPersistent) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Trinket integer
function Stub.TryRemoveTrinketCostume(ctx, player, Trinket) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param NullId NullItemID | integer
function Stub.TryRemoveNullCostume(ctx, player, NullId) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetMaxPocketItems(ctx, player) end

---@param player Component.Entity.Player
function Stub.clear_item_anim(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 CollectibleType | integer
function Stub.clear_item_anim_collectible(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param unused NullItemID | integer
function Stub.clear_item_anim_nullitem(ctx, player, unused) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
---@param string string
---@return boolean
function Stub.is_item_anim_finished_collectible(ctx, player, param_1, string) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param NullItemID integer
---@param AnimationName string
---@return boolean
function Stub.is_item_anim_finished_nullitem(ctx, player, NullItemID, AnimationName) end

---@param param_1 string
---@param param_2 Vector
---@param param_3 string
---@param param_4 string
---@param param_5 string
---@param param_6 string
---@return string
function Stub.get_animation_from_vector(param_1, param_2, param_3, param_4, param_5, param_6) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param trinketType TrinketType | integer
---@param FirstTimePickingUp boolean
function Stub.TriggerTrinketAdded(ctx, player, trinketType, FirstTimePickingUp) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param trinketType TrinketType | integer
function Stub.TriggerTrinketRemoved(ctx, player, trinketType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Parent Component.Entity
---@param Variant integer
---@param RotationOffset number
---@param CantOverwrite boolean
---@param SubType integer
---@return Component.Entity.Knife
function Stub.FireKnife(ctx, player, Parent, Variant, RotationOffset, CantOverwrite, SubType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param parent Component.Entity
---@param variant integer
---@param param_3 boolean
---@return Component.Entity.Knife
function Stub.FireBoneClub(ctx, player, parent, variant, param_3) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param pos Vector
---@param vel Vector
---@param offset Vector
---@return Component.Entity.Laser
function Stub.FireBrimstoneBall(ctx, player, pos, vel, offset) end

---@param player Component.Entity.Player
---@param param_1 Component.GameStatePlayer.SubPlayer
function Stub.RestoreGameState_CoPlayerData(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param state Component.GameStatePlayer
function Stub.RestoreGameState(ctx, player, state) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.check_death(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param PlayerData Component.GameStatePlayer
function Stub.RestoreGameState_PostLevelInit(ctx, player, PlayerData) end

---@param player Component.Entity.Player
---@param param_1 Component.GameStatePlayer.SubPlayer
function Stub.store_sub_player(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 Component.GameStatePlayer
function Stub.StoreGameState(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.DonateLuck(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param cardType Card | integer
---@param useFlag UseFlag | integer
function Stub.UseCard(ctx, player, cardType, useFlag) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.UpdateFootEffects(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 boolean
---@param color KColor
function Stub.SetFootprintColor(ctx, player, param_1, color) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param foot integer
---@return boolean
function Stub.IsFootstepFrame(ctx, player, foot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.NotifyGrabbed(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.UpdateGrabbedState(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.UpdatePitfallState(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
---@param param_2 boolean
---@return boolean
function Stub.TryDecreaseGlowingHourglassUses(ctx, player, param_1, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_babies(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.trigger_baby_death(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.InitPreLevelInitStats(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.InitPostLevelInitStats(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.InitPlayerSkin(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.init_baby_skin(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Angle number
---@param Parent Component.Entity
---@return Component.Entity.Laser
function Stub.FireDelayedBrimstone(ctx, player, Angle, Parent) end

---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickupItem(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsHoldingItem(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsHeldItemVisible(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@return Component.Entity
function Stub.AddBlueSpider(ctx, player, Position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param Target Vector
---@return Component.Entity
function Stub.ThrowBlueSpider(ctx, player, Position, Target) end

---@param player Component.Entity.Player
function Stub.RemoveBlueSpider(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetExtraLives(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param WeaponType WeaponType | integer
---@param DamageScale number
---@param TearDisplacement integer
---@param Source Component.Entity?
---@return Component.Entity.Player.TearParams
function Stub.GetTearHitParams(ctx, player, WeaponType, DamageScale, TearDisplacement, Source) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_2 integer
---@return number
function Stub.GetTearFlagScale(ctx, player, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.Debug_SetHighLuck(ctx, player) end

---@param ctx Context.Common
---@return integer
function Stub.get_glitch_baby_subtype(ctx) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Flags DamageFlags | integer
---@return boolean
function Stub.HasInvincibility(ctx, player, Flags) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasInvisibility(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.HasPoisonImmunity(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.CanCrushRocks(ctx, player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickRedHearts(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickSoulHearts(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickBlackHearts(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.RemoveSkinCostume(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.ResetItemState(ctx, player) end

---@param player Component.Entity.Player
---@param Cooldown integer
function Stub.SetShootingCooldown(player, Cooldown) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ActiveSlot integer
---@return boolean
function Stub.NeedsCharge(ctx, player, ActiveSlot) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param ActiveSlot integer
---@param Force boolean
---@return boolean
function Stub.FullCharge(ctx, player, ActiveSlot, Force) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.preload_sounds(ctx, player) end

---@param player Component.Entity.Player
---@param effect PillEffect | integer
---@return boolean
function Stub.CanUsePill(player, effect) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Effect PillEffect | integer
---@param Color PillColor | integer
---@param UseFlag UseFlag | integer
function Stub.UsePill(ctx, player, Effect, Color, UseFlag) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AddDeadEyeCharge(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.ClearDeadEyeCharge(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return CollectibleType | integer
function Stub.GetZodiacEffect(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param item Component.ItemConfig.Item
---@param SpritePath string
---@param SpriteId integer
function Stub.ReplaceCostumeSprite(ctx, player, item, SpritePath, SpriteId) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param damageFlagsL integer
---@param damageFlagsH integer
---@return boolean
function Stub.TryDullRazorWisp(ctx, player, damageFlagsL, damageFlagsH) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_purity_sprite(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 boolean
function Stub.update_isaac_pregnancy(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerHeartPickedUp(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Timeout integer
---@return Component.Entity.Laser
function Stub.SpawnMawOfVoid(ctx, player, Timeout) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AddGoldenBomb(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.RemoveGoldenBomb(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.add_dollar_bill_effect(ctx, player) end

---@param player Component.Entity.Player
---@return integer
function Stub.get_cambion_level(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.get_cambion_pregnancy_level(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Direction Vector
function Stub.shoot_red_candle(ctx, player, Direction) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Direction Vector
function Stub.shoot_blue_candle(ctx, player, Direction) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Direction Vector
function Stub.do_zit_effect(ctx, player, Direction) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param seed integer
function Stub.TriggerPreVictoryLap(ctx, player, seed) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return number
function Stub.GetSoundPitch(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.AddJarFlies(ctx, player, param_1) end

---@param player Component.Entity.Player
---@param Position Vector
---@return boolean
function Stub.IsPosInSpotLight(player, Position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Hearts integer
function Stub.AddGoldenHearts(ctx, player, Hearts) end

---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickGoldenHearts(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_red_hearts(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param number_qqq integer
function Stub.trigger_golden_hearts(ctx, player, number_qqq) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_golden_hearts(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Hearts integer
function Stub.AddBoneHearts(ctx, player, Hearts) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickBoneHearts(ctx, player) end

---@param player Component.Entity.Player
---@param Heart integer
---@return boolean
function Stub.IsBoneHeart(player, Heart) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.TryPreventDeath(ctx, player) end

---@param ctx Context.Common
---@param param_1 Component.Entity.Player
function Stub.update_bone_hearts(ctx, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param IgnoreModifiers boolean
---@return integer
function Stub.GetHeartLimit(ctx, player, IgnoreModifiers) end

---@param player Component.Entity.Player
---@return HealthType | integer
function Stub.GetHealthType(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetEffectiveMaxHearts(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.InitBabyStats(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param Direction Vector
---@param Radius number
---@param Source Component.Entity
---@param DamageMultiplier number
---@return Component.Entity.Laser
function Stub.FireTechXLaser(ctx, player, Position, Direction, Radius, Source, DamageMultiplier) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.TriggerNonEnemyTearHit(ctx, player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsFullSpriteRendering(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param id integer
---@param soundDelay integer
---@param frameDelay unknown
---@param volume number
function Stub.play_delayed_sfx(ctx, player, id, soundDelay, frameDelay, volume) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param TrinketID TrinketType | integer
---@return integer
function Stub.GetTrinketMultiplier(ctx, player, TrinketID) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.UpdateCanShoot(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.WillPlayerRevive(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return number
function Stub.GetGreedDonationBreakChance(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.AddHallowedGroundCountdown(ctx, player, param_1) end

---@param player Component.Entity.Player
---@return Component.Entity.Player
function Stub.GetEffectTarget(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_forgotten_state(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return Component.EntityConfig.Entity
function Stub.spawn_forgotten_body(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param IgnoreHealth boolean
---@param DisableVisuals boolean
---@return boolean
function Stub.swap_forgotten(ctx, player, IgnoreHealth, DisableVisuals) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param doEffects boolean
---@param teleportTwinPlayers boolean
function Stub.Teleport(ctx, player, Position, doEffects, teleportTwinPlayers) end

---@param ctx Context.Common
function Stub.PlayTeleportSoundEffect(ctx) end

---@param player Component.Entity.Player
---@return Component.Entity.Player
function Stub.GetParentPlayer(player) end

---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@return boolean
function Stub.CanRerollCollectible(ctx, CollectibleType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.get_greeds_gullet_hearts(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_greeds_gullet(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param PlayerType PlayerType | integer
---@param param_2 boolean
function Stub.ChangePlayerType(ctx, player, PlayerType, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param PlayerType PlayerType | integer
function Stub.TriggerPlayerTypeChanged(ctx, player, PlayerType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.IsLocalPlayer(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 Vector
function Stub.RenderDebugInfo(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param retVar integer
---@param retSubType integer
function Stub.GetGlyphOfBalanceDrop(ctx, player, retVar, retSubType) end

---@param ctx Context.Common
---@return Vector
function Stub.GetEnterPosition(ctx) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 boolean
---@return boolean
function Stub.CheckIsStuck(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Position Vector
---@param PlayAnim boolean
---@return Component.Entity
function Stub.AddMinisaac(ctx, player, Position, PlayAnim) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.TryTriggerPerfectBreath(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param playerType PlayerType | integer
---@return Component.Entity.Player
function Stub.init_twin(ctx, player, playerType) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Entity Component.Entity
---@return boolean
function Stub.TryHoldEntity(ctx, player, Entity) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Velocity Vector
---@return Component.Entity
function Stub.ThrowHeldEntity(ctx, player, Velocity) end

---@param player Component.Entity.Player
---@param param_1 Component.Entity.EntityRef
---@param param_2 Vector
---@param param_3 number
---@return boolean
function Stub.TryThrow(player, param_1, param_2, param_3) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Subtype integer
---@param Position Vector
function Stub.AddFriendlyDip(ctx, player, Subtype, Position) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount unknown
function Stub.AddBrokenHearts(ctx, player, amount) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Amount integer
function Stub.AddSoulCharge(ctx, player, Amount) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetEffectiveSoulCharge(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.update_soul_charges(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Amount integer
function Stub.AddBloodCharge(ctx, player, Amount) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetEffectiveBloodCharge(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param charges integer
function Stub.update_blood_charges(ctx, player, charges) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param RottenHearts integer
---@param param_2 boolean
function Stub.AddRottenHearts(ctx, player, RottenHearts, param_2) end

---@param player Component.Entity.Player
---@return boolean
function Stub.CanPickRottenHearts(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 boolean
function Stub.update_book_of_virtues(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.AddRedemptionBonus(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Amount integer
function Stub.AddUrnSouls(ctx, player, Amount) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param GigaBombs integer
function Stub.AddGigaBombs(ctx, player, GigaBombs) end

---@param ctx Context.Common
---@return number
function Stub.get_effect_charge_multiplier(ctx) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.try_end_astral_projection(ctx, player) end

---@param player Component.Entity.Player
function Stub.reset_rock_bottom(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_wavy_cap_state(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.spawn_saturnus_tears(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetInventoryMaxSize(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param type CollectibleType | integer
---@return boolean
function Stub.CanAddCollectibleToInventory(ctx, player, type) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type CollectibleType | integer
---@param ActiveSlot ActiveSlot | integer
---@param KeepInPools boolean
function Stub.SetPocketActiveItem(ctx, player, Type, ActiveSlot, KeepInPools) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetTMaggyPermanentHearts(ctx, player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetSalvationScale(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.UpdateSuplexState(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 Component.Entity.Pickup
---@return boolean
function Stub.TryAddToBagOfCrafting(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param position Vector
---@param subtype CollectibleType | integer
---@param seed integer
---@param pool integer
function Stub.SalvageCollectible(ctx, player, position, subtype, seed, pool) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetMaxPoopMana(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Num integer
function Stub.AddPoopMana(ctx, player, Num) end

---@param player Component.Entity.Player
function Stub.CheckPoopSpellQueue(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param Type integer
function Stub.UsePoopSpell(ctx, player, Type) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 Component.Entity.Familiar
function Stub.RecomputeWispCollectibles(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 Vector
function Stub.TriggerCrackedOrb(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param id CollectibleType | integer
---@return integer
function Stub.AddItemCard(ctx, player, id) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.update_lil_clot(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param bitset integer
---@param new integer
function Stub.AddLiquidPoopEffect(ctx, player, bitset, new) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.TryFakeDeath(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.AddCurseMistEffect(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.RemoveCurseMistEffect(ctx, player) end

---@param player Component.Entity.Player
---@param minecartNPC Component.Entity.Npc
function Stub.AttachToMinecart(player, minecartNPC) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
function Stub.add_samson_berserk_charge(ctx, player, param_1) end

---@param player Component.Entity.Player
---@param param_1 number
function Stub.add_ibs_charge(player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.revive_coop_ghost(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.morph_to_coop_ghost(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.assign_coop_ghost_skin(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param bagContent BagOfCraftingPickup | integer
---@param unused boolean
---@return CollectibleType | integer
function Stub.get_crafting_output(ctx, player, bagContent, unused) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean
function Stub.HasPassiveBelial(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param param_1 integer
---@return boolean
function Stub.CanOverrideActiveItem(ctx, player, param_1) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param pos Vector
---@param param_2 boolean
function Stub.spawn_clot_baby(ctx, player, pos, param_2) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param direction Vector
---@return boolean
function Stub.TryForgottenThrow(ctx, player, direction) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.PreTriggerGenesis(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.ResetPlayer(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
function Stub.PostTriggerGenesis(ctx, player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasInstantDeathCurse(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.IsHologram(player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param pocketItemType ePocketCollectibleType | integer
---@param cardOrPillColor integer
function Stub.TriggerEchoChamber(ctx, player, pocketItemType, cardOrPillColor) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetGFuelAmount(ctx, player) end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@return integer
function Stub.GetGFuelWeaponType(ctx, player) end

---@param player Component.Entity.Player
---@return string
function Stub.GetName(player) end

---@param player Component.Entity.Player
---@return number
function Stub.GetSmoothBodyRotation(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasFullHeartsAndSoulHearts(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetJarFlies(player) end

---@param player Component.Entity.Player
---@param ActiveSlot integer
---@return integer
function Stub.GetActiveSubCharge(player, ActiveSlot) end

---@param player Component.Entity.Player
---@return Vector
function Stub.GetMovementVector(player) end

---@param player Component.Entity.Player
---@return Vector
function Stub.GetRecentMovementVector(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetBlackHearts(player) end

---@param player Component.Entity.Player
---@return boolean
function Stub.HasGoldenBomb(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetTearRangeModifier(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetControlsCooldown(player) end

---@param player Component.Entity.Player
---@param Cooldown integer
function Stub.AddControlsCooldown(player, Cooldown) end

---@param player Component.Entity.Player
---@return Component.Entity.EntityRef
function Stub.GetLastDamageSource(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetLastDamageFlags(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetTotalDamageTaken(player) end

---@param player Component.Entity.Player
---@param Scale Vector
function Stub.SetSpriteScale(player, Scale) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetLastActionTriggers(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetBodyColor(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetHeadColor(player) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetNumGigaBombs(player) end

---@param player Component.Entity.Player
---@param Position integer
---@return integer
function Stub.GetPoopSpell(player, Position) end

---@param player Component.Entity.Player
---@return integer
function Stub.GetModelingClayEffect(player) end

--endregion

Interface.IsEntityTypePlayer = Stub.IsEntityTypePlayer
Interface.IsActive = Stub.IsActive
Interface.SetValid = Stub.SetValid
Interface.GetMainTwin = Stub.GetMainTwin
Interface.GetOtherTwin = Stub.GetOtherTwin
Interface.GetFireDirection = Stub.GetFireDirection
Interface.GetAimDirection = Stub.GetAimDirection
Interface.GetPlayerType = Stub.GetPlayerType
Interface.GetNumBlueFlies = Stub.GetNumBlueFlies
Interface.AddCacheFlags = Stub.AddCacheFlags
Interface.GetHeadDirection = Stub.GetHeadDirection
Interface.AreOpposingShootDirectionsPressed = Stub.AreOpposingShootDirectionsPressed
Interface.GetShotSpeed = Stub.GetShotSpeed
Interface.GetTearPoisonDamage = Stub.GetTearPoisonDamage
Interface.GetItemState = Stub.GetItemState
Interface.GetEffects = Stub.GetEffects
Interface.SetMinDamageCooldown = Stub.SetMinDamageCooldown
Interface.GetNumCoins = Stub.GetNumCoins
Interface.GetMovementDirection = Stub.GetMovementDirection
Interface.GetActiveItem = Stub.GetActiveItem
Interface.GetActiveCharge = Stub.GetActiveCharge
Interface.GetWeaponFireDelay = Stub.GetWeaponFireDelay
Interface.AreControlsEnabled = Stub.AreControlsEnabled
Interface.IsItemQueueEmpty = Stub.IsItemQueueEmpty
Interface.StopExtraAnimation = Stub.StopExtraAnimation
Interface.GetActiveItemSlot = Stub.GetActiveItemSlot
Interface.GetVarData = Stub.GetVarData
Interface.GetNumKeys = Stub.GetNumKeys
Interface.HasWeaponType = Stub.HasWeaponType
Interface.SetControlsEnabled = Stub.SetControlsEnabled
Interface.SetControlsCooldown = Stub.SetControlsCooldown
Interface.GetCollectibleRNG = Stub.GetCollectibleRNG
Interface.use_moms_bracelet = Stub.use_moms_bracelet
Interface.use_red_key = Stub.use_red_key
Interface.spawn_locust = Stub.spawn_locust
Interface.UseActiveItem = Stub.UseActiveItem
Interface.TriggerForgetMeNow = Stub.TriggerForgetMeNow
Interface.TriggerCrackTheSky = Stub.TriggerCrackTheSky
Interface.RerollAllCollectibles = Stub.RerollAllCollectibles
Interface.get_stitches_familiar = Stub.get_stitches_familiar
Interface.AddWisp = Stub.AddWisp
Interface.AddItemWisp = Stub.AddItemWisp
Interface.TriggerBookOfBelial = Stub.TriggerBookOfBelial
Interface.TriggerBookOfVirtues = Stub.TriggerBookOfVirtues
Interface.CanUseCollectible = Stub.CanUseCollectible
Interface.GetItemRNGByID = Stub.GetItemRNGByID
Interface.GetLastDirection = Stub.GetLastDirection
Interface.GetMaxFireDelay = Stub.GetMaxFireDelay
Interface.GetMoveSpeed = Stub.GetMoveSpeed
Interface.GetTearHeight = Stub.GetTearHeight
Interface.SetForcedTargetPosition = Stub.SetForcedTargetPosition
Interface.SetFriendBallEnemy = Stub.SetFriendBallEnemy
Interface.GetFriendBallEnemy = Stub.GetFriendBallEnemy
Interface.get_shooting_input_wrapper = Stub.get_shooting_input_wrapper
Interface.GetBoneHearts = Stub.GetBoneHearts
Interface.GetDamage = Stub.GetDamage
Interface.GetHearts = Stub.GetHearts
Interface.GetSoulHearts = Stub.GetSoulHearts
Interface.GetNumBlueSpiders = Stub.GetNumBlueSpiders
Interface.GetControllerIndex = Stub.GetControllerIndex
Interface.GetDamageCooldown = Stub.GetDamageCooldown
Interface.ResetDamageCooldown = Stub.ResetDamageCooldown
Interface.GetSpriteScale = Stub.GetSpriteScale
Interface.GetMainWeapon = Stub.GetMainWeapon
Interface.ThrowFriendlyDip = Stub.ThrowFriendlyDip
Interface.GetBrokenHearts = Stub.GetBrokenHearts
Interface.GetNumBombs = Stub.GetNumBombs
Interface.IsP2Appearing = Stub.IsP2Appearing
Interface.GetTrinketRNG = Stub.GetTrinketRNG
Interface.GetLuck = Stub.GetLuck
Interface.GetTractorBeam = Stub.GetTractorBeam
Interface.GetLaserColor = Stub.GetLaserColor
Interface.GetControlsEnabled = Stub.GetControlsEnabled
Interface.HasFullHearts = Stub.HasFullHearts
Interface.GetJarHearts = Stub.GetJarHearts
Interface.GetSoulCharge = Stub.GetSoulCharge
Interface.GetBloodCharge = Stub.GetBloodCharge
Interface.GetBatteryCharge = Stub.GetBatteryCharge
Interface.GetVelocityBeforeUpdate = Stub.GetVelocityBeforeUpdate
Interface.GetMaxHearts = Stub.GetMaxHearts
Interface.GetEternalHearts = Stub.GetEternalHearts
Interface.HasGoldenKey = Stub.HasGoldenKey
Interface.GetBabySkin = Stub.GetBabySkin
Interface.GetSubPlayer = Stub.GetSubPlayer
Interface.SetSoulCharge = Stub.SetSoulCharge
Interface.SetBloodCharge = Stub.SetBloodCharge
Interface.IsCoopGhost = Stub.IsCoopGhost
Interface.TryOpenStrangeDoor = Stub.TryOpenStrangeDoor
Interface.GetRottenHearts = Stub.GetRottenHearts
Interface.GetPocketItem = Stub.GetPocketItem
Interface.GetTearsOffset = Stub.GetTearsOffset
Interface.GetLastBufferedDirection = Stub.GetLastBufferedDirection
Interface.GetGoldenHearts = Stub.GetGoldenHearts
Interface.SetWeaponTypeEnabled = Stub.SetWeaponTypeEnabled
Interface.reset_weapons = Stub.reset_weapons
Interface.QueueExtraAnimation = Stub.QueueExtraAnimation
Interface.CanShoot = Stub.CanShoot
Interface.GetPillRNG = Stub.GetPillRNG
Interface.GetCardRNG = Stub.GetCardRNG
Interface.IsSubPlayer = Stub.IsSubPlayer
Interface.GetPoopMana = Stub.GetPoopMana
Interface.HasCurseMistEffect = Stub.HasCurseMistEffect
Interface.constructor = Stub.constructor
Interface.Free = Stub.Free
Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.get_default_color = Stub.get_default_color
Interface.reset_color = Stub.reset_color
Interface.get_time_scale = Stub.get_time_scale
Interface.ClearReferences = Stub.ClearReferences
Interface.IsValidTarget = Stub.IsValidTarget
Interface.clear_references = Stub.clear_references
Interface.InvalidateCoPlayerItems = Stub.InvalidateCoPlayerItems
Interface.IsPacifist = Stub.IsPacifist
Interface.PossessorProcessInput = Stub.PossessorProcessInput
Interface.trigger_max_hearts_removed = Stub.trigger_max_hearts_removed
Interface.AddMaxHearts = Stub.AddMaxHearts
Interface.AddHearts = Stub.AddHearts
Interface.eternal_heart_show_overlay = Stub.eternal_heart_show_overlay
Interface.AddEternalHearts = Stub.AddEternalHearts
Interface.AddSoulHearts = Stub.AddSoulHearts
Interface.AddBlackHearts = Stub.AddBlackHearts
Interface.RemoveBlackHeart = Stub.RemoveBlackHeart
Interface.IsBlackHeart = Stub.IsBlackHeart
Interface.GetNumBlackHearts = Stub.GetNumBlackHearts
Interface.AdjustBlackHearts = Stub.AdjustBlackHearts
Interface.AddJarHearts = Stub.AddJarHearts
Interface.AddCoins = Stub.AddCoins
Interface.AddBombs = Stub.AddBombs
Interface.AddKeys = Stub.AddKeys
Interface.AddGoldenKey = Stub.AddGoldenKey
Interface.RemoveGoldenKey = Stub.RemoveGoldenKey
Interface.sync_consumable_counts = Stub.sync_consumable_counts
Interface.consumable_count_changed = Stub.consumable_count_changed
Interface.restore_consumable_data = Stub.restore_consumable_data
Interface.AddBlueFlies = Stub.AddBlueFlies
Interface.RemoveBlueFly = Stub.RemoveBlueFly
Interface.AddLeprocy = Stub.AddLeprocy
Interface.AddBoneOrbital = Stub.AddBoneOrbital
Interface.AddSwarmFlyOrbital = Stub.AddSwarmFlyOrbital
Interface.TryUseKey = Stub.TryUseKey
Interface.play_item_anim_collectible = Stub.play_item_anim_collectible
Interface.weapon_item_anim_filter = Stub.weapon_item_anim_filter
Interface.play_item_anim_nullItem = Stub.play_item_anim_nullItem
Interface.play_item_anim_constDesc = Stub.play_item_anim_constDesc
Interface.set_item_anim_frame = Stub.set_item_anim_frame
Interface.get_costume_null_pos = Stub.get_costume_null_pos
Interface.translate_costume_sprite_path = Stub.translate_costume_sprite_path
Interface.rebuild_costume_map = Stub.rebuild_costume_map
Interface.AddCostume = Stub.AddCostume
Interface.AddNullCostume = Stub.AddNullCostume
Interface.RemoveCostume = Stub.RemoveCostume
Interface.IsItemCostumeVisible = Stub.IsItemCostumeVisible
Interface.IsNullItemCostumeVisible = Stub.IsNullItemCostumeVisible
Interface.IsCollectibleCostumeVisible = Stub.IsCollectibleCostumeVisible
Interface.ShuffleCostumes = Stub.ShuffleCostumes
Interface.ClearCostumes = Stub.ClearCostumes
Interface.QueueItem = Stub.QueueItem
Interface.DestroyQueueItem = Stub.DestroyQueueItem
Interface.FlushQueueItem = Stub.FlushQueueItem
Interface.increment_player_form_counter = Stub.increment_player_form_counter
Interface.add_player_form_costume = Stub.add_player_form_costume
Interface.set_itemstate = Stub.set_itemstate
Interface.render_chargebar = Stub.render_chargebar
Interface.GetCollectibleCount = Stub.GetCollectibleCount
Interface.CountTaggedCollectibles = Stub.CountTaggedCollectibles
Interface.AddCollectible = Stub.AddCollectible
Interface.check_lachryphagry = Stub.check_lachryphagry
Interface.check_familiar = Stub.check_familiar
Interface.EvaluateItems = Stub.EvaluateItems
Interface.RespawnFamiliars = Stub.RespawnFamiliars
Interface.GetNPCTarget = Stub.GetNPCTarget
Interface.SetAimDirection = Stub.SetAimDirection
Interface.HasCollectible = Stub.HasCollectible
Interface.NumCollectibleHeld = Stub.NumCollectibleHeld
Interface.VoidHasCollectible = Stub.VoidHasCollectible
Interface.HasTrinket = Stub.HasTrinket
Interface.HasGoldenTrinket = Stub.HasGoldenTrinket
Interface.TryHoldTrinket = Stub.TryHoldTrinket
Interface.GetMaxTrinkets = Stub.GetMaxTrinkets
Interface.DropTrinket = Stub.DropTrinket
Interface.AddTrinket = Stub.AddTrinket
Interface.TryRemoveTrinket = Stub.TryRemoveTrinket
Interface.TryRemoveSmeltedTrinket = Stub.TryRemoveSmeltedTrinket
Interface.TryReplaceTrinket = Stub.TryReplaceTrinket
Interface.TakeDamage = Stub.TakeDamage
Interface.SetFullHearts = Stub.SetFullHearts
Interface.SetTearsOffset = Stub.SetTearsOffset
Interface.GetFocusEntity = Stub.GetFocusEntity
Interface.get_movement_input = Stub.get_movement_input
Interface.get_shooting_input = Stub.get_shooting_input
Interface.get_body_move_dir = Stub.get_body_move_dir
Interface.get_weapon_modifiers = Stub.get_weapon_modifiers
Interface.control_movement = Stub.control_movement
Interface.control_shooting = Stub.control_shooting
Interface.GetBombFlags = Stub.GetBombFlags
Interface.GetBombVariant = Stub.GetBombVariant
Interface.GetBombScale = Stub.GetBombScale
Interface.control_bombs = Stub.control_bombs
Interface.GetMultiShotParams = Stub.GetMultiShotParams
Interface.GetMultiShotPositionVelocity = Stub.GetMultiShotPositionVelocity
Interface.GetFlyingOffset = Stub.GetFlyingOffset
Interface.GetMarkedTarget = Stub.GetMarkedTarget
Interface.fire = Stub.fire
Interface.get_death_anim = Stub.get_death_anim
Interface.sync_coplayer = Stub.sync_coplayer
Interface.GetActiveWeaponEntity = Stub.GetActiveWeaponEntity
Interface.CanTurnHead = Stub.CanTurnHead
Interface.GetFireDelay = Stub.GetFireDelay
Interface.SetFireDelay = Stub.SetFireDelay
Interface.Update = Stub.Update
Interface.IsHeadless = Stub.IsHeadless
Interface.render_player_sprite_helper = Stub.render_player_sprite_helper
Interface.render_player_sprite = Stub.render_player_sprite
Interface.Render = Stub.Render
Interface.RenderShadowLayer = Stub.RenderShadowLayer
Interface.RenderGlow = Stub.RenderGlow
Interface.RenderBody = Stub.RenderBody
Interface.RenderHead = Stub.RenderHead
Interface.RenderHeadBack = Stub.RenderHeadBack
Interface.RenderTop = Stub.RenderTop
Interface.handle_collision = Stub.handle_collision
Interface.RemoveCollectible = Stub.RemoveCollectible
Interface.RemoveCollectibleByHistoryIndex = Stub.RemoveCollectibleByHistoryIndex
Interface.TriggerCollectibleRemoved = Stub.TriggerCollectibleRemoved
Interface.DropCollectible = Stub.DropCollectible
Interface.DropCollectibleByHistoryIndex = Stub.DropCollectibleByHistoryIndex
Interface.ClearTemporaryEffects = Stub.ClearTemporaryEffects
Interface.FireTear = Stub.FireTear
Interface.GetTotalActiveCharge = Stub.GetTotalActiveCharge
Interface.SetActiveVarData = Stub.SetActiveVarData
Interface.GetActiveMaxCharge = Stub.GetActiveMaxCharge
Interface.GetActiveMaxChargeWrapper = Stub.GetActiveMaxChargeWrapper
Interface.GetActiveMinUsableCharge = Stub.GetActiveMinUsableCharge
Interface.SetActiveCharge = Stub.SetActiveCharge
Interface.AddActiveCharge = Stub.AddActiveCharge
Interface.control_active_item = Stub.control_active_item
Interface.HasTimedItem = Stub.HasTimedItem
Interface.TriggerEffectRemoved = Stub.TriggerEffectRemoved
Interface.update_effects = Stub.update_effects
Interface.update_ladder = Stub.update_ladder
Interface.TriggerEnemyDeath = Stub.TriggerEnemyDeath
Interface.FireBomb = Stub.FireBomb
Interface.FireBrimstone = Stub.FireBrimstone
Interface.TriggerDeath = Stub.TriggerDeath
Interface.Revive = Stub.Revive
Interface.ReviveFromCollectible = Stub.ReviveFromCollectible
Interface.ReviveFromTrinket = Stub.ReviveFromTrinket
Interface.MergeTwins = Stub.MergeTwins
Interface.add_pocketitem = Stub.add_pocketitem
Interface.AddCard = Stub.AddCard
Interface.AddPill = Stub.AddPill
Interface.GetCard = Stub.GetCard
Interface.GetPill = Stub.GetPill
Interface.SetCard = Stub.SetCard
Interface.SetPill = Stub.SetPill
Interface.control_pocket_item = Stub.control_pocket_item
Interface.control_drop_pocket_items = Stub.control_drop_pocket_items
Interface.SwapActiveItems = Stub.SwapActiveItems
Interface.RemovePocketItem = Stub.RemovePocketItem
Interface.DropPocketItem = Stub.DropPocketItem
Interface.try_spawn_pee_puddle = Stub.try_spawn_pee_puddle
Interface.TriggerNewStage = Stub.TriggerNewStage
Interface.TriggerFart = Stub.TriggerFart
Interface.GetTrinket = Stub.GetTrinket
Interface.SetControllerIndex = Stub.SetControllerIndex
Interface.TriggerRoomExit = Stub.TriggerRoomExit
Interface.TriggerNewRoom = Stub.TriggerNewRoom
Interface.TriggerNewRoom_TemporaryEffects = Stub.TriggerNewRoom_TemporaryEffects
Interface.TriggerRoomClear = Stub.TriggerRoomClear
Interface.HasPlayerForm = Stub.HasPlayerForm
Interface.CanAddCollectible = Stub.CanAddCollectible
Interface.get_laser_offset = Stub.get_laser_offset
Interface.FireTechLaser = Stub.FireTechLaser
Interface.get_tear_movement_inheritance = Stub.get_tear_movement_inheritance
Interface.CanEnterTrapDoor = Stub.CanEnterTrapDoor
Interface.IsExtraAnimationFinished = Stub.IsExtraAnimationFinished
Interface.AnimatePickup = Stub.AnimatePickup
Interface.AnimateCollectible = Stub.AnimateCollectible
Interface.AnimateTrinket = Stub.AnimateTrinket
Interface.AnimateCard = Stub.AnimateCard
Interface.AnimatePill = Stub.AnimatePill
Interface.AnimateTrapdoor = Stub.AnimateTrapdoor
Interface.AnimateLightTravel = Stub.AnimateLightTravel
Interface.AnimatePitfallIn = Stub.AnimatePitfallIn
Interface.AnimatePitfallOut = Stub.AnimatePitfallOut
Interface.AnimateAppear = Stub.AnimateAppear
Interface.AnimateTeleport = Stub.AnimateTeleport
Interface.AnimateHappy = Stub.AnimateHappy
Interface.AnimateSad = Stub.AnimateSad
Interface.AddPrettyFly = Stub.AddPrettyFly
Interface.PlayExtraAnimation = Stub.PlayExtraAnimation
Interface.PlayItemNullAnimation = Stub.PlayItemNullAnimation
Interface.TriggerActiveItemUsed = Stub.TriggerActiveItemUsed
Interface.DischargeActiveItem = Stub.DischargeActiveItem
Interface.TryRemoveCollectibleCostume = Stub.TryRemoveCollectibleCostume
Interface.TryRemoveTrinketCostume = Stub.TryRemoveTrinketCostume
Interface.TryRemoveNullCostume = Stub.TryRemoveNullCostume
Interface.GetMaxPocketItems = Stub.GetMaxPocketItems
Interface.clear_item_anim = Stub.clear_item_anim
Interface.clear_item_anim_collectible = Stub.clear_item_anim_collectible
Interface.clear_item_anim_nullitem = Stub.clear_item_anim_nullitem
Interface.is_item_anim_finished_collectible = Stub.is_item_anim_finished_collectible
Interface.is_item_anim_finished_nullitem = Stub.is_item_anim_finished_nullitem
Interface.get_animation_from_vector = Stub.get_animation_from_vector
Interface.TriggerTrinketAdded = Stub.TriggerTrinketAdded
Interface.TriggerTrinketRemoved = Stub.TriggerTrinketRemoved
Interface.FireKnife = Stub.FireKnife
Interface.FireBoneClub = Stub.FireBoneClub
Interface.FireBrimstoneBall = Stub.FireBrimstoneBall
Interface.RestoreGameState_CoPlayerData = Stub.RestoreGameState_CoPlayerData
Interface.RestoreGameState = Stub.RestoreGameState
Interface.check_death = Stub.check_death
Interface.RestoreGameState_PostLevelInit = Stub.RestoreGameState_PostLevelInit
Interface.store_sub_player = Stub.store_sub_player
Interface.StoreGameState = Stub.StoreGameState
Interface.DonateLuck = Stub.DonateLuck
Interface.UseCard = Stub.UseCard
Interface.UpdateFootEffects = Stub.UpdateFootEffects
Interface.SetFootprintColor = Stub.SetFootprintColor
Interface.IsFootstepFrame = Stub.IsFootstepFrame
Interface.NotifyGrabbed = Stub.NotifyGrabbed
Interface.UpdateGrabbedState = Stub.UpdateGrabbedState
Interface.UpdatePitfallState = Stub.UpdatePitfallState
Interface.TryDecreaseGlowingHourglassUses = Stub.TryDecreaseGlowingHourglassUses
Interface.update_babies = Stub.update_babies
Interface.trigger_baby_death = Stub.trigger_baby_death
Interface.InitPreLevelInitStats = Stub.InitPreLevelInitStats
Interface.InitPostLevelInitStats = Stub.InitPostLevelInitStats
Interface.InitPlayerSkin = Stub.InitPlayerSkin
Interface.init_baby_skin = Stub.init_baby_skin
Interface.FireDelayedBrimstone = Stub.FireDelayedBrimstone
Interface.CanPickupItem = Stub.CanPickupItem
Interface.IsHoldingItem = Stub.IsHoldingItem
Interface.IsHeldItemVisible = Stub.IsHeldItemVisible
Interface.AddBlueSpider = Stub.AddBlueSpider
Interface.ThrowBlueSpider = Stub.ThrowBlueSpider
Interface.RemoveBlueSpider = Stub.RemoveBlueSpider
Interface.GetExtraLives = Stub.GetExtraLives
Interface.GetTearHitParams = Stub.GetTearHitParams
Interface.GetTearFlagScale = Stub.GetTearFlagScale
Interface.Debug_SetHighLuck = Stub.Debug_SetHighLuck
Interface.get_glitch_baby_subtype = Stub.get_glitch_baby_subtype
Interface.HasInvincibility = Stub.HasInvincibility
Interface.HasInvisibility = Stub.HasInvisibility
Interface.HasPoisonImmunity = Stub.HasPoisonImmunity
Interface.CanCrushRocks = Stub.CanCrushRocks
Interface.CanPickRedHearts = Stub.CanPickRedHearts
Interface.CanPickSoulHearts = Stub.CanPickSoulHearts
Interface.CanPickBlackHearts = Stub.CanPickBlackHearts
Interface.RemoveSkinCostume = Stub.RemoveSkinCostume
Interface.ResetItemState = Stub.ResetItemState
Interface.SetShootingCooldown = Stub.SetShootingCooldown
Interface.NeedsCharge = Stub.NeedsCharge
Interface.FullCharge = Stub.FullCharge
Interface.preload_sounds = Stub.preload_sounds
Interface.CanUsePill = Stub.CanUsePill
Interface.UsePill = Stub.UsePill
Interface.AddDeadEyeCharge = Stub.AddDeadEyeCharge
Interface.ClearDeadEyeCharge = Stub.ClearDeadEyeCharge
Interface.GetZodiacEffect = Stub.GetZodiacEffect
Interface.ReplaceCostumeSprite = Stub.ReplaceCostumeSprite
Interface.TryDullRazorWisp = Stub.TryDullRazorWisp
Interface.update_purity_sprite = Stub.update_purity_sprite
Interface.update_isaac_pregnancy = Stub.update_isaac_pregnancy
Interface.TriggerHeartPickedUp = Stub.TriggerHeartPickedUp
Interface.SpawnMawOfVoid = Stub.SpawnMawOfVoid
Interface.AddGoldenBomb = Stub.AddGoldenBomb
Interface.RemoveGoldenBomb = Stub.RemoveGoldenBomb
Interface.add_dollar_bill_effect = Stub.add_dollar_bill_effect
Interface.get_cambion_level = Stub.get_cambion_level
Interface.get_cambion_pregnancy_level = Stub.get_cambion_pregnancy_level
Interface.shoot_red_candle = Stub.shoot_red_candle
Interface.shoot_blue_candle = Stub.shoot_blue_candle
Interface.do_zit_effect = Stub.do_zit_effect
Interface.TriggerPreVictoryLap = Stub.TriggerPreVictoryLap
Interface.GetSoundPitch = Stub.GetSoundPitch
Interface.AddJarFlies = Stub.AddJarFlies
Interface.IsPosInSpotLight = Stub.IsPosInSpotLight
Interface.AddGoldenHearts = Stub.AddGoldenHearts
Interface.CanPickGoldenHearts = Stub.CanPickGoldenHearts
Interface.update_red_hearts = Stub.update_red_hearts
Interface.trigger_golden_hearts = Stub.trigger_golden_hearts
Interface.update_golden_hearts = Stub.update_golden_hearts
Interface.AddBoneHearts = Stub.AddBoneHearts
Interface.CanPickBoneHearts = Stub.CanPickBoneHearts
Interface.IsBoneHeart = Stub.IsBoneHeart
Interface.TryPreventDeath = Stub.TryPreventDeath
Interface.update_bone_hearts = Stub.update_bone_hearts
Interface.GetHeartLimit = Stub.GetHeartLimit
Interface.GetHealthType = Stub.GetHealthType
Interface.GetEffectiveMaxHearts = Stub.GetEffectiveMaxHearts
Interface.InitBabyStats = Stub.InitBabyStats
Interface.FireTechXLaser = Stub.FireTechXLaser
Interface.TriggerNonEnemyTearHit = Stub.TriggerNonEnemyTearHit
Interface.IsFullSpriteRendering = Stub.IsFullSpriteRendering
Interface.play_delayed_sfx = Stub.play_delayed_sfx
Interface.GetTrinketMultiplier = Stub.GetTrinketMultiplier
Interface.UpdateCanShoot = Stub.UpdateCanShoot
Interface.WillPlayerRevive = Stub.WillPlayerRevive
Interface.GetGreedDonationBreakChance = Stub.GetGreedDonationBreakChance
Interface.AddHallowedGroundCountdown = Stub.AddHallowedGroundCountdown
Interface.GetEffectTarget = Stub.GetEffectTarget
Interface.update_forgotten_state = Stub.update_forgotten_state
Interface.spawn_forgotten_body = Stub.spawn_forgotten_body
Interface.swap_forgotten = Stub.swap_forgotten
Interface.Teleport = Stub.Teleport
Interface.PlayTeleportSoundEffect = Stub.PlayTeleportSoundEffect
Interface.GetParentPlayer = Stub.GetParentPlayer
Interface.CanRerollCollectible = Stub.CanRerollCollectible
Interface.get_greeds_gullet_hearts = Stub.get_greeds_gullet_hearts
Interface.update_greeds_gullet = Stub.update_greeds_gullet
Interface.ChangePlayerType = Stub.ChangePlayerType
Interface.TriggerPlayerTypeChanged = Stub.TriggerPlayerTypeChanged
Interface.IsLocalPlayer = Stub.IsLocalPlayer
Interface.RenderDebugInfo = Stub.RenderDebugInfo
Interface.GetGlyphOfBalanceDrop = Stub.GetGlyphOfBalanceDrop
Interface.GetEnterPosition = Stub.GetEnterPosition
Interface.CheckIsStuck = Stub.CheckIsStuck
Interface.AddMinisaac = Stub.AddMinisaac
Interface.TryTriggerPerfectBreath = Stub.TryTriggerPerfectBreath
Interface.init_twin = Stub.init_twin
Interface.TryHoldEntity = Stub.TryHoldEntity
Interface.ThrowHeldEntity = Stub.ThrowHeldEntity
Interface.TryThrow = Stub.TryThrow
Interface.AddFriendlyDip = Stub.AddFriendlyDip
Interface.AddBrokenHearts = Stub.AddBrokenHearts
Interface.AddSoulCharge = Stub.AddSoulCharge
Interface.GetEffectiveSoulCharge = Stub.GetEffectiveSoulCharge
Interface.update_soul_charges = Stub.update_soul_charges
Interface.AddBloodCharge = Stub.AddBloodCharge
Interface.GetEffectiveBloodCharge = Stub.GetEffectiveBloodCharge
Interface.update_blood_charges = Stub.update_blood_charges
Interface.AddRottenHearts = Stub.AddRottenHearts
Interface.CanPickRottenHearts = Stub.CanPickRottenHearts
Interface.update_book_of_virtues = Stub.update_book_of_virtues
Interface.AddRedemptionBonus = Stub.AddRedemptionBonus
Interface.AddUrnSouls = Stub.AddUrnSouls
Interface.AddGigaBombs = Stub.AddGigaBombs
Interface.get_effect_charge_multiplier = Stub.get_effect_charge_multiplier
Interface.try_end_astral_projection = Stub.try_end_astral_projection
Interface.reset_rock_bottom = Stub.reset_rock_bottom
Interface.update_wavy_cap_state = Stub.update_wavy_cap_state
Interface.spawn_saturnus_tears = Stub.spawn_saturnus_tears
Interface.GetInventoryMaxSize = Stub.GetInventoryMaxSize
Interface.CanAddCollectibleToInventory = Stub.CanAddCollectibleToInventory
Interface.SetPocketActiveItem = Stub.SetPocketActiveItem
Interface.GetTMaggyPermanentHearts = Stub.GetTMaggyPermanentHearts
Interface.GetSalvationScale = Stub.GetSalvationScale
Interface.UpdateSuplexState = Stub.UpdateSuplexState
Interface.TryAddToBagOfCrafting = Stub.TryAddToBagOfCrafting
Interface.SalvageCollectible = Stub.SalvageCollectible
Interface.GetMaxPoopMana = Stub.GetMaxPoopMana
Interface.AddPoopMana = Stub.AddPoopMana
Interface.CheckPoopSpellQueue = Stub.CheckPoopSpellQueue
Interface.UsePoopSpell = Stub.UsePoopSpell
Interface.RecomputeWispCollectibles = Stub.RecomputeWispCollectibles
Interface.TriggerCrackedOrb = Stub.TriggerCrackedOrb
Interface.AddItemCard = Stub.AddItemCard
Interface.update_lil_clot = Stub.update_lil_clot
Interface.AddLiquidPoopEffect = Stub.AddLiquidPoopEffect
Interface.TryFakeDeath = Stub.TryFakeDeath
Interface.AddCurseMistEffect = Stub.AddCurseMistEffect
Interface.RemoveCurseMistEffect = Stub.RemoveCurseMistEffect
Interface.AttachToMinecart = Stub.AttachToMinecart
Interface.add_samson_berserk_charge = Stub.add_samson_berserk_charge
Interface.add_ibs_charge = Stub.add_ibs_charge
Interface.revive_coop_ghost = Stub.revive_coop_ghost
Interface.morph_to_coop_ghost = Stub.morph_to_coop_ghost
Interface.assign_coop_ghost_skin = Stub.assign_coop_ghost_skin
Interface.get_crafting_output = Stub.get_crafting_output
Interface.HasPassiveBelial = Stub.HasPassiveBelial
Interface.CanOverrideActiveItem = Stub.CanOverrideActiveItem
Interface.spawn_clot_baby = Stub.spawn_clot_baby
Interface.TryForgottenThrow = Stub.TryForgottenThrow
Interface.PreTriggerGenesis = Stub.PreTriggerGenesis
Interface.ResetPlayer = Stub.ResetPlayer
Interface.PostTriggerGenesis = Stub.PostTriggerGenesis
Interface.HasInstantDeathCurse = Stub.HasInstantDeathCurse
Interface.IsHologram = Stub.IsHologram
Interface.TriggerEchoChamber = Stub.TriggerEchoChamber
Interface.GetGFuelAmount = Stub.GetGFuelAmount
Interface.GetGFuelWeaponType = Stub.GetGFuelWeaponType
Interface.GetName = Stub.GetName
Interface.GetSmoothBodyRotation = Stub.GetSmoothBodyRotation
Interface.HasFullHeartsAndSoulHearts = Stub.HasFullHeartsAndSoulHearts
Interface.GetJarFlies = Stub.GetJarFlies
Interface.GetActiveSubCharge = Stub.GetActiveSubCharge
Interface.GetMovementVector = Stub.GetMovementVector
Interface.GetRecentMovementVector = Stub.GetRecentMovementVector
Interface.GetBlackHearts = Stub.GetBlackHearts
Interface.HasGoldenBomb = Stub.HasGoldenBomb
Interface.GetTearRangeModifier = Stub.GetTearRangeModifier
Interface.GetControlsCooldown = Stub.GetControlsCooldown
Interface.AddControlsCooldown = Stub.AddControlsCooldown
Interface.GetLastDamageSource = Stub.GetLastDamageSource
Interface.GetLastDamageFlags = Stub.GetLastDamageFlags
Interface.GetTotalDamageTaken = Stub.GetTotalDamageTaken
Interface.SetSpriteScale = Stub.SetSpriteScale
Interface.GetLastActionTriggers = Stub.GetLastActionTriggers
Interface.GetBodyColor = Stub.GetBodyColor
Interface.GetHeadColor = Stub.GetHeadColor
Interface.GetNumGigaBombs = Stub.GetNumGigaBombs
Interface.GetPoopSpell = Stub.GetPoopSpell
Interface.GetModelingClayEffect = Stub.GetModelingClayEffect