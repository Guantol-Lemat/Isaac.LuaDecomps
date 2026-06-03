---@class Interface.LevelGenerator
local Interface = require("Isaac.Interface.LevelGenerator")

local Component = require("Isaac.Components.Level.LevelGeneratorComponent")
local Utils = require("Isaac.Gameplay.Level.LevelGenerator.Utils")

--#region Stub

local Stub = {}

---@param levelGen Component.LevelGenerator
---@param loops integer
---@param chapter6 boolean
---@param isXL boolean
---@param isVoid boolean
---@param allowedShapes integer
---@param numDeadEnds integer
---@param startRoom Component.LevelGenerator.Room
function Stub.Generate(levelGen, loops, chapter6, isXL, isVoid, allowedShapes, numDeadEnds, startRoom) end

---@param levelGen Component.LevelGenerator
---@param x integer
---@param y integer
---@param shape RoomShape | integer
---@param connectX integer
---@param connectY integer
---@param connectDir Direction | integer
function Stub.CreateRoom(levelGen, x, y, shape, connectX, connectY, connectDir) end

---@param levelGen Component.LevelGenerator
---@param param_1 unknown
---@param param_2 integer
---@return integer
function Stub.CreateRandomEndRoom(levelGen, param_1, param_2) end

---@param levelGen Component.LevelGenerator
---@param roomShape integer
---@param possibleDoors integer
---@return integer
function Stub.GetNewEndRoom(levelGen, roomShape, possibleDoors) end

---@param levelGen Component.LevelGenerator
---@param param_1 unknown
---@return Component.Room
function Stub.GetNewSecretRoom(levelGen, param_1) end

---@param levelGen Component.LevelGenerator
---@param tree integer
---@return Component.Room
function Stub.GetNewUltraSecretRoom(levelGen, tree) end

---@param levelGen Component.LevelGenerator
---@param shape RoomShape | integer
---@param possibleDoors DoorSlot | integer
function Stub.determine_boss_room(levelGen, shape, possibleDoors) end

---@param levelGen Component.LevelGenerator
---@param shape RoomShape | integer
---@param possibleDoorSlots DoorSlot | integer
---@param force_qqq boolean
---@return Component.LevelGenerator.Room
function Stub.GetNewBossRoom(levelGen, shape, possibleDoorSlots, force_qqq) end

---@param levelGen Component.LevelGenerator
---@return boolean
function Stub.make_new_dead_end(levelGen) end

---@param levelGen Component.LevelGenerator
---@param room Component.LevelGenerator.Room
function Stub.calc_required_doors(levelGen, room) end

---@param levelGen Component.LevelGenerator
function Stub.mark_dead_ends(levelGen) end

---@param levelGen Component.LevelGenerator
function Stub.calc_required_doors_wrapper(levelGen) end

---@param levelGen Component.LevelGenerator
---@param room Component.LevelGenerator.Room
---@return Component.LevelGenerator.Room
function Stub.place_room(levelGen, room) end

---@param levelGen Component.LevelGenerator
---@param loops integer
---@param startRoom Component.LevelGenerator.Room
function Stub.make_rooms(levelGen, loops, startRoom) end

---@param levelGen Component.LevelGenerator
---@param resVector Component.LevelGenerator.Room[]
---@param generationIdx integer
---@param param_3 boolean
function Stub.get_neighbor_candidates(levelGen, resVector, generationIdx, param_3) end

---@param levelGen Component.LevelGenerator
---@param room Component.LevelGenerator.Room
---@param shape RoomShape | integer
---@param possibleSlots integer
function Stub.try_resize_endroom(levelGen, room, shape, possibleSlots) end

--endregion

Interface.New = Component.New
Interface.Generate = Stub.Generate
Interface.CreateRoom = Stub.CreateRoom
Interface.CreateRandomEndRoom = Stub.CreateRandomEndRoom
Interface.GetNewEndRoom = Stub.GetNewEndRoom
Interface.GetNewSecretRoom = Stub.GetNewSecretRoom
Interface.GetNewUltraSecretRoom = Stub.GetNewUltraSecretRoom
Interface.determine_boss_room = Stub.determine_boss_room
Interface.GetNewBossRoom = Stub.GetNewBossRoom
Interface.GetRemainingRooms = Utils.GetRemainingRooms
Interface.make_new_dead_end = Stub.make_new_dead_end
Interface.has_shape_slot = Utils.HasShapeSlot
Interface.get_door_source_position = Utils.GetDoorSourcePosition
Interface.get_door_target_position = Utils.GetDoorTargetPosition
Interface.calc_required_doors = Stub.calc_required_doors
Interface.mark_dead_ends = Stub.mark_dead_ends
Interface.calc_required_doors_wrapper = Stub.calc_required_doors_wrapper
Interface.index = Utils.Index
Interface.get_room_placement_offsets = Utils.GetRoomPlacementOffsets
Interface.is_pos_free = Utils.IsPosFree
Interface.is_placement_valid = Utils.IsPlacementValid
Interface.place_room = Stub.place_room
Interface.count_neighbors = Utils.CountNeighbors
Interface.make_rooms = Stub.make_rooms
Interface.get_neighbor_candidates = Stub.get_neighbor_candidates
Interface.try_resize_endroom = Stub.try_resize_endroom
Interface.BlockOccupiedAndNeighbors_Room = Utils.BlockOccupiedAndNeighbors_Room
Interface.BlockPosition = Utils.BlockPosition
Interface.BlockOccupiedAndNeighbors_LevelGen = Utils.BlockOccupiedAndNeighbors_LevelGen
Interface.BlockDisabledDoorPositions = Utils.BlockDisabledDoorPositions