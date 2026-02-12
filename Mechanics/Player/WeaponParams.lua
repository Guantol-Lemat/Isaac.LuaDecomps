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
---@param weaponType WeaponType
---@param damageScale number
---@param tearDisplacement integer
---@param source EntityComponent?
---@return TearHitParamsComponent
local function GetTearHitParams(myContext, player, weaponType, damageScale, tearDisplacement, source)
end

local Module = {}

--#region Module

Module.GetTearMovementInheritance = GetTearMovementInheritance
Module.GetTearHitParams = GetTearHitParams

--#endregion

return Module