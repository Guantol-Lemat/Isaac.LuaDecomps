---@class Decomp.Xml.BossPool
local BossPoolXml = {}
Decomp.Data.BossPoolXml = BossPoolXml

require("Data.XmlData")
require("Pools.BossPool")

local XmlData = Decomp.Data.XmlData
local Class = Decomp.Class

---@class Decomp.Xml.BossPool.Root
---@field bosspools Decomp.Xml.BossPool.PoolNode[]?

---@alias Decomp.Xml.BossPool.PoolNode Decomp.Xml.BossPool.PoolNode.Attribute | Decomp.Xml.BossPool.BossNode[]

---@class Decomp.Xml.BossPool.PoolNode.Attribute
---@field name string 
---@field doubletrouble string

---@class Decomp.Xml.BossPool.BossNode
---@field id string
---@field weight string
---@field room string

local s_StageNameToId = {
    ["basement"] = StbType.BASEMENT,
    ["cellar"] = StbType.CELLAR,
    ["caves"] = StbType.CAVES,
    ["catacombs"] = StbType.CATACOMBS,
    ["depths"] = StbType.DEPTHS,
    ["necropolis"] = StbType.NECROPOLIS,
    ["womb"] = StbType.WOMB,
    ["utero"] = StbType.UTERO,
    ["sheol"] = StbType.SHEOL,
    ["cathedral"] = StbType.CATHEDRAL,
    ["dark room"] = StbType.DARK_ROOM,
    ["chest"] = StbType.CHEST,
    ["burning basement"] = StbType.BURNING_BASEMENT,
    ["flooded caves"] = StbType.FLOODED_CAVES,
    ["dank depths"] = StbType.DANK_DEPTHS,
    ["scarred womb"] = StbType.SCARRED_WOMB,
    ["blue womb"] = StbType.BLUE_WOMB,
    ["void"] = StbType.VOID,
    ["downpour"] = StbType.DOWNPOUR,
    ["mines"] = StbType.MINES,
    ["mausoleum"] = StbType.MAUSOLEUM,
    ["corpse"] = StbType.CORPSE,
    ["dross"] = StbType.DROSS,
    ["ashpit"] = StbType.ASHPIT,
    ["gehenna"] = StbType.GEHENNA,
    ["mortis"] = StbType.MORTIS,
}

---@param pool Decomp.Pools.BossPool.Pool.Data
---@param bossNode Decomp.Xml.BossPool.BossNode
local function parse_boss_node(pool, bossNode)
    local id = bossNode.id and tonumber(bossNode.id) or 0
    local weight = bossNode.weight and tonumber(bossNode.weight) or 0.0
    local room = bossNode.room and tonumber(bossNode.room) or 0

    local achievement = 0 -- Fetch it from BossConfig

    local poolBoss = Class.BossPool.Boss.new()
    poolBoss.m_BossId = id
    poolBoss.m_InitialWeight = weight
    poolBoss.m_Weight = weight
    poolBoss.m_Achievement = achievement
    poolBoss.m_RoomVariantStart = room

    table.insert(pool.m_Bosses, poolBoss)
    pool.m_TotalWeight = pool.m_TotalWeight + weight
end

---@param bossPool Decomp.Class.BossPool.Data
---@param poolNode Decomp.Xml.BossPool.PoolNode
local function parse_pool_node(bossPool, poolNode)
    local name = poolNode.name or ""
    local doubleTrouble = poolNode.doubletrouble and tonumber(poolNode.doubletrouble) or 0

    local stageId = s_StageNameToId[name]
    if not stageId then
        Isaac.DebugString(string.format("Boss pool: Unknown stage '%s'", name))
        return
    end

    local pool = bossPool.m_Pools[stageId + 1]
    pool.m_Name = name
    pool.m_Bosses = {}
    pool.m_TotalWeight = 0.0
    pool.m_DoubleTroubleVariantStart = doubleTrouble

    for index, bossNode in ipairs(poolNode) do
        parse_boss_node(pool, bossNode)
    end
end

---@param bossPool Decomp.Class.BossPool.Data
---@param filePath string
---@param modEntry Decomp.ModManager.ModEntry?
local function LoadPools(bossPool, filePath, modEntry)
    if modEntry then
        return
    end

    ---@type Decomp.Xml.BossPool.Root?
    local xmlData = XmlData.GetXmlData(filePath)
    if not xmlData then
        return
    end

    local root = xmlData.bosspools
    if not root then
        return
    end

    for index, poolNode in ipairs(root) do
        parse_pool_node(bossPool, poolNode)
    end
end

--#region Module

---@param bossPool Decomp.Class.BossPool.Data
---@param filePath string
---@param modEntry Decomp.ModManager.ModEntry?
function BossPoolXml.LoadPools(bossPool, filePath, modEntry) -- BossPool::LoadPools
    LoadPools(bossPool, filePath, modEntry)
end

--#endregion