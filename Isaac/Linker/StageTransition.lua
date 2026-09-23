---@class Interface.StageTransition
local Interface = require("Isaac.Interface.StageTransition")

--#region Stub

local Stub = {}

---@param stageTransition Component.StageTransition
function Stub.Reset(stageTransition) end

---@param stageTransition Component.StageTransition
---@return boolean
function Stub.IsActive(stageTransition) end

---@param stageTransition Component.StageTransition
---@param sameStage boolean
---@param Animation eStageTransitionAnim | integer
---@param player Component.Entity.Player
function Stub.Start(stageTransition, sameStage, Animation, player) end

---@param stageTransition Component.StageTransition
---@param player Component.Entity.Player
---@param interpolate boolean
function Stub.update_player_anim(stageTransition, player, interpolate) end

---@param stageTransition Component.StageTransition
function Stub.Interpolate(stageTransition) end

---@param stageTransition Component.StageTransition
function Stub.Update(stageTransition) end

---@param stageTransition Component.StageTransition
function Stub.Render(stageTransition) end

---@param stageTransition Component.StageTransition
---@return number
function Stub.GetFadeValue(stageTransition) end

---@param stageTransition Component.StageTransition
---@return boolean
function Stub.UsesPixelation(stageTransition) end

--#endregion

Interface.Reset = Stub.Reset
Interface.IsActive = Stub.IsActive
Interface.Start = Stub.Start
Interface.update_player_anim = Stub.update_player_anim
Interface.Interpolate = Stub.Interpolate
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.GetFadeValue = Stub.GetFadeValue
Interface.UsesPixelation = Stub.UsesPixelation