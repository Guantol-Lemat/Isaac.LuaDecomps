--#region Dependencies

local EngineGlobal = require("Engine.Global")
local MyGlobal = require("Isaac.Gameplay.ItemPool.Global")
local IFileManager = require("Engine.Interface.FileManager")
local IItemConfig = require("Isaac.Interface.ItemConfig")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local Xml = require("Engine.Lib.XML")
local Log = require("General.Log")

--#endregion

---@class Xml.ItemPools.Document : Lib.XML.Document
---@field ItemPools Xml.ItemPools.Node.Root

---@class Xml.ItemPools.Node.Root : Lib.XML.Node
---@field m_name "ItemPools"
---@field m_children Xml.ItemPools.Node.Pool[]

---@class Xml.ItemPools.Node.Pool : Lib.XML.Node
---@field m_name "Pool" -- name is expected to be Pool but is not enforced after first
---@field m_attributes Xml.ItemPools.Node.Pool.Attributes
---@field m_children Xml.ItemPools.Node.PoolItem[]

---@class Xml.ItemPools.Node.Pool.Attributes
---@field Name string

---@class Xml.ItemPools.Node.PoolItem : Lib.XML.Node
---@field m_name "Item" -- name is expected to be Item but is not enforced after first
---@field m_attributes Xml.ItemPools.Node.PoolItem.Attributes

---@class Xml.ItemPools.Node.PoolItem.Attributes
---@field Id string
---@field Weight string
---@field DecreaseBy string
---@field RemoveOn string
---@field Name string

local POOL_NAMES_TO_ID = {}
for i = 1, #MyGlobal.ItemPoolNames, 1 do
    POOL_NAMES_TO_ID[MyGlobal.ItemPoolNames[i]] = i - 1
end

---@param poolItem_node Xml.ItemPools.Node.PoolItem
---@param ctx Context.Manager
---@return Component.ItemPool.PoolItem
local function parse_pool_item(poolItem_node, ctx)
    ---@type Component.ItemPool.PoolItem
    local poolItem = {
        m_itemID = 0,
        m_initialWeight = 1.0,
        m_weight = 1.0,
        m_decreaseBy = 0.5,
        m_removeOn = 0.1,
        m_isUnlocked = false,
        m_isSpecial = false,
    }

    local poolItem_attrib = poolItem_node.m_attributes
    if poolItem_attrib.Id then
        poolItem.m_itemID = Xml.ToInt(poolItem_attrib.Id)
    end

    if poolItem_attrib.Weight then
        poolItem.m_initialWeight = Xml.ToFloat(poolItem_attrib.Weight)
        poolItem.m_weight = poolItem.m_initialWeight
    end

    if poolItem_attrib.DecreaseBy then
        poolItem.m_decreaseBy = Xml.ToFloat(poolItem_attrib.DecreaseBy)
    end

    if poolItem_attrib.RemoveOn then
        poolItem.m_removeOn = Xml.ToFloat(poolItem_attrib.RemoveOn)
    end

    if poolItem_attrib.Name then
        local id = IItemConfig.lua_get_item_id(ctx.manager.m_itemConfig, poolItem_attrib.Name)
        if id >= 0 then
            poolItem.m_itemID = id
        end
    end

    return poolItem
end

---@param itemPool Component.ItemPool
---@param ctx Context.Common
---@param xmlPath string
---@param isMod boolean
local function LoadPools(itemPool, ctx, xmlPath, isMod)
    local manager = ctx.manager
    local itemConfig = manager.m_itemConfig
    local persistentGameData = manager.m_persistentGameData

    if not isMod then
        -- reset pools
        for i = 1, ItemPoolType.NUM_ITEMPOOLS, 1 do
            local pool = itemPool.m_pools[i]
            local seed1 = itemPool.m_rng:Next()
            local seed2 = itemPool.m_rng:Next()

            pool.m_totalWeight = 0.0
            pool.m_itemList = {}
            pool.m_rng1 = RNG(seed1, 35)
            pool.m_rng2 = RNG(seed2, 35)
            pool.m_bibleUpgrade = 0
        end
    end

    local file = IFileManager.OpenRead(EngineGlobal.FileManager, xmlPath)
    if not file then
        return
    end

    local document = Xml.Parse(file)
    ---@cast document Xml.ItemPools.Document

    local root = document.ItemPools
    if not root then
        Log.LogMessage(3, string.format("Could not find root node 'ItemPools' in %s\n", xmlPath))
        return -- game doesn't actually return here, meaning that it will crash when attempting to look for other nodes
    end

    local nextPool = Xml.FirstNode_Name(root.m_children, "Pool")
    while nextPool do
        ---@type Xml.ItemPools.Node.Pool
        ---@diagnostic disable-next-line: assign-type-mismatch
        local pool_node = nextPool
        nextPool = Xml.NextSibling(root.m_children, nextPool) -- the next child nodes are not guaranteed to be named "Pool"

        local pool_attrib = pool_node.m_attributes
        local pool_name = pool_attrib.Name

        if not pool_name then
            goto continue
        end

        local pool_id = POOL_NAMES_TO_ID[pool_name]
        if not pool_id then
            Log.LogMessage(0, string.format("Pool %s not found, please recheck config or item pool list", pool_name))
            goto continue
        end

        local pool = itemPool.m_pools[pool_id + 1]
        local nextPoolItem = Xml.FirstNode_Name(pool_node.m_children, "Item")
        while nextPoolItem do
            ---@type Xml.ItemPools.Node.PoolItem
            ---@diagnostic disable-next-line: assign-type-mismatch
            local poolItem_node = nextPoolItem
            nextPoolItem = Xml.NextSibling(root.m_children, nextPoolItem) -- the next child nodes are not guaranteed to be named "Item"

            local poolItem = parse_pool_item(poolItem_node, ctx)
            local collectibleConfig = IItemConfig.GetCollectible(itemConfig, ctx, poolItem.m_itemID)

            if not collectibleConfig then
                poolItem.m_isUnlocked = false
                poolItem.m_isSpecial = false
            else
                poolItem.m_isSpecial = collectibleConfig.m_special
                poolItem.m_isUnlocked = IPersistentGameData.Unlocked(persistentGameData, ctx, collectibleConfig.m_achievementID)
            end

            table.insert(pool.m_itemList, poolItem)
            pool.m_totalWeight = pool.m_totalWeight + poolItem.m_weight
        end
        ::continue::
    end
end

---@class Gameplay.ItemPool.Load
local Module = {}

--#region Module

Module.LoadPools = LoadPools

--#endregion

return Module