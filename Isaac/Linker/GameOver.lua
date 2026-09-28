---@class Interface.GameOver
local Interface = require("Isaac.Interface.GameOver")

--#region Stub

local Stub = {}

---@param gameOver Component.GameOver
function Stub.destructor(gameOver) end

---@param gameOver Component.GameOver
function Stub.Init(gameOver) end

---@param gameOver Component.GameOver
function Stub.Update(gameOver) end

---@param gameOver Component.GameOver
function Stub.Render(gameOver) end

---@param gameOver Component.GameOver
function Stub.ProcessInput(gameOver) end

---@param gameOver Component.GameOver
function Stub.Show(gameOver) end

---@param gameOver Component.GameOver
---@param collectible CollectibleType | integer
---@param pos Vector
---@param color Color
---@param scale Vector
---@param blend Engine.BlendMode
function Stub.RenderItemSprite(gameOver, collectible, pos, color, scale, blend) end

--#endregion

Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.ProcessInput = Stub.ProcessInput
Interface.Show = Stub.Show
Interface.RenderItemSprite = Stub.RenderItemSprite