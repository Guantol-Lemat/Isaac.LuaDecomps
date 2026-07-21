--#region Dependencies

local TableUtils = require("General.Table")
local RNGUtils = require("General.RNG")
local IBossPool = require("Isaac.Interface.BossPool")
local IModManager = require("Isaac.Interface.ModManager")

--#endregion

---@param bossPool Component.BossPool
---@param ctx Context.Common
---@param seed integer
local function Init(bossPool, ctx, seed)
    local rng = RNG(seed, 26)

    local numPools = 37
    local pools = bossPool.m_pools
    for i = 1, numPools, 1 do
        local pool = pools[i]
        pool.m_rng = RNG(rng:Next(), 17)
    end

    local numBosses = 104
    local BOOL_CONSTRUCTOR = function() return false end
    TableUtils.Vector_Resize(bossPool.m_removedBosses, numBosses, BOOL_CONSTRUCTOR)
    TableUtils.Vector_Resize(bossPool.m_levelBlacklist, numBosses, BOOL_CONSTRUCTOR)

    for i = 1, numBosses, 1 do
        bossPool.m_removedBosses[i] = false
        bossPool.m_levelBlacklist[i] = false
    end

    IBossPool.LoadPools(bossPool, ctx, "bosspools.xml", nil)
    IModManager.UpdateBossPools(ctx.manager.m_modManager, ctx)

    for i = 1, numPools, 1 do
        local pool = pools[i]
        local shuffleRng = RNGUtils.MTRNG_New(pool.m_rng:GetSeed())
        RNGUtils.MTRNG_RandomShuffle(pool.m_bosses, shuffleRng)
    end
end

---@class Gameplay.BossPool.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module