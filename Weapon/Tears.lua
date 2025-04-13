---@class Decomp.Weapon.Tears
local Tears = {}
Decomp.Weapon.Tears = Tears

require("Lib.Math")
require("General.Enums")
require("Weapon.Weapon")
require("Entity.EntityPlayer")

local Lib = Decomp.Lib
local Class = Decomp.Class

local Enum = Decomp.Enums
local eWeaponModifiers = Decomp.Enums.eWeaponModifiers
local Weapon = Decomp.Weapon

local super = Weapon.Weapon

---@class Decomp.Weapon.Tears.Data
---@field Weapon Decomp.Weapon.Weapon.Data
---@field tearUnk1 integer
---@field tearUnk2 integer
---@field m_OtherEyeFireDelay number

---@param fireDelay number
---@return number tearsStat
local function convert_fire_delay_to_tears(fireDelay)
    return 30.0 / (fireDelay + 1.0)
end

---@param tearsStat number
---@return number fireDelay
local function convert_tears_to_fire_delay(tearsStat)
    return 30.0 / tearsStat - 1.0
end

--#region Update

---@param tears Decomp.Weapon.Tears.Data
---@param fireDelay number
---@return number updatedFireDelay
local function update_fire_delay(tears, fireDelay)
    if fireDelay <= -1.0 then
        return fireDelay
    end

    return fireDelay - super.GetTimeScale(tears.Weapon)
end

---@param tears Decomp.Weapon.Tears.Data
---@param interpolationUpdate boolean
local function Update(tears, interpolationUpdate)
    if interpolationUpdate then
        return
    end

    tears.Weapon.m_FireDelay = update_fire_delay(tears, tears.Weapon.m_FireDelay)
    tears.m_OtherEyeFireDelay = update_fire_delay(tears, tears.m_OtherEyeFireDelay)
end

--#endregion

--#region Fire

local eFireEye = {
    UNDETERMINED = 0,
    LEFT = -1,
    RIGHT = 1,
}

---@class Decomp.Weapon.Tears.FireData
---@field sourcePlayer EntityPlayer?
---@field ownerPlayer EntityPlayer?
---@field isShootingActionPressed boolean
---@field hasActiveCharge boolean
---@field eye integer
---@field loops integer

---@param tears Decomp.Weapon.Tears.Data
---@param isShootingActionPressed boolean
---@return boolean isShooting
local function is_shooting_action_pressed(tears, isShootingActionPressed)
    -- TODO
end

---@param tears Decomp.Weapon.Tears.Data
---@return boolean
local function has_active_charge(tears)
    local weapon = tears.Weapon

    if super.HasWeaponModifier(weapon, eWeaponModifiers.NEPTUNUS) then
        return false
    end

    return super.HasWeaponModifier(weapon, eWeaponModifiers.CHOCOLATE_MILK) or super.HasWeaponModifier(weapon, eWeaponModifiers.CURSED_EYE)
end

---@param tears Decomp.Weapon.Tears.Data
---@param sourcePlayer EntityPlayer?
---@return integer eye
local function get_fire_eye(tears, sourcePlayer)
    if not sourcePlayer then
        return eFireEye.UNDETERMINED
    end

    local weapon = tears.Weapon
    local playerType = sourcePlayer:GetPlayerType()

    if playerType == PlayerType.PLAYER_CAIN or playerType == PlayerType.PLAYER_CAIN_B or
       super.HasWeaponModifier(weapon, eWeaponModifiers.CURSED_EYE) or
       sourcePlayer:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL, false) or
       sourcePlayer:HasCollectible(CollectibleType.COLLECTIBLE_STAPLER) then
        return eFireEye.RIGHT
    end

    if sourcePlayer:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2, false) then
        return eFireEye.LEFT
    end

    return eFireEye.UNDETERMINED
end

---@param sourcePlayer EntityPlayer?
---@param hasActiveCharge boolean
---@param eye integer
local function get_fire_loops(sourcePlayer, hasActiveCharge, eye)
    if not sourcePlayer or hasActiveCharge then
        return 1
    end

    if sourcePlayer:HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS, false) and eye == eFireEye.UNDETERMINED then
        return 2
    end

    return 1
end

---@param tears Decomp.Weapon.Tears.Data
---@param shootingActionPressed boolean
---@return Decomp.Weapon.Tears.FireData
local function prepare_fire_data(tears, shootingActionPressed)
    local weapon = tears.Weapon
    local sourcePlayer = super.GetPlayer(weapon)
    local ownerPlayer = weapon.m_Owner and weapon.m_Owner:ToPlayer()

    local marked = not not (sourcePlayer and sourcePlayer:HasCollectible(CollectibleType.COLLECTIBLE_MARKED, false))
    local rapidFire = super.HasWeaponModifier(weapon, eWeaponModifiers.SOY_MILK) or weapon.m_MaxFireDelay <= 0.0

    if ownerPlayer then
        rapidFire = rapidFire or Class.EntityPlayer.GetGFuelWeaponType(ownerPlayer) ~= -1
    end

    local hasActiveCharge = has_active_charge(tears)
    local eye = get_fire_eye(tears, sourcePlayer)

    ---@type Decomp.Weapon.Tears.FireData
    local fireData = {
        sourcePlayer = sourcePlayer,
        ownerPlayer = ownerPlayer,
        isShootingActionPressed = is_shooting_action_pressed(tears, shootingActionPressed),
        hasActiveCharge = hasActiveCharge,
        eye = eye,
        loops = get_fire_loops(sourcePlayer, hasActiveCharge, eye)
    }

    return fireData
