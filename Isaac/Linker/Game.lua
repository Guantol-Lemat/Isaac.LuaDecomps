---@class Interface.Game
local Interface = require("Isaac.Interface.Game")

--#region Stub

local Stub = {}

---@param game Component.Game
---@return Component.Room
function Stub.GetRoom(game) end

---@param game Component.Game
---@return integer
function Stub.GetFrameCount(game) end

---@param game Component.Game
---@return Vector
function Stub.GetScreenShakeOffset(game) end

---@param game Component.Game
---@return Component.PlayerManager
function Stub.GetPlayerManager(game) end

---@param game Component.Game
---@param Index integer
---@return Component.Entity.Player
function Stub.GetPlayer(game, Index) end

---@param game Component.Game
---@return integer
function Stub.GetNumPlayers(game) end

---@param game Component.Game
---@return Component.HUD
function Stub.GetHUD(game) end

---@param ctx Context.Common
---@return Component.RoomTransition
function Stub.GetRoomTransition(ctx) end

---@param ctx Context.Common
---@return Component.RoomConfig
function Stub.GetRoomConfig(ctx) end

---@param game Component.Game
---@param GameStateFlag GameStateFlag | integer
---@return boolean
function Stub.GetStateFlag(game, GameStateFlag) end

---@param game Component.Game
---@return Challenge | integer
function Stub.GetChallenge(game) end

---@param ctx Context.Common
---@return Component.DailyChallenge
function Stub.GetDailyChallenge(ctx) end

---@param game Component.Game
---@return Component.Level
function Stub.GetLevel(game) end

---@param ctx Context.Common
---@param game Component.Game
---@param type EntityType | integer
---@param variant integer
---@param position Vector
---@param velocity Vector
---@param spawner Component.Entity?
---@param subtype integer
---@param seed integer
---@return Component.Entity
function Stub.Spawn(ctx, game, type, variant, position, velocity, spawner, subtype, seed) end

---@param game Component.Game
---@param debug eDebugId | integer
---@return boolean
function Stub.GetDebugFlag(game, debug) end

---@param game Component.Game
---@return Component.ItemPool
function Stub.GetItemPool(game) end

---@param game Component.Game
---@return Component.Seeds
function Stub.GetSeeds(game) end

---@param game Component.Game
---@return number
function Stub.GetDarknessModifier(game) end

---@param game Component.Game
---@return number
function Stub.GetTargetDarkness(game) end

---@param game Component.Game
---@param Darkness number
---@param Timeout integer
function Stub.Darken(game, Darkness, Timeout) end

---@param game Component.Game
---@return unknown
function Stub.GetItemOverlay(game) end

---@param game Component.Game
---@return boolean
function Stub.HasHallucination(game) end

---@param game Component.Game
---@param flag integer
---@param value boolean
function Stub.SetStateFlag(game, flag, value) end

---@param game Component.Game
---@return Difficulty | integer
function Stub.GetDifficulty(game) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.ShowFortuneGeneral(ctx, game) end

---@param game Component.Game
---@return integer
function Stub.GetDevilRoomDeals(game) end

---@param game Component.Game
---@return Component.Ambush
function Stub.GetAmbush(game) end

---@param ctx Context.Common
---@return unknown
function Stub.GetMagicSkinUses(ctx) end

---@param ctx Context.Common
---@param param_1 integer
---@return unknown
function Stub.AddMagicSkinUses(ctx, param_1) end

---@param game Component.Game
---@return Component.ProceduralItemManager
function Stub.GetProceduralItemManager(game) end

---@param ctx Context.Common
function Stub.TriggerRKey(ctx) end

---@param ctx Context.Common
---@return Component.StageTransition
function Stub.GetStageTransition(ctx) end

---@param ctx Context.Common
---@return boolean
function Stub.GetStartingFromState_qqq(ctx) end

---@param ctx Context.Common
function Stub.ShowFortuneSeed(ctx) end

---@param game Component.Game
---@return integer
function Stub.GetDonationModGreed(game) end

---@param game Component.Game
---@param seedType SeedEffect | integer
---@return boolean
function Stub.HasSeedEffect(game, seedType) end

---@param ctx Context.Common
---@return Component.BossPool
function Stub.GetBossPool(ctx) end

