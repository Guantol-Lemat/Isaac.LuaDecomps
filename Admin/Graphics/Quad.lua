--#region Dependencies

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")

--#endregion

---@class GraphicsQuadComponent
---@field topLeft Vector
---@field topRight Vector
---@field bottomLeft Vector
---@field bottomRight Vector

---@class SourceQuadComponent : GraphicsQuadComponent
---@field coordinateSpace eCoordinateSpace

---@class DestinationQuadComponent : GraphicsQuadComponent

---@enum eCoordinateSpace
local eCoordinateSpace = {
    PIXEL_SPACE = 0,
    NORMALIZED_UV_SPACE = 1,
}

---@class GraphicsQuadModule
local Module = {}

---@param topLeft Vector
---@param topRight Vector
---@param bottomLeft Vector
---@param bottomRight Vector
---@param coordinateSpace eCoordinateSpace
---@return SourceQuadComponent
local function CreateSourceQuad(topLeft, topRight, bottomLeft, bottomRight, coordinateSpace)
    ---@type SourceQuadComponent
    return {
        topLeft = topLeft,
        topRight = topRight,
        bottomLeft = bottomLeft,
        bottomRight = bottomRight,
        coordinateSpace = coordinateSpace,
    }
end

---@param topLeft Vector
---@param topRight Vector
---@param bottomLeft Vector
---@param bottomRight Vector
---@return DestinationQuadComponent
local function CreateDestinationQuad(topLeft, topRight, bottomLeft, bottomRight)
    ---@type DestinationQuadComponent
    return {
        topLeft = topLeft,
        topRight = topRight,
        bottomLeft = bottomLeft,
        bottomRight = bottomRight,
    }
end

---@param topLeft Vector
---@param bottomRight Vector
---@return DestinationQuadComponent
local function CreateDestinationQuadAxisAligned(topLeft, bottomRight)
    ---@type DestinationQuadComponent
    return {
        topLeft = topLeft,
        topRight = Vector(bottomRight.X, topLeft.Y),
        bottomLeft = Vector(topLeft.X, bottomRight.Y),
        bottomRight = bottomRight,
    }
end

---@param quad SourceQuadComponent
---@return SourceQuadComponent
local function CopySourceQuad(quad)
    ---@type SourceQuadComponent
    return {
        topLeft = quad.topLeft,
        topRight = quad.topRight,
        bottomLeft = quad.bottomLeft,
        bottomRight = quad.bottomRight,
        coordinateSpace = quad.coordinateSpace,
    }
end

---@param quad DestinationQuadComponent
---@return DestinationQuadComponent
local function CopyDestinationQuad(quad)
    ---@type DestinationQuadComponent
    return {
        topLeft = quad.topLeft,
        topRight = quad.topRight,
        bottomLeft = quad.bottomLeft,
        bottomRight = quad.bottomRight,
    }
end

---@param quad GraphicsQuadComponent
---@param pivot Vector
---@param scale Vector
local function Scale(quad, pivot, scale)
    if VectorUtils.Equals(scale, Vector.One) then
        return
    end

    local topLeft = quad.topLeft
    local topRight = quad.topRight
    local bottomLeft = quad.bottomLeft
    local bottomRight = quad.bottomRight

    -- translate to pivot, scale then undo translation
    topLeft = ((topLeft - pivot) * scale) + pivot
    topRight = ((topRight - pivot) * scale) + pivot
    bottomLeft = ((bottomLeft - pivot) * scale) + pivot
    bottomRight = ((bottomRight - pivot) * scale) + pivot

    quad.topLeft = topLeft
    quad.topRight = topRight
    quad.bottomLeft = bottomLeft
    quad.bottomRight = bottomRight
end

---@param quad GraphicsQuadComponent
---@param pivot Vector
---@param radians number
local function RotateRadians(quad, pivot, radians)
    if radians == 0.0 then
        return
    end

    local topLeft = quad.topLeft
    local topRight = quad.topRight
    local bottomLeft = quad.bottomLeft
    local bottomRight = quad.bottomRight

    local sin = math.sin(radians)
    local cos = math.cos(radians)

    -- translate
    topLeft = topLeft - pivot
    topRight = topRight - pivot
    bottomLeft = bottomLeft - pivot
    bottomRight = bottomRight - pivot

    -- apply rotation
    local x, y = topLeft.X, topLeft.Y
    topLeft.X = cos * x - sin * y
    topLeft.Y = sin * x + cos * y

    x, y = topRight.X, topRight.Y
    topRight.X = cos * x - sin * y
    topRight.Y = sin * x + cos * y

    x, y = bottomLeft.X, bottomLeft.Y
    bottomLeft.X = cos * x - sin * y
    bottomLeft.Y = sin * x + cos * y

    x, y = bottomRight.X, bottomRight.Y
    bottomRight.X = cos * x - sin * y
    bottomRight.Y = sin * x + cos * y

    -- undo translation
    topLeft = topLeft + pivot
    topRight = topRight + pivot
    bottomLeft = bottomLeft + pivot
    bottomRight = bottomRight + pivot

    quad.topLeft = topLeft
    quad.topRight = topRight
    quad.bottomLeft = bottomLeft
    quad.bottomRight = bottomRight
end

---@param quad GraphicsQuadComponent
---@param pivot Vector
---@param degrees number
local function RotateDegrees(quad, pivot, degrees)
    local radians = MathUtils.DegreesToRadians(degrees)
    RotateRadians(quad, pivot, radians)
end

---@param quad SourceQuadComponent
---@param coordinateSpace eCoordinateSpace
local function ConvertToCoordinateSpace(quad, coordinateSpace)

end

--#region Module

Module.eCoordinateSpace = eCoordinateSpace
Module.CreateSourceQuad = CreateSourceQuad
Module.CreateDestinationQuad = CreateDestinationQuad
Module.CreateDestinationQuadAxisAligned = CreateDestinationQuadAxisAligned
Module.CopySourceQuad = CopySourceQuad
Module.CopyDestinationQuad = CopyDestinationQuad
Module.Scale = Scale
Module.RotateRadians = RotateRadians
Module.RotateDegrees = RotateDegrees
Module.ConvertToCoordinateSpace = ConvertToCoordinateSpace

--#endregion

return Module