end

---@param tears Decomp.Weapon.Tears.Data
---@param evaluatingBothEyes boolean
---@param iteration integer
local function get_effective_max_fire_delay(tears, evaluatingBothEyes, iteration)
    local weapon = tears.Weapon

    if super.HasWeaponModifier(weapon, eWeaponModifiers.NEPTUNUS) then
        local remappedCharge = Lib.Math.MapToRange(weapon.m_Charge, {0.0, weapon.m_MaxFireDelay * 12.0}, {1.0, 2.4495}, true)
        local neptunusFireDelay = (weapon.m_MaxFireDelay + 1.0) / (remappedCharge ^ 2)
        neptunusFireDelay = math.max(neptunusFireDelay, 0.25)

        return neptunusFireDelay - 1.0
    end

    if evaluatingBothEyes then
        local tearsMultiplier = iteration == 0 and 0.5833333 or 0.41666666
        local weaponTearsStat = convert_fire_delay_to_tears(weapon.m_MaxFireDelay)
        weaponTearsStat = weaponTearsStat * tearsMultiplier
        return convert_tears_to_fire_delay(weaponTearsStat)
    end

    return weapon.m_MaxFireDelay
end

---@param tears Decomp.Weapon.Tears.Data
---@param iteration integer
---@return number
local function get_current_eye_delay(tears, iteration)
    return iteration == 0 and tears.Weapon.m_FireDelay or tears.m_OtherEyeFireDelay
end

---@param tears Decomp.Weapon.Tears.Data
---@param iteration integer
---@param value number
local function set_current_eye_delay(tears, iteration, value)
    if iteration ~= 0 then
        tears.m_OtherEyeFireDelay = value
    else
        tears.Weapon.m_FireDelay = value
    end
end

---@param tears Decomp.Weapon.Tears.Data
---@return boolean
local function can_active_charge_shoot(tears)
    local weapon = tears.Weapon
    if super.HasWeaponModifier(weapon, eWeaponModifiers.CHOCOLATE_MILK) and weapon.m_Charge > 0.0 then
        return true
    end

    if super.HasWeaponModifier(weapon, eWeaponModifiers.CURSED_EYE) and tears.tearUnk2 > 0 then
        return true
    end

    return false
end

---@param tears Decomp.Weapon.Tears.Data
---@param fireData Decomp.Weapon.Tears.FireData
---@return boolean earlyReturn
local function handle_interpolation_update_fire(tears, fireData)
    if fireData.hasActiveCharge then
        if not fireData.isShootingActionPressed and can_active_charge_shoot(tears) then
            super.SetBlinkTime(tears.Weapon, 1, false)
        end

        return true
    end

    return fireData.isShootingActionPressed
end

-- This is implemented as a loop in the original game, but I find this to be cleaner
local function get_fire_count_from_fire_delay(maxFireDelay, fireDelay)
    if fireDelay >= 0.0 then
        return 0
    end

    maxFireDelay = maxFireDelay + 1.0
    local fireCount = maxFireDelay <= 0 and math.huge or math.ceil(-fireDelay / maxFireDelay)
    return math.min(fireCount, 8)
end

---@param tears Decomp.Weapon.Tears.Data
---@param iteration integer
---@param fireData Decomp.Weapon.Tears.FireData
---@return integer fireCount
local function get_fire_count(tears, iteration, fireData)
    local weapon = tears.Weapon
    local local_dc = 0.0

    if fireData.hasActiveCharge then
        return (not fireData.isShootingActionPressed and can_active_charge_shoot(tears)) and 1 or 0
    end

    if not fireData.isShootingActionPressed then
        return 0
    end

    tears.tearUnk2 = 0

    local currentEyeDelay = get_current_eye_delay(tears, iteration)
    local effectiveMaxFireDelay = get_effective_max_fire_delay(tears, fireData.loops == 2, iteration)
    local fireCount = get_fire_count_from_fire_delay(effectiveMaxFireDelay, currentEyeDelay)

    set_current_eye_delay(tears, iteration, currentEyeDelay + (effectiveMaxFireDelay + 1.0) * fireCount) -- Increase fire delay
    return fireCount
end

---@param tears Decomp.Weapon.Tears.Data
---@param param2 Vector
---@param shootingActionPressed boolean
---@param interpolationUpdate boolean
local function Fire(tears, param2, shootingActionPressed, interpolationUpdate)
    local fireData = prepare_fire_data(tears, shootingActionPressed)

    if interpolationUpdate and handle_interpolation_update_fire(tears, fireData) then
        return -- This early return is handled inside of the loop in the game, but it doesn't change much, aside from evaluating some conditions twice
    end

    for i = 1, fireData.loops, 1 do
        local fireCount = get_fire_count(tears, i, fireData)
        for j = 1, fireCount, 1 do
            -- TODO
        end
    end
end

--#endregion

--#region Module

---@param tears Decomp.Weapon.Tears.Data
---@param interpolationUpdate boolean
function Tears.Update(tears, interpolationUpdate)
    Update(tears, interpolationUpdate)
end

---@param tears Decomp.Weapon.Tears.Data
---@param param2 Vector
---@param shootingActionPressed boolean
---@param interpolationUpdate boolean
function Tears.Fire(tears, param2, shootingActionPressed, interpolationUpdate)
    Fire(tears, param2, shootingActionPressed, interpolationUpdate)
end

--#endregion