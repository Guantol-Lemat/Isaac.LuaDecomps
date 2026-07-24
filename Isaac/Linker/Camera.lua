---@class Interface.Camera
local Interface = require("Isaac.Interface.Camera")

--#region Stub

local Stub = {}

---@param camera Component.Camera
function Stub.destructor(camera) end

---@param ctx Context.Common
---@param room Component.Room
---@return Component.Camera
function Stub.New(ctx, room) end

---@param samples Vector[]
---@param smoothAmount number
---@return Vector
function Stub.smooth_samples(samples, smoothAmount) end

---@param camera Component.Camera
---@param min_qqq Vector
---@param max_qqq Vector
function Stub.get_min_max_offset(camera, min_qqq, max_qqq) end

---@param camera Component.Camera
---@param ctx Context.Common
---@param res Vector
---@param pos Vector
---@return Vector
function Stub.clamped_to_room(camera, ctx, res, pos) end

---@param camera Component.Camera
---@param ret Vector
---@param renderScrollOffset Vector
---@return Vector
function Stub.slow_stop(camera, ret, renderScrollOffset) end

---@param camera Component.Camera
---@param ctx Context.Common
---@param unk boolean
function Stub.DoUpdate(camera, ctx, unk) end

---@param camera Component.Camera
---@param ctx Context.Common
function Stub.InitPosition(camera, ctx) end

---@param camera Component.Camera
---@param ctx Context.Common
---@param unkBool boolean
function Stub.update_ultrasmooth(camera, ctx, unkBool) end

---@param camera Component.Camera
---@param ctx Context.Common
function Stub.update_drag2(camera, ctx) end

---@param camera Component.Camera
---@param ctx Context.Common
---@param Pos Vector
---@return boolean
function Stub.IsPosVisible(camera, ctx, Pos) end

---@param camera Component.Camera
---@param pos Vector
function Stub.SetFocusPosition(camera, pos) end

---@param camera Component.Camera
---@param ctx Context.Common
---@param pos Vector
function Stub.SnapToPosition(camera, ctx, pos) end

--#endregion

Interface.destructor = Stub.destructor
Interface.New = Stub.New
Interface.smooth_samples = Stub.smooth_samples
Interface.get_min_max_offset = Stub.get_min_max_offset
Interface.clamped_to_room = Stub.clamped_to_room
Interface.slow_stop = Stub.slow_stop
Interface.DoUpdate = Stub.DoUpdate
Interface.InitPosition = Stub.InitPosition
Interface.update_ultrasmooth = Stub.update_ultrasmooth
Interface.update_drag2 = Stub.update_drag2
Interface.IsPosVisible = Stub.IsPosVisible
Interface.SetFocusPosition = Stub.SetFocusPosition
Interface.SnapToPosition = Stub.SnapToPosition