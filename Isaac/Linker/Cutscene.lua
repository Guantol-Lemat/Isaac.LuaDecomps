---@class Interface.Cutscene
local Interface = require("Isaac.Interface.Cutscene")

--#region Stub

local Stub = {}

---@param cutscene Component.Cutscene
---@param filepath string
function Stub.Init(cutscene, filepath) end

---@param cutscene Component.Cutscene
---@return boolean
function Stub.IsActive(cutscene) end

---@param cutscene Component.Cutscene
---@return boolean
function Stub.IsPlayingVideo(cutscene) end

---@param cutscene Component.Cutscene
---@return integer, integer
function Stub.GetRenderSize(cutscene) end

---@param cutscene Component.Cutscene
---@return boolean
function Stub.GetLetterbox(cutscene) end

---@param cutscene Component.Cutscene
function Stub.Update(cutscene) end

---@param cutscene Component.Cutscene
function Stub.Render(cutscene) end

---@param cutscene Component.Cutscene
---@param id Cutscene | integer
function Stub.Show(cutscene, id) end

---@param cutscene Component.Cutscene
function Stub.Unload(cutscene) end

--#endregion

Interface.Init = Stub.Init
Interface.IsActive = Stub.IsActive
Interface.IsPlayingVideo = Stub.IsPlayingVideo
Interface.GetRenderSize = Stub.GetRenderSize
Interface.GetLetterbox = Stub.GetLetterbox
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Show = Stub.Show
Interface.Unload = Stub.Unload