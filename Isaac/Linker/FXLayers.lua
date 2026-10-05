---@class Interface.FXLayers
local Interface = require("Isaac.Interface.FXLayers")

--#region Stub

local Stub = {}

---@param stage integer
---@param altStages integer
---@param compLevelStage integer
---@param compStageType integer
---@return boolean
function Stub.check_fxlayer_match(stage, altStages, compLevelStage, compStageType) end

---@param fxLayers Component.FXLayers
---@param fileName string
---@param levelStage LevelStage | integer
---@param stageType StageType | integer
function Stub.Init(fxLayers, fileName, levelStage, stageType) end

---@param fxLayers Component.FXLayers
function Stub.Unload(fxLayers) end

---@param fxLayers Component.FXLayers
---@param param_1 boolean
function Stub.Update(fxLayers, param_1) end

---@param fxLayers Component.FXLayers
---@param overlayIdx integer
function Stub.render(fxLayers, overlayIdx) end

---@param fxLayers Component.FXLayers
function Stub.RenderBehind(fxLayers) end

---@param fxLayers Component.FXLayers
function Stub.RenderBackground(fxLayers) end

---@param fxLayers Component.FXLayers
function Stub.RenderForeground(fxLayers) end

---@param fxLayers Component.FXLayers
---@param color KColor
function Stub.RenderLighting(fxLayers, color) end

---@param fxLayers Component.FXLayers
function Stub.RenderUnderwater(fxLayers) end

---@param fxLayers Component.FXLayers
function Stub.RenderOverlay(fxLayers) end

---@param fxLayers Component.FXLayers
---@param buffer KColor
---@param pos Vector
---@return KColor
function Stub.GetLightingAtPos(fxLayers, buffer, pos) end

---@param fxLayers Component.FXLayers
---@param param_1 Color
function Stub.AddPoopFx(fxLayers, param_1) end

---@param fxLayers Component.FXLayers
function Stub.RenderVeins(fxLayers) end

---@param fxLayers Component.FXLayers
---@param vein Component.FXLayers.Vein
function Stub.render_vein(fxLayers, vein) end

---@param fxLayers Component.FXLayers
---@param vein Component.FXLayers.Vein
function Stub.build_vein_tree(fxLayers, vein) end

---@param Vein Component.FXLayers.Vein
function Stub.clear_vein_tree(Vein) end

---@param fxLayers Component.FXLayers
---@param Vein Component.FXLayers.Vein
function Stub.update_vein_tree(fxLayers, Vein) end

---@param fxLayers Component.FXLayers
---@param node unknown
function Stub.xml_read_fxparams(fxLayers, node) end

---@param fxLayers Component.FXLayers
---@param filePath string
function Stub.LoadOverrides(fxLayers, filePath) end

--#endregion

Interface.check_fxlayer_match = Stub.check_fxlayer_match
Interface.xml_read_fxparams = Stub.xml_read_fxparams
Interface.Init = Stub.Init
Interface.LoadOverrides = Stub.LoadOverrides
Interface.Unload = Stub.Unload
Interface.Update = Stub.Update
Interface.render = Stub.render
Interface.RenderBehind = Stub.RenderBehind
Interface.RenderBackground = Stub.RenderBackground
Interface.RenderForeground = Stub.RenderForeground
Interface.RenderLighting = Stub.RenderLighting
Interface.RenderUnderwater = Stub.RenderUnderwater
Interface.RenderOverlay = Stub.RenderOverlay
Interface.GetLightingAtPos = Stub.GetLightingAtPos
Interface.AddPoopFx = Stub.AddPoopFx
Interface.RenderVeins = Stub.RenderVeins
Interface.render_vein = Stub.render_vein
Interface.build_vein_tree = Stub.build_vein_tree
Interface.clear_vein_tree = Stub.clear_vein_tree
Interface.update_vein_tree = Stub.update_vein_tree