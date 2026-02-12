--#region Dependencies

local IsaacSFX = require("Admin.Sound.Rules")
local VectorUtils = require("General.Math.VectorUtils")
local ColorUtils = require("General.Color")
local BlendModeUtils = require("Admin.Graphics.BlendMode")
local GameRules = require("Game.Rules")
local GameSpawn = require("Game.Spawn")
local WeaponParamsRules = require("Weapon.Common.Params.Rules")

--#endregion

---@class GFuelLogic
local Module = {}

---@alias GFuelLogic._SWITCH_WeaponTearFireFX fun(context: Context, owner: EntityPlayerComponent, baseVelocity: Vector, tearHitParams: TearHitParamsComponent)

---@type GFuelLogic._SWITCH_WeaponTearFireFX
local function gunShotSpreadFX(context)
    local sfxAdmin = context:GetSFXManager()
    local game = context:GetGame()

    IsaacSFX.Play(context, sfxAdmin, SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD, 1.0, 2, false, 1.0)
    GameRules.ShakeScreen(context, game, 16)
end

---@type GFuelLogic._SWITCH_WeaponTearFireFX
local function gunShotMiniFX(context, owner, baseVelocity)
    local sfxAdmin = context:GetSFXManager()
    local game = context:GetGame()

    IsaacSFX.Play(context, sfxAdmin, SoundEffect.SOUND_GFUEL_GUNSHOT_MINI, 1.0, 2, false, 1.0)
    GameRules.ShakeScreen(context, game, 10)

    local pushBack = -baseVelocity * 0.02
    local pushBackDirection = pushBack:Normalized()
    local ownerVelocity = owner.m_velocity
    local pushBackAlignment = math.min(pushBackDirection:Dot(ownerVelocity), 0.2)

    owner.m_velocity = ownerVelocity + pushBack * pushBackAlignment
end

---@type GFuelLogic._SWITCH_WeaponTearFireFX
local function rocketLauncherFX(context)
    local sfxAdmin = context:GetSFXManager()
    local game = context:GetGame()

    IsaacSFX.Play(context, sfxAdmin, SoundEffect.SOUND_GFUEL_ROCKETLAUNCHER, 1.0, 2, false, 1.0)
    GameRules.ShakeScreen(context, game, 10)
end

---@type GFuelLogic._SWITCH_WeaponTearFireFX
local function defaultWeaponFX(context, _, _, tearHitParams)
    local shakeDuration = 0
    local sfx = 0

    local tearScale = tearHitParams.tearScale
    if tearScale >= 1.75 then
        sfx = SoundEffect.SOUND_GFUEL_GUNSHOT_LARGE
        shakeDuration = 10
    elseif tearScale >= 0.75 then
        sfx = SoundEffect.SOUND_GFUEL_GUNSHOT
        shakeDuration = 6
    else
        sfx = SoundEffect.SOUND_GFUEL_GUNSHOT_SMALL
        shakeDuration = 3
    end

    local sfxAdmin = context:GetSFXManager()
    local game = context:GetGame()

    IsaacSFX.Play(context, sfxAdmin, sfx, 1.0, 2, false, 1.0)
    GameRules.ShakeScreen(context, game, shakeDuration)
end

local switch_WeaponTearFireFX = {
    [2] = gunShotSpreadFX,
    [3] = gunShotSpreadFX,
    [4] = gunShotMiniFX,
    [5] = rocketLauncherFX,
    default = defaultWeaponFX,
}

---@param context Context
---@param owner EntityPlayerComponent
---@param position Vector
---@param baseVelocity Vector
---@param gFuelWeapon integer
local function ApplyTearFireFX(context, owner, position, baseVelocity, gFuelWeapon)
    if gFuelWeapon == -1 then
        return
    end

    local muzzleStartVelocity = baseVelocity:Resized(4.0)
    local muzzlePosition = position + muzzleStartVelocity

    local seed = context:Random()
    local muzzleFlash = GameSpawn.Spawn(context, EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, seed, muzzlePosition, VectorUtils.VectorZero, nil)
    ---@cast muzzleFlash EntityEffectComponent
    muzzleFlash.m_timeout = 2
    muzzleFlash.m_lifeSpan = 2
    muzzleFlash.m_positionOffset = Vector(0.0, -20.0)

    local sprite = muzzleFlash.m_sprite
    sprite:Load("gfx/promo/gfuel/effects/muzzle_flash.anm2", true)
    local randomAnimation = tostring(context:RandomInt(4))
    sprite:Play(randomAnimation, true)

    local randomDisplacement = (context:RandomInt(2) * 2) - 1 -- -1 or 1
    local hitParams = WeaponParamsRules.GetTearHitParams(context, WeaponType.WEAPON_TEARS, 1.0, randomDisplacement, nil)

    sprite.Scale = VectorUtils.VectorOne * hitParams.tearScale
    local tint = KColor(1.0, 1.0, 1.0, 1.0)
    tint = ColorUtils.ApplyColorMod(tint, hitParams.tearColor)

    local color = sprite.Color
    color:Reset()
    color:SetTint(tint.Red, tint.Green, tint.Blue, tint.Alpha)

    local rotation = baseVelocity:GetAngleDegrees()

    local layer = sprite:GetLayer(0)
    -- guaranteed to exist
    ---@cast layer LayerState
    layer:SetRotation(rotation)
    local graphicsManager = context:GetGraphicsManager()
    local blendMode = BlendModeUtils.GetBlendModeAdditive(graphicsManager)
    -- layer:SetBlendMode(blendMode) -- does not exist in RGON

    muzzleFlash:Update(context)

    local casingVelocityMulti = -(context:RandomFloat() * 0.2 + 0.1)
    local randomAngle = (context:RandomFloat() * 20.0) - 10.0
    local casingVelocity = baseVelocity:Rotated(randomAngle) * casingVelocityMulti

    seed = context:Random()
    local casing = GameSpawn.Spawn(context, EntityType.ENTITY_EFFECT, EffectVariant.WOOD_PARTICLE, 0, seed, position, casingVelocity, nil)
    ---@cast casing EntityEffectComponent

    sprite = casing.m_sprite
    sprite:Load("gfx/promo/gfuel/effects/casing.anm2", true)
    sprite:Play("Gib1", true)
    sprite.PlaybackSpeed = context:RandomFloat() * 0.6 + 0.8

    casing.m_fallingSpeed = context:RandomFloat() * 16.0
    casing:Update(context)

    local fx = switch_WeaponTearFireFX[gFuelWeapon] or switch_WeaponTearFireFX.default
    fx(context, owner, baseVelocity, hitParams)
end

--#region Module

Module.ApplyTearFireFX = ApplyTearFireFX

--#endregion

return Module