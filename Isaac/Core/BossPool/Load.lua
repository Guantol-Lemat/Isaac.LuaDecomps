--#region Dependencies

local EngineGlobal = require("Engine.Global")
local Xml = require("Engine.Lib.XML")
local Log = require("General.Log")
local IFileManager = require("Engine.Interface.FileManager")

--#endregion

---@class Xml.BossPools.Document : Lib.XML.Document
---@field bosspools Xml.BossPools.Node.Root

---@class Xml.BossPools.Node.Root : Lib.XML.Node
---@field m_children Xml.BossPools.Node.Pool[]

---@class Xml.BossPools.Node.Pool : Lib.XML.Node
---@field m_attributes Xml.BossPools.Node.Pool.Attributes
---@field m_children Xml.BossPools.Node.Boss[]

---@class Xml.BossPools.Node.Pool.Attributes
---@field name string
---@field doubletrouble string

---@class Xml.BossPools.Node.Boss : Lib.XML.Node
---@field m_attributes Xml.BossPools.Node.Boss.Attributes

---@class Xml.BossPools.Node.Boss.Attributes
---@field id string
---@field weight string
---@field room string

local UNINITIALIZED_FLOAT = 0.0

---@type table<string, integer>
local POOL_MAP = {
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

---@param bossPool Component.BossPool
---@param ctx Context.Common
---@param filepath string
---@param mod Component.ModEntry?
local function LoadPools(bossPool, ctx, filepath, mod)
    if mod ~= nil then
        return
    end

    local bossesConfig = ctx.manager.m_entityConfig.m_bosses

    local file = IFileManager.OpenRead(EngineGlobal.FileManager, filepath)
    if not file then
        return
    end

    local document = Xml.Parse(file)
    ---@cast document Xml.BossPools.Document

    local root = document.bosspools
    if not root then
        return
    end

    local nextPool = Xml.FirstNode(root.m_children)
    while nextPool do
        ---@type Xml.BossPools.Node.Pool
        ---@diagnostic disable-next-line: assign-type-mismatch
        local pool_node = nextPool
        nextPool = Xml.NextSibling(root.m_children, nextPool)

        local attributes = pool_node.m_attributes
        local pool_name = attributes.name or ""
        local pool_doubleTrouble = attributes.doubletrouble and Xml.ToInt(attributes.doubletrouble) or 0

        local id = POOL_MAP[pool_name]
        if not id then
            Log.LogMessage(1, string.format("Boss pool: Unknown stage '%s'\n", pool_name))
            goto continue
        end

        -- init pool
        local pool = bossPool.m_pools[id + 1]
        pool.m_name = pool_name
        pool.m_doubleTroubleRoomVariantStart = pool_doubleTrouble
        pool.m_bosses = {}
        pool.m_totalWeight = 0.0

        local nextBoss = Xml.FirstNode(pool_node.m_children)
        while nextBoss do
            ---@type Xml.BossPools.Node.Boss
            ---@diagnostic disable-next-line: assign-type-mismatch
            local boss_node = nextBoss
            nextBoss = Xml.NextSibling(pool_node.m_children, nextBoss)

            local boss_attributes = boss_node.m_attributes
            local boss_id = boss_attributes.id and Xml.ToInt(boss_attributes.id) or 0
            local boss_weight = boss_attributes.weight and Xml.ToFloat(boss_attributes.weight) or UNINITIALIZED_FLOAT
            local boss_room = boss_attributes.room and Xml.ToInt(boss_attributes.room) or 0

            assert(boss_id < #bossesConfig, "BossID out of bounds\n")
            local bossConfig = bossesConfig[boss_id + 1]

            ---@type Component.BossPool.Pool.Boss
            local boss = {
                m_id = boss_id,
                m_initialWeight = boss_weight,
                m_weight = boss_weight,
                m_achievementID = bossConfig.achievement,
                m_roomVariantStart = boss_room
            }

            table.insert(pool.m_bosses, boss)
            pool.m_totalWeight = pool.m_totalWeight + boss_weight
        end
        ::continue::
    end
end

---@class Gameplay.BossPool.Load
local Module = {}

--#region Module

Module.LoadPools = LoadPools

--#endregion

return Module