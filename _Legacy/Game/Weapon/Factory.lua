--#region Dependencies



--#endregion

---@param weaponType WeaponType
---@return WeaponComponent
local function CreateWeapon(weaponType)
end

---@param weapon WeaponComponent
local function DestroyWeapon(weapon)
    weapon:ClearReferences()
    weapon:Free()
end

local Module = {}

--#region Module

Module.CreateWeapon = CreateWeapon
Module.DestroyWeapon = DestroyWeapon

--#endregion

return Module