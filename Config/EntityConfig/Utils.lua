--#region Dependencies



--#endregion

---@class EntityConfigUtils
local Module = {}

---@param type integer
---@param variant integer?
---@param subtype integer?
local function GetHash(type, variant, subtype)
    variant = variant or 0
    subtype = subtype or 0
    return type << 12 | variant << 8 | subtype
end

--#region Module

Module.GetHash = GetHash

--#endregion

return Module