---@class EntityRefUtils
local Module = {}

---@param entityRef EntityRefComponent
---@return boolean
local function IsCharmed(entityRef)
    return (entityRef.flags & 1) ~= 0
end

---@param entityRef EntityRefComponent
---@return boolean
local function IsFriendly(entityRef)
    return (entityRef.flags & 2) ~= 0
end

---@param entityRef EntityRefComponent
---@return boolean
local function IsWeak(entityRef)
    return (entityRef.flags & 4) ~= 0
end

--#region Module

Module.IsCharmed = IsCharmed
Module.IsFriendly = IsFriendly
Module.IsWeak = IsWeak

--#endregion

return Module