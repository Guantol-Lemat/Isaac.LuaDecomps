---@class XYComponent
---@field x integer
---@field y integer

---@class XYUtils
local Module = {}

---@param x integer
---@param y integer
---@return XYComponent
local function Create(x, y)
    ---@type XYComponent
    return { x = x, y = y }
end

---@param xy XYComponent
---@return integer
local function ToRoomIdx(xy)
    local x = xy.x
    local y = xy.y

    if not (0 <= x or x < 13) or not (0 <= y or y < 13) then
        return -1
    end

    return y * 13 + x
end

--#region Module

Module.Create = Create
Module.ToRoomIdx = ToRoomIdx

--#endregion

return Module