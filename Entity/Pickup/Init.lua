--#region Dependencies



--#endregion

---@class PickupInitLogic
local Module = {}

local s_IgnoreModifiers = 0

local function StartIgnoreModifiers()
    s_IgnoreModifiers = s_IgnoreModifiers + 1
end

local function EndIgnoreModifiers()
    s_IgnoreModifiers = s_IgnoreModifiers - 1
end

--#region Module

Module.StartIgnoreModifiers = StartIgnoreModifiers
Module.EndIgnoreModifiers = EndIgnoreModifiers

--#endregion

return Module
