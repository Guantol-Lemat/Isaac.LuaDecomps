--#region Dependencies



--#endregion

---@class Component.Capsule
---@field center Vector : 0x0
---@field startPoint Vector : 0x8
---@field endPoint Vector : 0x10
---@field direction Vector : 0x18
---@field radius number : 0x20
---@field halfSegmentLength number : 0x24

---@param center Vector
---@param size number
---@param sizeMulti Vector
---@param rotation number
local function NewFromDimensions(center, size, sizeMulti, rotation)
    local dimensions = sizeMulti * size
    local direction = Vector.FromAngle(rotation)
    local radius
    local halfSegmentLength

    local width = dimensions.X
    local height = dimensions.Y
    local isVertical = width <= height

    if isVertical then
        radius = width
        halfSegmentLength = height - width
        direction = direction
    else
        radius = height
        halfSegmentLength = width - height
        direction = Vector(direction.Y, direction.X)
    end

    local startPoint = center - halfSegmentLength * direction
    local endPoint = center + halfSegmentLength * direction

    ---@type Component.Capsule
    return {
        center = center,
        startPoint = startPoint,
        endPoint = endPoint,
        direction = direction,
        radius = radius,
        halfSegmentLength = halfSegmentLength,
    }
end

---@param startPoint Vector
---@param endPoint Vector
---@param radius number
---@return Component.Capsule
local function NewFromEndPoints(startPoint, endPoint, radius)
    local displacement = endPoint - startPoint
    local direction = displacement:Normalized()
    local halfSegmentLength = displacement:Length() * 0.5
    local center = startPoint + (endPoint * 0.5)

    ---@type Component.Capsule
    return {
        center = center,
        startPoint = startPoint,
        endPoint = endPoint,
        direction = direction,
        radius = radius,
        halfSegmentLength = halfSegmentLength,
    }
end

---@class Utils.Capsule
local Module = {}

--#region Module

Module.NewFromDimensions = NewFromDimensions
Module.NewFromEndPoints = NewFromEndPoints

--#endregion

return Module