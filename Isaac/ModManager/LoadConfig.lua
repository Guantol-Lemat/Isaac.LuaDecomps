--#region Dependencies

local EngineGlobal = require("Engine.Global")
local IFileManager = require("Engine.Interface.FileManager")
local IItemPool = require("Isaac.Interface.ItemPool")
local IBossPool = require("Isaac.Interface.BossPool")
local IModManager = require("Isaac.Interface.ModManager")

--#endregion

local IModEntry = IModManager.ModEntry

---@param modManager Component.ModManager
---@param ctx Context.Common
local function UpdatePools(modManager, ctx)
    local itemPool = ctx.game.m_itemPool
    local basePath = "itempools.xml"

    local modEntries = modManager.m_modEntries
    for i = 1, modEntries, 1 do
        local mod = modEntries[i]
        if not mod.m_loaded then
            goto continue
        end

        local contentPath = IModEntry.GetContentPath(mod, basePath)
        if not IFileManager.Exists(EngineGlobal.FileManager, contentPath) then
            goto continue
        end

        IItemPool.load_pools(itemPool, ctx, contentPath, true)
        ::continue::
    end
end

---@param modManager Component.ModManager
---@param ctx Context.Common
local function UpdateBossPools(modManager, ctx)
    local bossPool = ctx.game.m_bossPool
    local basePath = "bosspools.xml"

    local modEntries = modManager.m_modEntries
    for i = 1, modEntries, 1 do
        local mod = modEntries[i]
        if not mod.m_loaded then
            goto continue
        end

        local contentPath = IModEntry.GetContentPath(mod, basePath)
        if not IFileManager.Exists(EngineGlobal.FileManager, contentPath) then
            goto continue
        end

        IBossPool.LoadPools(bossPool, ctx, contentPath, mod)
        ::continue::
    end
end

---@class ModManager.LoadConfig
local Module = {}

--#region Module

Module.UpdatePools = UpdatePools
Module.UpdateBossPools = UpdateBossPools

--#endregion

return Module