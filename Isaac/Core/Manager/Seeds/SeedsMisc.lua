--#region Dependencies

local ISeeds = require("Isaac.Interface.Seeds")
local IsaacUtils = require("Isaac.Utils.Common")
local Log = require("General.Log")

--#endregion

---@param seeds Component.Seeds
local function assert_start_seed(seeds)
    if seeds.m_startSeed == 0 then
        Log.LogMessage(Log.eLogType.ASSERT, "Error: Game Start Seed was not set.\n")
    end
end

---@param seeds Component.Seeds
---@return integer
local function GetStartSeed(seeds)
    assert_start_seed(seeds)
    return seeds.m_startSeed
end

---@param seeds Component.Seeds
---@param seed integer
local function SetStartSeed(seeds, seed)
    if seed == 0 then
        seed = math.max(IsaacUtils.Random(), 1)
    end

    seeds.m_startSeed = seed
    local myRng = RNG(seed, 27)
    seeds.m_rng = myRng

    for i = 1, #seeds.m_stageSeeds, 1 do
        seeds.m_stageSeeds[i] = myRng:Next()
    end

    seeds.m_playerSeed = myRng:Next()
end

---@param seeds Component.Seeds
---@return string
local function GetStartSeedString(seeds)
    return ISeeds.Seed2String(GetStartSeed(seeds))
end

---@param seeds Component.Seeds
---@param str string
local function SetStartSeed_String(seeds, str)
    local seed = ISeeds.String2Seed(str)
    SetStartSeed(seeds, seed)
end

---@param seeds Component.Seeds
local function ClearStartSeed(seeds)
    seeds.m_startSeed = 0
end

---@param seeds Component.Seeds
---@return integer
local function GetNextSeed(seeds)
    assert_start_seed(seeds)
    return seeds.m_rng:Next()
end

---@param seeds Component.Seeds
---@param seedEffect SeedEffect | integer
---@return boolean
local function HasSeedEffect(seeds, seedEffect)
    return seeds.m_seedEffects[seedEffect] ~= nil
end

---@param seeds Component.Seeds
---@param seedEffect SeedEffect | integer
local function AddSeedEffect(seeds, seedEffect)
    seeds.m_seedEffects[seedEffect] = true
end

---@param seeds Component.Seeds
---@param seedEffect SeedEffect | integer
local function RemoveSeedEffect(seeds, seedEffect)
    seeds.m_seedEffects[seedEffect] = nil
end

---@param seeds Component.Seeds
local function ClearSeedEffects(seeds)
    seeds.m_seedEffects = {}
end

---@param seeds Component.Seeds
---@return integer
local function CountSeedEffects(seeds)
    local count = 0
    for key, value in pairs(seeds.m_seedEffects) do
        count = count + 1
    end

    return count
end

---@class Gameplay.Seeds.Misc
local Module = {}

--#region Module

Module.GetStartSeed = GetStartSeed
Module.GetStartSeedString = GetStartSeedString
Module.SetStartSeed = SetStartSeed
Module.SetStartSeed_String = SetStartSeed_String
Module.ClearStartSeed = ClearStartSeed
Module.GetNextSeed = GetNextSeed
Module.HasSeedEffect = HasSeedEffect
Module.AddSeedEffect = AddSeedEffect
Module.RemoveSeedEffect = RemoveSeedEffect
Module.ClearSeedEffects = ClearSeedEffects
Module.CountSeedEffects = CountSeedEffects

--#endregion

return Module
