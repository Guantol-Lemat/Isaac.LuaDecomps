--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local Math = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")

local VectorZero = VectorUtils.VectorZero

--#endregion

---@class FamiliarFingerLogic
local Module = {}

---@param familiar EntityFamiliarComponent
local function Update(familiar)
    local player = familiar.m_player
    local aimDirection = player.m_aimDirection

    if VectorUtils.Equals(aimDirection, VectorZero) then
        aimDirection = IsaacUtils.GetAxisAlignedUnitVectorFromDirection(player.m_headDirection)
        if VectorUtils.Equals(aimDirection, VectorZero) then
            aimDirection = Vector(0.0, 1.0)
        end
    end

    local aimAngle = aimDirection:GetAngleDegrees()
    local newAngle = Math.InterpolateAngle(familiar.m_orbitAngleOffset, aimAngle, 0.3)
    familiar.m_orbitAngleOffset = newAngle

    local playerOffset = Vector.FromAngle(newAngle) * 50.0
    local targetPosition = player.m_position + playerOffset
    local newVelocity = (targetPosition - familiar.m_position) * 0.3
    familiar.m_velocity = newVelocity

    familiar.m_friction = familiar.m_friction * 0.7

    -- TODO: rest of update
end

--#region Module

Module.Update = Update

--#endregion

return Module