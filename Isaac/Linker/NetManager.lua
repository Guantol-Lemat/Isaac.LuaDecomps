---@class Interface.NetManager
local Interface = require("Isaac.Interface.NetManager")

--#region Stub

local Stub = {}

---@param manager Component.NetManager
function Stub.Init(manager)
end

---@param manager Component.NetManager
---@param param1 boolean
function Stub.Reset(manager, param1)
end

---@param manager Component.NetManager
function Stub.Update(manager)
end

--#endregion

Interface.Init = Stub.Init
Interface.Reset = Stub.Reset
Interface.Update = Stub.Update