--#region Dependencies

local Log = require("General.Log")

--#endregion

---@param t number -- normalized progress alongside the curve
---@param startPoint Vector
---@param controlPoint1 Vector
---@param controlPoint2 Vector
---@param endPoint Vector
---@return Vector
local function GetBezierPosition(t, startPoint, controlPoint1, controlPoint2, endPoint)
    local startWeight = (1.0 - t) ^ 3
    local controlWeight1 = 3.0 * (1.0 - t)^2 * t
    local controlWeight2 = 3.0 * (1.0 - t) * t^2
    local endWeight = t^3
    return (startPoint * startWeight) + (controlPoint1 * controlWeight1) + (controlPoint2 * controlWeight2) + (endPoint * endWeight)
end

---@param point Vector
---@param segmentStart Vector
---@param segmentEnd Vector
---@return number distance
---@return number closestPointFactor
local function point_segment_distance_sq(point, segmentStart, segmentEnd)
    local segmentVector = segmentEnd - segmentStart
    local segmentLengthSquared = segmentVector:LengthSquared()

    if segmentLengthSquared == 0.0 then
        return (point - segmentStart):LengthSquared(), 0.0 -- closest point is start
    end

    -- scalar projection
    local t = ((point - segmentStart):Dot(segmentEnd - segmentStart)) / segmentLengthSquared

    if t < 0.0 then
        return (point - segmentStart):LengthSquared(), 0.0 -- closest point is start
    elseif t > 1.0 then
        return (point - segmentEnd):LengthSquared(), 1.0 -- closest point is end
    end

    local closestPoint = (segmentVector * t) + segmentStart
    return (point - closestPoint):LengthSquared(), t
end

---@param point Vector
---@param bezier BezierPointComponent
---@param otherBezier BezierPointComponent
---@param samples integer
---@return number distance
---@return number closestPointFactor
local function distance_from_bezier_sq(point, bezier, otherBezier, samples)
    if samples == 0 then
        Log.LogMessage(3, "Closest Bezier T Samples should be != 0!\n")
    end

    local startPoint, controlPoint1, controlPoint2, endPoint = bezier.anchor, bezier.outgoingHandle, otherBezier.incomingHandle, otherBezier.anchor
    local segmentStart = GetBezierPosition(0.0, startPoint, controlPoint1, controlPoint2, endPoint)

    local lowestDistance = 1000000.0
    local closestT = 0.0
    local previousT = 0.0

    -- find lowest distance by testing <samples> segments
    for i = 1, samples, 1 do
        local t = i / samples
        local segmentEnd = GetBezierPosition(t, startPoint, controlPoint1, controlPoint2, endPoint)
        local segmentDistance, closestSegmentT = point_segment_distance_sq(point, segmentStart, segmentEnd)
        if segmentDistance < lowestDistance then
            closestT = previousT + (t - previousT) * closestSegmentT
            local position = GetBezierPosition(closestT, startPoint, controlPoint1, controlPoint2, endPoint)
            lowestDistance = (point - position):LengthSquared()
        end
    end

    return lowestDistance, closestT
end

---@param point Vector
---@param bezier BezierPointComponent
---@param otherBezier BezierPointComponent
---@return number distance
---@return number closestPointFactor
local function DistanceFromBezierSq(point, bezier, otherBezier)
    return distance_from_bezier_sq(point, bezier, otherBezier, 5)
end

local Module = {}

--#region Module

Module.GetBezierPosition = GetBezierPosition
Module.DistanceFromBezierSq = DistanceFromBezierSq

--#endregion

return Module