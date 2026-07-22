---@class Interface.GenericPrompt
local Interface = require("Isaac.Interface.GenericPrompt")

--#region Stub

local Stub = {}

---@return Component.GenericPrompt
function Stub.constructor() end

---@param prompt Component.GenericPrompt
function Stub.destructor(prompt) end

---@param prompt Component.GenericPrompt
---@param ctx Context.Common
---@param SmallPrompt boolean
function Stub.Initialize(prompt, ctx, SmallPrompt) end

---@param prompt Component.GenericPrompt
---@param ctx Context.Common
---@param processInput boolean
function Stub.Update(prompt, ctx, processInput) end

---@param prompt Component.GenericPrompt
---@param ctx Context.Common
function Stub.Render(prompt, ctx) end

---@param prompt Component.GenericPrompt
---@param ctx Context.Common
function Stub.ProcessInput(prompt, ctx) end

---@param prompt Component.GenericPrompt
function Stub.Show(prompt) end

---@param anm2 Sprite
function Stub.Hide(anm2) end

---@param prompt Component.GenericPrompt
---@return boolean
function Stub.IsActive(prompt) end

---@param prompt Component.GenericPrompt
---@param param_1 string
---@param param_2 string
---@param param_3 string
---@param param_4 string
---@param param_5 string
function Stub.SetText(prompt, param_1, param_2, param_3, param_4, param_5) end

---@param prompt Component.GenericPrompt
---@param ctx Context.Common
---@param unused string
function Stub.SetImageToVictoryRun(prompt, ctx, unused) end

--#endregion

Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.Initialize = Stub.Initialize
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.ProcessInput = Stub.ProcessInput
Interface.Show = Stub.Show
Interface.Hide = Stub.Hide
Interface.IsActive = Stub.IsActive
Interface.SetText = Stub.SetText
Interface.SetImageToVictoryRun = Stub.SetImageToVictoryRun