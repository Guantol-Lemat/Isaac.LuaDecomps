---@class Interface.BossOverlay
local Interface = require("Isaac.Interface.BossOverlay")

--#region Stub

local Stub = {}

---@param bossOverlay Component.BossOverlay
function Stub.destructor(bossOverlay) end

---@param bossOverlay Component.BossOverlay
---@param filename string
function Stub.Init(bossOverlay, filename) end

---@param bossOverlay Component.BossOverlay
function Stub.Reset(bossOverlay) end

---@param bossOverlay Component.BossOverlay
function Stub.Update(bossOverlay) end

---@param bossOverlay Component.BossOverlay
function Stub.Render(bossOverlay) end

---@param bossOverlay Component.BossOverlay
---@param overlayID BossOverlay.eOverlayID | integer
function Stub.Show(bossOverlay, overlayID) end

--#endregion

Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.Reset = Stub.Reset
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Show = Stub.Show