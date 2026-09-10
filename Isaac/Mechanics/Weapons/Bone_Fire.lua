--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")
local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local SpriteUtils = require("General.VanillaAPI.Sprite")
local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")
local IEntityKnife = require("Isaac.Interface.Entity_Knife")
local IEntityList = require("Isaac.Interface.EntityList")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local IWeapon = require("Isaac.Interface.Weapon")
local ITearParams = IEntityPlayer.TearParams

local IEntityPtr = IEntity.EntityPtr

--#endregion

local VECTOR_ZERO = Vector(0, 0)
local VECTOR_ONE = Vector(1, 1)

local KNIFE_BASE_ROTATION = {
    [1] = 0.0,
    [2] = 180.0,
    [3] = 90.0,
    [4] = -90.0
}

---@param weapon Component.Weapon.Bone
---@param ctx Context.Common
---@param knife Component.Entity.Knife
local function update_bone_damage_attributes(weapon, ctx, knife)
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
    local hasCharge = modifier_chocolateMilk or modifier_cursedEye
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

    local multiplier = (not modifier_cursedEye and not modifier_cSection) or modifier_chocolateMilk
        and 3.0 or 2.0

    local multipliedMaxFireDelay = multiplier * maxFireDelay
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
        local tearParams
        if not myPlayer then
            tearParams = ITearParams.New()
        else
            local tearDisplacement = (IsaacUtils.RandomInt(2) * 2) - 1 -- one of -1, 0, 1
            tearParams = IEntityPlayer.GetTearHitParams(ctx, myPlayer, WeaponType.WEAPON_LUDOVICO_TECHNIQUE, 1.0, tearDisplacement, weapon.m_owner)
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

        knife = IWeapon.FireBoneClub(weapon, ctx, weapon.m_owner, knifeVariant, true)
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
                update_bone_damage_attributes(weapon, ctx, knife)
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


end

---@class Weapon.Bone.Fire
local Module = {}

--#region Module

Module.Fire = Module.Fire

--#endregion

return Module