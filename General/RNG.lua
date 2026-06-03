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

---@class Utils.RNG
local Module = {}

--#region Module

Module.RandomShuffle = RandomShuffle

--#endregion

return Module