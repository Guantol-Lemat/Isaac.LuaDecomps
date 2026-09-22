--#region Dependencies

local GraphicsQuad = require("Admin.Graphics.Quad")

--#endregion

local s_colorOverride = {}
local s_glitchRNG = RNG()
local s_reflectionRendering = false
local s_screenShakingEnabled = false

local function PushColorOverride(color)
end

local function PopColorOverride()
end

---@param frame FrameComponent
---@param layerState LayerStateComponent
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
---@param anm2 ANM2Component
---@return SourceQuadComponent
local function GetSourceQuad(frame, layerState, topLeftClamp, bottomRightClamp, anm2)
    local size = layerState.m_scale * frame.m_scale
    local topLeftY = frame.m_crop.Y + topLeftClamp.Y / size.Y
    local topLeftX = frame.m_crop.X + topLeftClamp.X / size.X
    local bottomRightX = (frame.m_crop.X + frame.m_width) - bottomRightClamp.X / size.X
    local bottomRightY = (frame.m_crop.Y + frame.m_height) - bottomRightClamp.Y / size.Y

    local topLeft = Vector(topLeftX, topLeftY)
    local topRight = Vector(bottomRightX, topLeftY)
    local bottomLeft = Vector(topLeftX, bottomRightY)
    local bottomRight = Vector(bottomRightX, bottomRightY)

    size.X = layerState.m_flipX and -size.X or size.X
    size.Y = layerState.m_flipY and -size.Y or size.Y

    local anm2FlipY = anm2.m_flipY
    if s_reflectionRendering then
        anm2FlipY = not anm2FlipY
    end

    local anm2Scale = VectorUtils.Copy(anm2.m_scale)
    anm2Scale.X = anm2.m_flipX and -anm2Scale.X or anm2Scale.X
    anm2Scale.Y = (anm2FlipY) and -anm2Scale.Y or anm2Scale.Y

    if (size.X < 0) ~= (anm2Scale.X < 0) then
        -- flipX
        local temp = topLeft
        topLeft = topRight
        topRight = temp

        temp = bottomLeft
        bottomLeft = bottomRight
        bottomRight = temp
    end

    if (size.Y < 0) ~= (anm2Scale.Y < 0) then
        -- flipY
        local temp = topLeft
        topLeft = bottomLeft
        bottomLeft = temp

        temp = topRight
        topRight = bottomRight
        bottomRight = temp
    end

    local flags = anm2.m_flags | layerState.m_flags
    if BitsetUtils.HasAny(flags, eAnimationFlags.GLITCH) then
        local rng = s_glitchRNG

        local yModifier = rng:RandomFloat()
        local xModifier = rng:RandomFloat()

        local offset = Vector((topRight.X - topLeft.X) * (xModifier - 0.5), (bottomLeft.Y - topLeft.Y) * (yModifier - 0.5))
        topLeft = topLeft + offset
        topRight = topRight + offset
        bottomLeft = bottomLeft + offset
        bottomRight = bottomRight + offset
    end

    local quad = GraphicsQuad.CreateSourceQuad(
        topLeft + layerState.m_cropOffset,
        topRight + layerState.m_cropOffset,
        bottomLeft + layerState.m_cropOffset,
        bottomRight + layerState.m_cropOffset,
        eCoordinateSpace.PIXEL_SPACE
    )

    return quad
end

---@param myContext Context.Game
---@param position Vector
---@param frame FrameComponent
---@param layerState LayerStateComponent
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
---@param anm2 ANM2Component
---@return DestinationQuadComponent
local function GetDestQuad(myContext, position, frame, layerState, topLeftClamp, bottomRightClamp, anm2)
    local game = myContext.game
    local flags = anm2.m_flags | layerState.m_flags

    local anm2FlipY = anm2.m_flipY
    if admin.g_ReflectionRendering then
        anm2FlipY = not anm2FlipY
    end

    local spriteOffset = VectorUtils.Copy(anm2.m_offset)
    local frameOffset = layerState.m_position + frame.m_position + spriteOffset
    local spriteScale = VectorUtils.Copy(anm2.m_scale)
    local frameScale = layerState.m_scale * frame.m_scale
    local spriteRotation = anm2.m_rotation
    local frameRotation = layerState.m_rotation + frame.m_rotation
    local pivot = VectorUtils.Copy(frame.m_pivot)

    -- invert scale transform hierarchy
    if BitsetUtils.HasAny(flags, eAnimationFlags.APPLY_LAYER_SCALE_TO_SPRITE) then
        spriteScale = layerState.m_scale * anm2.m_scale
        frameScale = VectorUtils.Copy(frame.m_scale)
    end

    if layerState.m_flipX then
        frameScale.X = -frameScale.X
    end

    if layerState.m_flipY then
        frameScale.Y = -frameScale.Y
    end

    if anm2.m_flipX then
        spriteScale.X = -spriteScale.X
    end

    if anm2FlipY then
        spriteScale.Y = -spriteScale.Y
    end

    if spriteScale.X < 0.0 then
        spriteScale.X = -spriteScale.X
        frameOffset.X = -frameOffset.X
        frameRotation = -frameRotation
        spriteRotation = -spriteRotation
        pivot.X = frame.m_width - pivot.X
    end

    if spriteScale.Y < 0.0 then
        spriteScale.Y = -spriteScale.Y
        frameOffset.Y = -frameOffset.Y
        frameRotation = -frameRotation
        spriteRotation = -spriteRotation
        pivot.Y = frame.m_height - pivot.Y
    end

    if frameScale.X < 0.0 then
        frameScale.X = -frameScale.X
        pivot.X = frame.m_width - pivot.X
    end

    if frameScale.Y < 0.0 then
        frameScale.Y = -frameScale.Y
        pivot.Y = frame.m_height - pivot.Y
    end

    local shakeOffset = s_screenShakingEnabled and game.m_screenShake_offset or Vector(0, 0)
    position = position + shakeOffset

    local spritePosition = position + spriteOffset
    local layerPosition = position + frameOffset - pivot

    topLeftClamp = topLeftClamp / frameScale
    bottomRightClamp = bottomRightClamp / frameScale

    local topLeft = position + topLeftClamp
    local bottomRightX = (position.X + frame.m_width) - bottomRightClamp.X
    local bottomRightY = (position.Y + frame.m_height) - bottomRightClamp.Y
    local bottomRight = Vector(bottomRightX, bottomRightY)

    local destQuad = GraphicsQuad.CreateDestinationQuadAxisAligned(topLeft, bottomRight)
    GraphicsQuad.Scale(destQuad, layerPosition, frameScale)
    GraphicsQuad.Scale(destQuad, spritePosition, spriteScale)
    GraphicsQuad.RotateDegrees(destQuad, layerPosition, frameRotation)
    GraphicsQuad.RotateDegrees(destQuad, spritePosition, spriteRotation)

    return destQuad
end

local Module = {}

--#region Module

Module.PushColorOverride = PushColorOverride
Module.PopColorOverride = PopColorOverride

--#endregion

return Module