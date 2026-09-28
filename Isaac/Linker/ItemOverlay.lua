---@class Interface.ItemOverlay
local Interface = require("Isaac.Interface.ItemOverlay")

--#region Stub

local Stub = {}

---@param itemOverlay Component.ItemOverlay
---@return Sprite
function Stub.GetMegaMushPlayerSprite(itemOverlay) end

---@param itemOverlay Component.ItemOverlay
function Stub.destructor(itemOverlay) end

---@param itemOverlay Component.ItemOverlay
---@param fileName string
function Stub.Init(itemOverlay, fileName) end

---@param itemOverlay Component.ItemOverlay
function Stub.Reset(itemOverlay) end

---@param itemOverlay Component.ItemOverlay
---@param exit boolean
function Stub.Update(itemOverlay, exit) end

---@param itemOverlay Component.ItemOverlay
function Stub.Render(itemOverlay) end

---@param itemOverlay Component.ItemOverlay
---@param id Giantbook | integer
---@param delay integer
---@param player Component.Entity.Player
function Stub.Show(itemOverlay, id, delay, player) end

--#endregion

Interface.GetMegaMushPlayerSprite = Stub.GetMegaMushPlayerSprite
Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.Reset = Stub.Reset
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Show = Stub.Show