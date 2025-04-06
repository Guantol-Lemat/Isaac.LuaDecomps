---@class Decomp.Class.BossPool
local Class_BossPool = {}
Decomp.Class.BossPool = Class_BossPool

---@class Decomp.Pools.BossPooL.Pool
Class_BossPool.Pool = {}

---@class Decomp.Pools.BossPool.Boss
Class_BossPool.Boss = {}

---@class Decomp.Pools.BossPool.GameState
Class_BossPool.GameState = {}

require("General.ModManager")
require("Data.XmlData")
require("Pools.BossPool.BossSelection")

local Class = Decomp.Class
local XmlData = Decomp.Data.XmlData
local BossPoolXml = Decomp.Data.BossPoolXml
local BossSelection = Decomp.Pools.BossPool.BossSelection

---@class Decomp.Class.BossPool.Data
---@field m_Pools Decomp.Pools.BossPool.Pool.Data[]
---@field m_RemovedBosses boolean[]
---@field m_LevelBlacklist boolean[]

---@class Decomp.Pools.BossPool.Pool.Data
---@field m_Name string
---@field m_Bosses Decomp.Pools.BossPool.Boss.Data[]
---@field m_TotalWeight number
---@field m_RNG RNG
---@field m_DoubleTrouble integer

---@class Decomp.Pools.BossPool.Boss.Data
---@field m_BossId BossType | integer
---@field m_InitialWeight number
---@field m_Weight number
---@field m_Achievement Achievement | integer
---@field m_Room integer

---@class Decomp.Pools.BossPool.GameState.Data
---@field m_PoolSeeds integer[]
---@field m_RemovedBosses boolean[]

---@return Decomp.Class.BossPool.Data
function Class_BossPool.new()
    ---@type Decomp.Class.BossPool.Data
    local bossPool = {
        m_Pools = {},
        m_RemovedBosses = {},
        m_LevelBlacklist = {},
    }

    for i = 1, 37, 1 do
        bossPool.m_Pools[i] = Class_BossPool.Pool.new()
    end

    return bossPool
end

---@return Decomp.Pools.BossPool.Pool.Data
function Class_BossPool.Pool.new()
    ---@type Decomp.Pools.BossPool.Pool.Data
    local pool = {
        m_Name = "",
        m_Bosses = {},
        m_TotalWeight = 0.0,
        m_RNG = RNG(),
        m_DoubleTrouble = 0,
    }

    return pool
end

---@return Decomp.Pools.BossPool.Boss.Data
function Class_BossPool.Boss.new()
    ---@type Decomp.Pools.BossPool.Boss.Data
    local boss = {
        m_BossId = 0,
        m_InitialWeight = 0.0,
        m_Weight = 0.0,
        m_Achievement = 0,
        m_Room = 0,
    }

    return boss
end

function Class_BossPool.GameState.new()
    ---@type Decomp.Pools.BossPool.GameState.Data
    local gameState = {
        m_PoolSeeds = {},
        m_RemovedBosses = {},
    }

    for i = 1, 37, 1 do
        gameState.m_PoolSeeds[i] = 0
    end
end

local m_BossPoolData = Class_BossPool.new()

---@param modEntry Decomp.ModManager.ModEntry
local function load_mod_xml(modEntry)
    if not modEntry.__data.m_Loaded then
        return
    end

    local filePath = modEntry:GetContentPath("bosspools.xml")
    local xmlData = XmlData.GetXmlData(filePath)
    if not xmlData then
        return
    end

    Class_BossPool.LoadPools(filePath, modEntry)
end

local function load_xml()
    Class_BossPool.LoadPools("bosspools.xml", nil)

    for index, modEntry in ipairs(Class.ModManager.GetModEntries()) do
        load_mod_xml(modEntry)
    end
end

---@param pool Decomp.Pools.BossPool.Pool.Data
local function shuffle_pool(pool)
    local rng = RNG(pool.m_RNG:GetSeed())

    for i = #pool.m_Bosses, 1, -1 do
        local randomIndex = rng:RandomInt(i) + 1
        local temp = pool.m_Bosses[i]
        pool.m_Bosses[i] = pool.m_Bosses[randomIndex]
        pool.m_Bosses[randomIndex] = temp
    end
end

---@param seed integer
function Class_BossPool.Init(seed)
    local rng = RNG(); rng:SetSeed(seed, 26)

    for index, pool in ipairs(m_BossPoolData.m_Pools) do
        pool.m_RNG:SetSeed(rng:Next(), 17)
    end

    for i = 1, 104, 1 do
        m_BossPoolData.m_RemovedBosses[i] = false
        m_BossPoolData.m_LevelBlacklist[i] = false
    end

    load_xml()

    for index, pool in ipairs(m_BossPoolData.m_Pools) do
        shuffle_pool(pool)
    end
end

---@param filePath string
---@param modEntry Decomp.ModManager.ModEntry?
function Class_BossPool.LoadPools(filePath, modEntry)
    BossPoolXml.LoadPools(m_BossPoolData, filePath, modEntry)
end

function Class_BossPool.CommitLevelBlacklist()
    for i = 1, #m_BossPoolData.m_RemovedBosses, 1 do
        if (m_BossPoolData.m_RemovedBosses[i] or m_BossPoolData.m_LevelBlacklist[i]) then
            m_BossPoolData.m_RemovedBosses[i] = true
        end
    end

    for i = 1, #m_BossPoolData.m_LevelBlacklist, 1 do
        m_BossPoolData.m_LevelBlacklist[i] = false
    end
end

---@param boss BossType
function Class_BossPool.WasBossRemoved(boss)
    return m_BossPoolData.m_RemovedBosses[boss] == true or m_BossPoolData.m_LevelBlacklist[boss] == true
end

---@param pool Decomp.Pools.BossPool.Pool.Data
---@param targetWeight number
---@return Decomp.Pools.BossPool.Boss.Data? boss
function Class_BossPool.PickBoss(pool, targetWeight)
    return BossSelection.PickBoss(m_BossPoolData, pool, targetWeight)
end

---@param stage LevelStage
---@param stageType StageType
---@param rng RNG?
---@return BossType boss
function Class_BossPool.GetBossId(stage, stageType, rng)
    return BossSelection.GetBossId(m_BossPoolData, stage, stageType, rng)
end

---@param gameState Decomp.Pools.BossPool.GameState.Data
function Class_BossPool.StoreGameState(gameState)
    for i = 1, 37, 1 do
        gameState.m_PoolSeeds[i] = m_BossPoolData.m_Pools[i].m_RNG:GetSeed()
    end

    gameState.m_RemovedBosses = {}
    for i = 1, 104, 1 do
        gameState.m_RemovedBosses[i] = m_BossPoolData.m_RemovedBosses[i]
    end
end

---@param gameState Decomp.Pools.BossPool.GameState.Data
function Class_BossPool.RestoreGameState(gameState)
    for index, pool in ipairs(m_BossPoolData.m_Pools) do
        pool.m_RNG:SetSeed(gameState.m_PoolSeeds[index], 17)
    end

    m_BossPoolData.m_RemovedBosses = {}
    m_BossPoolData.m_LevelBlacklist = {}
    for i = 1, 104, 1 do
        m_BossPoolData.m_RemovedBosses[i] = gameState.m_RemovedBosses[i]
        m_BossPoolData.m_LevelBlacklist[i] = false
    end
end