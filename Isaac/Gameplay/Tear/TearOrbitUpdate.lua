--#region Dependencies

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local IEntity = require("Isaac.Interface.Entity")
local IEntityTear = require("Isaac.Interface.Entity_Tear")

--#endregion

local VectorZero = Vector(0, 0)

---@param tear Component.Entity.Tear
---@param orbitTarget Component.Entity?
local function update_ludovico_orbit(tear, orbitTarget)
    if not IEntityTear.IsMainTear(tear) or not orbitTarget then
        return
    end

    local toTargetDisplacement = tear.m_position - orbitTarget.m_position
    local distance = toTargetDisplacement:Length()

    -- avoid dividing by 0
    if distance == 0.0 then
        distance = 0.1
    end

    local toTargetDirection = toTargetDisplacement / distance
    local sidewaysPushDirection = Vector(-toTargetDirection.X, toTargetDirection.Y)

    local inwardPullStrength = (100.0 - distance) * 0.01
    local velocityAlignment = sidewaysPushDirection:Dot(tear.m_velocity)

    if velocityAlignment < 0.0 then
        sidewaysPushDirection = -sidewaysPushDirection
    end

    local inwardPull = toTargetDirection * inwardPullStrength
    local sidewaysPush = sidewaysPushDirection * 1.0 -- I assume they multiplied it by a constant which was later changed to 1.0 hence this operation
    local addedVelocity = inwardPull + sidewaysPush
    IEntity.AddVelocity(tear, addedVelocity, false)
end

---@param tear Component.Entity.Tear
---@param orbitTarget Component.Entity?
local function advanced_orbit_update(tear, orbitTarget)
    local target_position = Vector(0, 0)
    local target_velocity = Vector(0, 0)

    if not VectorUtils.Equals(tear.m_targetPosition, VectorZero) then
        target_position = tear.m_targetPosition
        target_velocity = Vector(0, 0)
    else
        assert(orbitTarget)
        target_position = orbitTarget.m_position
        target_velocity = orbitTarget.m_velocity / orbitTarget.m_friction
    end

    -- initialize orbit
    if tear.m_advancedOrbit_initSpeed == 0.0 then
        local fromTargetDisplacement = tear.m_position - target_position
        local initVelocity = tear.m_wait_frames > 1 and tear.m_wait_velocity or tear.m_velocity
        local initDirection = initVelocity:Normalized()
        local fromTargetDirection = fromTargetDisplacement:Normalized()
        local outwardMotionAlignment = fromTargetDirection:Dot(initDirection)

        local initSpeed
        local initOrbitReference
        -- tear is already orbiting
        if outwardMotionAlignment < 0.8 then
            -- tangent vector 
            local orbitVector = fromTargetDisplacement:Rotated(90.0)
            local orbitAlignment = orbitVector:Dot(initVelocity)
            local directionFactor = orbitAlignment >= 0.0 and 1.0 or -1.0

            initSpeed = initVelocity:Length() * directionFactor
            initOrbitReference = fromTargetDisplacement
        else
            local directionFactor = tear.m_tearIdx % 2 ~= 0 and 1.0 or -1.0
            initSpeed = initVelocity:Length() * directionFactor
            initOrbitReference = initVelocity
        end

        tear.m_advancedOrbit_initSpeed = initSpeed
        local orbitAngle = initOrbitReference:GetAngleDegrees()
        tear.m_advancedOrbit_angle = orbitAngle
    end

    local orbit_radius = tear.m_wait_frames > 0 and 30.0 or 90.0
    local orbit_currentDirection = Vector.FromAngle(tear.m_advancedOrbit_angle)
    local orbit_offset = orbit_currentDirection * orbit_radius
    local orbit_position = target_position + orbit_offset
    local orbit_speed = math.abs(tear.m_advancedOrbit_initSpeed)
    local maxCorrection = math.max(orbit_speed, 5.0)

    local movementInheritance = target_velocity * 2.0
    local tearPositionWithInheritance = tear.m_position + movementInheritance

    -- compute correction based on tear position with inheritance applied
    local orbit_error = orbit_position - tearPositionWithInheritance
    local orbit_correction = orbit_error * 0.5
    local correctionMagnitude = orbit_correction:Length()
    if maxCorrection < correctionMagnitude then
        orbit_correction:Resize(maxCorrection)
    end

    local newVelocity = movementInheritance + orbit_correction
    tear.m_velocity = newVelocity / tear.m_friction

    local orbitStep = MathUtils.RadiansToDegrees(tear.m_advancedOrbit_initSpeed / orbit_radius)
    local orbitAngle = orbitStep * tear.m_timeScale + tear.m_advancedOrbit_angle
    tear.m_advancedOrbit_angle = MathUtils.NormalizeAngle(orbitAngle)

    if tear.m_wait_frames > 1 then
        local orbitDirection = Vector.FromAngle(tear.m_advancedOrbit_angle)
        tear.m_wait_velocity = orbitDirection * orbit_speed
    end
