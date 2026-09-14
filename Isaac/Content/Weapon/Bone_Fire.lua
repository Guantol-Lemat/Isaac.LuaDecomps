--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")
local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local ColorUtils = require("General.VanillaAPI.Color")
local SpriteUtils = require("General.VanillaAPI.Sprite")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")
local IEntityBomb = require("Isaac.Interface.Entity_Bomb")
local IEntityKnife = require("Isaac.Interface.Entity_Knife")
local IEntityList = require("Isaac.Interface.EntityList")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local IWeapon = require("Isaac.Interface.Weapon")
local ITearParams = IEntityPlayer.TearParams

local IEntityPtr = IEntity.EntityPtr

--#endregion

local VECTOR_ZERO = Vector(0, 0)
local VECTOR_ONE = Vector(1, 1)
local BITSET_ZERO = BitSet128()
local COLOR_RED = Color(1.0, 0.0, 0.0, 1.0)

local TEAR_BROKEN_BONE_PATH = "gfx/tears_brokenbone.png"
local SOUND_BRIMSTONE_BALL_SPAWN = SoundEffect.SOUND_BLOOD_LASER_LARGE
local SOUND_BONE_SWING = SoundEffect.SOUND_SHELLGAME
local SOUND_HOLD_BOMB = SoundEffect.SOUND_FETUS_FEET

local NULL_LAYER_TIP = 0

local KNIFE_BASE_ROTATION = {
    [1] = 0.0,
    [2] = 180.0,
    [3] = 90.0,
    [4] = -90.0
}

---@param weapon Component.Weapon.Bone
---@param ctx Context.Common
---@param knife Component.Entity.Knife
local function update_bone_attributes(weapon, ctx, knife)
    if weapon.m_weaponType == WeaponType.WEAPON_NOTCHED_AXE then
        knife:SetCollisionDamage(ctx, 7.0)
        return
    end

    knife:SetColor(ctx, IWeapon.GetTearColor(weapon, ctx), -1, -1, false, true)
    knife.m_tearFlags = IWeapon.GetTearFlags(weapon, ctx)
    knife:SetCollisionDamage(ctx, IWeapon.GetTearDamage(weapon, ctx))
    knife.m_mass = weapon.m_weaponModifier & WeaponModifier.ALMOND_MILK ~= 0 and 0.5 or 3.0
end

