--#region Dependencies



--#endregion

---@class RNGUtils
local Module = {}

---@generic T
---@param tbl T[]
---@param rng RNG
local function Shuffle(tbl, rng)
    for i = #tbl, 1, -1 do
        local swapIdx = rng:RandomInt(i) + 1
        if i ~= swapIdx then
            local temp = tbl[swapIdx]
            tbl[swapIdx] = tbl[i]
            tbl[i] = temp
        end
    end
end

--#region Module

Module.Shuffle = Shuffle

--#endregion

return Module