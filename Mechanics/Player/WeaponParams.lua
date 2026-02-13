--#region Dependencies



--#endregion

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param shotDirection Vector
---@param ignoreModifiers boolean
---@return Vector
local function GetTearMovementInheritance(myContext, player, shotDirection, ignoreModifiers)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param weaponType WeaponType | integer
---@param damageScale number
---@param tearDisplacement integer
---@param source EntityComponent?
---@return TearHitParamsComponent
local function GetTearHitParams(myContext, player, weaponType, damageScale, tearDisplacement, source)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param weaponType WeaponType | integer
---@return MultiShotParamsComponent
local function GetMultiShotParams(myContext, player, weaponType)
end

---@param eyeIndex integer -- the "index" of the numEyesActive that is currently being evaluated
---@param weaponType WeaponType | integer
---@param shotDirection Vector
---@param shotSpeed number
---@param multiShotParams MultiShotParamsComponent
---@return Vector position
---@return Vector velocity
local function GetMultiShotPositionVelocity(eyeIndex, weaponType, shotDirection, shotSpeed, multiShotParams)
end

local Module = {}

--#region Module

Module.GetTearMovementInheritance = GetTearMovementInheritance
Module.GetTearHitParams = GetTearHitParams
Module.GetMultiShotParams = GetMultiShotParams
Module.GetMultiShotPositionVelocity = GetMultiShotPositionVelocity

--#endregion

return Module