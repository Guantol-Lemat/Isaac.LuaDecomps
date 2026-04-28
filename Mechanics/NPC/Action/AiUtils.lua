--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")

--#endregion

local VECTOR_ZERO = VectorUtils.VectorZero

---@param npc EntityNPCComponent
---@param param_2 boolean
---@param param_3 number
---@param param_4 number
---@param param_5 number
local function SetChargeBar(npc, param_2, param_3, param_4, param_5)
end

---@param ctx Context.Game
---@param npc EntityNPCComponent
---@param distanceLimit number
---@return Vector
local function CalcTargetPosition(ctx, npc, distanceLimit)
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@param param_2 number
---@param param_3 boolean
---@param param_4 integer
---@return boolean
local function CanShootPlayer(ctx, npc, param_2, param_3, param_4)
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@return EntityComponent
local function GetPlayerTarget(ctx, npc)
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@param unk number
---@return Vector
local function GetMovementInput(ctx, npc, unk)
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@param unk number
---@return Vector
local function GetShootingInput(ctx, npc, unk)
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@param force boolean
local function UpdatePlayerAim(ctx, npc, force)
    if npc.m_possessor_controllerIdx == -1 then
        npc.m_possessor_aim = VECTOR_ZERO
        return
    end

    local shootingInput = GetShootingInput(ctx, npc, 0.1)
    if VectorUtils.Equals(shootingInput, VECTOR_ZERO) and not force then
        return
    end

    npc.m_possessor_aim = shootingInput
end

---@param ctx Context.Common
---@param position Vector
---@param spawner EntityComponent
---@param targetPosition Vector
---@param big boolean
---@param yOffset number
---@return EntityNPCComponent
local function ThrowSpider(ctx, position, spawner, targetPosition, big, yOffset)
end

---@class Mechanics.NPC.AiUtils
local Module = {}

--#region Module

Module.SetChargeBar = SetChargeBar
Module.CalcTargetPosition = CalcTargetPosition
Module.CanShootPlayer = CanShootPlayer
Module.GetPlayerTarget = GetPlayerTarget
Module.GetMovementInput = GetMovementInput
Module.GetShootingInput = GetShootingInput
Module.UpdatePlayerAim = UpdatePlayerAim
Module.ThrowSpider = ThrowSpider

--#endregion

return Module