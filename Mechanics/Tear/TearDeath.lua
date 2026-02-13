--#region Dependencies

local SpawnLogic = require("Game.Spawn")
local IsaacUtils = require("Isaac.Utils")
local EntityUtils = require("Entity.Utils")
local VectorUtils = require("General.Math.VectorUtils")

--#endregion

---@class TearDeathLogic
local Module = {}

---@alias TearDeathLogic._SWITCH_TearSplash fun(tear: EntityTearComponent, returns: TearDeathLogic._SWITCH_TearSplashReturns)

---@class TearDeathLogic._SWITCH_TearSplashReturns
---@field splashEffect EffectVariant | integer
---@field splashSubtype integer
---@field splashSound SoundEffect | integer
---@field volume number

---@type TearDeathLogic._SWITCH_TearSplash
local function default_tear_splash() end

---@type TearDeathLogic._SWITCH_TearSplash
local function regular_tear_splash(tear, returns)
    local scale = tear.m_fScale

    if scale < 0.4 then
        returns.splashSound = SoundEffect.SOUND_SPLATTER
        returns.splashEffect = EffectVariant.TEAR_POOF_VERYSMALL
        returns.volume = 0.7
        return
    end

    if scale < 0.8 then
        returns.splashSound = SoundEffect.SOUND_SPLATTER
        returns.splashEffect = EffectVariant.TEAR_POOF_SMALL
        returns.volume = 0.85
        return
    end

    if tear.m_height <= -5.0 then
        returns.splashSound = SoundEffect.SOUND_TEARIMPACTS
        returns.splashEffect = EffectVariant.TEAR_POOF_A
        return
    end

    returns.splashSound = SoundEffect.SOUND_SPLATTER
    returns.splashEffect = EffectVariant.TEAR_POOF_B
end

-- TODO: Other tear splashes
local switch_TearSplash = {
    [TearVariant.BLUE] = regular_tear_splash,
    [TearVariant.METALLIC] = regular_tear_splash,
    [TearVariant.FIRE_MIND] = regular_tear_splash,
    [TearVariant.DARK_MATTER] = regular_tear_splash,
    [TearVariant.MYSTERIOUS] = regular_tear_splash,
    [TearVariant.LOST_CONTACT] = regular_tear_splash,
    [TearVariant.CUPID_BLUE] = regular_tear_splash,
    [TearVariant.PUPULA] = regular_tear_splash,
    [TearVariant.GODS_FLESH] = regular_tear_splash,
    [TearVariant.EXPLOSIVO] = regular_tear_splash,
    [TearVariant.MULTIDIMENSIONAL] = regular_tear_splash,
    [TearVariant.GLAUCOMA] = regular_tear_splash,
    [TearVariant.BOOGER] = regular_tear_splash,
    [TearVariant.EGG] = regular_tear_splash,
    [TearVariant.NEEDLE] = regular_tear_splash,
    [TearVariant.HUNGRY] = regular_tear_splash,
    [TearVariant.ICE] = regular_tear_splash,
    [TearVariant.ERASER] = regular_tear_splash,
    [TearVariant.SPORE] = regular_tear_splash,
    default = default_tear_splash,
}

---@param context TearMechanicsContext.TriggerDeath
---@param tear EntityTearComponent
---@param splashEffect EffectVariant
---@param splashSubtype integer
---@param splashScale number
local function do_splash_effect(context, tear, splashEffect, splashSubtype, splashScale)
    local position = tear.m_position
    local seed = IsaacUtils.Random()

    local splashEnt = SpawnLogic.Spawn(context, EntityType.ENTITY_EFFECT, splashEffect, splashSubtype, seed, position, Vector(0, 0), nil)
    local splash = EntityUtils.ToEffect(splashEnt)
    assert(splash, "Effect is not an EntityEffect.")

    VectorUtils.Assign(splash.m_positionOffset, tear.m_positionOffset)
    ---@type TearVariant
    local tearVariant = tear.m_variant
    local sprite = splash.m_sprite

    if splashEffect ~= EffectVariant.BOMB_EXPLOSION and splashEffect ~= EffectVariant.TEAR_POOF_SMALL and splashEffect ~= EffectVariant.TEAR_POOF_VERYSMALL then
        local scaleMulti
        if splashEffect == EffectVariant.CROSS_POOF then
            splash.m_positionOffset.Y = 0.0
            scaleMulti = (tear.m_size + 8.0) / 28.0
        elseif splashEffect == EffectVariant.SCYTHE_BREAK or (tearVariant == TearVariant.PUPULA_BLOOD or tearVariant == TearVariant.PUPULA) then
            scaleMulti = tear.m_fScale * 0.4
        else
            scaleMulti = tear.m_fScale * 0.8
        end

        sprite.Scale = Vector(1, 1) * scaleMulti
        sprite.Rotation = IsaacUtils.RandomInt(4) * 90.0
    end

    if splashScale ~= 1.0 then
        sprite.Scale = sprite.Scale * splashScale
    end

    -- TODO: Variant based color set
end

---@param context TearMechanicsContext.TriggerDeath
---@param tear EntityTearComponent
---@return boolean shouldExit
local function TriggerDeath(context, tear)
    ---@type TearVariant
    local variant = tear.m_variant

    if variant == TearVariant.GRIDENT then
        -- TODO: grid entity death
        return true
    end

    local tearFlags = tear.m_tearFlags
    local hydrobounce = (tearFlags & TearFlags.TEAR_HYDROBOUNCE) ~= 0

    if hydrobounce and tear.m_deathRelatedFlags == 0x4 then
        -- TODO: revive and bounce
    end

    local position = tear.m_position

    local splashEffect = EffectVariant.EFFECT_NULL
    local splashSubtype
    local splashSound = SoundEffect.SOUND_NULL
    local volume = 1.0

    ---@type TearDeathLogic._SWITCH_TearSplashReturns
    local returns = {
        splashEffect = splashEffect,
        splashSubtype = splashSubtype,
        splashSound = splashSound,
        volume = volume
    }

    local switch = switch_TearSplash[variant] or switch_TearSplash.default
    switch(tear, returns)

    splashEffect = returns.splashEffect
    splashSubtype = returns.splashSubtype
    splashSound = returns.splashSound
    volume = returns.volume
    local splashScale = 1.0

    -- TODO: Rest of Death

    if splashEffect ~= EffectVariant.EFFECT_NULL then
        do_splash_effect(context, tear, splashEffect, splashSubtype, splashScale)
    end

    -- TODO: Rest of Death
end

--#region Module

Module.TriggerDeath = TriggerDeath

--#endregion

return Module