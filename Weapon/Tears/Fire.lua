--#region Dependencies

local Enums = require("General.Enums")
local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local BitsetUtils = require("General.Bitset")
local WeaponUtils = require("Weapon.Common.Utils")
local WeaponRules = require("Weapon.Common.Rules")
local WeaponFire = require("Weapon.Common.Fire")
local WeaponParamsUtils = require("Weapon.Common.Params.Utils")
local IsaacUtils = require("Isaac.Utils")
local EntityUtils = require("Entity.Common.Utils")
local GFuelRules = require("Mechanics.Game.GFuel.Rules")
local GFuelLogic = require("Mechanics.Game.GFuel.Logic")
local PlayerUtils = require("Entity.Player.Utils")
local Inventory = require("Entity.Player.Inventory.Inventory")

local eWeaponModifiers = Enums.eWeaponModifiers
local eItemAnimation = Enums.eItemAnimation
local eFireTearFlags = WeaponFire.eFireTearFlags

--#endregion

local eEye = {
    BOTH_EYES = 0,
    RIGHT_ONLY = 1,
    LEFT_ONLY = -1,
}

---@class WeaponTearsFireLogic
local Module = {}

---@param context Context
---@param weapon WeaponTearsComponent
---@param playerOwner EntityPlayerComponent?
---@return integer tearDisplacement
local function get_weapon_tear_displacement(context, weapon, playerOwner)
    if not playerOwner then
        return 0
    end

    if BitsetUtils.HasAny(weapon.m_weaponModifiers, eWeaponModifiers.CURSED_EYE) or
       Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_LEAD_PENCIL, false) or
       Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_STAPLER, false) then
        return 1
    end

    if Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_TECHNOLOGY_2, false) then
        return -1
    end

    return 0
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param shootingInput Vector
local function update_tear_fx(context, weapon, shootingInput)
    local weaponModifiers = weapon.m_weaponModifiers
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)
    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)

    local blinkTime = 0
    if chocolateMilkModifier then
        blinkTime = 12
    else
        blinkTime = math.max(math.floor(weapon.m_maxFireDelay * 0.45) + 7, 11)
    end
    WeaponUtils.SetBlinkTime(weapon, blinkTime)

    if neptunusModifier then
        local progress = ((weapon.m_charge + 1.0) / (weapon.m_maxFireDelay * 12.0 + 1.0)) * 18.0
        if progress == 0 then
            WeaponRules.ClearItemAnim(context, weapon, CollectibleType.COLLECTIBLE_NEPTUNUS)
        else
            WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_NEPTUNUS, eItemAnimation.SHOOT, shootingInput, progress)
        end
    end
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param playerOwner EntityPlayerComponent?
---@param tearDisplacement integer
---@param desyncedEyes boolean
---@param mainEye boolean
---@param shotsFired integer
---@return integer
local function update_tear_displacement(context, weapon, playerOwner, tearDisplacement, desyncedEyes, mainEye, shotsFired)
    local trueTearDisplacement = 0
    if not playerOwner then
        return trueTearDisplacement
    end

    local weaponModifiers = weapon.m_weaponModifiers
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)
    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)

    if tearDisplacement == 0 then
        if desyncedEyes then
            tearDisplacement = mainEye and -1 or 1
        else
            tearDisplacement = -playerOwner.m_tearDisplacement
        end
    end

    playerOwner.m_tearDisplacement = tearDisplacement
    trueTearDisplacement = tearDisplacement
    if WeaponRules.HasWizardEffect(context, weapon) then
        shootingInput = shootingInput:Rotated(tearDisplacement * 45.0)
    end

    if chocolateMilkModifier or neptunusModifier or shotsFired > 1 or Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_POLYPHEMUS, false) or Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_IPECAC, false) then
        trueTearDisplacement = 0
    end

    if Inventory.HasCollectibleRealOrEffect(context, playerOwner, CollectibleType.COLLECTIBLE_NUMBER_ONE, false) or Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_KIDNEY_STONE, false) then
        trueTearDisplacement = 0
        WeaponUtils.SetBlinkTime(weapon, 16)
    end

    return trueTearDisplacement
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param shootingInput Vector
---@return Vector
local function get_tear_velocity(context, weapon, shootingInput)
    local tearVelocity = shootingInput * 10.0
    local movementInheritance =  WeaponRules.GetTearMovementInheritance(context, weapon, shootingInput)
    tearVelocity = tearVelocity + movementInheritance

    local player = WeaponUtils.GetPlayer(weapon)
    if player and Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_IPECAC, false) then
        local randomVelocityMultiplier = context:RandomFloat() * 0.2 + 0.9
        tearVelocity = tearVelocity * randomVelocityMultiplier
    end

    return tearVelocity
