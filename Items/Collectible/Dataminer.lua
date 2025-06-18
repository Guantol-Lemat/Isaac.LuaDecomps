local Dataminer = {}

local Lib = {
    RNG = require("Lib.RNG")
}

---@return number
local function get_messed_up_pitch()
    if Lib.RNG.SeedToInt(Random(), 2) == 0 then
        local random = Lib.RNG.SeedToFloatInclusive(Random())
        return random * 0.1 + 0.2
    end

    local random = Lib.RNG.SeedToFloatInclusive(Random())
    return random * 0.5 + 1.5
end

---@return number
local function get_messed_up_volume()
    if Lib.RNG.SeedToInt(Random(), 4) ~= 0 then
        return 1.0
    end

    local random = Lib.RNG.SeedToFloatInclusive(Random())
    return random * 0.7 + 0.3
end

---@param api Decomp.IGlobalAPI
---@param env Decomp.EnvironmentObject
local function MessUpMusic(api, env) -- Room::Update
    local musicManager = api.Isaac.GetMusicManager(env)

    if Lib.RNG.SeedToInt(Random(), 10) ~= 0 then
        api.MusicManager.ResetPitch(musicManager)
    end

    local pitch = get_messed_up_pitch()
    api.MusicManager.SetPitch(musicManager, pitch)

    local volume = get_messed_up_volume() * Options.MusicVolume
    api.MusicManager.SetVolume(musicManager, volume)
end

--#region Module

Dataminer.MessUpMusic = MessUpMusic

--#endregion

return Dataminer