---@class Interface.Room
local Interface = require("Isaac.Interface.Room")

--#region Stub

local Stub = {}

---@param room Component.Room
---@return number
function Stub.GetWaterAmount(room) end

---@param room Component.Room
---@return integer
function Stub.GetGridHeight(room) end

---@param room Component.Room
---@return integer
function Stub.GetGridWidth(room) end

---@param room Component.Room
---@return Component.Image
function Stub.GetFloorSurface(room) end

---@param room Component.Room
---@return Vector
function Stub.GetRenderScrollOffset(room) end

---@param room Component.Room
---@return Component.EntityList
function Stub.GetEntityList(room) end

---@param room Component.Room
---@param Slot integer
---@return Component.GridEntity
function Stub.GetDoor(room, Slot) end

---@param room Component.Room
---@return integer
function Stub.GetSpawnSeed(room) end

---@param room Component.Room
---@param idx integer
---@return unknown
function Stub.GetGridEntity(room, idx) end

---@param room Component.Room
---@return boolean
function Stub.IsClear(room) end

---@param room Component.Room
---@param Pos Vector
---@param Margin number
---@return Vector
function Stub.GetClampedPositionWrapper(room, Pos, Margin) end

---@param room Component.Room
---@return Component.EntityList.EL
function Stub.GetEntities(room) end

---@param room Component.Room
---@return integer
function Stub.GetTintedRockIdx(room) end

---@param room Component.Room
---@return Component.TemporaryEffects
function Stub.GetTemporaryEffects(room) end

---@param room Component.Room
---@return integer
function Stub.GetType(room) end

---@param room Component.Room
---@return Vector
function Stub.GetRoomBoundsCenter(room) end

---@param room Component.Room
---@return BossType | integer
function Stub.GetBossID(room) end

---@param room Component.Room
---@return Vector
function Stub.GetTopLeftPos(room) end

---@param room Component.Room
---@return Vector
function Stub.GetBottomRightPos(room) end

---@param room Component.Room
---@return RoomShape | integer
function Stub.GetRoomShape(room) end

---@param room Component.Room
---@return unknown
function Stub.GetRoomClearDelay(room) end

---@param room Component.Room
---@param Index integer
---@return integer
function Stub.GetGridPath(room, Index) end

---@param room Component.Room
---@param Index integer
---@param Value integer
---@return boolean
function Stub.SetGridPath(room, Index, Value) end

---@param room Component.Room
---@param gridIdx integer
---@param GridPathThreshold integer
---@return boolean
function Stub.IsGridPathAtIdxUnder951(room, gridIdx, GridPathThreshold) end

---@param room Component.Room
---@param Pos Vector
---@return Component.GridEntity
function Stub.GetGridEntityFromPos(room, Pos) end

---@param room Component.Room
---@return integer
function Stub.GetGridSize(room) end

---@param room Component.Room
---@return integer
function Stub.GetAliveEnemiesCount(room) end

---@param room Component.Room
---@return integer
function Stub.GetAliveBossesCount(room) end

---@param room Component.Room
---@return unknown
function Stub.GetCamera(room) end

---@param room Component.Room
---@param Duration integer
---@param Count integer
function Stub.EmitBloodFromWalls(room, Duration, Count) end

---@param room Component.Room
---@return boolean
function Stub.HasSlowDown(room) end

---@param room Component.Room
---@param Duration integer
function Stub.SetSlowDown(room, Duration) end

---@param room Component.Room
---@return Component.Backdrop
function Stub.GetBackdrop(room) end

---@param room Component.Room
---@return integer
function Stub.GetDecorationSeed(room) end

---@param room Component.Room
---@param Clear boolean
function Stub.SetClear(room, Clear) end

---@param room Component.Room
---@param Value boolean
function Stub.SetSacrificeDone(room, Value) end

---@param room Component.Room
---@return BackdropType | integer
function Stub.GetBackdropType(room) end

---@param room Component.Room
---@param gridIdx integer
---@param pathmarker integer
---@return boolean
function Stub.pathmarker_set_related(room, gridIdx, pathmarker) end

---@param room Component.Room
---@param pos Vector
---@param gridpath integer
---@return boolean
function Stub.unk_gridpaths_setter(room, pos, gridpath) end

---@param room Component.Room
---@return boolean
function Stub.HasTriggerPressurePlates(room) end

---@param room Component.Room
---@return Component.Room.CorpseList
function Stub.GetCorpseList(room) end

---@param ctx Context.Common
---@param param_1 Vector
---@return boolean
function Stub.GridCollisionAtPos(ctx, param_1) end

---@param room Component.Room
---@return boolean
function Stub.HasWaterPits(room) end

---@param room Component.Room
---@return Vector
function Stub.GetWaterCurrent(room) end

---@param ctx Context.Common
---@param param_1 boolean
function Stub.ClearBossHazards(ctx, param_1) end

---@param room Component.Room
function Stub.StopRain(room) end

---@param ctx Context.Common
---@param room Component.Room
---@param Pos Vector
---@param Force boolean
---@return boolean
function Stub.CanSpawnObstacleAtPosition_Vector(ctx, room, Pos, Force) end

---@param room Component.Room
---@return Component.HellBackdrop
function Stub.GetHellBackdrop(room) end

---@param room Component.Room
---@param Slot DoorSlot | integer
---@return boolean
function Stub.IsDoorSlotAllowed(room, Slot) end

---@param room Component.Room
function Stub.InvalidatePickupVision(room) end

---@param room Component.Room
---@return boolean
function Stub.IsSacrificeDone(room) end

---@param room Component.Room
---@return boolean
function Stub.IsDeathsListInactive(room) end

---@param room Component.Room
---@return boolean
function Stub.DoGhostsPersist(room) end

