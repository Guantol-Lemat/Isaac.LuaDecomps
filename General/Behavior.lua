--#region Dependencies



--#endregion

---@param functions function[]
---@param ... unknown
local function first_of(functions, ...)
    for i = 1, #functions, 1 do
        if functions[i](...) then
            return
        end
    end
end

---@class Behavior
local Module = {}

--#region Module

Module.first_of = first_of

--#endregion

return Module