---@class Component.EntityPtr
---@field ref Component.Entity?

---@param ref Component.Entity?
---@return Component.EntityPtr
local function New(ref)
    ---@type Component.EntityPtr
    return {ref = ref}
end

---@class Module.Component.EntityPtr
local Module = {}

--#region Module

Module.New = New

--#endregion

return Module