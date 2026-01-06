---@class RoomDescriptorUtils
local Module = {}

---@param desc RoomDescriptorComponent
---@param rng RNG
local function InitSeeds(desc, rng)
    desc.m_decorationSeed = rng:Next()
    desc.m_spawnSeed = rng:Next()
    desc.m_awardSeed = rng:Next()

    local bossRNG = RNG(rng:GetSeed(), 66)
    desc.m_bossDeathEffectSeed = bossRNG:Next()
end

--#region Module

Module.InitSeeds = InitSeeds

--#endregion

return Module