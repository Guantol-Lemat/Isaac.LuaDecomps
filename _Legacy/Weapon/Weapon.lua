---@class Decomp.Weapon.Weapon
local Weapon = {}
Decomp.Weapon.Weapon = Weapon

---@class Decomp.Weapon.Weapon.Data
---@field m_Owner Entity?
---@field m_FireDelay number
---@field m_MaxFireDelay number
---@field m_Charge number
---@field m_TargetPosition Vector
---@field m_WeaponModifiers integer

---@return Decomp.Weapon.Weapon.Data
local function NewWeapon()
    ---@type Decomp.Weapon.Weapon.Data
    local weapon = {
        m_Owner = nil,
        m_FireDelay = 0.0,
        m_MaxFireDelay = 0.0,
        m_Charge = 0.0,
        m_TargetPosition = Vector(0, 0),
        m_WeaponModifiers = 0
    }

    return weapon
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param modifier Decomp.Enum.eWeaponModifiers
---@return boolean
local function HasWeaponModifier(weapon, modifier)
    return (((weapon.m_WeaponModifiers >> modifier)) & 1) ~= 0
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param modifier Decomp.Enum.eWeaponModifiers
local function SetWeaponModifier(weapon, modifier)
    weapon.m_WeaponModifiers = weapon.m_WeaponModifiers | (1 << modifier)
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param modifier Decomp.Enum.eWeaponModifiers
local function ResetWeaponModifier(weapon, modifier)
    weapon.m_WeaponModifiers = weapon.m_WeaponModifiers & ~(1 << modifier)
end

--#region Module

---@return Decomp.Weapon.Weapon.Data
function Weapon.new()
    return NewWeapon()
end

---@param weapon Decomp.Weapon.Weapon.Data
---@return EntityPlayer?
function Weapon.GetPlayer(weapon)
    --TODO
end

---@param weapon Decomp.Weapon.Weapon.Data
---@return integer
function Weapon.GetPeeBurstCooldown(weapon)
    --TODO
end

---@param weapon Decomp.Weapon.Weapon.Data
---@return Vector?
function Weapon.GetMarkedTarget(weapon)
    --TODO
end

---@param weapon Decomp.Weapon.Weapon.Data
---@return number
function Weapon.GetTimeScale(weapon)
    local owner = weapon.m_Owner
    if not owner then
        return 1.0
    end

    return owner:GetSpeedMultiplier()
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param int integer
---@param allowReduction boolean -- unused in rep+ (allowed the new value to be lower than the current one)
function Weapon.SetBlinkTime(weapon, int, allowReduction)
    --TODO
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param modifier Decomp.Enum.eWeaponModifiers
---@return boolean
function Weapon.HasWeaponModifier(weapon, modifier)
    return HasWeaponModifier(weapon, modifier)
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param modifier Decomp.Enum.eWeaponModifiers
function Weapon.SetWeaponModifier(weapon, modifier)
    SetWeaponModifier(weapon, modifier)
end

---@param weapon Decomp.Weapon.Weapon.Data
---@param modifier Decomp.Enum.eWeaponModifiers
function Weapon.ResetWeaponModifier(weapon, modifier)
    ResetWeaponModifier(weapon, modifier)
end

--#endregion