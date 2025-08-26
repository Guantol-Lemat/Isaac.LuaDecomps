--#region Dependencies



--#endregion

---@class WeaponRules
local Module = {}

---@param context Context
---@param weapon WeaponComponent
---@return boolean
local function IsAxisAligned(context, weapon)
end

---@param weapon WeaponComponent
---@param context Context
---@param shootingInput Vector
---@param isShooting boolean
---@param isInterpolationUpdate boolean
local function Fire(weapon, context, shootingInput, isShooting, isInterpolationUpdate)
end

--#region Module

Module.IsAxisAligned = IsAxisAligned
Module.Fire = Fire

--#endregion

return Module