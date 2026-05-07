---@class Interface.Level
local Interface = require("Isaac.Interface.Level")

--#region Stub

local Stub = {}

---@param level Component.Level
---@return StageType | integer
function Stub.GetStageType(level) end

---@param level Component.Level
---@return LevelStage | integer
function Stub.GetStage(level) end

---@param level Component.Level
function Stub.SetHeartPicked(level) end

---@param level Component.Level
---@return GridRooms | integer
function Stub.GetCurrentRoomIdx(level) end

---@param level Component.Level
---@return LevelStage | integer
function Stub.GetEffectiveStage(level) end

---@param level Component.Level
---@param id integer
---@return Component.Portal
function Stub.GetPortal(level, id) end

---@param level Component.Level
---@return DoorSlot | integer
function Stub.GetEnterDoor(level) end

---@param level Component.Level
---@return integer
function Stub.GetLastBossRoomListIndex(level) end

---@param level Component.Level
---@param LevelStateFlag integer
---@return boolean
function Stub.GetStateFlag(level, LevelStateFlag) end

---@param level Component.Level
---@return unknown
function Stub.GetDimension(level) end

---@param level Component.Level
---@return integer
function Stub.GetStartingRoomIndex(level) end

---@param level Component.Level
---@param DoorSlot integer
function Stub.SetLeaveDoor(level, DoorSlot) end

---@param level Component.Level
---@param LevelStateFlag integer
---@param Value boolean
function Stub.SetStateFlag(level, LevelStateFlag, Value) end

---@param level Component.Level
---@return integer
function Stub.GetRoomCount(level) end

---@param level Component.Level
---@param DoorSlot integer
function Stub.SetEnterDoor(level, DoorSlot) end

---@param level Component.Level
---@param Position Vector
function Stub.SetDungeonReturnPosition(level, Position) end

---@param level Component.Level
---@param Index integer
function Stub.SetDungeonRoomIndex(level, Index) end

---@param ctx Context.Common
---@return boolean
function Stub.IsCorpse(ctx) end

---@param level Component.Level
---@return GridRooms | integer
function Stub.GetPreviousRoomIndex(level) end

---@param level Component.Level
---@param Value boolean
function Stub.SetCanSeeEverything(level, Value) end

---@param level Component.Level
---@return integer
function Stub.GetDungeonReturnRoomIndex(level) end

---@param level Component.Level
---@return integer
function Stub.GetDungeonPlacementSeed(level) end

---@param level Component.Level
---@param dimension Dimension | integer
---@return integer
function Stub.GetRoomDescriptorsOffsetsArrayForDimension(level, dimension) end

---@param level Component.Level
---@param Chance number
function Stub.AddAngelRoomChance(level, Chance) end

---@param ctx Context.Common
---@return StbType | integer
function Stub.GetStageID(ctx) end

---@param level Component.Level
---@return DoorSlot | integer
function Stub.GetLeaveDoor(level) end

---@param ctx Context.Common
---@param level Component.Level
---@param Level LevelStage | integer
function Stub.SaveBackwardsStage(ctx, level, Level) end

---@param level Component.Level
---@return integer
function Stub.GetGreedModeWave(level) end

---@param level Component.Level
function Stub.destructor(level) end

---@param ctx Context.Common
---@param level Component.Level
---@param unused boolean
---@return StbType | integer
function Stub.GetStageID(ctx, level, unused) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.Reset(ctx, level) end

---@param ctx Context.Common
---@param Stage integer
---@return boolean
function Stub.CanStageHaveCurseOfLabyrinth(ctx, Stage) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.Update(ctx, level) end

---@param level Component.Level
function Stub.reset_room_list(level) end

---@param ctx Context.Common
---@param level Component.Level
---@param levelGenRoom Component.LevelGenerator.Room
---@param roomConfigRoom Component.RoomConfig.Room
---@param Seed integer
---@param Dimension Dimension | integer
---@return boolean
function Stub.place_room(ctx, level, levelGenRoom, roomConfigRoom, Seed, Dimension) end

---@param level Component.Level
---@param unk unknown
function Stub.build_secret_room_index_blacklist(level, unk) end

---@param ctx Context.Common
---@param level Component.Level
---@param levelGenerator Component.LevelGenerator
---@param minDifficulty integer
---@param maxDifficulty integer
---@return boolean
function Stub.place_rooms(ctx, level, levelGenerator, minDifficulty, maxDifficulty) end

