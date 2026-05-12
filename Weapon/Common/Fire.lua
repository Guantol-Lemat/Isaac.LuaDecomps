--#region Dependencies



--#endregion

---@class WeaponFireLogic
local Module = {}

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
---@param source Component.Entity?
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
---@return Component.Entity.Laser
local function FireTechLaser(context, weapon, position, offsetId, velocity, leftEye, oneHit, damageMultiplier)
end

--#region Module

Module.Fire = Fire
Module.TriggerTearFired = TriggerTearFired
Module.FireTear = FireTear
Module.FireTechLaser = FireTechLaser

--#endregion

return Module