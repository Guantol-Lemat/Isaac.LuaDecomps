--#region Dependencies



--#endregion

---@class Component.XY
---@field X integer
---@field Y integer

---@param x integer
---@param y integer
---@return Component.XY
local function New(x, y)
    ---@type Component.XY
    return { X = x, Y = y }
end

---@return Component.XY
local function NewInvalid()
    ---@type Component.XY
    return { X = -1, Y = -1 }
end

---@param xy Component.XY
---@return Component.XY
local function Copy(xy)
    ---@type Component.XY
    return { X = xy.X, Y = xy.Y}
end

---@param xy Component.XY
---@return boolean
local function IsInvalid(xy)
    return xy.X == -1 and xy.Y == -1
end

---@param xy Component.XY
---@param other Component.XY
---@return boolean
local function Equals(xy, other)
    return xy.X == other.X and xy.Y == other.Y
end

---@param xy Component.XY
---@param other Component.XY
---@return Component.XY
local function Add(xy, other)
    local x = xy.X + other.X
    local y = xy.Y + other.Y

    ---@type Component.XY
    return { X = x, Y = y }
end

---@param xy Component.XY
---@param other Component.XY
---@return integer
local function Dot(xy, other)
    return xy.X * other.X + xy.Y * other.Y
end

---@param xy Component.XY
---@param other Component.XY
---@return integer
local function ManhattanDistance(xy, other)
    return math.abs(xy.X - other.X) + math.abs(xy.Y - other.Y)
end

---@class Utils.XY
local Module = {}

--#region Module

Module.New = New
Module.NewInvalid = NewInvalid
Module.Copy = Copy
Module.IsInvalid = IsInvalid
Module.Equals = Equals
Module.Add = Add
Module.Dot = Dot
Module.ManhattanDistance = ManhattanDistance

--#endregion

return Module