---@param ctx Context.Common
---@param game Component.Game
---@param debug integer
function Stub.ToggleDebugFlag(ctx, game, debug) end

---@param ctx Context.Common
---@return Component.Console
function Stub.GetConsole(ctx) end

---@param game Component.Game
---@return Font
function Stub.GetFont(game) end

---@param game Component.Game
---@return integer
function Stub.GetVictoryLap(game) end

---@param game Component.Game
---@return boolean
function Stub.InChallenge(game) end

---@param ctx Context.Common
---@return Component.Game
function Stub.New(ctx) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.Destructor(ctx, game) end

---@param ctx Context.Common
---@return unknown
function Stub.CreateSurfaces(ctx) end

---@param ctx Context.Common
function Stub.PostLanguageSwitch(ctx) end

function Stub.LogPerformanceCounters() end

---@param game Component.Game
function Stub.init_vars(game) end

---@param game Component.Game
function Stub.ResetState(game) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.Init(ctx, game) end

---@param game Component.Game
---@param Speed number
function Stub.Fadein(game, Speed) end

---@param game Component.Game
---@param Speed number
---@param FadeoutTarget integer
function Stub.Fadeout(game, Speed, FadeoutTarget) end

---@param ctx Context.Common
---@param game Component.Game
---@param playerType integer
---@param challenge Challenge | integer
---@param seeds Component.Seeds
---@param difficulty Difficulty | integer
function Stub.Start(ctx, game, playerType, challenge, seeds, difficulty) end

---@param ctx Context.Common
---@param unk unknown -- something relating to net controllers
---@param challenge unknown
---@param seed Component.Seeds
---@param initState Component.GameState?
function Stub.NetStart(ctx, unk, challenge, seed, initState) end

---@param ctx Context.Common
---@param game Component.Game
---@param daily Component.DailyChallenge
function Stub.StartDailyChallenge(ctx, game, daily) end

---@param game Component.Game
---@param ctx Context.Common
---@param state Component.GameState
function Stub.StartFromSavedState(game, ctx, state) end

---@param ctx Context.Common
---@param game Component.Game
---@param state Component.GameState
function Stub.StartFromRerunState(ctx, game, state) end

---@param ctx Context.Common
---@param game Component.Game
---@param levelStage integer
---@param stageType integer
---@param difficulty integer
---@param roomPath string
function Stub.StartDebug(ctx, game, levelStage, stageType, difficulty, roomPath) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.NextVictoryLap(ctx, game) end

---@param ctx Context.Common
---@return boolean
function Stub.IsHardMode(ctx) end

---@param game Component.Game
---@return boolean
function Stub.IsGreedMode(game) end

---@param ctx Context.Common
---@param game Component.Game
---@param param_1 Component.GameState
---@param param_2 boolean
function Stub.RestoreState(ctx, game, param_1, param_2) end

---@param ctx Context.Common
---@param game Component.Game
---@param state Component.GameState
function Stub.SaveState(ctx, game, state) end

---@param ctx Context.Common
---@return LevelCurse | integer
function Stub.GetSpecialSeedPermanentCurses(ctx) end

---@param ctx Context.Common
---@return LevelCurse | integer
function Stub.GetSpecialSeedBannedCurses(ctx) end

---@param ctx Context.Common
---@param game Component.Game
---@param Ending Ending | integer
function Stub.End(ctx, game, Ending) end

---@param ctx Context.Common
---@param game Component.Game
---@param param_1 boolean
---@return Ending | integer
function Stub.GetChestEnding(ctx, game, param_1) end

