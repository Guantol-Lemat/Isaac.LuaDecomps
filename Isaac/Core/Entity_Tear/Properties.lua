--#region Dependencies



--#endregion

local BLOOD_TEAR_VARIANT = {
    [TearVariant.BLUE] = TearVariant.BLOOD,
    [TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
    [TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
    [TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
    [TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
    [TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
    [TearVariant.EYE] = TearVariant.EYE_BLOOD
}

---@param variant TearVariant | integer
---@return TearVariant | integer
local function GetBloodTearVariant(variant)
    return BLOOD_TEAR_VARIANT[variant] or variant
end

---@class Tear.Properties
local Module = {}

--#region Module

Module.GetBloodTearVariant = GetBloodTearVariant

--#endregion

return Module