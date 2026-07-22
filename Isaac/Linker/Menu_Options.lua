---@class Interface.Menu_Options
local Interface = require("Isaac.Interface.Menu_Options")

--#region Stub

local Stub = {}

---@param menuOptions Component.Menu_Options
---@return Component.Menu_Options
function Stub.Constructor(menuOptions) end

---@param menuOptions Component.Menu_Options
function Stub.destructor(menuOptions) end

---@param menuOptions Component.Menu_Options
---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 boolean
function Stub.Init(menuOptions, ctx, param_1, param_2) end

---@param menuOptions Component.Menu_Options
---@param ctx Context.Common
function Stub.PostLanguageSwitch(menuOptions, ctx) end

---@param menuOptions Component.Menu_Options
---@param ctx Context.Common
function Stub.Update(menuOptions, ctx) end

---@param menuOptions Component.Menu_Options
---@param ctx Context.Common
function Stub.Render(menuOptions, ctx) end

---@param menuOptions Component.Menu_Options
---@param ctx Context.Common
function Stub.Reset(menuOptions, ctx) end

---@param menuOptions Component.Menu_Options
---@param ctx Context.Common
---@param param_1 integer
---@param param_2 integer
---@param param_3 Vector
function Stub.DisplayNum(menuOptions, ctx, param_1, param_2, param_3) end

---@param menuOptions Component.Menu_Options
---@param param_1 integer
function Stub.SetLocalRenderOffset(menuOptions, param_1) end

--#endregion

Interface.Constructor = Stub.Constructor
Interface.destructor = Stub.destructor
Interface.Init = Stub.Init
Interface.PostLanguageSwitch = Stub.PostLanguageSwitch
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Reset = Stub.Reset
Interface.DisplayNum = Stub.DisplayNum
Interface.SetLocalRenderOffset = Stub.SetLocalRenderOffset