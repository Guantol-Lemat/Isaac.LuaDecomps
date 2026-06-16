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

--#region Module

Module.Add = Add

--#endregion

return Module