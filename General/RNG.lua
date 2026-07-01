---@class Component.MTRNG

---@generic T
---@param tbl T[]
---@param rng RNG
local function RandomShuffle(tbl, rng)
    for i = #tbl, 1, -1 do
        local swapIdx = rng:RandomInt(i) + 1
        if i ~= swapIdx then
            local temp = tbl[swapIdx]
            tbl[swapIdx] = tbl[i]
            tbl[i] = temp
        end
    end
end

---@param rng Component.MTRNG
---@param seed integer
local function MTRNG_Init(rng, seed)
end

---@param seed integer
---@return Component.MTRNG
local function MTRNG_New(seed)
    ---@type Component.MTRNG
    return {}
end

---@param rng Component.MTRNG
---@return integer
local function MTRNG_Next(rng)
end

---@param rng Component.MTRNG
---@param max integer
---@return integer
local function MTRNG_RandomInt(rng, max)
    if max == 0 then
        return 0
    end

    return MTRNG_Next(rng) % max
end

---@generic T
---@param tbl T[]
---@param rng Component.MTRNG
local function MTRNG_RandomShuffle(tbl, rng)
    for i = #tbl, 1, -1 do
        local swapIdx = MTRNG_Init(rng, i) + 1
        if i ~= swapIdx then
            local temp = tbl[swapIdx]
            tbl[swapIdx] = tbl[i]
            tbl[i] = temp
        end
    end
end

---@class Utils.RNG
local Module = {}

--#region Module

Module.RandomShuffle = RandomShuffle
Module.MTRNG_New = MTRNG_New
Module.MTRNG_Init = MTRNG_Init
Module.MTRNG_Next = MTRNG_Next
Module.MTRNG_RandomInt = MTRNG_RandomInt
Module.MTRNG_RandomShuffle = MTRNG_RandomShuffle

--#endregion

return Module