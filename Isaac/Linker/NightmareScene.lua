---@class Interface.NightmareScene
local Interface = require("Isaac.Interface.NightmareScene")

--#region Stub

local Stub = {}

---@param nightmare Component.NightmareScene
---@param param_1 string
function Stub.LoadConfig(nightmare, param_1) end

---@param nightmare Component.NightmareScene
function Stub.Reset(nightmare) end

---@param nightmare Component.NightmareScene
---@param ctx Context.Common
function Stub.Update(nightmare, ctx) end

---@param nightmare Component.NightmareScene
---@param ctx Context.Common
function Stub.Render(nightmare, ctx) end

---@param nightmare Component.NightmareScene
---@param ctx Context.Common
---@param param_1 boolean
function Stub.Show(nightmare, ctx, param_1) end

---@param nightmare Component.NightmareScene
---@param ctx Context.Common
---@param StageID LevelStage | integer
---@param AltStageID StageType | integer
function Stub.SetStageAlt(nightmare, ctx, StageID, AltStageID) end

---@param nightmare Component.NightmareScene
function Stub.Destroy(nightmare) end

--endregion

Interface.LoadConfig = Stub.LoadConfig
Interface.Reset = Stub.Reset
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Show = Stub.Show
Interface.SetStageAlt = Stub.SetStageAlt
Interface.Destroy = Stub.Destroy