end

---@param weapon WeaponTearsComponent
---@return number
local function get_tear_damage_multiplier(weapon)
    local weaponModifiers = weapon.m_weaponModifiers
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)
    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)

    local damageMultiplier = 1.0

    if chocolateMilkModifier then
        local maxFireDelay = weapon.m_maxFireDelay + 1.0
        if neptunusModifier then
            local charge = weapon.m_charge + 1.0
            damageMultiplier = (charge * 4.0) / (maxFireDelay * 12.0)
        else
            local charge = weapon.m_chocolateMilkCharge + 1.0
            damageMultiplier = (charge * 4.0) / (maxFireDelay * 2.5)
        end

        damageMultiplier = MathUtils.Clamp(damageMultiplier, 0.1, 4.0)
    end

    return damageMultiplier
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param playerOwner EntityPlayerComponent?
---@return number
local function get_tear_spread(context, weapon, playerOwner)
    local weaponModifiers = weapon.m_weaponModifiers
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)

    local spread = 0.0

    if playerOwner then
        local charge = playerOwner.m_epiphoraCharge
        if Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_EPIPHORA, false) and charge > 0 then
            spread = ((charge // 90) * 16.0) / 3.0 + 0.0
        end

        local peeBurstCooldown = playerOwner.m_peeBurstCooldown
        local maxPeeBurstCooldown = playerOwner.m_maxPeeBurstCooldown

        if peeBurstCooldown > 0 and maxPeeBurstCooldown > 0 and peeBurstCooldown < maxPeeBurstCooldown - 1 then
            local peeRotation = (peeBurstCooldown * 24.0) / maxPeeBurstCooldown
            spread = spread + peeRotation
        end

        local gFuelWeaponType = GFuelRules.GetGFuelWeaponType(context, playerOwner)
        if gFuelWeaponType == 2 then
            spread = spread + 24.0
        elseif gFuelWeaponType == 4 then
            spread = spread + 8.0
        end
    end

    if neptunusModifier then
        local neptunusRotation = (weapon.m_charge * 16.0) / (weapon.m_maxFireDelay * 12.0)
        neptunusRotation = MathUtils.Clamp(neptunusRotation, 0.0, 16.0)
        spread = spread + neptunusRotation
    end

    return spread
end

---@param context Context
---@param velocity Vector
---@param spread number
---@return Vector newVelocity
local function apply_tear_spread(context, velocity, spread)
    if spread == 0 then
        return velocity
    end

    local randomRotation = spread * (context:RandomFloat() - 0.5)
    return velocity:Rotated(randomRotation)
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param position Vector
---@param tearVelocity Vector
---@param tearDisplacement integer
---@param damageMultiplier number
---@param startPositionFactor number
---@param spread number
---@param multiShotParams MultiShotParamsComponent
local function fire_regular_tear(context, weapon, position, tearVelocity, tearDisplacement, damageMultiplier, startPositionFactor, spread, multiShotParams)
    local MAIN_TEAR_FLAGS = 0
    local EXTRA_TEAR_FLAGS = eFireTearFlags.NO_TRACTOR_BEAM | eFireTearFlags.CANNOT_TRIGGER_STREAK_END

    local owner = weapon.m_owner
    local shotSpeed = WeaponUtils.GetShotSpeed(weapon)

    if multiShotParams.isShootingBackwards then
        local velocity = -tearVelocity * shotSpeed
        velocity = apply_tear_spread(context, velocity, spread)
        WeaponFire.FireTear(context, weapon, position, velocity, EXTRA_TEAR_FLAGS, owner, damageMultiplier, startPositionFactor)
    end

    if multiShotParams.isShootingSideways then
        local velocity = tearVelocity * shotSpeed

        local sideWayVelocity = Vector(-velocity.Y, velocity.X)
        sideWayVelocity = apply_tear_spread(context, sideWayVelocity, spread)
        WeaponFire.FireTear(context, weapon, position, sideWayVelocity, EXTRA_TEAR_FLAGS, owner, damageMultiplier, startPositionFactor)

        sideWayVelocity = Vector(velocity.Y, -velocity.X)
        sideWayVelocity = apply_tear_spread(context, sideWayVelocity, spread)
        WeaponFire.FireTear(context, weapon, position, sideWayVelocity, EXTRA_TEAR_FLAGS, owner, damageMultiplier, startPositionFactor)
    end

    for i = 1, multiShotParams.numRandomTears, 1 do
        local randomAngle = (context:RandomFloat() * 360.0)
        local velocity = tearVelocity:Rotated(randomAngle) * shotSpeed
        velocity = apply_tear_spread(context, velocity, spread)
        WeaponFire.FireTear(context, weapon, position, velocity, EXTRA_TEAR_FLAGS, owner, damageMultiplier, startPositionFactor)
    end

    if tearDisplacement ~= 0 then
        local displacement = tearDisplacement * (context:RandomFloat() * 0.2 + 0.3)
        position.X = position.X - tearVelocity.Y * displacement
        position.Y = position.Y + tearVelocity.X * displacement
    end

    for i = 1, multiShotParams.numTears, 1 do
        local posVel = WeaponParamsUtils.GetMultiShotPositionVelocity(i - 1, weapon.m_weaponType, tearVelocity, shotSpeed, multiShotParams)
        local tearPosition = position + posVel.position
        local velocity = posVel.velocity
        velocity = apply_tear_spread(context, velocity, spread)
        WeaponFire.FireTear(context, weapon, tearPosition, velocity, MAIN_TEAR_FLAGS, owner, damageMultiplier, startPositionFactor)
    end

    local playerOwner = owner and EntityUtils.ToPlayer(owner)

    if playerOwner then
        local gFuelWeapon = GFuelRules.GetGFuelWeaponType(context, playerOwner)
        GFuelLogic.ApplyTearFireFX(context, playerOwner, position, tearVelocity, gFuelWeapon)
    end
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param position Vector
---@param tearVelocity Vector
---@param damageMultiplier number
---@param spread number
---@param multiShotParams MultiShotParamsComponent
local function fire_tech_laser(context, weapon, position, tearVelocity, damageMultiplier, spread, multiShotParams)
    local staticContext = context:GetStaticContext()
    staticContext.WEAPON_TEARS_TECH_LASERS = {} -- clear
    local techLasers = staticContext.WEAPON_TEARS_TECH_LASERS

    local shotSpeed = WeaponUtils.GetShotSpeed(weapon)

    if multiShotParams.isShootingBackwards then
        local velocity = -tearVelocity * shotSpeed
        velocity = apply_tear_spread(context, velocity, spread)
        local laser = WeaponFire.FireTechLaser(context, weapon, position, LaserOffset.LASER_TECH2_OFFSET, velocity, false, true, damageMultiplier)
        table.insert(techLasers, laser)
    end

    if multiShotParams.isShootingSideways then
        local velocity = tearVelocity * shotSpeed

        local sideWayVelocity = Vector(-velocity.Y, velocity.X)
        sideWayVelocity = apply_tear_spread(context, sideWayVelocity, spread)
        local laser = WeaponFire.FireTechLaser(context, weapon, position, LaserOffset.LASER_TECH2_OFFSET, sideWayVelocity, false, true, damageMultiplier)
        table.insert(techLasers, laser)

        sideWayVelocity = Vector(velocity.Y, -velocity.X)
        sideWayVelocity = apply_tear_spread(context, sideWayVelocity, spread)
        laser = WeaponFire.FireTechLaser(context, weapon, position, LaserOffset.LASER_TECH2_OFFSET, sideWayVelocity, false, true, damageMultiplier)
        table.insert(techLasers, laser)
    end

    for i = 1, multiShotParams.numRandomTears, 1 do
        local randomAngle = (context:RandomFloat() * 360.0)
        local velocity = tearVelocity:Rotated(randomAngle) * shotSpeed
        velocity = apply_tear_spread(context, velocity, spread)
        local laser = WeaponFire.FireTechLaser(context, weapon, position, LaserOffset.LASER_TECH2_OFFSET, velocity, false, true, damageMultiplier)
        table.insert(techLasers, laser)
    end

    for i = 1, multiShotParams.numTears, 1 do
        local posVel = WeaponParamsUtils.GetMultiShotPositionVelocity(i - 1, WeaponType.WEAPON_LASER, tearVelocity, shotSpeed, multiShotParams)
        local laserPosition = position + posVel.position
        local velocity = posVel.velocity:Normalized()
        velocity = apply_tear_spread(context, velocity, spread)
        local laser = WeaponFire.FireTechLaser(context, weapon, laserPosition, LaserOffset.LASER_TECH2_OFFSET, velocity, false, true, damageMultiplier)
        table.insert(techLasers, laser)
    end

    for i = 1, #techLasers, 1 do
        local laser = techLasers[i]
        laser.m_disableFollowParent = false
        laser:Update(context)
    end
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param shootingInput Vector
---@param tearDisplacement integer
---@param mainEye boolean
---@param desyncedEyes boolean
---@param shotsFired integer
---@param startPositionFactor number
local function fire_tear(context, weapon, shootingInput, tearDisplacement, mainEye, desyncedEyes, shotsFired, startPositionFactor)
    local multiShotParams = WeaponRules.GetMultiShotParams(context, weapon)

    update_tear_fx(context, weapon, shootingInput)
    WeaponFire.TriggerTearFired(context, weapon, shootingInput, 1)

    local owner = weapon.m_owner
    local playerOwner = nil
    if owner then
        playerOwner = EntityUtils.ToPlayer(owner)
    end

    local trueTearDisplacement = update_tear_displacement(context, weapon, playerOwner, tearDisplacement, desyncedEyes, mainEye, shotsFired)
    local position = WeaponUtils.GetPosition(weapon)
    local tearVelocity = get_tear_velocity(context, weapon, shootingInput)
    local damageMultiplier = get_tear_damage_multiplier(weapon)
    local spread = get_tear_spread(context, weapon, playerOwner)

    if trueTearDisplacement == 0 or tearDisplacement ~= 1 or not playerOwner or not Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_TECHNOLOGY_2, false) then
        fire_regular_tear(context, weapon, position, tearVelocity, trueTearDisplacement, damageMultiplier, startPositionFactor, spread, multiShotParams)
    else
        fire_tech_laser(context, weapon, position, tearVelocity, damageMultiplier, spread, multiShotParams)
    end
end

---@param weapon WeaponTearsComponent
---@param mainEye boolean
---@param desyncedEyes boolean
local function get_max_fire_delay(weapon, mainEye, desyncedEyes)
    local weaponModifiers = weapon.m_weaponModifiers
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)

    local maxFireDelay = weapon.m_fireDelay

    if desyncedEyes then
        local distributionFactor = mainEye and 0.5833333 or 0.41666667
        local tearsUp = PlayerUtils.FireDelayToTearsUp(maxFireDelay) * distributionFactor
        eyeMaxFireDelay = PlayerUtils.TearsUpToFireDelay(tearsUp)
    end

    if neptunusModifier then
        local remappedCharge = MathUtils.MapToRange(weapon.m_charge, {0.0, maxFireDelay * 12.0}, {1.0, 2.4495}, true)
        local neptunusMaxFireDelay = (eyeMaxFireDelay + 1.0) * (remappedCharge ^ 2) - 1.0
        eyeMaxFireDelay = math.max(neptunusMaxFireDelay, -0.75)
    end
