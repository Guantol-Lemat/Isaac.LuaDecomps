--#region Dependencies

local IGame = require("Isaac.Interface.Game")

--#endregion

---@alias Component.LootList Component.LootList.Entry[]

---@class Component.LootList.Entry
---@field type integer
---@field variant integer
---@field subtype integer
---@field seed integer
---@field rng RNG?

---@class Utils.LootList
local Module = {}

---@param lootList Component.LootList
---@param entryType integer
---@param variant integer
---@param subtype integer
---@param seed integer
---@param rng RNG?
local function Add(lootList, entryType, variant, subtype, seed, rng)
    ---@type Component.LootList.Entry
    local entry = {
        type = entryType,
        variant = variant,
        subtype = subtype,
        seed = seed,
        rng = rng
    }

    table.insert(lootList, entry)
end

---@param entry Component.LootList.Entry
---@param ctx Context.Common
---@param position Vector
---@param velocity Vector
---@param spawner Component.Entity?
---@return Component.Entity
local function Spawn(entry, ctx, position, velocity, spawner)
    local seed = entry.rng and entry.rng:Next() or entry.seed
    IGame.Spawn(
        ctx, ctx.game,
        entry.type, entry.variant,
        position, velocity, spawner,
        entry.subtype, seed
    )
end

--#region Module

Module.Add = Add
Module.Spawn = Spawn

--#endregion

return Module