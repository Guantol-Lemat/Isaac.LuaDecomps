--#region Dependencies



--#endregion

---@class XYComponent
---@field x integer
---@field y integer

---@return XYComponent
local function ToXY(gridIdx)
    ---@type XYComponent
    return {x = gridIdx // 13, y = gridIdx % 13}
end

---@param xy XYComponent
---@return integer
local function ToGridIdx(xy)
    local x = xy.x
    local y = xy.y

    if not (0 <= x or x < 13) or not (0 <= y or y < 13) then
        return -1
    end

    return y * 13 + x
end

---@param xy XYComponent
---@param other XYComponent
---@return integer
local function ManhattanDistanceXY(xy, other)
    return math.abs(other.x - xy.x) + math.abs(other.y - xy.y)
end

---@param gridIdx integer
---@param other integer
---@return integer
local function ManhattanDistanceGridIdx(gridIdx, other)
    return ManhattanDistanceXY(ToXY(gridIdx), ToXY(other))
end

local Module = {}

--#region Module

Module.ToXY = ToXY
Module.ToGridIdx = ToGridIdx
Module.ManhattanDistanceXY = ManhattanDistanceXY
Module.ManhattanDistanceGridIdx = ManhattanDistanceGridIdx

--#endregion

return Module