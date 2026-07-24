---@class Interface.RoomConfig
local Interface = require("Isaac.Interface.RoomConfig")

---@class Interface.RoomConfig.Spawn
local Interface_Spawn = Interface.Spawn

local RoomConfigMisc = require("Isaac.Gameplay.RoomConfig.RoomConfigMisc")

--#region Stub

local Stub = {}

---@param ctx Context.Common
---@param bossId BossType | integer
---@param seed integer
---@return Component.RoomConfig.Room
function Stub.GetRandomBossRoom(ctx, bossId, seed) end

---@param roomConfig Component.RoomConfig
function Stub.Destructor(roomConfig) end

---@param room unknown
---@param path string
function Stub.LoadSingleRoom(room, path) end

---@param x integer
---@param y integer
---@param shape RoomShape | integer
---@return DoorSlot | integer
function Stub.parse_door_node(x, y, shape) end

---@param param_1_00 integer
---@param param_2 unknown
---@param param_3 integer
function Stub.parse_room_node(param_1_00, param_2, param_3) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param Stage LevelStage | integer
---@param Mode eMode | integer
function Stub.ResetRoomWeights(roomConfig, ctx, Stage, Mode) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param StageID StbType | integer
---@param Mode eMode | integer
---@return boolean
function Stub.LoadStageBinary(roomConfig, ctx, StageID, Mode) end

---@param set Component.RoomConfig.Stage.RoomSet
---@param mode eMode | integer
---@param stageId StbType | integer
---@param file integer
function Stub.read_room(set, mode, stageId, file) end

---@param filepath string
function Stub.Load(filepath) end

---@param roomConfig Component.RoomConfig
---@param filepath string
---@param ismod boolean
function Stub.LoadCurses(roomConfig, filepath, ismod) end

---@param param_1 string
function Stub.LoadMinibosses(param_1) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param buffer string
---@param id integer
---@return string
function Stub.GetCurseName(roomConfig, ctx, buffer, id) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param stage StbType | integer
---@param type RoomType | integer
---@param variant integer
---@param mode eMode | integer
---@return Component.RoomConfig.Room
function Stub.GetRoom(roomConfig, ctx, stage, type, variant, mode) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param seed integer
---@param reduceWeight boolean
---@param stageId StbType | integer
---@param type RoomType | integer
---@param shape RoomShape | integer
---@param minVariant integer
---@param maxVariant integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors integer
---@param subtype integer
---@param mode eMode | integer
---@return Component.RoomConfig.Room
function Stub.GetRandomRoom(roomConfig, ctx, seed, reduceWeight, stageId, type, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param seed integer
---@param reduceWeight boolean
---@param stage1 StbType | integer
---@param stage2 StbType | integer
---@param type RoomType | integer
---@param shape RoomShape | integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors integer
---@param subtype integer
---@return Component.RoomConfig.Room
function Stub.GetRandomRoomFromOptionalStage(roomConfig, ctx, seed, reduceWeight, stage1, stage2, type, shape, minDifficulty, maxDifficulty, doors, subtype) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param result Component.RoomConfig.Room[]
---@param stage StbType | integer
---@param type RoomType | integer
---@param shape integer
---@param minVariant integer
---@param maxVariant integer
---@param minDifficulty integer
---@param maxDifficulty integer
---@param doors integer
---@param subtype integer
---@param mode eMode | integer
function Stub.GetRooms(roomConfig, ctx, result, stage, type, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, doors, subtype, mode) end

---@param ctx Context.Common
---@param LevelStage LevelStage | integer
---@param StageType StageType | integer
---@param Mode eMode | integer
---@return StbType | integer
function Stub.GetStageID(ctx, LevelStage, StageType, Mode) end

---@param roomConfig Component.RoomConfig
function Stub.ClearGeneratedRooms(roomConfig) end

---@param roomConfig Component.RoomConfig
---@param room1 Component.RoomConfig.Room
---@param room2 Component.RoomConfig.Room
---@param shape integer
---@return Component.RoomConfig.Room
function Stub.CreateMergedRoom(roomConfig, room1, room2, shape) end

---@param roomConfig Component.RoomConfig
---@param ctx Context.Common
---@param Seed integer
---@param ReduceWeight boolean
---@param Stage integer
---@param Type RoomType | integer
---@param Shape RoomShape | integer
---@param MinVariant integer
---@param MaxVariant integer
---@param MinDifficulty integer
---@param MaxDifficulty integer
---@param RequiredDoors integer
---@param SubType integer
---@param Mode integer
---@return Component.RoomConfig.Room
function Stub.try_generate_merged_room(roomConfig, ctx, Seed, ReduceWeight, Stage, Type, Shape, MinVariant, MaxVariant, MinDifficulty, MaxDifficulty, RequiredDoors, SubType, Mode) end

---@param roomConfig Component.RoomConfig
---@param room Component.RoomConfig.Room
---@return Component.RoomConfig.Room
function Stub.CreateMirroredRoom(roomConfig, room) end

--#endregion

Interface.GetRandomBossRoom = Stub.GetRandomBossRoom
Interface.Destructor = Stub.Destructor
Interface.LoadSingleRoom = Stub.LoadSingleRoom
Interface.parse_door_node = Stub.parse_door_node
Interface.parse_room_node = Stub.parse_room_node
Interface.ResetRoomWeights = Stub.ResetRoomWeights
Interface.LoadStageBinary = Stub.LoadStageBinary
Interface.read_room = Stub.read_room
Interface.Load = Stub.Load
Interface.LoadCurses = Stub.LoadCurses
Interface.LoadMinibosses = Stub.LoadMinibosses
Interface.GetCurseName = Stub.GetCurseName
Interface.GetRoom = Stub.GetRoom
Interface.GetRandomRoom = Stub.GetRandomRoom
Interface.GetRandomRoomFromOptionalStage = Stub.GetRandomRoomFromOptionalStage
Interface.GetRooms = Stub.GetRooms
Interface.GetStageID = Stub.GetStageID
Interface.ClearGeneratedRooms = Stub.ClearGeneratedRooms
Interface.CreateMergedRoom = Stub.CreateMergedRoom
Interface.try_generate_merged_room = Stub.try_generate_merged_room
Interface.CreateMirroredRoom = Stub.CreateMirroredRoom

Interface_Spawn.PickEntry = RoomConfigMisc.Spawn_PickEntry