end

---@param weapon WeaponTearsComponent
---@param mainEye boolean
---@param isShooting boolean
---@param interpolationUpdate boolean
---@return integer shotsFired, number startPositionFactor
local function update_fire_delay(weapon, mainEye, isShooting, interpolationUpdate)
    local weaponModifiers = weapon.m_weaponModifiers
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)
    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)
    local cursedEyeModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CURSED_EYE)
    local hasControlledChargeBar = (chocolateMilkModifier or cursedEyeModifier) and not neptunusModifier

    local fireDelayKey = mainEye and "m_fireDelay" or "m_otherEyeFireDelay"
    local eyeFireDelay = weapon[fireDelayKey]

    local shotsFired = 0
    local startPositionFactor = 0.0

    if hasControlledChargeBar then
        local isCharged = (chocolateMilkModifier and weapon.m_charge > 0.0) or (cursedEyeModifier and weapon.m_cursedEyeShots > 0)
        if not isShooting and isCharged then
            shotsFired = 1
        end
    else
        if isShooting then
            startPositionFactor = -1.0 - eyeFireDelay
            while eyeFireDelay < 0 do
                if shotsFired > 7 then
                    break
                end

                shotsFired = shotsFired + 1
                eyeFireDelay = eyeFireDelay + 1.0 + eyeMaxFireDelay
                weapon[fireDelayKey] = eyeFireDelay
            end

            weapon.m_chocolateMilkCharge = 0.0
        end
    end

    return shotsFired, startPositionFactor
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param isShooting boolean
---@param interpolate boolean
---@return boolean
local function override_is_shooting(context, weapon, isShooting, interpolate)
    local weaponModifiers = weapon.m_weaponModifiers

    local owner = weapon.m_owner
    local player = WeaponUtils.GetPlayer(weapon)
    local playerOwner = owner and EntityUtils.ToPlayer(owner)

    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)
    local cursedEyeModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CURSED_EYE)
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)
    local hasControlledChargeBar = (chocolateMilkModifier or cursedEyeModifier) and not neptunusModifier
    local rapidFire = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.SOY_MILK) or weapon.m_maxFireDelay <= 0.0

    if playerOwner then
        rapidFire = rapidFire or GFuelRules.GetGFuelWeaponType(context, playerOwner) ~= -1
    end

    local peeBurstCooldown = WeaponUtils.GetPeeBurstCooldown(weapon)
    -- peeBurst force release
    if peeBurstCooldown > 0 then
        local minChocoCharge = math.min(weapon.m_maxFireDelay * 2.5, 5.0)
        if chocolateMilkModifier and weapon.m_charge >= minChocoCharge then
            isShooting = false -- force release
        end

        if cursedEyeModifier and weapon.m_cursedEyeShots > 0 then
            isShooting = false -- force release
        end
    end

    local targetPosition = weapon.m_targetPosition
    local markedTarget = WeaponUtils.GetMarkedTarget(weapon)
    if player and markedTarget and Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_MARKED, false) then
        targetPosition = markedTarget.m_position
    end
    targetPosition = VectorUtils.Copy(targetPosition)

    local hasTargetPosition = not VectorUtils.Equals(targetPosition, VectorUtils.VectorZero)

    if interpolate then
        return isShooting
    end

    -- target controls automatic release
    if hasTargetPosition then
        local position = WeaponUtils.GetPosition(weapon)
        local distanceToTarget = (targetPosition - position):Length()
        local normalizedDistance = MathUtils.InverseLerp(50.0, 300.0, distanceToTarget)
        normalizedDistance = MathUtils.Clamp(normalizedDistance, 0.0, 1.0)

        local charge = weapon.m_charge

        local minimumCharge = MathUtils.Lerp(5.0, weapon.m_maxFireDelay * 2.5, normalizedDistance) - 1.0
        if chocolateMilkModifier and charge > minimumCharge then
            return false
        end

        local minimumEyes = 1
        if charge > 0.0 then
            minimumEyes = math.floor(MathUtils.Lerp(1.0, 5.0, normalizedDistance))
        end

        if cursedEyeModifier and weapon.m_cursedEyeShots >= minimumEyes then
            return false
        end
    end

    -- rapidFire automatic release
    if rapidFire and hasControlledChargeBar then
        local charge = weapon.m_charge
        local minCurseEyeShots = charge <= 0.0 and 1 or 5

        if (chocolateMilkModifier and charge >= (weapon.m_maxFireDelay * 2.5)) or
           (cursedEyeModifier and weapon.m_cursedEyeShots >= minCurseEyeShots) then
            charge = math.max(charge, 1.0e-5)
            weapon.m_charge = charge
            weapon.m_chocolateMilkCharge = charge
            isShooting = false
        end
    end

    return isShooting
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param isShooting boolean
---@param shootingInput Vector
---@param originalIsShooting boolean
local function update_weapon_charge(context, weapon, isShooting, shootingInput, originalIsShooting)
    local owner = weapon.m_owner
    local weaponModifiers = weapon.m_weaponModifiers

    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)
    local cursedEyeModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CURSED_EYE)

    if not isShooting then
        if weapon.m_cursedEyeShots > 0 then
            weapon.m_cursedEyeShots = weapon.m_cursedEyeShots - 1
        end

        weapon.m_charge = 0.0
        WeaponRules.ClearAllItemAnim(context, weapon)
    else
        local charge = weapon.m_charge

        if chocolateMilkModifier then
            local maxCharge = weapon:GetMaxCharge()
            local currentCharge = weapon.m_charge
            if currentCharge >= maxCharge then
                WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK, eItemAnimation.CHARGE_FULL, shootingInput, -1)
            else
                local progress = (currentCharge / maxCharge) * 18.0
                WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK, eItemAnimation.CHARGE, shootingInput, progress)
                local timeScale = WeaponUtils.GetTimeScale(weapon)
                charge = math.min(currentCharge + timeScale, maxCharge)
                WeaponUtils.SetBlinkTime(weapon, 1)
            end
        end

        if cursedEyeModifier then
            local maxCharge = weapon:GetMaxCharge()
            local currentCharge = weapon.m_charge
            if currentCharge >= maxCharge then
                WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_CURSED_EYE, eItemAnimation.CHARGE_FULL, shootingInput, -1)
            else
                local progress = (owner and owner.m_type == EntityType.ENTITY_PLAYER) and ((currentCharge / maxCharge) * 18.0) or 0.0
                WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_CURSED_EYE, eItemAnimation.CHARGE, shootingInput, progress)
                local timeScale = WeaponUtils.GetTimeScale(weapon)
                charge = math.min(currentCharge + timeScale, maxCharge)
                WeaponUtils.SetBlinkTime(weapon, 1)
                weapon.m_cursedEyeShots = ((charge + 1.0) * 5.0) / (maxCharge + 1.0)
            end
        end

        weapon.m_charge = charge
        weapon.m_chocolateMilkCharge = charge
    end

    if originalIsShooting then
        local bufferedDirection = nil
        if WeaponRules.IsAxisAligned(context, weapon) then
            bufferedDirection = VectorUtils.Copy(shootingInput)
        else
            bufferedDirection = WeaponRules.GetLastBufferedDirection(context, weapon, shootingInput)
        end

        weapon.m_directionBuffer = bufferedDirection
    end
