---@class CircleUtils
local Module = {}

---@param circle Circle
---@param other Circle
---@return boolean collided
---@return number distance
local function Collide(circle, other)
    local distance = (other.center - circle.center):Length()
    return distance < (circle.radius + circle.radius), distance
end

--#region Module

Module.Collide = Collide

--#endregion

return Module