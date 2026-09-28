---@class Interface.NetManager
local Interface = require("Isaac.Interface.NetManager")

--#region Stub

local Stub = {}

---@param netManager Component.NetManager
---@return boolean
function Stub.IsNetPlay(netManager)
end

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

Interface.IsNetPlay = Interface.IsNetPlay
Interface.Init = Stub.Init
Interface.Reset = Stub.Reset
Interface.Update = Stub.Update