---@param room Component.Room
---@param Pos Vector
---@param Margin number
---@return Vector
function Stub.ScreenWrapPosition_wrapper(room, Pos, Margin) end

---@param room Component.Room
---@return boolean
function Stub.IsFirstVisit(room) end

---@param ctx Context.Common
---@param room Component.Room
---@param idx integer
---@param type EntityType | integer
---@param variant integer
function Stub.spawn_entity_wrapper(ctx, room, idx, type, variant) end

---@param room Component.Room
---@return Vector
function Stub.GetRenderSurfaceTopLeft(room) end

---@param room Component.Room
---@return boolean
function Stub.IsFirstEnemyDead(room) end

---@param room Component.Room
---@param Value boolean
function Stub.SetFirstEnemyDead(room, Value) end

---@param room Component.Room
---@param flags eRoomConfigRoomFlag | integer
---@return boolean
function Stub.HasRoomConfigFlag(room, flags) end

---@param room Component.Room
---@return boolean
function Stub.GetUnkBool(room) end

---@param room Component.Room
---@return boolean
function Stub.IsAmbushDone(room) end

---@param room Component.Room
---@param param_1 Color
function Stub.GetWallColor(room, param_1) end

---@param room Component.Room
---@return number
function Stub.GetLavaIntensity(room) end

---@param room Component.Room
function Stub.SetRedHeartDamage(room) end

---@param room Component.Room
function Stub.SetCardAgainstHumanity(room) end

---@param room Component.Room
---@return integer
function Stub.GetDeliriumDistance(room) end

---@param room Component.Room
---@return boolean
function Stub.GetRedHeartDamage(room) end

---@param room Component.Room
---@param Color Color
function Stub.SetFloorColor(room, Color) end

---@param room Component.Room
---@param Color Color
function Stub.SetWallColor(room, Color) end

---@param ctx Context.Common
---@return Component.Room
function Stub.Constructor(ctx) end

---@param room Component.Room
function Stub.Destructor(room) end

---@param room Component.Room
---@return boolean
function Stub.IsDungeon(room) end

---@param ctx Context.Common
---@param room Component.Room
---@param item Component.ItemConfig.Item
---@param unused integer
function Stub.TriggerEffectRemoved(ctx, room, item, unused) end

---@param room Component.Room
---@param Duration integer
function Stub.SetPauseTimer(room, Duration) end

