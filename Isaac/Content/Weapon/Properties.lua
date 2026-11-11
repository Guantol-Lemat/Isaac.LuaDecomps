---@param weaponType WeaponType | integer
---@return boolean
local function IsLaserWeapon(weaponType)
    return weaponType == WeaponType.WEAPON_LASER
        or weaponType == WeaponType.WEAPON_BRIMSTONE
        or weaponType == WeaponType.WEAPON_TECH_X
end

---@class Content.Weapon.Properties
local Module = {}

--#region Module

Module.IsLaserWeapon = IsLaserWeapon

--#endregion

return Module