end

---@param context Context
---@param weapon WeaponTearsComponent
---@param isShooting boolean
---@param shootingInput Vector
local function update_neptunus_charge(context, weapon, isShooting, shootingInput)
    local owner = weapon.m_owner
    local playerOwner = owner and EntityUtils.ToPlayer(owner)

    if isShooting then
        local maxCharge = weapon:GetMaxCharge()
        local currentCharge = weapon.m_charge
        local maxFireDelay = math.max(weapon.m_maxFireDelay + 1.0, 1.0)

        local progress = MathUtils.InverseLerp(0.0, maxCharge + 1.0, currentCharge + 1.0)
        local reduction = MathUtils.Lerp(1.0, maxFireDelay, progress ^ 2)

        local timeScale = WeaponUtils.GetTimeScale(weapon)
        local charge = math.max(currentCharge - reduction * timeScale, 0.0)

        weapon.m_charge = charge
        weapon.m_chocolateMilkCharge = charge
    else
        local chargeDirection = playerOwner and IsaacUtils.GetAxisAlignedUnitVectorFromDirection(playerOwner.m_headDirection) or shootingInput

        local maxCharge = weapon:GetMaxCharge()
        local currentCharge = weapon.m_charge
        if currentCharge >= maxCharge then
            WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_NEPTUNUS, eItemAnimation.CHARGE_FULL, chargeDirection, -1)
            weapon.m_chocolateMilkCharge = currentCharge
        else
            local progress = (currentCharge / maxCharge) * 18.0
            WeaponRules.PlayItemAnim(context, weapon, CollectibleType.COLLECTIBLE_NEPTUNUS, eItemAnimation.CHARGE, chargeDirection, progress)
            local timeScale = WeaponUtils.GetTimeScale(weapon)
            local charge = math.min(currentCharge + timeScale, maxCharge)
            weapon.m_charge = charge
            weapon.m_chocolateMilkCharge = charge
        end
    end
