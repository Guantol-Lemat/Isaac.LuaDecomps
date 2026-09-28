---@class Interface.DebugRenderer
local Interface = require("Isaac.Interface.DebugRenderer")

--#region Stub

local Stub = {}

---@param debugRenderer Component.DebugRenderer
function Stub.Update(debugRenderer) end

---@param debugRenderer Component.DebugRenderer
function Stub.Render(debugRenderer) end

---@param debugRenderer Component.DebugRenderer
---@param Index_qqq integer
---@param param_2 boolean
---@return Component.DebugRenderer.Shape
function Stub.Get(debugRenderer, Index_qqq, param_2) end

---@param debugRenderer Component.DebugRenderer
function Stub.Destructor(debugRenderer) end

--#endregion

Interface.Destructor = Stub.Destructor
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Get = Stub.Get