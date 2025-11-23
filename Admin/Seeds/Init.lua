--#region Dependencies

local Random = require("General.Random")

--#endregion

---@class SeedsInit
local Module = {}

---@param seeds SeedsComponent
---@param startSeed integer
local function SetStartSeed(seeds, startSeed)
    if startSeed == 0 then
        startSeed = Random.RandomInt()
        startSeed = math.max(startSeed, 1)
    end

    seeds.m_startSeed = startSeed
    local rng = RNG(startSeed, 27)

    local stageSeeds = seeds.m_stageSeeds
    for i = 1, LevelStage.NUM_STAGES, 1 do
        stageSeeds[i] = rng:Next()
    end

    seeds.m_playerSeed = rng:Next()
end

---@param seeds SeedsComponent
---@param stage LevelStage
local function ForgetStageSeed(seeds, stage)
    local stageSeeds = seeds.m_stageSeeds

    local rng = RNG(stageSeeds[stage + 1], 39)
    stageSeeds[stage + 1] = rng:Next()
end

--#region Module

Module.SetStartSeed = SetStartSeed
Module.ForgetStageSeed = ForgetStageSeed

--#endregion

return Module