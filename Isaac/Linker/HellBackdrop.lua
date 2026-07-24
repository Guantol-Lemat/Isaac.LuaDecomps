---@class Interface.HellBackdrop
local Interface = require("Isaac.Interface.HellBackdrop")

--#region Stub

local Stub = {}

---@param hellBackdrop Component.HellBackdrop
---@return number
function Stub.ScrollRelatedMethod(hellBackdrop) end

---@param hellBackdrop Component.HellBackdrop
---@param ctx Context.Common
function Stub.Init(hellBackdrop, ctx) end

---@param hellBackdrop Component.HellBackdrop
---@param ctx Context.Common
function Stub.Update(hellBackdrop, ctx) end

---@param hellBackdrop Component.HellBackdrop
---@param ctx Context.Common
function Stub.PreRenderLightOverlay(hellBackdrop, ctx) end

---@param hellBackdrop Component.HellBackdrop
---@param ctx Context.Common
---@param eHellLayer integer
function Stub.RenderLayer(hellBackdrop, ctx, eHellLayer) end

--#endregion

Interface.ScrollRelatedMethod = Stub.ScrollRelatedMethod
Interface.Init = Stub.Init
Interface.Update = Stub.Update
Interface.PreRenderLightOverlay = Stub.PreRenderLightOverlay
Interface.RenderLayer = Stub.RenderLayer