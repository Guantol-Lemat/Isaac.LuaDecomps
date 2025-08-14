---@class Decomp.Lib.WeightedOutcomePicker
local Lib_Wop = {}
Decomp.Lib.WeightedOutcomePicker = Lib_Wop

---@param wop WeightedOutcomePicker
---@param seed integer
---@param shiftIdx integer
---@return integer outcome
function Lib_Wop.PhantomPickOutcome(wop, seed, shiftIdx)
    local rng = RNG(); rng:SetSeed(seed, shiftIdx)
    return wop:PickOutcome(rng)
end