---@param ctx Context.Common
---@param room Component.Room
---@return number
function Stub.GetMusicPitch(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param unused Vector
---@param entity Component.Entity
---@return number
function Stub.GetTimeScale(ctx, room, unused, entity) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.StopAmbientSounds(ctx, room) end

---@param ctx Context.Common
function Stub.CreateSurfaces(ctx) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.reset(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.PlayMusic(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@return boolean
function Stub.TryPlayMusicLayer(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.PlayBossMusic(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param GridIdx integer
---@param Type GridEntityType | integer
---@param Variant integer
---@param Seed integer
---@param VarData integer
---@return boolean
function Stub.SpawnGridEntity(ctx, room, GridIdx, Type, Variant, Seed, VarData) end

---@param ctx Context.Common
---@param room Component.Room
---@param GridIndex integer
---@param Desc Component.GridEntityDesc
---@return boolean
function Stub.SpawnGridEntityDesc(ctx, room, GridIndex, Desc) end

---@param ctx Context.Common
---@param room Component.Room
---@param Seed integer
---@param NoDecrease boolean
---@return CollectibleType | integer
function Stub.GetSeededCollectible(ctx, room, Seed, NoDecrease) end

---@param ctx Context.Common
---@param room Component.Room
---@param spawn Component.RoomConfig.Spawn.Entry
---@param gridIdx integer
---@param seed integer
function Stub.FixSpawnEntry(ctx, room, spawn, gridIdx, seed) end

---@param type EntityType | integer
---@param variant integer
---@param unusedSubtype integer
---@return boolean
function Stub.is_persistent_room_entity(type, variant, unusedSubtype) end

---@param ctx Context.Common
---@param room Component.Room
---@param idx integer
---@param Entry Component.RoomConfig.Spawn.Entry
---@param entrySeed integer
---@param unk Component.Entity
---@param respawning boolean
function Stub.spawn_entity(ctx, room, idx, Entry, entrySeed, unk, respawning) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 integer
---@param param_2 integer
---@return boolean
function Stub.make_wall(ctx, room, param_1, param_2) end

---@param ctx Context.Common
---@param room Component.Room
---@param slot DoorSlot | integer
function Stub.make_door(ctx, room, slot) end

---@param room Component.Room
---@return StbType | integer
function Stub.GetRoomConfigStage(room) end

---@param type EntityType | integer
---@param variant EffectVariant | integer
---@param subtype integer
---@param spawnertype integer
---@param unk boolean
---@return boolean
function Stub.ShouldSaveEntity(type, variant, subtype, spawnertype, unk) end

---@param room Component.Room
---@param entity Component.Entity.Effect
---@param savestate Component.EntitySaveState
---@param param_3 boolean
---@return boolean
function Stub.save_entity(room, entity, savestate, param_3) end

---@param ctx Context.Common
---@param room Component.Room
---@param entity Component.Entity
---@param state Component.EntitySaveState
function Stub.restore_entity(ctx, room, entity, state) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.SaveState(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.RestoreState(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.check_player_enter_door(ctx, room) end

---@param room Component.Room
---@param Pos Vector
---@return EntityGridCollisionClass | integer
function Stub.GetGridCollisionAtPos(room, Pos) end

---@param room Component.Room
---@param Index integer
---@return EntityGridCollisionClass | integer
function Stub.GetGridCollision(room, Index) end

---@param room Component.Room
---@param origin Vector
---@param target Vector
---@param collision EntityGridCollisionClass | integer
---@param param_4 boolean
---@param param_5 boolean
---@param retPos Vector
---@return boolean
function Stub.TraceLine(room, origin, target, collision, param_4, param_5, retPos) end

---@param room Component.Room
---@param Pos Vector
---@param Dir Vector
---@return Vector
function Stub.GetLaserTarget(room, Pos, Dir) end

---@param ctx Context.Common
---@param room Component.Room
---@param Pos1 Vector
---@param Pos2 Vector
---@param Mode LineCheckMode | integer
---@param GridPathThreshold integer
---@param IgnoreWalls boolean
---@param IgnoreCrushable boolean
---@param resultPos Vector
---@return boolean
function Stub.CheckLine(ctx, room, Pos1, Pos2, Mode, GridPathThreshold, IgnoreWalls, IgnoreCrushable, resultPos) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.LoadBackdropGraphics(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.ReloadFX(ctx, room) end

---@param slot DoorSlot | integer
---@param widthOffset2 integer
---@param heightOffset2 integer
---@param shape RoomShape | integer
---@return integer
function Stub.GetDoorGridIndex(slot, widthOffset2, heightOffset2, shape) end

---@param room Component.Room
---@param unkBool boolean
function Stub.RecomputeRoomBounds(room, unkBool) end

---@param ctx Context.Common
---@param room Component.Room
---@param config Component.RoomConfig.Room
---@param desc Component.RoomDescriptor
function Stub.Init(ctx, room, config, desc) end

---@param room Component.Room
---@param Slot DoorSlot | integer
---@return Vector
function Stub.GetDoorSlotPosition(room, Slot) end

---@param ctx Context.Common
---@param room Component.Room
---@param Animate boolean
---@param Force boolean
---@return boolean
function Stub.TrySpawnSecretExit(ctx, room, Animate, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@param Force boolean
---@return boolean
function Stub.TrySpawnSecretShop(ctx, room, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@param Animate boolean
---@param Force boolean
---@return boolean
function Stub.TrySpawnDevilRoomDoor(ctx, room, Animate, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@return number
function Stub.GetDevilRoomChance(ctx, room) end

---@param ctx Context.Common
---@return number
function Stub.GetAngelRoomChance(ctx) end

---@param ctx Context.Common
---@param room Component.Room
---@param IgnoreTime boolean
---@param Force boolean
---@return boolean
function Stub.TrySpawnBossRushDoor(ctx, room, IgnoreTime, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@param Force boolean
---@return boolean
function Stub.TrySpawnMegaSatanRoomDoor(ctx, room, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 Vector
function Stub.fix_award_pos(ctx, room, param_1) end

---@param room Component.Room
---@param idx integer
function Stub.fix_award_pos_idx(room, idx) end

---@param ctx Context.Common
---@param room Component.Room
---@param idx integer
function Stub.fix_trapdoor_pos(ctx, room, idx) end

---@param ctx Context.Common
---@param param_1 RNG
---@param param_2 boolean
---@return PickupVariant | integer
function Stub.GetClearAwardVariant(ctx, param_1, param_2) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.SpawnClearAward(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_card_against_humanity(ctx, room) end

---@param room Component.Room
---@param Boss Component.Entity.Npc
function Stub.TriggerBossSpawn(room, Boss) end

---@param ctx Context.Common
---@param room Component.Room
---@param Boss Component.Entity.Npc
function Stub.TriggerBossDeath(ctx, room, Boss) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_ambient_sounds(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_greed_mode(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_death_list(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.check_pressure_plates_triggered(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.SpawnMomExitDoor(ctx, room) end

---@param ctx Context.Common
---@param pos Vector
---@param param_3 number
---@param param_4 number
---@return Vector
function Stub.unk_free_pos_getter(ctx, pos, param_3, param_4) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.Update(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param silent boolean
function Stub.TriggerClear(ctx, room, silent) end

---@param ctx Context.Common
---@param room Component.Room
---@param ent Component.Entity
---@param offset Vector
function Stub.render_entity_light(ctx, room, ent, offset) end

---@param ctx Context.Common
---@param room Component.Room
---@param entity Component.Entity
---@param pos Vector
function Stub.render_entity_glow(ctx, room, entity, pos) end

---@param ctx Context.Common
---@param room Component.Room
---@param grid Component.GridEntity
---@param offset Vector
function Stub.render_grid_light(ctx, room, grid, offset) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.PreRender(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 Component.Room
function Stub.Render(ctx, room, param_1) end

---@param ctx Context.Common
---@param room Component.Room
---@param pos Vector
function Stub.RenderDebugInformation(ctx, room, pos) end

---@param room Component.Room
---@param Pos Vector
---@return integer
function Stub.GetGridPathFromPos(room, Pos) end

---@param room Component.Room
---@param Pos Vector
---@return integer
function Stub.GetGridIndex(room, Pos) end

---@param ctx Context.Common
---@return Vector
function Stub.GetCenterPos(ctx) end

---@param room Component.Room
---@param Pos Vector
---@return integer
function Stub.GetClampedGridIndex(room, Pos) end

---@param room Component.Room
---@param GridColumn integer
---@param GridRow integer
---@return integer
function Stub.GetGridIndexByTile(room, GridColumn, GridRow) end

---@param pos Vector
---@param x integer
---@param y integer
function Stub.GetGridXY(pos, x, y) end

---@param room Component.Room
---@param param_2 integer
---@return Vector
function Stub.GetGridPosition(room, param_2) end

---@param room Component.Room
---@param Pos Vector
---@param topLeftX number
---@param topLeftY number
---@param bottomRightX number
---@param bottomRightY number
---@return Vector
function Stub.GetClampedPosition(room, Pos, topLeftX, topLeftY, bottomRightX, bottomRightY) end

---@param room Component.Room
---@param param_3 Vector
---@param param_4 number
---@param param_5 number
---@param param_6 number
---@param param_7 number
---@return Vector
function Stub.ScreenWrapPosition(room, param_3, param_4, param_5, param_6, param_7) end

---@param room Component.Room
---@param Pos Vector
---@param Margin number
---@return boolean
function Stub.IsPositionInRoom(room, Pos, Margin) end

---@param room Component.Room
---@param x integer
---@param y integer
---@return Component.GridEntity
function Stub.GetGridEntityByXY(room, x, y) end

---@param room Component.Room
---@param AvoidActiveEntities boolean
---@param AllowPits boolean
---@return Vector
function Stub.FindRandomFreePickupSpawnPosition(room, AvoidActiveEntities, AllowPits) end

---@param room Component.Room
---@param pos Vector
---@param InitialStep number
---@param AvoidActiveEntities boolean
---@param AllowPits boolean
---@return Vector
function Stub.FindFreePickupSpawnPosition(room, pos, InitialStep, AvoidActiveEntities, AllowPits) end

---@param room Component.Room
---@param Index integer
---@param Damage integer
---@return boolean
function Stub.DamageGrid(room, Index, Damage) end

---@param room Component.Room
---@param idx integer
---@param damage integer
---@param instant boolean
---@return boolean
function Stub.DestroyGrid(room, idx, damage, instant) end

---@param ctx Context.Common
---@param room Component.Room
---@return integer
function Stub.GetFrameCount(ctx, room) end

---@param seed integer
---@return integer
function Stub.greed_random_shopitem(seed) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.init_shop(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param idx PickupVariant | integer
---@param subtype integer
---@param Price ShopItemPrice | integer
---@param seed integer
---@return integer
function Stub.MakeShopItem(ctx, room, idx, subtype, Price, seed) end

---@param ctx Context.Common
---@param Index integer
---@param retVariant PickupVariant | integer
---@param retSubtype integer
---@param seed integer
function Stub.GetShopItem(ctx, Index, retVariant, retSubtype, seed) end

---@param ctx Context.Common
---@param room Component.Room
---@param entVariant PickupVariant | integer
---@param entSubtype integer
---@param shopItemID integer
---@return ShopItemPrice | integer
function Stub.GetShopItemPrice(ctx, room, entVariant, entSubtype, shopItemID) end

---@param room Component.Room
---@param param_1 unknown
---@param param_2 unknown
function Stub.TriggerRestock(room, param_1, param_2) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.ShopRestockPartial(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.ShopRestockFull(ctx, room) end

---@param room Component.Room
---@param KeepCollectibleIdx boolean
---@param ReselectSaleItem boolean
function Stub.ShopReshuffle(room, KeepCollectibleIdx, ReselectSaleItem) end

---@param ctx Context.Common
---@param room Component.Room
---@param ShopItemIdx integer
---@param Price ShopItemPrice | integer
---@return ShopItemPrice | integer
function Stub.TryGetShopDiscount(ctx, room, ShopItemIdx, Price) end

---@param ctx Context.Common
---@param room Component.Room
---@param Slot DoorSlot | integer
function Stub.RemoveDoor(ctx, room, Slot) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.SpawnGreedModeWave(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 boolean
function Stub.render_caustics(ctx, room, param_1) end

---@param room Component.Room
---@param id integer
---@param params Component.ShockwaveParams
function Stub.SetShockwaveParam(room, id, params) end

---@param ctx Context.Common
---@param room Component.Room
---@param pos Vector
---@param param_3 Component.Image
---@return Vector
function Stub.GetScreenUVPos(ctx, room, pos, param_3) end

---@param room Component.Room
---@return integer
function Stub.GetNextShockwaveId(room) end

---@param ctx Context.Common
---@return boolean
function Stub.IsAmbushActive(ctx) end

---@param ctx Context.Common
---@param room Component.Room
---@return number
function Stub.GetLightingAlpha(ctx, room) end

---@param room Component.Room
---@param Pos Vector
---@param Margin number
---@return Vector
function Stub.FindFreeTilePosition(room, Pos, Margin) end

---@param ctx Context.Common
---@param room Component.Room
---@param Pit Component.GridEntity.Pit
---@param Rock Component.GridEntity.Rock
---@return boolean
function Stub.TryMakeBridge(ctx, room, Pit, Rock) end

---@param room Component.Room
---@param GridIndex integer
---@param PathTrail integer
---@param KeepDecoration boolean
function Stub.RemoveGridEntity(room, GridIndex, PathTrail, KeepDecoration) end

---@param room Component.Room
---@param GridIndex integer
---@param PathTrail integer
---@param KeepDecoration boolean
function Stub.RemoveGridEntityImmediate(room, GridIndex, PathTrail, KeepDecoration) end

---@param room Component.Room
---@param Margin number
---@return Vector
function Stub.GetRandomPosition(room, Margin) end

---@param room Component.Room
---@param Seed integer
---@return integer
function Stub.GetRandomTileIndex(room, Seed) end

---@param ctx Context.Common
---@param room Component.Room
---@return integer
function Stub.GetBrokenWatchState(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param State integer
function Stub.SetBrokenWatchState(ctx, room, State) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.make_walls(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 Vector
function Stub.RenderDebugGridInfo(ctx, room, param_1) end

---@param room Component.Room
---@return boolean
function Stub.IsLShapedRoom(room) end

---@param room Component.Room
---@return Component.LRoomAreaDesc
function Stub.GetLRoomAreaDesc(room) end

---@param room Component.Room
---@return Component.LRoomTileDesc
function Stub.GetLRoomTileDesc(room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.RespawnEnemies(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param FirstTIme boolean
---@param IgnoreTime boolean
---@param Force boolean
---@return boolean
function Stub.TrySpawnBlueWombDoor(ctx, room, FirstTIme, IgnoreTime, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@param Force boolean
---@return boolean
function Stub.TrySpawnTheVoidDoor(ctx, room, Force) end

---@param ctx Context.Common
---@param room Component.Room
---@return Music | integer
function Stub.GetBossMusic(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@return Music | integer
function Stub.GetBossVictoryJingle(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@return boolean
function Stub.TrySpawnBrokenShovel(ctx, room) end

---@param room Component.Room
---@return boolean
function Stub.HasWater(room) end

---@param ctx Context.Common
---@return boolean
function Stub.IsCurrentRoomLastBoss(ctx) end

---@param ctx Context.Common
---@param room Component.Room
---@param Position Vector
function Stub.MamaMegaExplosion(ctx, room, Position) end

---@param ctx Context.Common
---@param room Component.Room
---@return integer
function Stub.GetDungeonRockIdx(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.TurnGold(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param screenWidth_qqq number
---@param screenHeight_qqq number
---@return Vector
function Stub.WorldToScreenPosition(ctx, room, screenWidth_qqq, screenHeight_qqq) end

---@param room Component.Room
---@param entity Component.Entity.Npc
function Stub.AddEnemyCorpse(room, entity) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.pre_render_water(ctx, room) end

---@param room Component.Room
function Stub.RemovePacifist(room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_2 Vector
function Stub.render_water_surface(ctx, room, param_2) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 integer
---@param param_2 integer
---@param param_3 integer
---@return boolean
function Stub.CheckGridPath(ctx, room, param_1, param_2, param_3) end

---@param ctx Context.Common
---@param room Component.Room
---@param GridIndex integer
---@param Force boolean
---@return boolean
function Stub.CanSpawnObstacleAtPosition(ctx, room, GridIndex, Force) end

---@param room Component.Room
---@param output integer
---@param gridIdx integer
function Stub.add_output(room, output, gridIdx) end

---@param room Component.Room
---@param id unknown
---@param column integer
---@param row integer
function Stub.AddOutput(room, id, column, row) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.init_outputs(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 Component.Entity
---@param output unknown
---@return Component.Entity
function Stub.convert_entity_to_spawner(ctx, room, param_1, output) end

---@param ctx Context.Common
---@param room Component.Room
---@param output integer
function Stub.TriggerOutput(ctx, room, output) end

---@param ctx Context.Common
---@param room Component.Room
---@param returnedResult Component.FXLayers.ColorModState
---@return Component.FXLayers.ColorModState
function Stub.ComputeColorModifier(ctx, room, returnedResult) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.ProcessColorModifier(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param color KColor
---@param Pos Vector
---@param Radius number
---@return KColor
function Stub.GetFloorColorAt(ctx, room, color, Pos, Radius) end

---@param ctx Context.Common
---@param room Component.Room
---@param pos Vector
---@param player Component.Entity.Player
---@return boolean
function Stub.IsPlayerReachablePosition(ctx, room, pos, player) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 Vector
---@param param_2 Vector
function Stub.FindPlayerReachablePosition(ctx, room, param_1, param_2) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.init_train_tracks(ctx, room) end

---@param room Component.Room
---@return boolean
function Stub.HasLava(room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.init_rain(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_rain(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_mist(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.update_water_current(ctx, room) end

---@param room Component.Room
---@param GridIndex integer
---@return boolean
function Stub.CanPickupGridEntity(room, GridIndex) end

---@param ctx Context.Common
---@param room Component.Room
---@param GridIndex integer
---@param param_2 Component.GridEntityDesc
---@param Sprite Sprite
---@return boolean
function Stub.PickupGridEntity(ctx, room, GridIndex, param_2, Sprite) end

---@param ctx Context.Common
---@param room Component.Room
---@param GridIndex integer
---@return Component.Entity.Effect
function Stub.PickupGridEntity_Idx(ctx, room, GridIndex) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 boolean
function Stub.pre_render_dust(ctx, room, param_1) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.pre_render_pits(ctx, room) end

---@param room Component.Room
---@param offset Vector
function Stub.render_pit_surface(room, offset) end

---@param room Component.Room
---@param Pos Vector
---@return integer
function Stub.GetNearestDoorOutline(room, Pos) end

---@param ctx Context.Common
---@param room Component.Room
function Stub.UpdateRedKey(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 integer
---@param RoomDesc Component.RoomDescriptor
function Stub.TriggerRedRoomDoorCreated(ctx, room, param_1, RoomDesc) end

---@param ctx Context.Common
---@param param_1 Component.Entity.Pickup
---@return integer
function Stub.SpawnOptionReward(ctx, param_1) end

---@param room Component.Room
---@return boolean
function Stub.IsBeastRoom(room) end

---@param room Component.Room
---@return number
function Stub.GetBeastRoomLavaHeight(room) end

---@param ctx Context.Common
---@param room Component.Room
---@return boolean
function Stub.TrySpawnSpecialQuestDoor(ctx, room) end

---@param ctx Context.Common
---@return boolean
function Stub.IsMirrorWorld(ctx) end

---@param room Component.Room
---@return boolean
function Stub.HasCurseMist(room) end

---@param ctx Context.Common
---@param room Component.Room
---@return boolean
function Stub.IsBackwardsPathEntrance(ctx, room) end

---@param ctx Context.Common
---@param room Component.Room
---@param param_1 boolean
---@return unknown
function Stub.TrySpawnSanguineBondSpike(ctx, room, param_1) end

---@param room Component.Room
---@return BossType | integer
function Stub.GetSecondBossID(room) end

---@param room Component.Room
---@param Value boolean
function Stub.SetAmbushDone(room, Value) end

---@param room Component.Room
function Stub.KeepDoorsClosed(room) end

---@param room Component.Room
---@return integer
function Stub.GetAwardSeed(room) end

---@param room Component.Room
---@return integer
function Stub.GetShopLevel(room) end

---@param room Component.Room
---@return number
function Stub.GetEnemyDamageInflicted(room) end

--endregion

Interface.GetWaterAmount = Stub.GetWaterAmount
Interface.GetGridHeight = Stub.GetGridHeight
Interface.GetGridWidth = Stub.GetGridWidth
Interface.GetFloorSurface = Stub.GetFloorSurface
Interface.GetRenderScrollOffset = Stub.GetRenderScrollOffset
Interface.GetEntityList = Stub.GetEntityList
Interface.GetDoor = Stub.GetDoor
Interface.GetSpawnSeed = Stub.GetSpawnSeed
Interface.GetGridEntity = Stub.GetGridEntity
Interface.IsClear = Stub.IsClear
Interface.GetClampedPositionWrapper = Stub.GetClampedPositionWrapper
Interface.GetEntities = Stub.GetEntities
Interface.GetTintedRockIdx = Stub.GetTintedRockIdx
Interface.GetTemporaryEffects = Stub.GetTemporaryEffects
Interface.GetType = Stub.GetType
Interface.GetRoomBoundsCenter = Stub.GetRoomBoundsCenter
Interface.GetBossID = Stub.GetBossID
Interface.GetTopLeftPos = Stub.GetTopLeftPos
Interface.GetBottomRightPos = Stub.GetBottomRightPos
Interface.GetRoomShape = Stub.GetRoomShape
Interface.GetRoomClearDelay = Stub.GetRoomClearDelay
Interface.GetGridPath = Stub.GetGridPath
Interface.SetGridPath = Stub.SetGridPath
Interface.IsGridPathAtIdxUnder951 = Stub.IsGridPathAtIdxUnder951
Interface.GetGridEntityFromPos = Stub.GetGridEntityFromPos
Interface.GetGridSize = Stub.GetGridSize
Interface.GetAliveEnemiesCount = Stub.GetAliveEnemiesCount
Interface.GetAliveBossesCount = Stub.GetAliveBossesCount
Interface.GetCamera = Stub.GetCamera
Interface.EmitBloodFromWalls = Stub.EmitBloodFromWalls
Interface.HasSlowDown = Stub.HasSlowDown
Interface.SetSlowDown = Stub.SetSlowDown
Interface.GetBackdrop = Stub.GetBackdrop
Interface.GetDecorationSeed = Stub.GetDecorationSeed
Interface.SetClear = Stub.SetClear
Interface.SetSacrificeDone = Stub.SetSacrificeDone
Interface.GetBackdropType = Stub.GetBackdropType
Interface.pathmarker_set_related = Stub.pathmarker_set_related
Interface.unk_gridpaths_setter = Stub.unk_gridpaths_setter
Interface.HasTriggerPressurePlates = Stub.HasTriggerPressurePlates
Interface.GetCorpseList = Stub.GetCorpseList
Interface.GridCollisionAtPos = Stub.GridCollisionAtPos
Interface.HasWaterPits = Stub.HasWaterPits
Interface.GetWaterCurrent = Stub.GetWaterCurrent
Interface.ClearBossHazards = Stub.ClearBossHazards
Interface.StopRain = Stub.StopRain
Interface.CanSpawnObstacleAtPosition_Vector = Stub.CanSpawnObstacleAtPosition_Vector
Interface.GetHellBackdrop = Stub.GetHellBackdrop
Interface.IsDoorSlotAllowed = Stub.IsDoorSlotAllowed
Interface.InvalidatePickupVision = Stub.InvalidatePickupVision
Interface.IsSacrificeDone = Stub.IsSacrificeDone
Interface.IsDeathsListInactive = Stub.IsDeathsListInactive
Interface.DoGhostsPersist = Stub.DoGhostsPersist
Interface.ScreenWrapPosition_wrapper = Stub.ScreenWrapPosition_wrapper
Interface.IsFirstVisit = Stub.IsFirstVisit
Interface.spawn_entity_wrapper = Stub.spawn_entity_wrapper
Interface.GetRenderSurfaceTopLeft = Stub.GetRenderSurfaceTopLeft
Interface.IsFirstEnemyDead = Stub.IsFirstEnemyDead
Interface.SetFirstEnemyDead = Stub.SetFirstEnemyDead
Interface.HasRoomConfigFlag = Stub.HasRoomConfigFlag
Interface.GetUnkBool = Stub.GetUnkBool
Interface.IsAmbushDone = Stub.IsAmbushDone
Interface.GetWallColor = Stub.GetWallColor
Interface.GetLavaIntensity = Stub.GetLavaIntensity
Interface.SetRedHeartDamage = Stub.SetRedHeartDamage
Interface.SetCardAgainstHumanity = Stub.SetCardAgainstHumanity
Interface.GetDeliriumDistance = Stub.GetDeliriumDistance
Interface.GetRedHeartDamage = Stub.GetRedHeartDamage
Interface.SetFloorColor = Stub.SetFloorColor
Interface.SetWallColor = Stub.SetWallColor
Interface.Constructor = Stub.Constructor
Interface.Destuctor = Stub.Destructor
Interface.IsDungeon = Stub.IsDungeon
Interface.TriggerEffectRemoved = Stub.TriggerEffectRemoved
Interface.SetPauseTimer = Stub.SetPauseTimer
Interface.GetMusicPitch = Stub.GetMusicPitch
Interface.GetTimeScale = Stub.GetTimeScale
Interface.StopAmbientSounds = Stub.StopAmbientSounds
Interface.CreateSurfaces = Stub.CreateSurfaces
Interface.reset = Stub.reset
Interface.PlayMusic = Stub.PlayMusic
Interface.TryPlayMusicLayer = Stub.TryPlayMusicLayer
Interface.PlayBossMusic = Stub.PlayBossMusic
Interface.SpawnGridEntity = Stub.SpawnGridEntity
Interface.SpawnGridEntityDesc = Stub.SpawnGridEntityDesc
Interface.GetSeededCollectible = Stub.GetSeededCollectible
Interface.FixSpawnEntry = Stub.FixSpawnEntry
Interface.is_persistent_room_entity = Stub.is_persistent_room_entity
Interface.spawn_entity = Stub.spawn_entity
Interface.make_wall = Stub.make_wall
Interface.make_door = Stub.make_door
Interface.GetRoomConfigStage = Stub.GetRoomConfigStage
Interface.ShouldSaveEntity = Stub.ShouldSaveEntity
Interface.save_entity = Stub.save_entity
Interface.restore_entity = Stub.restore_entity
Interface.SaveState = Stub.SaveState
Interface.RestoreState = Stub.RestoreState
Interface.check_player_enter_door = Stub.check_player_enter_door
Interface.GetGridCollisionAtPos = Stub.GetGridCollisionAtPos
Interface.GetGridCollision = Stub.GetGridCollision
Interface.TraceLine = Stub.TraceLine
Interface.GetLaserTarget = Stub.GetLaserTarget
Interface.CheckLine = Stub.CheckLine
Interface.LoadBackdropGraphics = Stub.LoadBackdropGraphics
Interface.ReloadFX = Stub.ReloadFX
Interface.GetDoorGridIndex = Stub.GetDoorGridIndex
Interface.RecomputeRoomBounds = Stub.RecomputeRoomBounds
Interface.Init = Stub.Init
Interface.GetDoorSlotPosition = Stub.GetDoorSlotPosition
Interface.TrySpawnSecretExit = Stub.TrySpawnSecretExit
Interface.TrySpawnSecretShop = Stub.TrySpawnSecretShop
Interface.TrySpawnDevilRoomDoor = Stub.TrySpawnDevilRoomDoor
Interface.GetDevilRoomChance = Stub.GetDevilRoomChance
Interface.GetAngelRoomChance = Stub.GetAngelRoomChance
Interface.TrySpawnBossRushDoor = Stub.TrySpawnBossRushDoor
Interface.TrySpawnMegaSatanRoomDoor = Stub.TrySpawnMegaSatanRoomDoor
Interface.fix_award_pos = Stub.fix_award_pos
Interface.fix_award_pos_idx = Stub.fix_award_pos_idx
Interface.fix_trapdoor_pos = Stub.fix_trapdoor_pos
Interface.GetClearAwardVariant = Stub.GetClearAwardVariant
Interface.SpawnClearAward = Stub.SpawnClearAward
Interface.update_card_against_humanity = Stub.update_card_against_humanity
Interface.TriggerBossSpawn = Stub.TriggerBossSpawn
Interface.TriggerBossDeath = Stub.TriggerBossDeath
Interface.update_ambient_sounds = Stub.update_ambient_sounds
Interface.update_greed_mode = Stub.update_greed_mode
Interface.update_death_list = Stub.update_death_list
Interface.check_pressure_plates_triggered = Stub.check_pressure_plates_triggered
Interface.SpawnMomExitDoor = Stub.SpawnMomExitDoor
Interface.unk_free_pos_getter = Stub.unk_free_pos_getter
Interface.Update = Stub.Update
Interface.TriggerClear = Stub.TriggerClear
Interface.render_entity_light = Stub.render_entity_light
Interface.render_entity_glow = Stub.render_entity_glow
Interface.render_grid_light = Stub.render_grid_light
Interface.PreRender = Stub.PreRender
Interface.Render = Stub.Render
Interface.RenderDebugInformation = Stub.RenderDebugInformation
Interface.GetGridPathFromPos = Stub.GetGridPathFromPos
Interface.GetGridIndex = Stub.GetGridIndex
Interface.GetCenterPos = Stub.GetCenterPos
Interface.GetClampedGridIndex = Stub.GetClampedGridIndex
Interface.GetGridIndexByTile = Stub.GetGridIndexByTile
Interface.GetGridXY = Stub.GetGridXY
Interface.GetGridPosition = Stub.GetGridPosition
Interface.GetClampedPosition = Stub.GetClampedPosition
Interface.ScreenWrapPosition = Stub.ScreenWrapPosition
Interface.IsPositionInRoom = Stub.IsPositionInRoom
Interface.GetGridEntityByXY = Stub.GetGridEntityByXY
Interface.FindRandomFreePickupSpawnPosition = Stub.FindRandomFreePickupSpawnPosition
Interface.FindFreePickupSpawnPosition = Stub.FindFreePickupSpawnPosition
Interface.DamageGrid = Stub.DamageGrid
Interface.DestroyGrid = Stub.DestroyGrid
Interface.GetFrameCount = Stub.GetFrameCount
Interface.greed_random_shopitem = Stub.greed_random_shopitem
Interface.init_shop = Stub.init_shop
Interface.MakeShopItem = Stub.MakeShopItem
Interface.GetShopItem = Stub.GetShopItem
Interface.GetShopItemPrice = Stub.GetShopItemPrice
Interface.TriggerRestock = Stub.TriggerRestock
Interface.ShopRestockPartial = Stub.ShopRestockPartial
Interface.ShopRestockFull = Stub.ShopRestockFull
Interface.ShopReshuffle = Stub.ShopReshuffle
Interface.TryGetShopDiscount = Stub.TryGetShopDiscount
Interface.RemoveDoor = Stub.RemoveDoor
Interface.SpawnGreedModeWave = Stub.SpawnGreedModeWave
Interface.render_caustics = Stub.render_caustics
Interface.SetShockwaveParam = Stub.SetShockwaveParam
Interface.GetScreenUVPos = Stub.GetScreenUVPos
Interface.GetNextShockwaveId = Stub.GetNextShockwaveId
Interface.IsAmbushActive = Stub.IsAmbushActive
Interface.GetLightingAlpha = Stub.GetLightingAlpha
Interface.FindFreeTilePosition = Stub.FindFreeTilePosition
Interface.TryMakeBridge = Stub.TryMakeBridge
Interface.RemoveGridEntity = Stub.RemoveGridEntity
Interface.RemoveGridEntityImmediate = Stub.RemoveGridEntityImmediate
Interface.GetRandomPosition = Stub.GetRandomPosition
Interface.GetRandomTileIndex = Stub.GetRandomTileIndex
Interface.GetBrokenWatchState = Stub.GetBrokenWatchState
Interface.SetBrokenWatchState = Stub.SetBrokenWatchState
Interface.make_walls = Stub.make_walls
Interface.RenderDebugGridInfo = Stub.RenderDebugGridInfo
Interface.IsLShapedRoom = Stub.IsLShapedRoom
Interface.GetLRoomAreaDesc = Stub.GetLRoomAreaDesc
Interface.GetLRoomTileDesc = Stub.GetLRoomTileDesc
Interface.RespawnEnemies = Stub.RespawnEnemies
Interface.TrySpawnBlueWombDoor = Stub.TrySpawnBlueWombDoor
Interface.TrySpawnTheVoidDoor = Stub.TrySpawnTheVoidDoor
Interface.GetBossMusic = Stub.GetBossMusic
Interface.GetBossVictoryJingle = Stub.GetBossVictoryJingle
Interface.TrySpawnBrokenShovel = Stub.TrySpawnBrokenShovel
Interface.HasWater = Stub.HasWater
Interface.IsCurrentRoomLastBoss = Stub.IsCurrentRoomLastBoss
Interface.MamaMegaExplosion = Stub.MamaMegaExplosion
Interface.GetDungeonRockIdx = Stub.GetDungeonRockIdx
Interface.TurnGold = Stub.TurnGold
Interface.WorldToScreenPosition = Stub.WorldToScreenPosition
Interface.AddEnemyCorpse = Stub.AddEnemyCorpse
Interface.pre_render_water = Stub.pre_render_water
Interface.RemovePacifist = Stub.RemovePacifist
Interface.render_water_surface = Stub.render_water_surface
Interface.CheckGridPath = Stub.CheckGridPath
Interface.CanSpawnObstacleAtPosition = Stub.CanSpawnObstacleAtPosition
Interface.add_output = Stub.add_output
Interface.AddOutput = Stub.AddOutput
Interface.init_outputs = Stub.init_outputs
Interface.convert_entity_to_spawner = Stub.convert_entity_to_spawner
Interface.TriggerOutput = Stub.TriggerOutput
Interface.ComputeColorModifier = Stub.ComputeColorModifier
Interface.ProcessColorModifier = Stub.ProcessColorModifier
Interface.GetFloorColorAt = Stub.GetFloorColorAt
Interface.IsPlayerReachablePosition = Stub.IsPlayerReachablePosition
Interface.FindPlayerReachablePosition = Stub.FindPlayerReachablePosition
Interface.init_train_tracks = Stub.init_train_tracks
Interface.HasLava = Stub.HasLava
Interface.init_rain = Stub.init_rain
Interface.update_rain = Stub.update_rain
Interface.update_mist = Stub.update_mist
Interface.update_water_current = Stub.update_water_current
Interface.CanPickupGridEntity = Stub.CanPickupGridEntity
Interface.PickupGridEntity = Stub.PickupGridEntity
Interface.PickupGridEntity_Idx = Stub.PickupGridEntity_Idx
Interface.pre_render_dust = Stub.pre_render_dust
Interface.pre_render_pits = Stub.pre_render_pits
Interface.render_pit_surface = Stub.render_pit_surface
Interface.GetNearestDoorOutline = Stub.GetNearestDoorOutline
Interface.UpdateRedKey = Stub.UpdateRedKey
Interface.TriggerRedRoomDoorCreated = Stub.TriggerRedRoomDoorCreated
Interface.SpawnOptionReward = Stub.SpawnOptionReward
Interface.IsBeastRoom = Stub.IsBeastRoom
Interface.GetBeastRoomLavaHeight = Stub.GetBeastRoomLavaHeight
Interface.TrySpawnSpecialQuestDoor = Stub.TrySpawnSpecialQuestDoor
Interface.IsMirrorWorld = Stub.IsMirrorWorld
Interface.HasCurseMist = Stub.HasCurseMist
Interface.IsBackwardsPathEntrance = Stub.IsBackwardsPathEntrance
Interface.TrySpawnSanguineBondSpike = Stub.TrySpawnSanguineBondSpike
Interface.GetSecondBossID = Stub.GetSecondBossID
Interface.SetAmbushDone = Stub.SetAmbushDone
Interface.KeepDoorsClosed = Stub.KeepDoorsClosed
Interface.GetAwardSeed = Stub.GetAwardSeed
Interface.GetShopLevel = Stub.GetShopLevel
Interface.GetEnemyDamageInflicted = Stub.GetEnemyDamageInflicted