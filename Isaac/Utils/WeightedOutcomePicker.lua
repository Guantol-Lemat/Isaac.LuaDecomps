--#region Dependencies



--#endregion

---@class Component.WeightedOutcomePicker
---@field outcomes Component.WeightedOutcomePicker.Outcome[]

---@class Component.WeightedOutcomePicker.Outcome
---@field value integer
---@field weight integer

---@return Component.WeightedOutcomePicker
local function New()
    ---@type Component.WeightedOutcomePicker
    return {
        outcomes = {}
    }
end

---@param wop Component.WeightedOutcomePicker
---@param value integer
---@param weight integer
---@param noMerge boolean
local function AddOutcomeWeight(wop, value, weight, noMerge)
end

---@param wop Component.WeightedOutcomePicker
---@param rng RNG
---@return integer
local function PickOutcome(wop, rng)
end

---@class Utils.WeightedOutcomePicker
local Module = {}

--#region Module

Module.New = New
Module.AddOutcomeWeight = AddOutcomeWeight
Module.PickOutcome = PickOutcome

--#endregion

return Module