end

---@param tear Component.Entity.Tear
---@param orbitTarget Component.Entity?
local function orbit_update(tear, orbitTarget)
    local directionFactor = tear.m_tearIdx % 2 == 0 and 1.0 or -1.0
    local radialOffset = Vector(0, 0)
    local movementInheritance = Vector(0, 0)

    local usesTargetPosition = not VectorUtils.Equals(tear.m_targetPosition, VectorZero)
    if not usesTargetPosition then
        assert(orbitTarget)
        local futurePosition = tear.m_position + tear.m_velocity
        radialOffset = futurePosition - orbitTarget.m_preUpdatePos
        movementInheritance = VectorUtils.Copy(orbitTarget.m_velocity)
    else
        local futurePosition = tear.m_position + tear.m_velocity
        radialOffset = futurePosition - tear.m_targetPosition
        tear.m_orbit_previousMovementInheritance = Vector(0, 0)
    end

    ---@cast orbitTarget Component.Entity
    if not usesTargetPosition and orbitTarget.m_type == EntityType.ENTITY_PLAYER then
        local orbitTarget_entityPlayer = IEntity.ToPlayer(orbitTarget)
        assert(orbitTarget_entityPlayer)
        -- move center of orbit in aim direction
        local orbitCenterOffset = orbitTarget_entityPlayer.m_aimDirection * 60.0
        radialOffset = radialOffset - orbitCenterOffset
    end

    local orbitCenterDistance = radialOffset:Length()
    if orbitCenterDistance == 0.0 then
        return
    end

    local radialDirection = radialOffset / orbitCenterDistance
    tear.m_velocity = tear.m_velocity - tear.m_orbit_previousMovementInheritance
    local orbitRadius = 120.0
    local radialCorrectionStrength = 0.1

    if tear.m_flags & TearFlags.TEAR_BOOMERANG ~= 0 then
        local radiusMulti = MathUtils.MapToRange(tear.m_height, {-5.0, -24.0}, {0.05, 1.5}, true)
        if tear.m_flags & TearFlags.TEAR_EXPLOSIVE ~= 0 then
            radiusMulti = math.max(radiusMulti, 0.4)
        end

        orbitRadius = radiusMulti * 120.0
        radialCorrectionStrength = 2.5 - radiusMulti * radialCorrectionStrength
    end

    local radialCorrectionMagnitude = (orbitRadius - orbitCenterDistance) * radialCorrectionStrength

    local tangentAngle = directionFactor * 90.0
    local orbitAngle = radialDirection:GetAngleDegrees() + tangentAngle

    local normalizedDistance = MathUtils.InverseLerp(0.0, orbitRadius, orbitCenterDistance)
    normalizedDistance = MathUtils.Clamp(normalizedDistance, 0.0, 1.0)
    local orbitSteeringStrength = normalizedDistance ^ normalizedDistance

    local velocityAngle = tear.m_velocity:GetAngleDegrees()
    local orbitAngleError = orbitAngle - velocityAngle
    orbitAngleError = MathUtils.NormalizeAngle(orbitAngleError)
    local orbitSteeringDelta = orbitAngleError * orbitSteeringStrength
    local steeredAngle = velocityAngle + orbitSteeringDelta
    local steeredDirection = Vector.FromAngle(steeredAngle)

    local currentSpeed = tear.m_velocity:Length()
    local radialCorrection = radialDirection * radialCorrectionMagnitude
    local tangentialVelocity = steeredDirection * currentSpeed
    local orbitDirection = (tangentialVelocity + radialCorrection):Normalized()
    local orbitVelocity = orbitDirection * currentSpeed
    tear.m_velocity = orbitVelocity + movementInheritance
    tear.m_orbit_previousMovementInheritance = movementInheritance
end

---@param tear Component.Entity.Tear
local function Update(tear)
    local orbitTarget = tear.m_spawnerEntity.ref or tear.m_parent.ref
    if tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 then
        update_ludovico_orbit(tear, orbitTarget)
        return
    end

    -- nothing to orbit around
    if not orbitTarget and VectorUtils.Equals(tear.m_targetPosition, VectorZero) then
        return
    end

    if tear.m_tearFlags & TearFlags.TEAR_TRACTOR_BEAM ~= 0 then
        return
    end

    local isAdvancedOrbit = tear.m_tearFlags & TearFlags.TEAR_ORBIT_ADVANCED ~= 0
    if isAdvancedOrbit or tear.m_wait_frames > 1 then
        advanced_orbit_update(tear, orbitTarget)
    else
        orbit_update(tear, orbitTarget)
    end
end

---@class Gameplay.TearOrbitUpdate
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module