end

---@param weapon WeaponTearsComponent
---@param context Context
---@param shootingInput Vector
---@param isShooting boolean
---@param interpolate boolean
local function Fire(weapon, context, shootingInput, isShooting, interpolate)
    WeaponFire.Fire(weapon, context, shootingInput, isShooting, interpolate)

    local owner = weapon.m_owner
    local playerOwner = owner and EntityUtils.ToPlayer(owner)
    local weaponModifiers = weapon.m_weaponModifiers

    local chocolateMilkModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CHOCOLATE_MILK)
    local cursedEyeModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.CURSED_EYE)
    local neptunusModifier = BitsetUtils.HasAny(weaponModifiers, eWeaponModifiers.NEPTUNUS)
    local hasControlledChargeBar = (chocolateMilkModifier or cursedEyeModifier) and not neptunusModifier

    local originalIsShooting = isShooting
    isShooting = override_is_shooting(context, weapon, isShooting, interpolate)

    if not originalIsShooting then
        shootingInput = VectorUtils.Copy(weapon.m_directionBuffer)
    end

    if WeaponRules.IsAxisAligned(context, weapon) then
        shootingInput = VectorUtils.AxisAligned(shootingInput)
    else
        shootingInput = shootingInput:Normalized()
    end

    local tearDisplacement = get_weapon_tear_displacement(context, weapon, playerOwner)
    local desyncedEyes = not not (tearDisplacement == 0 and playerOwner and not hasControlledChargeBar and Inventory.HasCollectible(context, playerOwner, CollectibleType.COLLECTIBLE_EYE_DROPS, false))

    local isCharged = (chocolateMilkModifier and weapon.m_charge > 0.0) or (cursedEyeModifier and weapon.m_cursedEyeShots > 0)

    -- this is part of the inner eye iterations loop, specifically in update_fire_delay,
    -- but it doesn't really fit there so it was moved in the main function
    if interpolate then
        if hasControlledChargeBar then
            if not isShooting and isCharged then
                WeaponUtils.SetBlinkTime(weapon, 1)
            end

            return
        else
            if isShooting then
                return
            end
        end
    end

    local eyeIterations = desyncedEyes and 2 or 1
    for i = 1, eyeIterations, 1 do
        local mainEye = i == 1
        local shotsFired, startPositionFactor = update_fire_delay(weapon, mainEye, isShooting, interpolate)
        for j = 1, shotsFired, 1 do
            fire_tear(context, weapon, shootingInput, tearDisplacement, mainEye, desyncedEyes, shotsFired, startPositionFactor)
            startPositionFactor = startPositionFactor - (eyeMaxFireDelay + 1.0)
        end
    end

    if neptunusModifier then
        update_neptunus_charge(context, weapon, isShooting, shootingInput)
    elseif hasControlledChargeBar then
        update_weapon_charge(context, weapon, isShooting, shootingInput, originalIsShooting)
    end
end

--#region Module

Module.Fire = Fire

--#endregion

return Module