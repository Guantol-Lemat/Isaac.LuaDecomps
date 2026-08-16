local s_ignoreModifiersStack = 0

---@return boolean
local function IgnoreModifiers()
    return s_ignoreModifiersStack == 0
end

local function BeginIgnoreModifiers()
    s_ignoreModifiersStack = s_ignoreModifiersStack + 1
end

local function EndIgnoreModifiers()
    s_ignoreModifiersStack = s_ignoreModifiersStack - 1
end

---@class Core.Pickup.Global
local Module = {}

--#region Module

Module.IgnoreModifiers = IgnoreModifiers
Module.BeginIgnoreModifiers = BeginIgnoreModifiers
Module.EndIgnoreModifiers = EndIgnoreModifiers

--#endregion

return Module