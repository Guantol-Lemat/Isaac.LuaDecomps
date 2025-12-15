--#region Dependencies

local RoomUtils = require("Room.Utils")
local TearUtils = require("Entity.Tear.Utils")
local TearRules = require("Entity.Tear.Rules")

--#endregion

---@class TearDeathLogic
local Module = {}

---@alias TearDeathLogic._SWITCH_TearSplash fun(tear: EntityTearComponent, returns: TearDeathLogic._SWITCH_TearSplashReturns)

---@class TearDeathLogic._SWITCH_TearSplashReturns
---@field splashSound SoundEffect | integer
---@field splashEffect EffectVariant | integer
---@field volume number

---@type TearDeathLogic._SWITCH_TearSplash
local function regular_tear_splash(tear, returns)
    local scale = tear.m_scale

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
}

---@param tear EntityTearComponent
local function TriggerDeath(tear)
    ---@type TearVariant
    local variant = tear.m_variant

    if variant == TearVariant.GRIDENT then
        -- TODO: grid entity death
        return
    end

    local tearFlags = tear.m_tearFlags
    local hydrobounce = (tearFlags & TearFlags.TEAR_HYDROBOUNCE) ~= 0

    if hydrobounce and tear.m_unkDegrees == 0x4 then
        -- TODO: revive and bounce
    end

    local position = tear.m_position

    local splashSound = SoundEffect.SOUND_NULL
    local splashEffect = EffectVariant.EFFECT_NULL
    local volume = 1.0

    ---@type TearDeathLogic._SWITCH_TearSplashReturns
    local returns = {
        splashSound = splashSound,
        splashEffect = splashEffect,
        volume = volume
    }


end

--#region Module

Module.TriggerDeath = TriggerDeath

--#endregion

return Module