--#region Dependencies

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local FamiliarUtils = require("Entity.Familiar.Utils")
local RoomUtils = require("Game.Room.Utils")

local VectorZero = VectorUtils.VectorZero

--#endregion

---@class FamiliarWispLogic
local Module = {}

---@class FamiliarWispContext.Update : FamiliarContext.GetOrbitTarget, FamiliarContext.GetOrbitPosition
---@field room RoomComponent

---@param context FamiliarWispContext.Update
---@param familiar EntityFamiliarComponent
local function update_motion(context, familiar)
    local familiarRead = familiar
    local familiarWrite = familiar

    local room = context.room

    if familiarRead.m_orbitLayer < 0 then
        if not VectorUtils.Equals(familiarRead.m_ductTape_tapedPosition, VectorZero) then
            VectorUtils.Assign(familiarWrite.m_position, familiarRead.m_ductTape_tapedPosition)
            VectorUtils.Assign(familiarWrite.m_velocity, VectorZero)
        end
        return
    end

    local orbitTarget = FamiliarUtils.GetOrbitTarget(context, familiarRead)
    local itemType = familiarRead.m_subtype

    local targetPosition = VectorUtils.Copy(orbitTarget.m_position)
    local targetVelocity = VectorUtils.Copy(orbitTarget.m_velocity)

    if itemType == CollectibleType.COLLECTIBLE_SUPLEX and itemType == CollectibleType.COLLECTIBLE_MOMS_BRACELET then
        -- wisp orbit around their target position
        if not VectorUtils.Equals(familiarRead.m_targetPosition, VectorZero) then
            targetPosition = VectorUtils.Copy(familiarRead.m_targetPosition)
            targetVelocity = VectorUtils.Copy(VectorZero)
        end
    end

    if orbitTarget.m_type == EntityType.ENTITY_FAMILIAR or orbitTarget.m_variant == FamiliarVariant.UMBILICAL_BABY then
        targetVelocity = targetVelocity * 0.5
    end

    local orbitPosition = FamiliarUtils.GetOrbitPosition(context, familiarWrite, targetPosition)
    if itemType == CollectibleType.COLLECTIBLE_MOMS_BRACELET then
        orbitPosition = RoomUtils.GetClampedPosition(room, orbitPosition, 0.0)
    end

    local orbitSteering
    local chaseVelocity
    do
        local targetDisplacement = targetPosition - familiarRead.m_position
        local chaseStep = (targetPosition - familiarRead.m_position) * 0.01
        if chaseStep:Length() > 8.0 then
            chaseStep:Resize(8.0)
        end

        local targetDistance = targetDisplacement:Length()
        local orbitRadii = familiarRead.m_orbitDistance
        local maxOrbitDistance = math.max(orbitRadii.X, orbitRadii.Y)
        local distanceBeyondOrbit = targetDistance - (maxOrbitDistance + 10.0) -- pad by 10 so that target is considered close just outside of the orbit

        local normalizedFarness = MathUtils.MapToRange(distanceBeyondOrbit, {0.0, 160.0}, {0.0, 1.0}, true)
        local quadraticFalloff = (1.0 - normalizedFarness) ^ 2 -- smooth out transition between far and close
        local targetFarness = 1.0 - quadraticFalloff
        local targetCloseness = 2.0 * quadraticFalloff

        local targetVelInfluence = targetVelocity * targetCloseness / orbitTarget.m_friction
        orbitSteering = (orbitPosition - (familiarRead.m_position + targetVelInfluence)) * 0.5
        local orbitSteerSpeed = orbitSteering:Length()

        if orbitSteerSpeed > 5.0 and (familiarRead.m_flags & EntityFlag.FLAG_SPIN) == 0 then
            orbitSteering:Resize(4.0) -- this caps the speed at 4.0 if > 5.0 (maybe a bug)
        end

        chaseVelocity = familiarRead.m_velocity + chaseStep
        orbitSteering = (orbitSteering + targetVelInfluence) / familiarRead.m_friction

        chaseVelocity = chaseVelocity * targetFarness -- chase dominates when target is far from orbit
        orbitSteering = orbitSteering - (orbitSteering * targetFarness) -- orbitSteer dominates when target is close to orbit
    end

    familiarWrite.m_velocity = chaseVelocity + orbitSteering
end

---@param context FamiliarWispContext.Update
---@param familiar EntityFamiliarComponent
local function UpdateAi(context, familiar)
    local familiarRead = familiar
    local familiarWrite = familiar
    -- TODO: Rest of update

    if familiarRead.m_state == 0 then
        update_motion(context, familiarWrite)
    end

    -- TODO: Rest of update
end

--#region Module

Module.UpdateAi = UpdateAi

--#endregion

return Module