---@class Interface.PauseScreen
local Interface = require("Isaac.Interface.PauseScreen")

--#region Stub

local Stub = {}

---@param pauseScreen Component.PauseScreen
function Stub.Destructor(pauseScreen) end

---@param ctx Context.Common
---@return Component.Entity.Player
function Stub.GetPlayer(ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.Init(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.Reset(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.ProcessInput(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.Update(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.Render(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.Close(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.Show(pauseScreen, ctx) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
---@param param_1 unknown
---@param param_2 integer
---@return boolean
function Stub.controller_disconnect_handling(pauseScreen, ctx, param_1, param_2) end

---@param pauseScreen Component.PauseScreen
function Stub.PreLanguageSwitch(pauseScreen) end

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
function Stub.PostLanguageSwitch(pauseScreen, ctx) end

--#endregion

Interface.Destructor = Stub.Destructor
Interface.GetPlayer = Stub.GetPlayer
Interface.Init = Stub.Init
Interface.Reset = Stub.Reset
Interface.ProcessInput = Stub.ProcessInput
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Close = Stub.Close
Interface.Show = Stub.Show
Interface.controller_disconnect_handling = Stub.controller_disconnect_handling
Interface.PreLanguageSwitch = Stub.PreLanguageSwitch
Interface.PostLanguageSwitch = Stub.PostLanguageSwitch