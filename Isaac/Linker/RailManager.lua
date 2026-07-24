---@class Interface.RailManager
local Interface = require("Isaac.Interface.RailManager")

--#region Stub

local Stub = {}

---@param ctx Context.Common
---@param param_1 integer
---@return integer
function Stub.GetRailVariant(ctx, param_1) end

---@param railManager Component.RailManager
---@param ctx Context.Common
function Stub.Init(railManager, ctx) end

---@param railManager Component.RailManager
---@param ctx Context.Common
---@param Pos Vector
function Stub.RenderGroundRails(railManager, ctx, Pos) end

---@param railManager Component.RailManager
---@param ctx Context.Common
---@param Pos Vector
function Stub.RenderPitRails(railManager, ctx, Pos) end

---@param railManager Component.RailManager
---@param param_1 integer
---@param param_2 integer
---@return boolean
function Stub.CanConnectToRail(railManager, param_1, param_2) end

---@param railManager Component.RailManager
---@param param_1 integer
---@param gridIdx integer
---@return Vector
function Stub.HasRailPath(railManager, param_1, gridIdx) end

---@param railManager Component.RailManager
---@param pos Vector
---@param velocity Vector
---@param gridIdx integer
---@param type_qqq integer
---@param vecBuffer Vector
---@param newPosBuffer Vector
---@param floatBuffer1 number
---@param floatBuffer2 number
---@param flip_qqq boolean
function Stub.ProjectPositionOnRail(railManager, pos, velocity, gridIdx, type_qqq, vecBuffer, newPosBuffer, floatBuffer1, floatBuffer2, flip_qqq) end

--#endregion

Interface.GetRailVariant = Stub.GetRailVariant
Interface.Init = Stub.Init
Interface.RenderGroundRails = Stub.RenderGroundRails
Interface.RenderPitRails = Stub.RenderPitRails
Interface.CanConnectToRail = Stub.CanConnectToRail
Interface.HasRailPath = Stub.HasRailPath
Interface.ProjectPositionOnRail = Stub.ProjectPositionOnRail