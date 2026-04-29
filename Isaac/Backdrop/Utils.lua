--#region Dependencies



--#endregion

---@param backdrop Component.Backdrop
---@return Component.Backdrop.Entry
local function GetCurrentBackdropEntry(backdrop)
    return backdrop.m_entries[backdrop.m_type + 1]
end

---@class Module.Backdrop.Utils
local Module = {}

--#region Module

Module.GetCurrentBackdropEntry = GetCurrentBackdropEntry

--#endregion

return Module