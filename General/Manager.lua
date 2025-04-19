---@class Decomp.Class.Manager
local Manager = {}
Decomp.Class.Manager = Manager

local g_Seeds = Game():GetSeeds()
local g_SFXManager = SFXManager()

local s_FartSeedRNG = RNG(); s_FartSeedRNG:SetSeed(0x69696969, 11)

local function ProcessFartSeedSound(sound)
    if not g_Seeds:HasSeedEffect(SeedEffect.SEED_FART_SOUNDS) then
        return sound
    end

    if s_FartSeedRNG:RandomInt(20) == 0 then
        return SoundEffect.SOUND_FART_GURG
    end

    return SoundEffect.SOUND_FART
end

---@param sound SoundEffect
---@param volume number?
---@param frameDelay integer?
---@param loop boolean?
---@param pitch number?
---@param pan number?
local function PlaySound(sound, volume, frameDelay, loop, pitch, pan)
    g_SFXManager:Play(ProcessFartSeedSound(sound), volume, frameDelay, loop, pitch, pan)
end

--#region Module

---@param sound SoundEffect
---@param volume number?
---@param frameDelay integer?
---@param loop boolean?
---@param pitch number?
---@param pan number?
function Manager.PlaySound(sound, volume, frameDelay, loop, pitch, pan)
    PlaySound(sound, volume, frameDelay, loop, pitch, pan)
end

--#endregion