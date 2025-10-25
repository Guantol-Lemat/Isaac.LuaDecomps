--#region Dependencies



--#endregion

---@class WeaponFireLogic
local Module = {}

---@enum eFireTearFlags
local eFireTearFlags = {
    CANNOT_BE_EYE = 1 << 0,
    NO_TRACTOR_BEAM = 1 << 1,
    CANNOT_TRIGGER_STREAK_END = 1 << 2,
}

---@param weapon WeaponComponent
---@param context Context
---@param shootingInput Vector
---@param isShooting boolean
---@param isInterpolationUpdate boolean
local function Fire(weapon, context, shootingInput, isShooting, isInterpolationUpdate)
end

---@param context Context
---@param weapon WeaponComponent
---@param shootingInput Vector
---@param count integer
local function TriggerTearFired(context, weapon, shootingInput, count)
end

---@param context Context
---@param weapon WeaponComponent
---@param position Vector
---@param velocity Vector
---@param flags integer
---@param source EntityComponent?
---@param damageMultiplier number
---@param startPositionFactor number
local function FireTear(context, weapon, position, velocity, flags, source, damageMultiplier, startPositionFactor)
end

---@param context Context
---@param weapon WeaponComponent
---@param position Vector
---@param offsetId LaserOffset
---@param velocity Vector
---@param leftEye boolean
---@param oneHit boolean
---@param damageMultiplier number
---@return EntityLaserComponent
local function FireTechLaser(context, weapon, position, offsetId, velocity, leftEye, oneHit, damageMultiplier)
end

--#region Module

Module.eFireTearFlags = eFireTearFlags
Module.Fire = Fire
Module.TriggerTearFired = TriggerTearFired
Module.FireTear = FireTear
Module.FireTechLaser = FireTechLaser

--#endregion

return Module