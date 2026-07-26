---@class ColorModStateUtils
local Module = {}

---@param first ColorModStateComponent
---@param other ColorModStateComponent
local function Equals(first, other)
    return (first.r == other.r) and
        (first.g == other.g) and
        (first.b == other.b) and
        (first.a == other.a) and
        (first.brightness == other.brightness) and
        (first.contrast == other.contrast)
end

--#region Module

Module.Equals = Equals

--#endregion

return Module