---@class Interface.HellBackdrop
local Interface = require("Isaac.Interface.HellBackdrop")

--#region Stub

local Stub = {}

---@param hellBackdrop Component.HellBackdrop
---@return number
function Stub.ScrollRelatedMethod(hellBackdrop) end

---@param hellBackdrop Component.HellBackdrop
function Stub.Init(hellBackdrop) end

---@param hellBackdrop Component.HellBackdrop
function Stub.Update(hellBackdrop) end

---@param hellBackdrop Component.HellBackdrop
function Stub.PreRenderLightOverlay(hellBackdrop) end

---@param hellBackdrop Component.HellBackdrop
---@param layer integer
function Stub.RenderLayer(hellBackdrop, layer) end

--#endregion

Interface.ScrollRelatedMethod = Stub.ScrollRelatedMethod
Interface.Init = Stub.Init
Interface.Update = Stub.Update
Interface.PreRenderLightOverlay = Stub.PreRenderLightOverlay
Interface.RenderLayer = Stub.RenderLayer