---@param weapon Component.Weapon.Bone
---@param ctx Context.Common
---@param shootingInput Vector
---@param isShooting boolean
---@param isInterpolation boolean
local function Fire(weapon, ctx, shootingInput, isShooting, isInterpolation)
    IWeapon.Fire(weapon, ctx, shootingInput, isShooting, isInterpolation)

    local myOwner = weapon.m_owner
    local weaponType = weapon.m_weaponType
    local weaponModifiers = weapon.m_weaponModifier

    local playerOwner = nil
    if myOwner and myOwner.m_type == EntityType.ENTITY_PLAYER then
        playerOwner = myOwner
        ---@cast playerOwner Component.Entity.Player
    end
    local myPlayer = IWeapon.GetPlayer(weapon)
    local myPosition = IWeapon.GetPosition(weapon)
    local myShotSpeed = IWeapon.GetShotSpeed(weapon)

    local modifier_chocolateMilk = weaponModifiers & WeaponModifier.CHOCOLATE_MILK ~= 0
    local modifier_cursedEye = weaponModifiers & WeaponModifier.CURSED_EYE ~= 0
    local modifier_brimstone = weaponModifiers & WeaponModifier.BRIMSTONE ~= 0
    local modifier_monstrosLung = weaponModifiers & WeaponModifier.MONSTROS_LUNG ~= 0

    local modifier_drFetus = false
    local modifier_epicFetus = false
    if weaponType ~= WeaponType.WEAPON_NOTCHED_AXE and myPlayer then
        modifier_epicFetus = IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_EPIC_FETUS, false)
        modifier_drFetus = not modifier_epicFetus and IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_DR_FETUS, false)
    end

    local modifier_ludovico = weaponModifiers & WeaponModifier.LUDOVICO_TECHNIQUE ~= 0
        and not modifier_epicFetus
    local modifier_berserk = weaponType ~= WeaponType.WEAPON_NOTCHED_AXE
        and (myPlayer and ITemporaryEffects.HasCollectibleEffect(myPlayer.m_temporaryEffects, CollectibleType.COLLECTIBLE_BERSERK))

    local modifier_cSection = weaponModifiers & WeaponModifier.C_SECTION ~= 0
    local modifier_rapidFire = weaponModifiers & WeaponModifier.SOY_MILK ~= 0 or weapon.m_maxFireDelay <= 0.0
    local hasChargedAttack = modifier_chocolateMilk or modifier_cursedEye
        or modifier_brimstone or modifier_monstrosLung
        or (modifier_rapidFire and modifier_cSection)

    local maxFireDelay = math.max(weapon.m_maxFireDelay, 0.001)
    local local_1f6 = false

    ---@type KnifeVariant
    local knifeVariant = KnifeVariant.BONE_CLUB
    if myPlayer and IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_MOMS_KNIFE, false) then
        knifeVariant = KnifeVariant.BONE_SCYTHE
    elseif modifier_berserk then
        knifeVariant = KnifeVariant.BERSERK_CLUB
    end

    if weaponType == WeaponType.WEAPON_NOTCHED_AXE then
        knifeVariant = KnifeVariant.NOTCHED_AXE
    end

    local highChargeMultiplier = (not modifier_cursedEye and not modifier_cSection) or modifier_chocolateMilk
        and 3.0 or 2.0

    local highMaxCharge = highChargeMultiplier * maxFireDelay
    local maxCharge = maxFireDelay * 2.0

    local function update_epic_fetus_target()
        ---@cast playerOwner Component.Entity.Player
        local rocket = playerOwner.m_heldEntity.ref
        local isTargeting = isShooting
            and rocket ~= nil and rocket.m_visible == false
            and rocket.m_type == EntityType.ENTITY_EFFECT and rocket.m_variant == EffectVariant.SMALL_ROCKET

        if not isTargeting then
            if not isInterpolation and weapon.m_epicFetusTarget.ref then
                weapon.m_epicFetusTarget.ref:Remove(ctx)
            end
            return
        end

        local targetEntity = weapon.m_epicFetusTarget.ref
        IWeapon.SetBlinkTime(weapon, 10)

        if not targetEntity and not isInterpolation then
            targetEntity = IGame.Spawn(
                ctx, ctx.game,
                EntityType.ENTITY_EFFECT, EffectVariant.TARGET,
                myPosition, VECTOR_ZERO, playerOwner,
                0, IsaacUtils.Random()
            )

            ---@cast targetEntity Component.Entity.Effect
            targetEntity.m_timeout = 0
            targetEntity.m_lifeSpan = 0

            IEntityPtr.SetReference(weapon.m_epicFetusTarget, targetEntity)
        end

        if not targetEntity then
            return
        end

        local input = VectorUtils.Copy(shootingInput)
        --- cap at 1.0
        if input:LengthSquared() > 1.0 then
            input:Resize(1.0)
        end

        local hasWizControls = IEntityPlayer.HasCollectible(ctx, playerOwner, CollectibleType.COLLECTIBLE_THE_WIZ, false)
            and not IEntityPlayer.HasCollectible(ctx, playerOwner, CollectibleType.COLLECTIBLE_20_20, false)

        if hasWizControls then
            input = input:Rotated(45)
        end

        IEntity.AddVelocity_NoFriction(targetEntity, input * 8.0, false)
    end

    if modifier_epicFetus and playerOwner then
        update_epic_fetus_target()
    end

    local weaponScale = 1.0
    if myOwner then
        if myOwner.m_type == EntityType.ENTITY_PLAYER then
            ---@cast myOwner Component.Entity.Player
            weaponScale = math.max(myOwner.m_spriteScale_qqq.X, 1.0)
        else
            weaponScale = math.max(myOwner.m_sprite.Scale.X, 1.0)
            if myOwner.m_type == EntityType.ENTITY_FAMILIAR then
                weaponScale = weaponScale * 0.8
            end
        end
    end

    if myPlayer and weaponType ~= WeaponType.WEAPON_NOTCHED_AXE then
        if ITemporaryEffects.HasCollectibleEffect(myPlayer.m_temporaryEffects, CollectibleType.COLLECTIBLE_MEGA_MUSH) then
            weaponScale = weaponScale * 4.0
        end

        if IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_POLYPHEMUS, false) then
            weaponScale = weaponScale * 2.0
        elseif IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_HAEMOLACRIA, false) then
            weaponScale = weaponScale * 1.5
        end
    end

    local function init_ludovico_tear()
        local tearParams = ITearParams.New()
        if myPlayer then
            local tearDisplacement = (IsaacUtils.RandomInt(2) * 2) - 1 -- one of -1, 0, 1
            tearParams = IEntityPlayer.GetTearHitParams(myPlayer, ctx, WeaponType.WEAPON_LUDOVICO_TECHNIQUE, 1.0, tearDisplacement, weapon.m_owner)
        end

        local tear = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_TEAR, tearParams.tearVariant,
            myPosition + Vector(0.0, 5.0), VECTOR_ZERO, nil,
            2, IsaacUtils.Random()
        )

        local tearDamage = tearParams.tearDamage
        local tearScale = tearDamage * 0.04 + 1.5 + math.sqrt(tearDamage) * 0.15
        tearScale = math.max(tearScale, 0.01)

        ---@cast tear Component.Entity.Tear
        IEntity.SetParent(tear, weapon.m_owner)
        IEntityTear.SetHeight(tear, ctx, -40.0)
        tear:SetCollisionDamage(ctx, tearDamage)
        IEntityTear.SetTearFlags(tear, ctx, tearParams.tearFlags | TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_SPECTRAL)
        tear:SetColor(ctx, tearParams.tearColor, -1, -1, false, true)
        IEntityTear.SetScale(tear, ctx, tearScale)
        tear:Update(ctx)

        IEntityPtr.SetReference(weapon.m_ludovicoTear, tear)
    end

    if modifier_ludovico and not weapon.m_ludovicoTear.ref then
        init_ludovico_tear()
    end

    local modifier_lokisHorns = false
    local modifier_momsEye = false
    if weaponType ~= WeaponType.WEAPON_NOTCHED_AXE and myPlayer then
        modifier_lokisHorns = IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_LOKIS_HORNS, false)
        modifier_momsEye = IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_MOMS_EYE, false)
    end

    local function update_knife_lifecycle(it)
        local index = it - 1
        local ptr = weapon.m_knives[it]
        local heldBone = index == 0
            or (index == 1 and modifier_momsEye)
            or modifier_lokisHorns

        if not heldBone then
            if ptr.ref then
                ptr.ref:Remove(ctx)
                IEntityPtr.SetReference(ptr, nil)
            end

            return
        end

        local knife = ptr.ref
        if knife then
            if knife.m_type == EntityType.ENTITY_KNIFE and knife.m_variant == knifeVariant then
                return
            end

            knife:Remove(ctx)
        end

        knife = IWeapon.FireBoneClub(weapon, ctx, weapon.m_owner, knifeVariant, 0.0, true)
        IEntityPtr.SetReference(ptr, knife)
        knife.m_rotation = KNIFE_BASE_ROTATION[it]
        knife.m_mainBone = index == 0
        knife:Update(ctx)
    end

    for i = 1, 4, 1 do
        update_knife_lifecycle(i)
    end

    local mainKnife = weapon.m_knives[1].ref
    ---@cast mainKnife Component.Entity.Knife

    local facingDirection = VectorUtils.Copy(shootingInput)
    if VectorUtils.Equals(facingDirection, VECTOR_ZERO) then
        facingDirection = VectorUtils.Copy(weapon.m_bufferDirection)

        if VectorUtils.Equals(facingDirection, VECTOR_ZERO) and playerOwner then
            facingDirection = IsaacUtils.GetAxisAlignedUnitVectorFromDirection(playerOwner.m_headDirection)
        end
    end

    if IWeapon.IsAxisAligned(weapon, ctx) then
        facingDirection = VectorUtils.GetAxisAlignedUnitVector(facingDirection)
    end

    if IWeapon.has_wizard_effect(weapon) then
        local tearSpawnDisplacement = IWeapon.GetTearSpawnDisplacement(weapon)
        facingDirection = facingDirection:Rotated(tearSpawnDisplacement * 45.0)
    end

    local function update_held_knives()
        for i = 1, 4, 1 do
            local knife = weapon.m_knives[i].ref
            if not knife then
                goto continue
            end

            ---@cast knife Component.Entity.Knife
            local angle = facingDirection:GetAngleDegrees() + KNIFE_BASE_ROTATION[i]
            angle = MathUtils.NormalizeAngle(angle)
            knife.m_rotation = angle
            ::continue::
        end

        if not mainKnife.m_meleeSwingInputHeld_qqq then
            mainKnife.m_rotationOffset = 0.0
        end

        local frameCount = IEntity.GetFrameCount(ctx, mainKnife)
        if weapon.m_charge > 0 and frameCount > 1 then
            return
        end

        local scale = weaponScale
        if frameCount > 1 then
            scale = MathUtils.Lerp(mainKnife.m_sprite.Scale.X, weaponScale, 0.5)
        end

        for i = 1, 4, 1 do
            local knife = weapon.m_knives[i].ref
            if knife then
                ---@cast knife Component.Entity.Knife
                update_bone_attributes(weapon, ctx, knife)
                knife.m_sprite.Scale = Vector(scale, scale)
            end
        end
    end

    if not mainKnife.m_isSwinging and not mainKnife.m_isFlying then
        update_held_knives()
    end

    if not isShooting then
        -- clear charge animations
        if modifier_brimstone and IWeapon.IsItemAnimFinished(weapon, ctx, CollectibleType.COLLECTIBLE_BRIMSTONE) then
            IWeapon.ClearItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_BRIMSTONE)
        end

        if modifier_cursedEye then
            IWeapon.ClearItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_CURSED_EYE)
        end

        if modifier_chocolateMilk and IWeapon.IsItemAnimFinished(weapon, ctx, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
            IWeapon.ClearItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
        end

        if modifier_monstrosLung and IWeapon.IsItemAnimFinished(weapon, ctx, CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
            IWeapon.ClearItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
        end

        if modifier_cSection and IWeapon.IsItemBodySubAnimFinished(weapon, ctx, CollectibleType.COLLECTIBLE_C_SECTION) then
            IWeapon.PlayItemBodySubAnim(weapon, ctx, CollectibleType.COLLECTIBLE_BRIMSTONE, ItemAnim.CHARGE, shootingInput, 0.0)
        end
    end

    if isInterpolation then
        return
    end

    local weaponCharge = weapon.m_charge
    local newCharge = weaponCharge

    local function try_shoot_bone()
        if weaponCharge > 1.0 then -- minimum charge for shoot
            local knives = IEntityList.QueryType(ctx.game.m_level.m_room.m_entityList, EntityType.ENTITY_KNIFE, -1, -1, false, false)
            for i = 1, #knives, 1 do
                local knife = knives[i]
                ---@cast knife Component.Entity.Knife
                local parent = knife.m_parent.ref

                if parent and (weapon.m_owner == parent or weapon.m_owner == parent.m_parent.ref) then
                    knife.m_rotationOffset = MathUtils.NormalizeAngle(knife.m_rotationOffset * 0.5)
                end
            end

            IWeapon.SetBlinkTime(weapon, 7 - math.floor(maxFireDelay * -0.45))
            IWeapon.TriggerTearFired(weapon, ctx, facingDirection, 1)

            local chargeCap = maxFireDelay * 3.0
            local charge = math.min(weaponCharge, chargeCap)
            local shootCharge = math.max(charge / chargeCap, 0.2)
            local playerRange = myPlayer and myPlayer.m_range or 260.0
            local playerRangeCap = myPlayer and IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_TINY_PLANET, false)
                and 100000.0
                or 300.0

            playerRange = math.min(playerRange, playerRangeCap)
            local shootRange = math.max(playerRange * 0.9, 200.0)

            for i = 1, 4, 1 do
                local knife = weapon.m_knives[i].ref
                local index = i - 1
                ---@cast knife Component.Entity.Knife?
                if knife and (index == 0 or knife.m_meleeSwingInputHeld_qqq) then -- should shoot
                    IEntityKnife.Shoot(knife, ctx, shootCharge, shootRange)
                end
            end

            IWeapon.SetHeadLockTime(weapon, 2)
            if playerOwner then
                IEntityPlayer.TryForgottenThrow(playerOwner, ctx, facingDirection)
            end
        end

        for i = 1, 4, 1 do
            local knife = weapon.m_knives[i].ref
            ---@cast knife Component.Entity.Knife
            knife.m_meleeSwingInputHeld_qqq = false
        end

        weapon.m_bufferDirection = Vector(0.0, 0.0)
    end

    if not isShooting then
        local canShootBone = not hasChargedAttack -- has no charge bar (charge release would cause a swing)
            and ((not playerOwner or not playerOwner.m_heldEntity.ref) -- has no held entity
            and not modifier_cSection) -- is not c section
        if canShootBone then
            try_shoot_bone()
            newCharge = 0
            return
        end

        if weaponCharge > 0.0 then
            newCharge = 0
            if weapon.m_fireDelay >= 0.0 then
                weapon.m_field_0x58 = 0
            end
        end
    end

    local condition_1_qqq = IWeapon.GetPeeBurstCooldown(weapon) > 0
        or (playerOwner and ITemporaryEffects.HasNullEffect(playerOwner.m_temporaryEffects, NullItemID.ID_SOUL_FORGOTTEN))
        or (modifier_rapidFire and not hasChargedAttack)

    if not condition_1_qqq then
        if modifier_rapidFire or modifier_cSection then
            if isShooting and highMaxCharge <= weaponCharge then
                isShooting = false
                if weaponCharge > 0.0 then
                    newCharge = 0
                    if weapon.m_fireDelay >= 0.0 then
                        weapon.m_field_0x58 = 0
                    end
                end
            end

            local_1f6 = true
        end
    else
        hasChargedAttack = false
        newCharge = weaponCharge
        weapon.m_charge = 0.0

        if modifier_rapidFire then
            local_1f6 = true
            newCharge = math.max(newCharge, 1.0)
        end
    end

    -- evaluate fire controls
    local shouldFire = false
    if isShooting then
        local canSwingBone = (not mainKnife.m_isSwinging or modifier_rapidFire)
        if canSwingBone then
            -- start at 1.0 charge when you have a charged attack
            if hasChargedAttack and weapon.m_charge < 1.0 then
                weapon.m_charge = 1.0
                newCharge = 1.0
            end

            shouldFire = not hasChargedAttack
                and weapon.m_fireDelay < 0.0 and weapon.m_charge <= 0.0
                and not mainKnife.m_isFlying
        end
    else -- not shooting
        shouldFire = (playerOwner and playerOwner.m_heldEntity.ref ~= nil) -- fire held entity
            or (modifier_cSection and weapon.m_fireDelay < 0.0 and weapon.m_charge > 1.0) -- fire c-section
            or (modifier_cursedEye and weapon.m_fireDelay < 0 and weapon.m_field_0x58 > 0) -- fire cursed eye
            or ((modifier_chocolateMilk or modifier_brimstone or modifier_monstrosLung)
            and (not isShooting and weapon.m_fireDelay < 0.0 and weapon.m_charge > 1.0)) -- fire charged attack
    end

    if shouldFire then
        local multiShotParams = IWeapon.GetMultiShotParams(weapon, ctx)
        weapon.m_fireDelay = maxFireDelay
        IWeapon.SetTearSpawnDisplacement(weapon, -IWeapon.GetTearSpawnDisplacement(weapon))
        IWeapon.SetBlinkTime(weapon, 7 - math.floor(maxFireDelay * -0.45))
        IWeapon.TriggerTearFired(weapon, ctx, facingDirection, 1)

        local damageMultiplier = 1.0
        local baseSwingPitch = 1.0 / (weaponScale * 0.5 + 0.5)
        baseSwingPitch = math.max(baseSwingPitch, 0.5)

        if playerOwner then
            local heldEntity = playerOwner.m_heldEntity.ref
            if heldEntity then
                heldEntity.m_position = VectorUtils.Copy(playerOwner.m_position)
                if heldEntity.m_type == EntityType.ENTITY_BOMB then
                    -- throw bomb
                    ---@cast heldEntity Component.Entity.Bomb
                    heldEntity.m_flags = heldEntity.m_flags & ~(EntityFlag.FLAG_HELD | EntityFlag.FLAG_PERSISTENT)
                    heldEntity.m_renderZOffset = 0

                    for i = 1, multiShotParams.m_numTears, 1 do
                        local index = i - 1
                        local posVel = IWeapon.GetMultiShotPositionVelocity(index, WeaponType.WEAPON_BOMBS, {X = facingDirection.X, Y = facingDirection.Y}, myShotSpeed, multiShotParams)

                        local currentBomb = heldEntity
                        if index == multiShotParams.m_numTears // 2 then
                            currentBomb.m_skipUpdate_qqq = true
                        else
                            currentBomb = IWeapon.FireBomb(weapon, ctx, myPosition, VECTOR_ZERO)
                            local countdown = heldEntity.m_explosionCountdown1
                            currentBomb.m_explosionCountdown1 = countdown
                            currentBomb.m_explosionCountdown2 = countdown
                            currentBomb.m_sprite:Play(heldEntity.m_sprite:GetAnimation())
                            currentBomb.m_sprite:SetFrame(heldEntity.m_sprite:GetFrame())
                        end

                        currentBomb.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                        currentBomb.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
                        if IEntityBomb.IsRocket(currentBomb) then
                            currentBomb.m_rocketAngle = posVel.Velocity:GetAngleDegrees()
                        else
                            currentBomb.m_fallSpeed = -5.0
                        end
                        currentBomb.m_positionOffset = Vector(0.0, -14.0)

                        local playerInheritance = playerOwner.m_velocityBeforeUpdate * 0.6
                        currentBomb.m_velocity = playerInheritance + (posVel.Velocity:Normalized() * 20.0)
                        currentBomb:SetCollisionDamage(ctx, mainKnife.m_collisionDamage)
                        currentBomb.m_rocketSpeed = 15.0
                    end
                elseif heldEntity.m_type == EntityType.ENTITY_EFFECT and heldEntity.m_variant == EffectVariant.SMALL_ROCKET then
                    ---@cast heldEntity Component.Entity.Effect
                    local target = weapon.m_epicFetusTarget.ref
                    local targetPosition

                    if target then
                        targetPosition = VectorUtils.Copy(target.m_position)
                    else
                        targetPosition = facingDirection * 80.0 + myPosition
                    end
                    local positionToTarget = targetPosition - myPosition

                    heldEntity.m_flags = heldEntity.m_flags & ~EntityFlag.FLAG_PERSISTENT
                    heldEntity.m_renderZOffset = 0
                    heldEntity.m_positionOffset = Vector(0, 0)
                    heldEntity.m_state = 1

                    for i = 1, multiShotParams.m_numTears, 1 do
                        local index = i - 1
                        local posVel = IWeapon.GetMultiShotPositionVelocity(index, WeaponType.WEAPON_BOMBS, {X = 1, Y = 0}, myShotSpeed, multiShotParams)

                        local currentRocket = heldEntity
                        if index ~= multiShotParams.m_numTears // 2 then
                            ---@diagnostic disable-next-line: cast-local-type
                            currentRocket = IGame.Spawn(
                                ctx, ctx.game,
                                EntityType.ENTITY_EFFECT, EffectVariant.SMALL_ROCKET,
                                myPosition, VECTOR_ZERO, weapon.m_owner,
                                0, IsaacUtils.Random()
                            )
                        end

                        local angle = posVel.Velocity:GetAngleDegrees()
                        currentRocket.m_targetPosition = myPosition + positionToTarget:Rotated(angle)
                        currentRocket.m_state = index + 1
                    end
                end

                heldEntity.m_visible = true
                IEntityPtr.SetReference(playerOwner.m_heldEntity, nil)
            end
        end

        if modifier_chocolateMilk then
            damageMultiplier = math.max(weapon.m_charge / maxFireDelay, 1.0)
        end

        if modifier_monstrosLung and weapon.m_charge >= maxCharge then
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_MONSTROS_LUNG, ItemAnim.SHOOT, facingDirection, -1.0)
            local baseVelocity = facingDirection * 10.0
            local tearMovementInheritance = IWeapon.get_tear_movement_inheritance(weapon, ctx, baseVelocity)

            baseVelocity = baseVelocity + tearMovementInheritance
            local baseNumTears = 12

            if myPlayer then
                if IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_IPECAC, false) then
                    baseVelocity = baseVelocity * IsaacUtils.RandomFloat() * 0.2 + 0.7
                end

                if IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_HAEMOLACRIA, false) then
                    baseNumTears = 7
                    if IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_BRIMSTONE, false) then
                        baseNumTears = baseNumTears - 2
                    end
                end
            end

            --- CRASH: myPlayer is not actually checked and used regardless of if it's nil or not
            ---@diagnostic disable-next-line: param-type-mismatch
            if IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_DR_FETUS, false) then
                baseNumTears = 5
            end

            local numTears = math.ceil((baseNumTears + math.floor((baseNumTears / 5.0) * multiShotParams.m_numTears)) / multiShotParams.m_numEyesActive)
            for i = 1, multiShotParams.m_numEyesActive, 1 do
                local eyeIndex = i - 1
                local angle = MathUtils.MapToRange(eyeIndex, {0.0, multiShotParams.m_numEyesActive - 1}, {-multiShotParams.m_multiEyeAngle, multiShotParams.m_multiEyeAngle}, true)
                local eyeVelocity = baseVelocity:Rotated(angle) * myShotSpeed

                for j = 1, numTears, 1 do
                    local baseFireSpeed = IsaacUtils.RandomFloat() * 3.5
                    local fireVelocity = eyeVelocity + (IsaacUtils.RandomVector() * baseFireSpeed)
                    local tear = IWeapon.FireTear(weapon, ctx, myPosition, fireVelocity, 0, 1.0, 0.0)

                    if tear.m_variant == TearVariant.BONE and IsaacUtils.RandomInt(4) ~= 0 then
                        local sprite = tear.m_sprite
                        local layers = sprite:GetAllLayers()
                        for it = 1, sprite:GetLayerCount(), 1 do
                            local layerId = it - 1
                            sprite:ReplaceSpritesheet(layerId, TEAR_BROKEN_BONE_PATH, false)
                        end
                        sprite:LoadGraphics()
                    end

                    local setFallPhysics = not myPlayer
                        or (not IEntityPlayer.HasCollectible(ctx, myPlayer, CollectibleType.COLLECTIBLE_IPECAC, false)
                        and (tear.m_tearFlags & TearFlags.TEAR_HYDROBOUNCE) == BITSET_ZERO)
                    if setFallPhysics then
                        --- this cannot crash as monstrosLung requires a player
                        assert(myPlayer)
                        tear.m_fallingAcceleration = myPlayer.m_tearFallingAcceleration + 0.5
                        tear.m_fallingSpeed = (myPlayer.m_tearFallingSpeed - IsaacUtils.RandomFloat() * 15.0) + 5.0
                    end

                    local randomInt = IsaacUtils.RandomInt(2)
                    local tearScale = (randomInt * 0.4 + 0.9 + IsaacUtils.RandomFloat() * 0.05) * tear.m_fScale
                    tearScale = math.max(tearScale, 0.01)
                    IEntityTear.SetScale(tear, ctx, tearScale)
                end
            end
        end

        if modifier_brimstone and weapon.m_charge >= maxCharge then
            assert(myPlayer)

            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_BRIMSTONE, ItemAnim.SHOOT, facingDirection, -1.0)
            local baseAngle = facingDirection:GetAngleDegrees()

            for i = 1, 4, 1 do
                local knifeIndex = i - 1
                local knife = weapon.m_knives[i].ref
                local canFireKnife = knife
                    and (knifeIndex == 0
                    or (knifeIndex == 1 and multiShotParams.m_isShootingBackwards)
                    or multiShotParams.m_isShootingSideways)

                if not canFireKnife then
                    goto continue
                end

                ---@cast knife Component.Entity.Knife
                local color = knifeIndex ~= 0
                    and ColorUtils.Multiply(COLOR_RED, myPlayer.m_laserColor)
                    or COLOR_RED
                knife:SetColor(ctx, color, 18, 1, true, true)

                if knifeIndex == 0 then
                    for j = 1, multiShotParams.m_numTears, 1 do
                        local tearIdx = j - 1
                        local posVel = IWeapon.GetMultiShotPositionVelocity(tearIdx, WeaponType.WEAPON_BONE, {X = 1.0, Y = 0.0}, myShotSpeed, multiShotParams)
                        local ballAngle = posVel.Velocity:GetAngleDegrees() + baseAngle
                        local ballDirection = Vector.FromAngle(ballAngle)

                        local velocity = ballDirection * 6.0
                        local position = ballDirection * 30.0 + myPosition
                        IWeapon.FireBrimstoneBall(weapon, ctx, position, velocity, knife.m_positionOffset)
                    end
                else
                    local ballAngle = baseAngle + KNIFE_BASE_ROTATION[knifeIndex + 1]
                    ballAngle = MathUtils.NormalizeAngle(ballAngle)
                    local ballDirection = Vector.FromAngle(ballAngle)

                    local velocity = ballDirection * 6.0
                    local position = ballDirection * 30.0 + myPosition
                    IWeapon.FireBrimstoneBall(weapon, ctx, position, velocity, knife.m_positionOffset)
                end
                ::continue::
            end

            IManager.PlaySound(ctx, SOUND_BRIMSTONE_BALL_SPAWN, 0.5, 2, false, 1.0)
            IWeapon.SetBlinkTime(weapon, 36)
        end

        if modifier_cSection and weapon.m_charge >= maxCharge then
            IWeapon.PlayItemBodySubAnim(weapon, ctx, CollectibleType.COLLECTIBLE_C_SECTION, ItemAnim.SHOOT, shootingInput, -1.0)
            local baseAngle = facingDirection:GetAngleDegrees()

            for i = 1, 4, 1 do
                local knifeIndex = i - 1
                local knife = weapon.m_knives[i].ref
                if not knife then
                    goto continue
                end

                ---@cast knife Component.Entity.Knife
                if knifeIndex == 0 then
                    for j = 1, multiShotParams.m_numTears, 1 do
                        local fetusIndex = j - 1
                        local posVel = IWeapon.GetMultiShotPositionVelocity(fetusIndex, WeaponType.WEAPON_BONE, {X = 1.0, Y = 0.0}, myShotSpeed, multiShotParams)
                        local fetusAngle = posVel.Velocity:GetAngleDegrees() + baseAngle
                        local fetusDirection = Vector.FromAngle(fetusAngle)

                        local velocity = fetusDirection * 10.0
                        local position = myPosition + fetusDirection * 4.0
                        local fetus = IWeapon.FireFetus(weapon, ctx, position, velocity, 0, weapon.m_owner, 1.0)

                        local scale = math.max(fetus.m_fScale * 1.2, 0.01)
                        IEntityTear.SetScale(fetus, ctx, scale)
                        fetus.m_tearRange = fetus.m_tearRange * 2.0
                        fetus:Update(ctx)
                    end
                elseif (knifeIndex == 1 and multiShotParams.m_isShootingBackwards) or multiShotParams.m_isShootingSideways then
                    local fetusAngle = baseAngle + KNIFE_BASE_ROTATION[knifeIndex + 1]
                    fetusAngle = MathUtils.NormalizeAngle(fetusAngle)
                    local fetusDirection = Vector.FromAngle(fetusAngle)

                    local velocity = fetusDirection * 10.0
                    local position = myPosition + fetusDirection * 4.0
                    local fetus = IWeapon.FireFetus(weapon, ctx, position, velocity, 0, weapon.m_owner, 1.0)

                    local scale = math.max(fetus.m_fScale * 1.2, 0.01)
                    IEntityTear.SetScale(fetus, ctx, scale)
                    fetus.m_tearRange = fetus.m_tearRange * 2.0
                    fetus:Update(ctx)
                end
                ::continue::
            end
        end

        local numSwings = modifier_cursedEye and weapon.m_field_0x58 or 1
        local knives = IEntityList.QueryType(ctx.game.m_level.m_room.m_entityList, EntityType.ENTITY_KNIFE, -1, -1, false, false)

        -- remove all previous swings
        for i = 1, #knives, 1 do
            local knife = knives[i]
            if knife.m_parent.ref == mainKnife then
                knife:Remove(ctx)
            end
        end

        local highestDamage = 0.0

        -- swing main knives
        for i = 1, 4, 1 do
            local knifeIndex = i - 1
            local knife = weapon.m_knives[i].ref
            local canSwingKnife = knife
                and (knifeIndex == 0
                or (knifeIndex == 1 and multiShotParams.m_isShootingBackwards)
                or multiShotParams.m_isShootingSideways)

            if not canSwingKnife then
                goto continue
            end

            ---@cast knife Component.Entity.Knife
            local tearParams = ITearParams.New()
            if myPlayer then
                local tearDisplacement = (IsaacUtils.RandomInt(2) * 2) - 1 -- one of -1, 0, 1
                tearParams = IEntityPlayer.GetTearHitParams(myPlayer, ctx, WeaponType.WEAPON_BONE, 1.0, tearDisplacement, weapon.m_owner)
            end

            local damage = tearParams.tearDamage * damageMultiplier
            highestDamage = math.max(damage, highestDamage)

            knife:SetColor(ctx, tearParams.tearColor, -1, -1, false, true)
            IEntityKnife.SetTearFlags(knife, tearParams.tearFlags)
            knife:SetCollisionDamage(ctx, damage)

            local knifeAngle = facingDirection:GetAngleDegrees() + KNIFE_BASE_ROTATION[knifeIndex + 1]
            knifeAngle = MathUtils.NormalizeAngle(knifeAngle)
            knife.m_rotation = knifeAngle
            IEntityKnife.InitSwing(knife, numSwings)
            IEntityKnife.Swing(knife, ctx)
            knife.m_meleeSwingInputHeld_qqq = not hasChargedAttack
            ::continue::
        end

        -- fire extra bone clubs
        for i = 1, multiShotParams.m_numTears, 1 do
            local boneIndex = i - 1
            local posVel = IWeapon.GetMultiShotPositionVelocity(boneIndex, WeaponType.WEAPON_BONE, {X = 1.0, Y = 0.0}, myShotSpeed, multiShotParams)
            local boneAngle = posVel.Velocity:GetAngleDegrees()

            if boneIndex == multiShotParams.m_numTears // 2 then
                mainKnife.m_rotationOffset = MathUtils.NormalizeAngle(boneAngle)
            else
                local tearParams = ITearParams.New()
                if myPlayer then
                    local tearDisplacement = (IsaacUtils.RandomInt(2) * 2) - 1 -- one of -1, 0, 1
                    tearParams = IEntityPlayer.GetTearHitParams(myPlayer, ctx, WeaponType.WEAPON_BONE, 1.0, tearDisplacement, weapon.m_owner)
                end

                local damage = tearParams.tearDamage * damageMultiplier
                highestDamage = math.max(damage, highestDamage)

                local knife = IWeapon.FireBoneClub(weapon, ctx, mainKnife, knifeVariant, boneAngle, false)
                knife:SetColor(ctx, tearParams.tearColor, -1, -1, false, true)
                IEntityKnife.SetTearFlags(knife, tearParams.tearFlags)
                knife:SetCollisionDamage(ctx, damage)
                knife.m_sprite.Scale = mainKnife.m_sprite.Scale

                IEntityKnife.InitSwing(knife, numSwings)
                IEntityKnife.Swing(knife, ctx)

                knife:Update(ctx)
            end
        end

        for i = 1, multiShotParams.m_numRandomTears, 1 do
            local tearParams = ITearParams.New()
            if myPlayer then
                local tearDisplacement = (IsaacUtils.RandomInt(2) * 2) - 1 -- one of -1, 0, 1
                tearParams = IEntityPlayer.GetTearHitParams(myPlayer, ctx, WeaponType.WEAPON_BONE, 1.0, tearDisplacement, weapon.m_owner)
            end

            local damage = tearParams.tearDamage * damageMultiplier
            highestDamage = math.max(damage, highestDamage)

            local randomAngle = IsaacUtils.RandomFloat() * 360.0
            local knife = IWeapon.FireBoneClub(weapon, ctx, mainKnife, knifeVariant, randomAngle, false)
            knife:SetColor(ctx, tearParams.tearColor, -1, -1, false, true)
            IEntityKnife.SetTearFlags(knife, tearParams.tearFlags)
            knife:SetCollisionDamage(ctx, damage)
            knife.m_sprite.Scale = mainKnife.m_sprite.Scale

            IEntityKnife.InitSwing(knife, numSwings)
            IEntityKnife.Swing(knife, ctx)

            knife:Update(ctx)
        end

        local pitch = (IsaacUtils.RandomFloat() * 0.2 + 0.9) * baseSwingPitch
        IManager.PlaySound(ctx, SOUND_BONE_SWING, 1.0, 1, false, pitch)
        if highestDamage > 20.0 and weaponScale > 1.5 then
            IGame.ShakeScreen(ctx.game, ctx, weaponScale * 5.0)
        end

        if hasChargedAttack then
            newCharge = 0.0
        elseif not local_1f6 then
            newCharge = 1.0
        elseif weapon.m_charge < 1.0 then
            weapon.m_charge = 1.0
        end

        weapon.m_field_0x58 = 0
        weapon.m_bufferDirection = Vector(0.0, 0.0)

        if modifier_cursedEye then
            IWeapon.ClearItemAnim_All(weapon)
        end

        if playerOwner then
            IEntityPlayer.TryForgottenThrow(playerOwner, ctx, facingDirection)
        end
    end

    if not isShooting then
        return
    end

    if weaponType == WeaponType.WEAPON_NOTCHED_AXE or (mainKnife.m_isFlying and not local_1f6) or weapon.m_charge < 1.0 then
        return
    end

    local chargeColor = Color(1.0, 1.0, 1.0, 0.0)
    newCharge = MathUtils.Clamp(highMaxCharge, 0.001 + 1.0, newCharge + 1.0)

    if playerOwner and (modifier_drFetus or modifier_epicFetus) and playerOwner.m_heldEntity.ref ~= nil then
        local requiredCharge = 1.0
        if hasChargedAttack then
            requiredCharge = math.max(highMaxCharge - 30.0, 2.0)
        end

        ---@BUG: This may entirely prevent the synergy from being triggered
        ---based on the player's maxFireDelay
        if weapon.m_charge == requiredCharge then
            if not modifier_epicFetus then
                local bomb = IWeapon.FireBomb(weapon, ctx, playerOwner.m_position, VECTOR_ZERO)
                IEntityPtr.SetReference(playerOwner.m_heldEntity, bomb)
                bomb.m_flags = bomb.m_flags | (EntityFlag.FLAG_HELD | EntityFlag.FLAG_PERSISTENT)
                bomb.m_explosionCountdown1 = 45
                bomb.m_explosionCountdown2 = 45
                bomb.m_entityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                bomb.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                bomb.m_visible = false
                bomb.m_rocketAngle = facingDirection:GetAngleDegrees()

                if IEntityBomb.IsRocket(bomb) then
                    bomb.m_sprite:Play("Idle", false)
                    bomb.m_sprite.Rotation = 0.0
                end
            else
                local rocket = IGame.Spawn(
                    ctx, ctx.game,
                    EntityType.ENTITY_EFFECT, EffectVariant.SMALL_ROCKET,
                    playerOwner.m_position, VECTOR_ZERO, weapon.m_owner,
                    0, IsaacUtils.Random()
                )

                IEntityPtr.SetReference(playerOwner.m_heldEntity, rocket)
                rocket.m_flags = rocket.m_flags | EntityFlag.FLAG_PERSISTENT
                rocket.m_visible = false
            end

            IManager.PlaySound(ctx, SOUND_HOLD_BOMB, 1.0, 2, false, 1.0)
        end
    end

    local heldEntity = playerOwner and playerOwner.m_heldEntity.ref
    if heldEntity then
        heldEntity.m_position = VectorUtils.Copy(playerOwner.m_position)
        heldEntity.m_velocity = VectorUtils.Copy(playerOwner.m_velocity)

        local headDirection = playerOwner.m_headDirection
        local xOffset = (headDirection % 2 == 0) and 8.0 or 12.0
        local reverse = headDirection == Direction.UP or headDirection == Direction.RIGHT

        if reverse then
            local playerScale = playerOwner.m_sprite.Scale
            heldEntity.m_positionOffset = playerOwner.m_sprite.Scale * Vector(-xOffset, -4.0)
            heldEntity.m_renderZOffset = -1
        else
            local playerScale = playerOwner.m_sprite.Scale
            heldEntity.m_positionOffset = playerOwner.m_sprite.Scale * Vector(xOffset, -4.0)
            heldEntity.m_renderZOffset = 0
        end

        if heldEntity.m_type == EntityType.ENTITY_BOMB then
            ---@cast heldEntity Component.Entity.Bomb
            heldEntity.m_rocketAngle = facingDirection:GetAngleDegrees()
        end
    end

    if modifier_cursedEye then
        if weapon.m_charge >= highMaxCharge then
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_CURSED_EYE, ItemAnim.CHARGE_FULL, facingDirection, -1.0)
            chargeColor.A = 1.0
            chargeColor:SetOffset(0.2, 0.2, 0.2)
            ColorUtils.MultiplyCompound(chargeColor, mainKnife.m_color)
        else
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_CURSED_EYE, ItemAnim.CHARGE, facingDirection, 0.0)
        end

        IWeapon.SetBlinkTime(weapon, 1)

        local numCursedEyeShots = math.floor((newCharge * 5.0) / highMaxCharge)
        if newCharge > 1.0 and numCursedEyeShots == 0 then
            numCursedEyeShots = 1
        end
        weapon.m_field_0x58 = numCursedEyeShots
    end

    if modifier_chocolateMilk then
        local frame = weapon.m_charge < highMaxCharge
            and (weapon.m_charge / highMaxCharge) * 18.0
            or -1.0

        local animation = weapon.m_charge < highMaxCharge
            and ItemAnim.CHARGE
            or ItemAnim.CHARGE_FULL

        IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK, animation, facingDirection, frame)
        IWeapon.SetBlinkTime(weapon, 1)

        local chocoScale = (newCharge / maxFireDelay - 1.0) * 0.5 + 1.0
        chocoScale = math.max(chocoScale, 1.0)
        chocoScale = chocoScale * weaponScale
        if mainKnife.m_isSwinging then
            chocoScale = math.max(mainKnife.m_sprite.Scale.X, chocoScale)
        end

        for i = 1, 4, 1 do
            local knife = weapon.m_knives[i].ref
            if knife then
                knife.m_sprite.Scale = VECTOR_ONE * chocoScale
            end
        end
    end

    if modifier_brimstone then
        if not weapon.m_charge < maxCharge then
            local frame = (weapon.m_charge / maxCharge) * 18.0
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_BRIMSTONE, ItemAnim.CHARGE, facingDirection, frame)
        else
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_BRIMSTONE, ItemAnim.CHARGE_FULL, facingDirection, -1.0)
            chargeColor = COLOR_RED
            if myPlayer then
                chargeColor = ColorUtils.Multiply(myPlayer.m_laserColor, chargeColor)
            end

            if IEntity.IsTimeScaledFrame(mainKnife, ctx, 2.0, 0.0) ~= 0 then -- spawn bubble
                local tipHelper = SpriteUtils.GetNullFrameById(mainKnife.m_sprite, NULL_LAYER_TIP)
                if tipHelper then
                    local tipOffset = IsaacUtils.ScreenToWorldDistance(tipHelper:GetPos())
                    tipOffset = tipOffset:Rotated(mainKnife.m_rotation) * 1.2
                    local tipDirection = tipOffset:Rotated(90.0):Normalized()

                    local scaleFactor = IsaacUtils.RandomFloat()
                    local spreadFactor = IsaacUtils.RandomFloat()
                    local bubblePosition = (spreadFactor * tipDirection * scaleFactor * mainKnife.m_sprite.Scale.Y * 10.0 + scaleFactor * tipOffset) + mainKnife.m_position

                    local randomVectorMagnitude = IsaacUtils.RandomFloat()
                    local myVelocity = weapon.m_owner
                        and weapon.m_owner.m_velocity
                        or VECTOR_ZERO

                    local bubbleSeed = IsaacUtils.Random()
                    local randomVelocity = (IsaacUtils.RandomVector() * randomVectorMagnitude) * 2
                    local bubbleVelocity = (randomVelocity + myVelocity * 0.2) + Vector(0.0, -1.0)

                    local bubble = IGame.Spawn(
                        ctx, ctx.game,
                        EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL,
                        bubblePosition, bubbleVelocity, nil,
                        0, bubbleSeed
                    )

                    if myPlayer then
                        bubble:SetColor(ctx, myPlayer.m_laserColor, -1, -1, false, true)
                    end

                    local sizeFactor = IsaacUtils.RandomFloat() * 0.3 + 0.3
                    bubble.m_sprite.Scale = mainKnife.m_sprite.Scale * sizeFactor
                    bubble.m_positionOffset = VectorUtils.Copy(mainKnife.m_positionOffset)
                    bubble.m_depthOffset = -100.0
                end
            end

            IWeapon.SetBlinkTime(weapon, 1)
        end
    end

    local defaultMaxChargeColor = not modifier_cursedEye
        and not modifier_chocolateMilk
        and not modifier_brimstone
    if defaultMaxChargeColor and weapon.m_charge >= highMaxCharge then
        chargeColor.A = 1.0
        chargeColor:SetOffset(0.2, 0.2, 0.2)
        ColorUtils.MultiplyCompound(chargeColor, mainKnife.m_color)
    end

    if modifier_monstrosLung then
        if weapon.m_charge >= maxCharge then
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_MONSTROS_LUNG, ItemAnim.CHARGE_FULL, facingDirection, -1.0)
            chargeColor.A = 1.0
            chargeColor:SetOffset(0.2, 0.2, 0.2)
            ColorUtils.MultiplyCompound(chargeColor, mainKnife.m_color)
        else
            local frame = (weapon.m_charge / maxCharge) * 18.0
            IWeapon.PlayItemAnim(weapon, ctx, CollectibleType.COLLECTIBLE_MONSTROS_LUNG, ItemAnim.CHARGE, facingDirection, frame)
        end

        IWeapon.SetBlinkTime(weapon, 1)
    end

    if modifier_cSection then
        if weapon.m_charge >= maxCharge then
            IWeapon.PlayItemBodySubAnim(weapon, ctx, CollectibleType.COLLECTIBLE_C_SECTION, ItemAnim.CHARGE_FULL, facingDirection, -1.0)
        elseif IWeapon.IsItemBodySubAnimFinished(weapon, ctx, CollectibleType.COLLECTIBLE_C_SECTION) then
            local frame = (weapon.m_charge / maxCharge) * 18.0
            IWeapon.PlayItemBodySubAnim(weapon, ctx, CollectibleType.COLLECTIBLE_C_SECTION, ItemAnim.CHARGE, facingDirection, frame)
        end

        IWeapon.SetBlinkTime(weapon, 1)
    end

    if IEntity.IsTimeScaledFrame(mainKnife, ctx, 4.0, 0.0) ~= 0 and chargeColor.A > 0.0 then
        mainKnife:SetColor(ctx, chargeColor, 8, 1, true, true)
    end

    weapon.m_bufferDirection = IWeapon.GetLastBufferedDirection(weapon, ctx, facingDirection)

    if mainKnife.m_isFlying then
        IWeapon.SetHeadDirection(weapon, 2)
    end

    weapon.m_charge = newCharge
end

---@class Weapon.Bone.Fire
local Module = {}

--#region Module

Module.Fire = Module.Fire

--#endregion

return Module