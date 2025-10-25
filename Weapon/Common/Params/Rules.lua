--#region Dependencies



--#endregion

---@class WeaponParamsRules
local Module = {}

---@param context Context
---@param weaponType WeaponType
---@param damageScale number
---@param tearDisplacement integer
---@param source EntityComponent?
---@return TearHitParamsComponent
local function GetTearHitParams(context, weaponType, damageScale, tearDisplacement, source)
end

--#region Module

Module.GetTearHitParams = GetTearHitParams

--#endregion

return Module