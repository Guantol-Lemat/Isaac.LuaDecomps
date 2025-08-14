---@class CircleComponent
local Module = {}

---@class Circle
---@field center Vector
---@field radius number

---@param center Vector
---@param radius number
---@return Circle
local function Create(center, radius)
    ---@type Circle
    local circle = {
        center = Vector(center.X, center.Y),
        radius = radius
    }
    return circle
end

--#region Module

Module.Create = Create

--#endregion

return Module