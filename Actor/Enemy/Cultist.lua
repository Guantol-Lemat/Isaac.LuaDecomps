--#region Dependencies

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils")
local EntityIdentity = require("Entity.Identity")

local VectorZero = VectorUtils.VectorZero
local eMyVariant = EntityIdentity.eCultistVariant

--#endregion

---@class Cultist.Blackboard
---@field idleFrames number -- V1.x (STATE_IDLE)
---@field attackSpeedFactor number -- V1.x (STATE_ATTACK)
---@field direction number -- V1.y

---@class CultistAi
local Module = {}

---@param cultist EntityNPCComponent
---@param blackboard Cultist.Blackboard
local function update_idle_movement(cultist, blackboard)
    local timescale = cultist.m_timescale

    local targetPosition = cultist.m_targetPosition
    local targetDisplacement = targetPosition - cultist.m_position
    local displacementAngle =  math.atan(targetDisplacement.Y, targetDisplacement.X)
    displacementAngle = MathUtils.RadiansToDegrees(displacementAngle)

    IsaacUtils.Random()
    local randomStep = (IsaacUtils.RandomFloat() * 20.0 + 3.0) * timescale
    local direction = MathUtils.ApproachAngle(blackboard.direction, displacementAngle, randomStep)
    blackboard.direction = direction

    local randomSpeed = (IsaacUtils.RandomFloat() * 1.7 + 0.7) * timescale
    local directionVector = Vector.FromAngle(direction)
    cultist.m_velocity = cultist.m_velocity + directionVector * randomSpeed
end

---@param cultist EntityNPCComponent
---@param blackboard Cultist.Blackboard
local function update_attack_movement(cultist, blackboard)
    local attackSpeedFactor = blackboard.attackSpeedFactor

    if attackSpeedFactor <= 0.0 then
        return
    end

    local variant = cultist.m_variant
    if variant == eMyVariant.BLOOD_CULTIST then
        local horizontalDirection = cultist.m_sprite.FlipX and 1.0 or -1.0
        local horizontalSpeed = attackSpeedFactor * 5.0 * horizontalDirection * cultist.m_timescale
        local velocity = Vector(horizontalSpeed, 0.0)
        cultist.m_velocity = cultist.m_velocity + velocity
    else
        local verticalSpeed = attackSpeedFactor * -5.0 * cultist.m_timescale
        local velocity = Vector(0.0, verticalSpeed)
        cultist.m_velocity = cultist.m_velocity + velocity
    end

    blackboard.attackSpeedFactor = blackboard.attackSpeedFactor - 0.1 * cultist.m_timescale
end

---@param cultist EntityNPCComponent
---@param blackboard Cultist.Blackboard
local function update_summon_movement(cultist, blackboard)
    -- snap to target position
    cultist.m_velocity = cultist.m_targetPosition - cultist.m_position
end

---@param cultist EntityNPCComponent
---@param blackboard Cultist.Blackboard
local function update_idle(cultist, blackboard)
    local sprite = cultist.m_sprite
    sprite:Play("Idle", false)

    cultist.m_friction = cultist.m_friction * 0.75
    local confused = (cultist.m_flags & (EntityFlag.FLAG_SHRINK | EntityFlag.FLAG_CONFUSION)) ~= 0

    if confused then
        -- TODO: Confused
    else
        local targetPosition = cultist.m_targetPosition
        if not VectorUtils.Equals(targetPosition, VectorZero) then
            local timescale = cultist.m_timescale
            blackboard.idleFrames = blackboard.idleFrames + timescale
            update_idle_movement(cultist, blackboard)
            -- TODO: Try Attack
        end
    end
end

---@param cultist EntityNPCComponent
---@param blackboard Cultist.Blackboard
local function update_attack(cultist, blackboard)
    cultist.m_friction = cultist.m_friction * 0.7
    -- TODO: Rest of attack
    update_attack_movement(cultist, blackboard)
    -- TODO: Rest of attack
end

---@param cultist EntityNPCComponent
---@param blackboard Cultist.Blackboard
local function update_summon(cultist, blackboard)
    cultist.m_friction = cultist.m_friction * 0.7
    update_summon_movement(cultist, blackboard)
    -- TODO: Rest of summon
end

local function UpdateAi(cultist)
end

--#region Module

Module.UpdateAi = UpdateAi

--#endregion

return Module