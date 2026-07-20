---@class Interface.Npc.Pathfinder
local Interface = require("Isaac.Interface.NPC_Pathfinder")

--#region Stub

local Stub = {}

---@param pathfinder Component.Npc.Pathfinder
---@return integer
function Stub.GetEvadeMovementCountdown(pathfinder) end

---@param pathfinder Component.Npc.Pathfinder
---@param Value boolean
function Stub.SetCanCrushRocks(pathfinder, Value) end

---@param pathfinder Component.Npc.Pathfinder
---@return boolean
function Stub.HasDirectPath(pathfinder) end

---@param pathfinder Component.Npc.Pathfinder
---@param entity Component.Entity
---@return Component.Npc.Pathfinder
function Stub.constructor(pathfinder, entity) end

---@param pathfinder Component.Npc.Pathfinder
function Stub.Reset(pathfinder) end

---@param pathfinder Component.Npc.Pathfinder
---@return boolean
function Stub.should_use_charmed_movement_qqq(pathfinder) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param Pos Vector
---@param Speed number
---@param PathMarker integer
---@param UseDirectPath boolean
function Stub.FindGridPath(ctx, pathfinder, Pos, Speed, PathMarker, UseDirectPath) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param TargetPos Vector
---@param IgnoreStatusEffects boolean
function Stub.EvadeTarget(ctx, pathfinder, TargetPos, IgnoreStatusEffects) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param Speed number
---@param IgnoreStatusEffects boolean
function Stub.MoveRandomlyAxisAligned(ctx, pathfinder, Speed, IgnoreStatusEffects) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param IgnoreStatusEffects boolean
---@return boolean
function Stub.MoveRandomly(ctx, pathfinder, IgnoreStatusEffects) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param IgnoreStatusEffects boolean
function Stub.MoveRandomlyBoss(ctx, pathfinder, IgnoreStatusEffects) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param unused boolean
function Stub.MoveRandomly2(ctx, pathfinder, unused) end

---@param pathfinder Component.Npc.Pathfinder
function Stub.ResetMovementTarget(pathfinder) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
function Stub.UpdateGridIndex(ctx, pathfinder) end

---@param ctx Context.Common
---@param pathfinder Component.Npc.Pathfinder
---@param Position Vector
---@param IgnorePoop boolean
---@return boolean
function Stub.HasPathToPos(ctx, pathfinder, Position, IgnorePoop) end

---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 Vector
---@return boolean
function Stub.HasPathToPos_vector(ctx, param_1, param_2) end

---@param pathfinder Component.Npc.Pathfinder
---@param PathMarker integer
---@return integer
function Stub.get_new_pathmarker_related(pathfinder, PathMarker) end

---@param pathfinder Component.Npc.Pathfinder
---@param movementInput Vector
---@param speed_qqq number
---@param unused boolean
function Stub.SimulatePlayerMovement(pathfinder, movementInput, speed_qqq, unused) end

--#endregion

Interface.GetEvadeMovementCountdown = Stub.GetEvadeMovementCountdown
Interface.SetCanCrushRocks = Stub.SetCanCrushRocks
Interface.HasDirectPath = Stub.HasDirectPath
Interface.constructor = Stub.constructor
Interface.Reset = Stub.Reset
Interface.should_use_charmed_movement_qqq = Stub.should_use_charmed_movement_qqq
Interface.FindGridPath = Stub.FindGridPath
Interface.EvadeTarget = Stub.EvadeTarget
Interface.MoveRandomlyAxisAligned = Stub.MoveRandomlyAxisAligned
Interface.MoveRandomly = Stub.MoveRandomly
Interface.MoveRandomlyBoss = Stub.MoveRandomlyBoss
Interface.MoveRandomly2 = Stub.MoveRandomly2
Interface.ResetMovementTarget = Stub.ResetMovementTarget
Interface.UpdateGridIndex = Stub.UpdateGridIndex
Interface.HasPathToPos = Stub.HasPathToPos
Interface.HasPathToPos_vector = Stub.HasPathToPos_vector
Interface.get_new_pathmarker_related = Stub.get_new_pathmarker_related
Interface.SimulatePlayerMovement = Stub.SimulatePlayerMovement