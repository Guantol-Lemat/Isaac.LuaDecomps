---@class Interface.Ambush
local Interface = require("Isaac.Interface.Ambush")

--#region Stub

local Stub = {}

---@param ambush Component.Ambush
function Stub.destructor(ambush) end

---@param ambush Component.Ambush
---@param ctx Context.Common
function Stub.init_bossrush_pool(ambush, ctx) end

---@param ambush Component.Ambush
---@param ctx Context.Common
function Stub.StartChallenge(ambush, ctx) end

---@param ambush Component.Ambush
---@param ctx Context.Common
function Stub.spawn_wave(ambush, ctx) end

---@param ambush Component.Ambush
---@param ctx Context.Common
function Stub.spawn_bossrush_wave(ambush, ctx) end

---@param ambush Component.Ambush
---@param ctx Context.Common
function Stub.Update(ambush, ctx) end

---@param ambush Component.Ambush
---@param file string
function Stub.Load(ambush, file) end

--#endregion

Interface.destructor = Stub.destructor
Interface.init_bossrush_pool = Stub.init_bossrush_pool
Interface.StartChallenge = Stub.StartChallenge
Interface.spawn_wave = Stub.spawn_wave
Interface.spawn_bossrush_wave = Stub.spawn_bossrush_wave
Interface.Update = Stub.Update
Interface.Load = Stub.Load