---@param ctx Context.Common
---@param ShouldSave boolean
function Stub.Exit(ctx, ShouldSave) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.ProcessInput(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.Update(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.Render(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
---@return boolean
function Stub.IsPaused(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.InterpolatePositions(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
---@param RoomIndex GridRooms | integer
---@param Direction Direction | integer
---@param Animation RoomTransitionAnim | integer
---@param Player Component.Entity.Player
---@param Dimension Dimension | integer
function Stub.StartRoomTransition(ctx, game, RoomIndex, Direction, Animation, Player, Dimension) end

---@param ctx Context.Common
---@param game Component.Game
---@param SameStage boolean
---@param Animation eStageTransitionAnim | integer
---@param Player Component.Entity.Player
function Stub.StartStageTransition(ctx, game, SameStage, Animation, Player) end

---@param ctx Context.Common
---@param game Component.Game
---@param RoomIndex GridRooms | integer
---@param Dimension integer
function Stub.ChangeRoom(ctx, game, RoomIndex, Dimension) end

---@param ctx Context.Common
---@param game Component.Game
---@param IAmErrorRoom boolean
---@param Seed integer
---@param Player Component.Entity.Player
function Stub.MoveToRandomRoom(ctx, game, IAmErrorRoom, Seed, Player) end

---@param ctx Context.Common
---@param game Component.Game
---@param Type EntityType | integer
---@param Variant integer
---@param Position Vector
---@param Velocity Vector
---@param Spawner Component.Entity?
---@param Subtype integer
---@param Seed integer
---@param Force_qqq boolean
---@return Component.Entity
function Stub.SpawnEx(ctx, game, Type, Variant, Position, Velocity, Spawner, Subtype, Seed, Force_qqq) end

---@param ctx Context.Common
---@param Desc Component.Entity.EntityDesc
---@param Position Vector
---@param Spawner Component.Entity
---@return Component.Entity.Npc
function Stub.SpawnEntityDesc(ctx, Desc, Position, Spawner) end

---@param ctx Context.Common
---@param Position Vector
---@param Radius number
---@param DamageSource Component.Entity
---@param DamageFlags integer
---@param CanDamageNPCs_qqq boolean
---@param PlayerDamage number
---@param NPCDamage number
---@param TearFlags BitSet128
function Stub.RadiusDamage(ctx, Position, Radius, DamageSource, DamageFlags, CanDamageNPCs_qqq, PlayerDamage, NPCDamage, TearFlags) end

---@param ctx Context.Common
---@param vec1 Vector
---@param vec2 Vector
---@param entity Component.Entity
---@param playerDamageRelated number
---@param enemyDamage number
---@param tearFlags BitSet128
function Stub.AreaDamage(ctx, vec1, vec2, entity, playerDamageRelated, enemyDamage, tearFlags) end

---@param ctx Context.Common
---@param game Component.Game
---@param Position Vector
---@param Damage number
---@param Radius number
---@param LineCheck boolean
---@param Source Component.Entity
---@param TearFlags BitSet128
---@param DamageFlags DamageFlags | integer
---@param DamageSource boolean
function Stub.BombDamage(ctx, game, Position, Damage, Radius, LineCheck, Source, TearFlags, DamageFlags, DamageSource) end

---@param ctx Context.Common
---@param game Component.Game
---@param Position Vector
---@param Damage number
---@param TearFlags BitSet128
---@param Color Color
---@param Source Component.Entity
---@param RadiusMult number
---@param LineCheck boolean
---@param DamageFlagsL DamageFlags | integer
---@param DamageFlagsH DamageFlags | integer
---@param DamageSource boolean
function Stub.BombExplosionEffects(ctx, game, Position, Damage, TearFlags, Color, Source, RadiusMult, LineCheck, DamageFlagsL, DamageFlagsH, DamageSource) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.FUN_005e2ea0(ctx, timer) end

---@param ctx Context.Common
---@param game Component.Game
---@param Position Vector
---@param Radius number
---@param TearFlags BitSet128
---@param Source Component.Entity
---@param RadiusMult number
function Stub.BombTearflagEffects(ctx, game, Position, Radius, TearFlags, Source, RadiusMult) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.DelayedExplosionDebrisSFX(ctx, timer) end

---@param ctx Context.Common
---@param game Component.Game
---@param Position Vector
---@param Scale number
---@return Component.Entity
function Stub.SpawnBombCrater(ctx, game, Position, Scale) end

---@param ctx Context.Common
---@param game Component.Game
---@param Pos Vector
---@param ParticleType EffectVariant | integer
---@param NumParticles integer
---@param Speed number
---@param Color Color
---@param Height number
---@param SubType integer
function Stub.SpawnParticles(ctx, game, Pos, ParticleType, NumParticles, Speed, Color, Height, SubType) end

---@param game Component.Game
---@param Boss integer
---@param Variant integer
function Stub.AddEncounteredBoss(game, Boss, Variant) end

---@param game Component.Game
---@param Boss EntityType | integer
---@param Variant integer
---@return boolean
function Stub.HasEncounteredBoss(game, Boss, Variant) end

---@param game Component.Game
---@return integer
function Stub.GetGreedWavesNum(game) end

---@param game Component.Game
---@return integer
function Stub.GetGreedBossWaveNum(game) end

---@param ctx Context.Common
---@param pos Vector
---@param color KColor
---@param text string
---@param size integer
function Stub.DebugText(ctx, pos, color, text, size) end

---@param ctx Context.Common
---@param game Component.Game
---@param timeout integer
function Stub.ShakeScreen(ctx, game, timeout) end

---@param ctx Context.Common
---@param game Component.Game
---@param pos Vector
---@param amplitude number
---@param speed number
---@param duration integer
function Stub.MakeShockwave(ctx, game, pos, amplitude, speed, duration) end

---@param ctx Context.Common
---@return number
function Stub.GetPixelationRenderAmount(ctx) end

---@param game Component.Game
---@param time integer
---@param strength number
function Stub.SetBloom(game, time, strength) end

---@param game Component.Game
---@param Vector Vector
---@param Radius number
---@return Component.Entity.Player
function Stub.GetRandomPlayer(game, Vector, Radius) end

---@param ctx Context.Common
---@param game Component.Game
---@param Pos Vector
---@return Component.Entity.Player
function Stub.GetNearestPlayer(ctx, game, Pos) end

---@param ctx Context.Common
---@param target Vector
---@param NoPlayerVariants boolean
---@param RequireGridCollision_qqq boolean
---@param AllowNoEntityCollision boolean
---@return Component.Entity.Player
function Stub.GetNearestPlayerEx(ctx, target, NoPlayerVariants, RequireGridCollision_qqq, AllowNoEntityCollision) end

---@param ctx Context.Common
---@param game Component.Game
---@param Position Vector
---@param Radius number
---@param Source Component.Entity
---@param FartScale number
---@param FartSubType integer
---@param FartColor Color
function Stub.Fart(ctx, game, Position, Radius, Source, FartScale, FartSubType, FartColor) end

---@param ctx Context.Common
---@param Position Vector
---@param Radius number
---@param Source Component.Entity
function Stub.CharmFart(ctx, Position, Radius, Source) end

---@param ctx Context.Common
---@param game Component.Game
---@param Position Vector
---@param Radius number
---@param Source Component.Entity
---@param ShowEffect boolean
---@param DoSuperKnockback boolean
function Stub.ButterBeanFart(ctx, game, Position, Radius, Source, ShowEffect, DoSuperKnockback) end

---@param ctx Context.Common
---@param game unknown
function Stub.AddDevilRoomDeal(ctx, game) end

---@param game Component.Game
---@param Donation integer
function Stub.DonateGreed(game, Donation) end

---@param game Component.Game
---@param Donate integer
function Stub.DonateAngel(game, Donate) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.RerollLevelCollectibles(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
---@param Seed integer
function Stub.RerollLevelPickups(ctx, game, Seed) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.FinishChallenge(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
---@return boolean
function Stub.AchievementUnlocksDisallowed(ctx, game) end

---@param ctx Context.Common
---@param game Component.Game
---@param Enemy Component.Entity.Npc
---@param ignoreRelativeHP_qqq boolean
---@return boolean
function Stub.RerollEnemy(ctx, game, Enemy, ignoreRelativeHP_qqq) end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
function Stub.DevolveEnemy(ctx, npc) end

---@param ctx Context.Common
---@param game Component.Game
---@param FrameCount integer
---@param BackdropId BackdropType | integer
function Stub.ShowHallucination(ctx, game, FrameCount, BackdropId) end

---@param game Component.Game
---@param position Vector
---@param force number
---@param radius number
---@param funcBoolEntityPtr unknown
function Stub.UpdateStrangeAttractor(game, position, force, radius, funcBoolEntityPtr) end

---@param ctx Context.Common
---@param leaveDoor DoorSlot | integer
function Stub.StoreGlowingHourGlassState(ctx, leaveDoor) end

---@param ctx Context.Common
---@param game Component.Game
---@param player Component.Entity.Player
function Stub.RestoreGlowingHourGlassState(ctx, game, player) end

---@param game Component.Game
---@return Component.GlowingHourglassState
function Stub.GetGlowingHourGlassState(game) end

---@param ctx Context.Common
---@param param_1 Component.FXLayers.ColorModState
---@param lerp boolean
---@param rate number
function Stub.SetColorModifier(ctx, param_1, lerp, rate) end

---@param ctx Context.Common
---@param game Component.Game
---@return Component.ChallengeParam
function Stub.GetChallengeParams(ctx, game) end

---@param ctx Context.Common
---@param currentPos Vector
---@param entity Component.Entity
---@param guessingLimit number
---@param bool1 boolean
---@param bool2 boolean
---@param fn function
---@return Component.Entity.Player
function Stub.FindPlayerTarget(ctx, currentPos, entity, guessingLimit, bool1, bool2, fn) end

---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 Component.Entity
---@param guessingLimit number
---@param fn function
---@return Component.Entity
function Stub.FindEnemyTarget(ctx, param_1, param_2, guessingLimit, fn) end

---@param type EntityType | integer
---@param variant integer
---@param subtype integer
function Stub.fix_erased_enemy(type, variant, subtype) end

---@param ctx Context.Common
---@param game Component.Game
---@param entity Component.Entity
function Stub.AddErasedEnemy(ctx, game, entity) end

---@param ctx Context.Common
---@param game Component.Game
---@param Entity Component.Entity
---@return boolean
function Stub.ShouldEraseEnemy(ctx, game, Entity) end

---@param ctx Context.Common
---@param Entity Component.Entity.Npc
function Stub.EraseEnemy(ctx, Entity) end

---@param ctx Context.Common
---@param position Vector
---@param damage number
---@param tearFlags BitSet128
---@param spawner Component.Entity
---@return Component.Entity.Effect
function Stub.ChainLightning(ctx, position, damage, tearFlags, spawner) end

---@param ctx Context.Common
---@param game Component.Game
---@param Level LevelStage | integer
function Stub.SaveBackwardsStage(ctx, game, Level) end

---@param ctx Context.Common
---@return integer
function Stub.GetGFuelAmount(ctx) end

---@param ctx Context.Common
---@return Component.Minimap
function Stub.GetMinimap(ctx) end

---@param game Component.Game
---@param Time integer
function Stub.SetBossRushParTime(game, Time) end

---@param game Component.Game
---@return integer
function Stub.GetTreasureRoomVisitCount(game) end

---@param game Component.Game
function Stub.ClearDonationModGreed(game) end

---@param game Component.Game
function Stub.ClearDonationModAngel(game) end

---@param ctx Context.Common
---@param stage LevelStage | integer
---@return Component.BackwardsStageDesc
function Stub.GetBackwardsStageDesc(ctx, stage) end

---@param ctx Context.Common
---@param rng RNG
---@return RoomType | integer
function Stub.GetRandomRedRoomType(ctx, rng) end

---@param ctx Context.Common
---@return Component.PauseScreen
function Stub.GetPauseScreen(ctx) end

---@param ctx Context.Common
---@param game Component.Game
function Stub.ShowRule(ctx, game) end

---@param game Component.Game
---@param Stage integer
function Stub.SetLastLevelWithDamage(game, Stage) end

---@param game Component.Game
---@param Stage integer
function Stub.SetLastLevelWithoutHalfHp(game, Stage) end

---@param game Component.Game
---@return integer
function Stub.GetLastLevelWithoutHalfHp(game) end

---@param game Component.Game
---@param Duration integer
function Stub.AddPixelation(game, Duration) end

---@param game Component.Game
---@return integer
function Stub.GetBossRushParTime(game) end

---@param game Component.Game
---@return integer
function Stub.GetBlueWombParTime(game) end

---@param game Component.Game
---@param Stage LevelStage | integer
function Stub.SetLastDevilRoomStage(game, Stage) end

---@param game Component.Game
---@return LevelStage | integer
function Stub.GetLastDevilRoomStage(game) end

---@param game Component.Game
function Stub.AddTreasureRoomsVisited(game) end

---@param game Component.Game
---@return integer
function Stub.GetStagesWithoutDamage(game) end

---@param game Component.Game
---@return integer
function Stub.GetDonationModAngel(game) end

---@param game Component.Game
---@return LevelStage | integer
function Stub.GetLastLevelWithDamage(game) end

---@param game Component.Game
---@param offset Vector
function Stub.SetScreenShakeOffset(game, offset) end

---@param param_1 RoomType | integer
---@return string
function Stub.GetRoomTypeName(param_1) end

---@param game Component.Game
---@param Time integer
function Stub.SetBlueWombParTime(game, Time) end

---@param game Component.Game
function Stub.AddStageWithoutHeartsPicked(game) end

---@param game Component.Game
function Stub.ClearStagesWithoutHeartsPicked(game) end

---@param game Component.Game
---@return integer
function Stub.GetStagesWithoutHeartsPicked(game) end

---@param game Component.Game
function Stub.AddStageWithoutDamage(game) end

---@param game Component.Game
function Stub.ClearStagesWIthoutDamage(game) end

---@param game Component.Game
---@return integer
function Stub.GetNumEncoutneredBosses(game) end

---@param game Component.Game
---@return integer
function Stub.GetScreenShakeCountdown(game) end

---@param game Component.Game
---@param Challenge integer
function Stub.SetChallenge(game, Challenge) end

---@param game Component.Game
---@param param_1 Vector
---@param param_2 number
---@param param_3 number
function Stub.UpdateStrangeAttractor_wrapper(game, param_1, param_2, param_3) end

---@param ctx Context.Common
---@return boolean
function Stub.IsGreedBoss(ctx) end

---@param ctx Context.Common
---@return boolean
function Stub.IsGreedFinalBoss(ctx) end

--endregion

Interface.GetRoom = Stub.GetRoom
Interface.GetFrameCount = Stub.GetFrameCount
Interface.GetScreenShakeOffset = Stub.GetScreenShakeOffset
Interface.GetPlayerManager = Stub.GetPlayerManager
Interface.GetPlayer = Stub.GetPlayer
Interface.GetNumPlayers = Stub.GetNumPlayers
Interface.GetHUD = Stub.GetHUD
Interface.GetRoomTransition = Stub.GetRoomTransition
Interface.GetRoomConfig = Stub.GetRoomConfig
Interface.GetStateFlag = Stub.GetStateFlag
Interface.GetChallenge = Stub.GetChallenge
Interface.GetDailyChallenge = Stub.GetDailyChallenge
Interface.GetLevel = Stub.GetLevel
Interface.Spawn = Stub.Spawn
Interface.GetDebugFlag = Stub.GetDebugFlag
Interface.GetItemPool = Stub.GetItemPool
Interface.GetSeeds = Stub.GetSeeds
Interface.GetDarknessModifier = Stub.GetDarknessModifier
Interface.GetTargetDarkness = Stub.GetTargetDarkness
Interface.Darken = Stub.Darken
Interface.GetItemOverlay = Stub.GetItemOverlay
Interface.HasHallucination = Stub.HasHallucination
Interface.SetStateFlag = Stub.SetStateFlag
Interface.GetDifficulty = Stub.GetDifficulty
Interface.ShowFortuneGeneral = Stub.ShowFortuneGeneral
Interface.GetDevilRoomDeals = Stub.GetDevilRoomDeals
Interface.GetAmbush = Stub.GetAmbush
Interface.GetMagicSkinUses = Stub.GetMagicSkinUses
Interface.AddMagicSkinUses = Stub.AddMagicSkinUses
Interface.GetProceduralItemManager = Stub.GetProceduralItemManager
Interface.TriggerRKey = Stub.TriggerRKey
Interface.GetStageTransition = Stub.GetStageTransition
Interface.GetStartingFromState_qqq = Stub.GetStartingFromState_qqq
Interface.ShowFortuneSeed = Stub.ShowFortuneSeed
Interface.GetDonationModGreed = Stub.GetDonationModGreed
Interface.HasSeedEffect = Stub.HasSeedEffect
Interface.GetBossPool = Stub.GetBossPool
Interface.ToggleDebugFlag = Stub.ToggleDebugFlag
Interface.GetConsole = Stub.GetConsole
Interface.GetFont = Stub.GetFont
Interface.GetVictoryLap = Stub.GetVictoryLap
Interface.InChallenge = Stub.InChallenge
Interface.New = Stub.New
Interface.Destructor = Stub.Destructor
Interface.CreateSurfaces = Stub.CreateSurfaces
Interface.PostLanguageSwitch = Stub.PostLanguageSwitch
Interface.LogPerformanceCounters = Stub.LogPerformanceCounters
Interface.init_vars = Stub.init_vars
Interface.ResetState = Stub.ResetState
Interface.Init = Stub.Init
Interface.Fadein = Stub.Fadein
Interface.Fadeout = Stub.Fadeout
Interface.Start = Stub.Start
Interface.NetStart = Stub.NetStart
Interface.StartDailyChallenge = Stub.StartDailyChallenge
Interface.StartFromSavedState = Stub.StartFromSavedState
Interface.StartFromRerunState = Stub.StartFromRerunState
Interface.StartDebug = Stub.StartDebug
Interface.NextVictoryLap = Stub.NextVictoryLap
Interface.IsHardMode = Stub.IsHardMode
Interface.IsGreedMode = Stub.IsGreedMode
Interface.RestoreState = Stub.RestoreState
Interface.SaveState = Stub.SaveState
Interface.GetSpecialSeedPermanentCurses = Stub.GetSpecialSeedPermanentCurses
Interface.GetSpecialSeedBannedCurses = Stub.GetSpecialSeedBannedCurses
Interface.End = Stub.End
Interface.GetChestEnding = Stub.GetChestEnding
Interface.Exit = Stub.Exit
Interface.ProcessInput = Stub.ProcessInput
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.IsPaused = Stub.IsPaused
Interface.InterpolatePositions = Stub.InterpolatePositions
Interface.StartRoomTransition = Stub.StartRoomTransition
Interface.StartStageTransition = Stub.StartStageTransition
Interface.ChangeRoom = Stub.ChangeRoom
Interface.MoveToRandomRoom = Stub.MoveToRandomRoom
Interface.SpawnEx = Stub.SpawnEx
Interface.SpawnEntityDesc = Stub.SpawnEntityDesc
Interface.RadiusDamage = Stub.RadiusDamage
Interface.AreaDamage = Stub.AreaDamage
Interface.BombDamage = Stub.BombDamage
Interface.BombExplosionEffects = Stub.BombExplosionEffects
Interface.FUN_005e2ea0 = Stub.FUN_005e2ea0
Interface.BombTearflagEffects = Stub.BombTearflagEffects
Interface.DelayedExplosionDebrisSFX = Stub.DelayedExplosionDebrisSFX
Interface.SpawnBombCrater = Stub.SpawnBombCrater
Interface.SpawnParticles = Stub.SpawnParticles
Interface.AddEncounteredBoss = Stub.AddEncounteredBoss
Interface.HasEncounteredBoss = Stub.HasEncounteredBoss
Interface.GetGreedWavesNum = Stub.GetGreedWavesNum
Interface.GetGreedBossWaveNum = Stub.GetGreedBossWaveNum
Interface.DebugText = Stub.DebugText
Interface.ShakeScreen = Stub.ShakeScreen
Interface.MakeShockwave = Stub.MakeShockwave
Interface.GetPixelationRenderAmount = Stub.GetPixelationRenderAmount
Interface.SetBloom = Stub.SetBloom
Interface.GetRandomPlayer = Stub.GetRandomPlayer
Interface.GetNearestPlayer = Stub.GetNearestPlayer
Interface.GetNearestPlayerEx = Stub.GetNearestPlayerEx
Interface.Fart = Stub.Fart
Interface.CharmFart = Stub.CharmFart
Interface.ButterBeanFart = Stub.ButterBeanFart
Interface.AddDevilRoomDeal = Stub.AddDevilRoomDeal
Interface.DonateGreed = Stub.DonateGreed
Interface.DonateAngel = Stub.DonateAngel
Interface.RerollLevelCollectibles = Stub.RerollLevelCollectibles
Interface.RerollLevelPickups = Stub.RerollLevelPickups
Interface.FinishChallenge = Stub.FinishChallenge
Interface.AchievementUnlocksDisallowed = Stub.AchievementUnlocksDisallowed
Interface.RerollEnemy = Stub.RerollEnemy
Interface.DevolveEnemy = Stub.DevolveEnemy
Interface.ShowHallucination = Stub.ShowHallucination
Interface.UpdateStrangeAttractor = Stub.UpdateStrangeAttractor
Interface.StoreGlowingHourGlassState = Stub.StoreGlowingHourGlassState
Interface.RestoreGlowingHourGlassState = Stub.RestoreGlowingHourGlassState
Interface.GetGlowingHourGlassState = Stub.GetGlowingHourGlassState
Interface.SetColorModifier = Stub.SetColorModifier
Interface.GetChallengeParams = Stub.GetChallengeParams
Interface.FindPlayerTarget = Stub.FindPlayerTarget
Interface.FindEnemyTarget = Stub.FindEnemyTarget
Interface.fix_erased_enemy = Stub.fix_erased_enemy
Interface.AddErasedEnemy = Stub.AddErasedEnemy
Interface.ShouldEraseEnemy = Stub.ShouldEraseEnemy
Interface.EraseEnemy = Stub.EraseEnemy
Interface.ChainLightning = Stub.ChainLightning
Interface.SaveBackwardsStage = Stub.SaveBackwardsStage
Interface.GetGFuelAmount = Stub.GetGFuelAmount
Interface.GetMinimap = Stub.GetMinimap
Interface.SetBossRushParTime = Stub.SetBossRushParTime
Interface.GetTreasureRoomVisitCount = Stub.GetTreasureRoomVisitCount
Interface.ClearDonationModGreed = Stub.ClearDonationModGreed
Interface.ClearDonationModAngel = Stub.ClearDonationModAngel
Interface.GetBackwardsStageDesc = Stub.GetBackwardsStageDesc
Interface.GetRandomRedRoomType = Stub.GetRandomRedRoomType
Interface.GetPauseScreen = Stub.GetPauseScreen
Interface.ShowRule = Stub.ShowRule
Interface.SetLastLevelWithDamage = Stub.SetLastLevelWithDamage
Interface.SetLastLevelWithoutHalfHp = Stub.SetLastLevelWithoutHalfHp
Interface.GetLastLevelWithoutHalfHp = Stub.GetLastLevelWithoutHalfHp
Interface.AddPixelation = Stub.AddPixelation
Interface.GetBossRushParTime = Stub.GetBossRushParTime
Interface.GetBlueWombParTime = Stub.GetBlueWombParTime
Interface.SetLastDevilRoomStage = Stub.SetLastDevilRoomStage
Interface.GetLastDevilRoomStage = Stub.GetLastDevilRoomStage
Interface.AddTreasureRoomsVisited = Stub.AddTreasureRoomsVisited
Interface.GetStagesWithoutDamage = Stub.GetStagesWithoutDamage
Interface.GetDonationModAngel = Stub.GetDonationModAngel
Interface.GetLastLevelWithDamage = Stub.GetLastLevelWithDamage
Interface.SetScreenShakeOffset = Stub.SetScreenShakeOffset
Interface.GetRoomTypeName = Stub.GetRoomTypeName
Interface.SetBlueWombParTime = Stub.SetBlueWombParTime
Interface.AddStageWithoutHeartsPicked = Stub.AddStageWithoutHeartsPicked
Interface.ClearStagesWithoutHeartsPicked = Stub.ClearStagesWithoutHeartsPicked
Interface.GetStagesWithoutHeartsPicked = Stub.GetStagesWithoutHeartsPicked
Interface.AddStageWithoutDamage = Stub.AddStageWithoutDamage
Interface.ClearStagesWIthoutDamage = Stub.ClearStagesWIthoutDamage
Interface.GetNumEncoutneredBosses = Stub.GetNumEncoutneredBosses
Interface.GetScreenShakeCountdown = Stub.GetScreenShakeCountdown
Interface.SetChallenge = Stub.SetChallenge
Interface.UpdateStrangeAttractor_wrapper = Stub.UpdateStrangeAttractor_wrapper
Interface.IsGreedBoss = Stub.IsGreedBoss
Interface.IsGreedFinalBoss = Stub.IsGreedFinalBoss