---@param level Component.Level
---@param idx GridRooms | integer
---@param direction Direction | integer
---@param unk boolean
---@param dimension Dimension | integer
---@return DoorSlot | integer
function Stub.try_get_target_slot(level, idx, direction, unk, dimension) end

---@param level Component.Level
---@param idx GridRooms | integer
---@param direction Direction | integer
---@return DoorSlot | integer
function Stub.get_target_slot(level, idx, direction) end

---@param level Component.Level
---@param room Component.RoomDescriptor
function Stub.precalc_allowed_doors(level, room) end

---@param level Component.Level
function Stub.precalc_allowed_doors_wrapper(level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.load_room(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param target Component.RoomDescriptor
---@param current Component.RoomDescriptor
---@param doorSlot DoorSlot | integer
---@return boolean
function Stub.try_display_room(ctx, level, target, current, doorSlot) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.UpdateVisibility(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param room Component.RoomConfig.Room
function Stub.DEBUG_goto_room(ctx, level, room) end

---@param ctx Context.Common
---@param level Component.Level
---@param targetRoomIDX GridRooms | integer
---@param dimension Dimension | integer
function Stub.ChangeRoom(ctx, level, targetRoomIDX, dimension) end

---@param ctx Context.Common
---@param level Component.Level
---@param IAmErrorRoom boolean
---@param Seed integer
---@return integer
function Stub.GetRandomRoomIndex(ctx, level, IAmErrorRoom, Seed) end

---@param ctx Context.Common
---@param level Component.Level
---@return GridRooms | integer
function Stub.GetNonCompleteRoomIndex(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param seed integer
---@return GridRooms | integer
function Stub.GetNonVisitedRoomIndex(ctx, level, seed) end

---@param level Component.Level
---@param Index GridRooms | integer
---@param Dimension Dimension | integer
---@return Component.RoomDescriptor
function Stub.GetRoomByIdx(level, Index, Dimension) end

---@param level Component.Level
---@param Index GridRooms | integer
---@param Dimension Dimension | integer
---@return Component.RoomDescriptor
function Stub.GetRoomByIdx_wrapper(level, Index, Dimension) end

---@param level Component.Level
---@return Component.RoomDescriptor
function Stub.GetCurrentRoomDesc(level) end

---@param level Component.Level
function Stub.GetLastRoomDesc(level) end

---@param level Component.Level
---@return RoomDescriptor[]
function Stub.GetRooms(level) end

---@param ctx Context.Common
---@param level Component.Level
---@param RNG RNG
function Stub.generate_dungeon(ctx, level, RNG) end

---@param ctx Context.Common
---@param level Component.Level
---@param levelGen Component.LevelGenerator
---@param Backwards Component.BackwardsStageDesc
---@param Stage StbType | integer
---@param MinDifficulty_inlined integer
---@param MaxDifficulty integer
function Stub.place_rooms_backwards(ctx, level, levelGen, Backwards, Stage, MinDifficulty_inlined, MaxDifficulty) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_backwards_dungeon(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_greed_dungeon(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.Init(ctx, level) end

---@param ctx Context.Common
---@param param_1 Component.Entity.Effect
function Stub.PlayNextMomAndDad(ctx, param_1) end

---@param ctx Context.Common
---@param ret string
---@param stage LevelStage | integer
---@param type StageType | integer
---@param curses LevelCurse | integer
---@param BASEMENTnum integer
---@param jumble boolean
---@param Mode eMode | integer
function Stub.GetName(ctx, ret, stage, type, curses, BASEMENTnum, jumble, Mode) end

---@param ctx Context.Common
---@param level Component.Level
---@return string
function Stub.GetName_wrapper(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return string
function Stub.GetCurseName(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param Sticky boolean
function Stub.ShowName(ctx, level, Sticky) end

---@param ctx Context.Common
---@param level Component.Level
---@param stageid LevelStage | integer
---@param alt StageType | integer
function Stub.SetStage(ctx, level, stageid, alt) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.SetNextStage(ctx, level) end

---@param level Component.Level
---@param param_1 Component.RoomConfig.Room
---@param state Component.GameState.RoomConfig
---@param param_3 unknown[]
function Stub.write_room_config(level, param_1, state, param_3) end

---@param ctx Context.Common
---@param room Component.GameState.RoomConfig
---@param deque unknown[]
---@return Component.RoomConfig.Room
function Stub.read_room_config(ctx, room, deque) end

---@param ctx Context.Common
---@param level Component.Level
---@param param_1 Component.GameState
function Stub.RestoreGameState(ctx, level, param_1) end

---@param level Component.Level
---@param state Component.GameState
function Stub.StoreGameState(level, state) end

---@param ctx Context.Common
---@param level Component.Level
---@param roomSeed integer
---@return boolean
function Stub.ForceHorsemanBoss(ctx, level, roomSeed) end

---@param ctx Context.Common
---@param level Component.Level
---@return LevelCurse | integer
function Stub.GetCurses(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param RoomType RoomType | integer
---@param Visited? boolean
---@param rng RNG
---@param IgnoreGroup boolean
---@return GridRooms | integer
function Stub.QueryRoomTypeIndex(ctx, level, RoomType, Visited_qqq, rng, IgnoreGroup) end

---@param ctx Context.Common
---@param level Component.Level
---@param RoomIdx GridRooms | integer
---@return boolean
function Stub.CanOpenChallengeRoom(ctx, level, RoomIdx) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.ApplyMapEffect(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.ApplyBlueMapEffect(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param Persistent boolean
function Stub.ApplyCompassEffect(ctx, level, Persistent) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.ShowMap(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.TriggerSolEffect(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.ShowFirstSecretRoom(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.RemoveCompassEffect(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param Curses LevelCurse | integer
function Stub.RemoveCurses(ctx, level, Curses) end

---@param level Component.Level
---@param index integer
function Stub.get_similar_room(level, index) end

---@param level Component.Level
---@param index1 integer
---@param index2 integer
function Stub.swap_rooms(level, index1, index2) end

---@param idx unknown
---@return Component.RoomDescriptor
function Stub.get_near_rooms(idx) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.CanSpawnDevilRoom(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param ForceAngel boolean
---@param ForceDevil boolean
function Stub.InitializeDevilAngelRoom(ctx, level, ForceAngel, ForceDevil) end

---@param level Component.Level
---@return Vector
function Stub.GetEnterPosition(level) end

---@param level Component.Level
---@param CurrentRoomIdx integer
---@param DoorSlot DoorSlot | integer
function Stub.UncoverHiddenDoor(level, CurrentRoomIdx, DoorSlot) end

---@param level Component.Level
---@param portalIdx integer
---@param gridIdx unknown
---@param param_3 boolean
function Stub.UpdatePortal(level, portalIdx, gridIdx, param_3) end

---@param ctx Context.Common
---@param level Component.Level
---@param Curse integer
---@param ShowName boolean
function Stub.AddCurse(ctx, level, Curse, ShowName) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_blue_womb(ctx, level) end

---@param level Component.Level
function Stub.SetRedHeartDamage(level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.CanSpawnTrapDoor(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.IsNextStageAvailable(ctx, level) end

---@param ctx Context.Common
---@param LevelStage LevelStage | integer
---@param StageType StageType | integer
---@return boolean
function Stub.IsStageAvailable(ctx, LevelStage, StageType) end

---@param ctx Context.Common
---@param level Component.Level
---@return LevelStage | integer
function Stub.GetAbsoluteStage(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param Position Vector
function Stub.StartMamaMega(ctx, level, Position) end

---@param level Component.Level
---@return boolean
function Stub.IsAltPath(level) end

---@param ctx Context.Common
---@param level Component.Level
---@return integer
function Stub.GetSecretExitType(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param subtype integer
---@return Component.RoomDescriptor
function Stub.InitializeSecretExit(ctx, level, subtype) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.InitializeGenesisRoom(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.InitializeRotgutRooms(ctx, level) end

---@param level Component.Level
---@param idx GridRooms | integer
---@param doorSlot DoorSlot | integer
---@return GridRooms | integer
function Stub.get_room_neighbor_pos(level, idx, doorSlot) end

---@param ctx Context.Common
---@param level Component.Level
---@param roomIdx GridRooms | integer
---@param slot DoorSlot | integer
---@param retSlot1 DoorSlot | integer
---@param retSlot2 DoorSlot | integer
---@return boolean
function Stub.try_calc_red_room_doors(ctx, level, roomIdx, slot, retSlot1, retSlot2) end

---@param ctx Context.Common
---@param level Component.Level
---@param idx GridRooms | integer
---@param doorSlot DoorSlot | integer
---@return Component.LevelGenerator.Room
function Stub.get_target_red_room(ctx, level, idx, doorSlot) end

---@param ctx Context.Common
---@param level Component.Level
---@param idx integer
---@param slot integer
---@return boolean
function Stub.CanSpawnDoorOutline(ctx, level, idx, slot) end

---@param ctx Context.Common
---@param level Component.Level
---@param CurrentRoomIdx GridRooms | integer
---@param DoorSlot DoorSlot | integer
---@return boolean
function Stub.MakeRedRoomDoor(ctx, level, CurrentRoomIdx, DoorSlot) end

---@param ctx Context.Common
---@param level Component.Level
---@param currentIdx integer
---@param destIdx integer
---@param direction integer
function Stub.TryInitializeBlueRoom(ctx, level, currentIdx, destIdx, direction) end

---@param ctx Context.Common
---@param level Component.Level
---@param seed integer
---@return boolean
function Stub.TryInitializeExtraBossRoom(ctx, level, seed) end

---@param ctx Context.Common
---@param level Component.Level
---@param param_1 Component.RoomDescriptor
---@return boolean
function Stub.can_convert_to_red_treasure_room(ctx, level, param_1) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.UpdateDevilsCrown(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return number
function Stub.GetPlanetariumChance(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_isaacs_house(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.IsCorpseEntrance(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.IsBackwardsPathEntrance(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.TriggerRailButton(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.HasMirrorDimension(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.HasAbandonedMineshaft(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.HasPhotoDoor(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@return boolean
function Stub.IsBackwardsPath(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_mirror_world(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_mines_dungeon(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param idx GridRooms | integer
---@return StageType | integer
function Stub.GetLocalStageType(ctx, level, idx) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_perlin_maps(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
---@param param_1 Component.LevelGenerator
function Stub.place_redkey_dungeon_rooms(ctx, level, param_1) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_redkey_dungeon(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.TeleportToDarkCloset(ctx, level) end

---@param ctx Context.Common
---@param level Component.Level
function Stub.generate_dark_closet(ctx, level) end

---@param ctx Context.Common
---@param stage LevelStage | integer
---@param type StageType | integer
---@return boolean
function Stub.GetExtraBossRoomStage(ctx, stage, type) end

---@param level Component.Level
---@param param_1 unknown
---@return unknown
function Stub.build_specialnormal_room_index_blacklist(level, param_1) end

---@param level Component.Level
---@return boolean
function Stub.GetHeartPicked(level) end

---@param level Component.Level
---@return RNG
function Stub.GetDevilAngelRoomRNG(level) end

---@param level Component.Level
---@param Wave integer
function Stub.SetGreedModeWave(level, Wave) end

---@param level Component.Level
function Stub.DisableDevilRoom(level) end

---@param level Component.Level
---@return number
function Stub.GetAngelRoomChance(level) end

---@param ctx Context.Common
---@return boolean
function Stub.IsAshpitStageID(ctx) end

---@param level Component.Level
---@param param_1 Vector
function Stub.GetDungeonReturnPosition(level, param_1) end

---@param level Component.Level
---@return boolean
function Stub.GetCanSeeEverything(level) end

--endregion

Interface.GetStageType = Stub.GetStageType
Interface.GetStage = Stub.GetStage
Interface.SetHeartPicked = Stub.SetHeartPicked
Interface.GetCurrentRoomIdx = Stub.GetCurrentRoomIdx
Interface.GetEffectiveStage = Stub.GetEffectiveStage
Interface.GetPortal = Stub.GetPortal
Interface.GetEnterDoor = Stub.GetEnterDoor
Interface.GetLastBossRoomListIndex = Stub.GetLastBossRoomListIndex
Interface.GetStateFlag = Stub.GetStateFlag
Interface.GetDimension = Stub.GetDimension
Interface.GetStartingRoomIndex = Stub.GetStartingRoomIndex
Interface.SetLeaveDoor = Stub.SetLeaveDoor
Interface.SetStateFlag = Stub.SetStateFlag
Interface.GetRoomCount = Stub.GetRoomCount
Interface.SetEnterDoor = Stub.SetEnterDoor
Interface.SetDungeonReturnPosition = Stub.SetDungeonReturnPosition
Interface.SetDungeonRoomIndex = Stub.SetDungeonRoomIndex
Interface.IsCorpse = Stub.IsCorpse
Interface.GetPreviousRoomIndex = Stub.GetPreviousRoomIndex
Interface.SetCanSeeEverything = Stub.SetCanSeeEverything
Interface.GetDungeonReturnRoomIndex = Stub.GetDungeonReturnRoomIndex
Interface.GetDungeonPlacementSeed = Stub.GetDungeonPlacementSeed
Interface.GetRoomDescriptorsOffsetsArrayForDimension = Stub.GetRoomDescriptorsOffsetsArrayForDimension
Interface.AddAngelRoomChance = Stub.AddAngelRoomChance
Interface.GetStageID = Stub.GetStageID
Interface.GetLeaveDoor = Stub.GetLeaveDoor
Interface.SaveBackwardsStage = Stub.SaveBackwardsStage
Interface.GetGreedModeWave = Stub.GetGreedModeWave
Interface.destructor = Stub.destructor
Interface.GetStageID = Stub.GetStageID
Interface.Reset = Stub.Reset
Interface.CanStageHaveCurseOfLabyrinth = Stub.CanStageHaveCurseOfLabyrinth
Interface.Update = Stub.Update
Interface.reset_room_list = Stub.reset_room_list
Interface.place_room = Stub.place_room
Interface.build_secret_room_index_blacklist = Stub.build_secret_room_index_blacklist
Interface.place_rooms = Stub.place_rooms
Interface.try_get_target_slot = Stub.try_get_target_slot
Interface.get_target_slot = Stub.get_target_slot
Interface.precalc_allowed_doors = Stub.precalc_allowed_doors
Interface.precalc_allowed_doors_wrapper = Stub.precalc_allowed_doors_wrapper
Interface.load_room = Stub.load_room
Interface.try_display_room = Stub.try_display_room
Interface.UpdateVisibility = Stub.UpdateVisibility
Interface.DEBUG_goto_room = Stub.DEBUG_goto_room
Interface.ChangeRoom = Stub.ChangeRoom
Interface.GetRandomRoomIndex = Stub.GetRandomRoomIndex
Interface.GetNonCompleteRoomIndex = Stub.GetNonCompleteRoomIndex
Interface.GetNonVisitedRoomIndex = Stub.GetNonVisitedRoomIndex
Interface.GetRoomByIdx = Stub.GetRoomByIdx
Interface.GetRoomByIdx_wrapper = Stub.GetRoomByIdx_wrapper
Interface.GetCurrentRoomDesc = Stub.GetCurrentRoomDesc
Interface.GetLastRoomDesc = Stub.GetLastRoomDesc
Interface.GetRooms = Stub.GetRooms
Interface.generate_dungeon = Stub.generate_dungeon
Interface.place_rooms_backwards = Stub.place_rooms_backwards
Interface.generate_backwards_dungeon = Stub.generate_backwards_dungeon
Interface.generate_greed_dungeon = Stub.generate_greed_dungeon
Interface.Init = Stub.Init
Interface.PlayNextMomAndDad = Stub.PlayNextMomAndDad
Interface.GetName = Stub.GetName
Interface.GetName_wrapper = Stub.GetName_wrapper
Interface.GetCurseName = Stub.GetCurseName
Interface.ShowName = Stub.ShowName
Interface.SetStage = Stub.SetStage
Interface.SetNextStage = Stub.SetNextStage
Interface.write_room_config = Stub.write_room_config
Interface.read_room_config = Stub.read_room_config
Interface.RestoreGameState = Stub.RestoreGameState
Interface.StoreGameState = Stub.StoreGameState
Interface.ForceHorsemanBoss = Stub.ForceHorsemanBoss
Interface.GetCurses = Stub.GetCurses
Interface.QueryRoomTypeIndex = Stub.QueryRoomTypeIndex
Interface.CanOpenChallengeRoom = Stub.CanOpenChallengeRoom
Interface.ApplyMapEffect = Stub.ApplyMapEffect
Interface.ApplyBlueMapEffect = Stub.ApplyBlueMapEffect
Interface.ApplyCompassEffect = Stub.ApplyCompassEffect
Interface.ShowMap = Stub.ShowMap
Interface.TriggerSolEffect = Stub.TriggerSolEffect
Interface.ShowFirstSecretRoom = Stub.ShowFirstSecretRoom
Interface.RemoveCompassEffect = Stub.RemoveCompassEffect
Interface.RemoveCurses = Stub.RemoveCurses
Interface.get_similar_room = Stub.get_similar_room
Interface.swap_rooms = Stub.swap_rooms
Interface.get_near_rooms = Stub.get_near_rooms
Interface.CanSpawnDevilRoom = Stub.CanSpawnDevilRoom
Interface.InitializeDevilAngelRoom = Stub.InitializeDevilAngelRoom
Interface.GetEnterPosition = Stub.GetEnterPosition
Interface.UncoverHiddenDoor = Stub.UncoverHiddenDoor
Interface.UpdatePortal = Stub.UpdatePortal
Interface.AddCurse = Stub.AddCurse
Interface.generate_blue_womb = Stub.generate_blue_womb
Interface.SetRedHeartDamage = Stub.SetRedHeartDamage
Interface.CanSpawnTrapDoor = Stub.CanSpawnTrapDoor
Interface.IsNextStageAvailable = Stub.IsNextStageAvailable
Interface.IsStageAvailable = Stub.IsStageAvailable
Interface.GetAbsoluteStage = Stub.GetAbsoluteStage
Interface.StartMamaMega = Stub.StartMamaMega
Interface.IsAltPath = Stub.IsAltPath
Interface.GetSecretExitType = Stub.GetSecretExitType
Interface.InitializeSecretExit = Stub.InitializeSecretExit
Interface.InitializeGenesisRoom = Stub.InitializeGenesisRoom
Interface.InitializeRotgutRooms = Stub.InitializeRotgutRooms
Interface.get_room_neighbor_pos = Stub.get_room_neighbor_pos
Interface.try_calc_red_room_doors = Stub.try_calc_red_room_doors
Interface.get_target_red_room = Stub.get_target_red_room
Interface.CanSpawnDoorOutline = Stub.CanSpawnDoorOutline
Interface.MakeRedRoomDoor = Stub.MakeRedRoomDoor
Interface.TryInitializeBlueRoom = Stub.TryInitializeBlueRoom
Interface.TryInitializeExtraBossRoom = Stub.TryInitializeExtraBossRoom
Interface.can_convert_to_red_treasure_room = Stub.can_convert_to_red_treasure_room
Interface.UpdateDevilsCrown = Stub.UpdateDevilsCrown
Interface.GetPlanetariumChance = Stub.GetPlanetariumChance
Interface.generate_isaacs_house = Stub.generate_isaacs_house
Interface.IsCorpseEntrance = Stub.IsCorpseEntrance
Interface.IsBackwardsPathEntrance = Stub.IsBackwardsPathEntrance
Interface.TriggerRailButton = Stub.TriggerRailButton
Interface.HasMirrorDimension = Stub.HasMirrorDimension
Interface.HasAbandonedMineshaft = Stub.HasAbandonedMineshaft
Interface.HasPhotoDoor = Stub.HasPhotoDoor
Interface.IsBackwardsPath = Stub.IsBackwardsPath
Interface.generate_mirror_world = Stub.generate_mirror_world
Interface.generate_mines_dungeon = Stub.generate_mines_dungeon
Interface.GetLocalStageType = Stub.GetLocalStageType
Interface.generate_perlin_maps = Stub.generate_perlin_maps
Interface.place_redkey_dungeon_rooms = Stub.place_redkey_dungeon_rooms
Interface.generate_redkey_dungeon = Stub.generate_redkey_dungeon
Interface.TeleportToDarkCloset = Stub.TeleportToDarkCloset
Interface.generate_dark_closet = Stub.generate_dark_closet
Interface.GetExtraBossRoomStage = Stub.GetExtraBossRoomStage
Interface.build_specialnormal_room_index_blacklist = Stub.build_specialnormal_room_index_blacklist
Interface.GetHeartPicked = Stub.GetHeartPicked
Interface.GetDevilAngelRoomRNG = Stub.GetDevilAngelRoomRNG
Interface.SetGreedModeWave = Stub.SetGreedModeWave
Interface.DisableDevilRoom = Stub.DisableDevilRoom
Interface.GetAngelRoomChance = Stub.GetAngelRoomChance
Interface.IsAshpitStageID = Stub.IsAshpitStageID
Interface.GetDungeonReturnPosition = Stub.GetDungeonReturnPosition
Interface.GetCanSeeEverything = Stub.GetCanSeeEverything