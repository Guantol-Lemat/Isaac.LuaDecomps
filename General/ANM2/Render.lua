--#region Dependencies

local Enums = require("General.Enums")
local BitsetUtils = require("General.Bitset")
local VectorUtils = require("General.Math.VectorUtils")
local ColorUtils = require("General.Color")
local ShaderUtils = require("General.Shader.Utils")

local GraphicsAdmin = require("Admin.Graphics.Admin")
local InternalUtils = require("General.ANM2.Utils")
local GraphicsQuad = require("Admin.Graphics.Quad")
local Memory = require("Admin.Memory.Memory")

local eAnimationFlags = Enums.eAnimationFlags
local eShaders = Enums.eShaders
local eCoordinateSpace = GraphicsQuad.eCoordinateSpace

--#endregion

---@class ANM2Render
local Module = {}

---@param admin ANM2AdminComponent
---@param anm2 ANM2Component
---@param layerState LayerStateComponent
---@param frame FrameComponent
---@param flags eAnimationFlags | integer
local function get_render_color(admin, anm2, layerState, frame, flags)
    if BitsetUtils.HasAny(flags, eAnimationFlags.IGNORE_COLOR_MODIFIERS) then
        return ColorUtils.Copy(layerState.m_color) * frame.m_color
    end

    local stackSize = #admin.g_ColorOverrideStack
    if stackSize > 0 then
        return ColorUtils.Copy(admin.g_ColorOverrideStack[stackSize])
    end

    local color = ColorUtils.Copy(layerState.m_color) * frame.m_color
    return color * anm2.m_color
end

---@param context Context
---@param frame FrameComponent
---@param layerState LayerStateComponent
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
---@param anm2 ANM2Component
---@return SourceQuadComponent
local function GetSourceQuad(context, frame, layerState, topLeftClamp, bottomRightClamp, anm2)
    local admin = context:GetANM2Manager()

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
    if admin.g_ReflectionRendering then
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
        local rng = admin.g_GlitchRNG

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

---@param context Context
---@param position Vector
---@param frame FrameComponent
---@param layerState LayerStateComponent
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
---@param anm2 ANM2Component
---@return DestinationQuadComponent
local function GetDestQuad(context, position, frame, layerState, topLeftClamp, bottomRightClamp, anm2)
    local admin = context:GetANM2Manager()
    local game = context:GetGame()
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

    local shakeOffset = admin.g_ScreenShakingEnabled and game.m_screenShake_offset or Vector(0, 0)
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

---@param context Context
---@param image ImageComponent
---@param color Color
---@param championColor Color
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
local function render_champion(context, image, color, championColor, sourceQuad, destQuad)
    context:LoadShader(eShaders.COLOR_OFFSET_CHAMPION)

    local vertexBuffer = image:Render_SourceDestQuadFlatColor(context, sourceQuad, destQuad, color:GetTint())
    if vertexBuffer then
        ShaderUtils.FillColorOffsetChampionVertexBuffer(context, color, championColor, vertexBuffer, image)
    end

    context:LoadShader(eShaders.COLOR_OFFSET)
end

---@param context Context
---@param image ImageComponent
---@param flags eImageFlags | integer
---@param color Color
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
local function render_dogma(context, image, flags, color, sourceQuad, destQuad)
    context:LoadShader(eShaders.COLOR_OFFSET_DOGMA)
    local isaac = context:GetAdmin()
    local game = context:GetGame()

    local frameCount = BitsetUtils.HasAny(flags, eAnimationFlags.IGNORE_GAME_TIME) and game.m_frameCounter or (isaac.m_frameCount / 2)
    local staticProgression = math.fmod(frameCount, 256) / 256 -- a number in the (-1.0, 1.0) range
    local colorize = color:GetColorize()
    color:SetColorize(colorize.R, colorize.G, colorize.B, staticProgression)

    local vertexBuffer = image:Render_SourceDestQuadFlatColor(context, sourceQuad, destQuad, color:GetTint())
    if vertexBuffer then
        ShaderUtils.FillColorOffsetVertexBuffer(context, color, vertexBuffer, image)
    end
end

---@param context Context
---@param image ImageComponent
---@param flags eImageFlags | integer
---@param color Color
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
local function render_gold(context, image, flags, color, sourceQuad, destQuad)
    context:LoadShader(eShaders.COLOR_OFFSET_GOLD)
    local isaac = context:GetAdmin()
    local game = context:GetGame()

    local frameCount = BitsetUtils.HasAny(flags, eAnimationFlags.IGNORE_GAME_TIME) and game.m_frameCounter or (isaac.m_frameCount / 2)
    local goldProgression = math.fmod(frameCount, 256) / 256 -- a number in the (-1.0, 1.0) range
    local colorize = color:GetColorize()
    color:SetColorize(colorize.R, colorize.G, colorize.B, goldProgression)

    local vertexBuffer = image:Render_SourceDestQuadFlatColor(context, sourceQuad, destQuad, color:GetTint())
    if vertexBuffer then
        ShaderUtils.FillColorOffsetVertexBuffer(context, color, vertexBuffer, image)
    end
end

---@param context Context
---@param image ImageComponent
---@param color Color
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
local function render_procedural(context, image, color, sourceQuad, destQuad)
    -- render using currently applied shader
    image:Render_SourceDestQuadFlatColor(context, sourceQuad, destQuad, color:GetTint())
end

---@param context Context
---@param image ImageComponent
---@param color Color
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
local function render_normal(context, image, color, sourceQuad, destQuad)
    context:LoadShader(eShaders.COLOR_OFFSET)
    local vertexBuffer = image:Render_SourceDestQuadFlatColor(context, sourceQuad, destQuad, color:GetTint())

    if vertexBuffer then
        ShaderUtils.FillColorOffsetVertexBuffer(context, color, vertexBuffer, image)
    end
end

---@param context Context
---@param layer AnimationLayerComponent
---@param position Vector
---@param frameIndex integer
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
---@param anm2 ANM2Component
local function RenderFrame(context, layer, position, frameIndex, topLeftClamp, bottomRightClamp, anm2)
    if not layer.m_visible then
        return
    end

    if not (0 <= frameIndex and frameIndex < layer.m_frameCount) then
        return
    end

    local frame = layer.m_frames[frameIndex + 1]
    if not frame.m_visible then
        return
    end

    local layerState = anm2.m_layerStates[layer.m_layerId + 1]
    if not layerState.m_visible then
        return
    end

    local image = InternalUtils.GetSpriteSheetImage(layerState)
    if not image then
        return
    end

    local admin = context:GetANM2Manager()
    local graphics = context:GetGraphicsManager()

    ---@type eAnimationFlags | integer
    local flags = anm2.m_flags | layerState.m_flags
    if BitsetUtils.HasAny(flags, eAnimationFlags.IS_LIGHT) and not admin.g_RenderLight then
        return
    end

    local previousBlendMode = GraphicsAdmin.GetBlendMode(graphics)
    graphics:SetBlendMode(layerState.m_blendMode)

    local color = get_render_color(admin, anm2, layerState, frame, flags)
    if admin.g_ReflectionRendering then
        local room = context:GetRoom()
        color.A = color.A * 0.5 * room.m_waterAmount
    end

    local sourceQuad = GetSourceQuad(context, frame, layerState, topLeftClamp, bottomRightClamp, anm2)
    local destQuad = GetDestQuad(context, position, frame, layerState, topLeftClamp, bottomRightClamp, anm2)

    if admin.g_GlitchRendering then
        local rng = RNG(); rng:SetSeed(Memory.GetLuaPtrHash(anm2), 35)

        local pivot = Vector(
            frame.m_width / 2 + frame.m_crop.X,
            frame.m_height / 2 + frame.m_crop.Y
        )

        local angle = rng:RandomInt(2) == 0 and 90.0 or -90.0
        GraphicsQuad.RotateDegrees(sourceQuad, pivot, angle)

        -- flipX (practically a flipY since the quad is rotated beforehand)
        if rng:RandomInt(2) ~= 0 then
            local tmp = sourceQuad.topLeft
            sourceQuad.topLeft = sourceQuad.topRight
            sourceQuad.topRight = tmp

            tmp = sourceQuad.bottomLeft
            sourceQuad.bottomLeft = sourceQuad.bottomRight
            sourceQuad.bottomRight = tmp
        end
    end

    if BitsetUtils.HasAny(flags, eAnimationFlags.CHAMPION) then
        render_champion(context, image, color, anm2.m_championColor, sourceQuad, destQuad)
    elseif BitsetUtils.HasAny(flags, eAnimationFlags.STATIC) then
        render_dogma(context, image, flags, color, sourceQuad, destQuad)
    elseif BitsetUtils.HasAny(flags, eAnimationFlags.GOLDEN) then
        render_gold(context, image, flags, color, sourceQuad, destQuad)
    elseif BitsetUtils.HasAny(flags, eAnimationFlags.PROCEDURAL) then
        render_procedural(context, image, color, sourceQuad, destQuad)
    else
        render_normal(context, image, color, sourceQuad, destQuad)
    end

    graphics:SetBlendMode(previousBlendMode)
end

---@param context Context
---@param animation AnimationStateComponent
---@param position Vector
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
local function RenderAnimation(context, animation, position, topLeftClamp, bottomRightClamp)
    local data = animation.m_data
    if not data then
        return
    end

    local layers = data.m_layers
    local layerFrames = animation.m_layerFrames
    local anm2 = animation.m_anm2

    for i = 1, #layers, 1 do
        RenderFrame(context, layers[i], position, layerFrames[i], topLeftClamp, bottomRightClamp, anm2)
    end
end

---@param context Context
---@param anm2 ANM2Component
---@param position Vector
---@param topLeftClamp Vector
---@param bottomRightClamp Vector
local function Render(context, anm2, position, topLeftClamp, bottomRightClamp)
    if not anm2.m_loaded then
        return
    end

    local first = anm2.m_animationState
    local second = anm2.m_overlayAnimationState

    if anm2.m_renderOverlayFirst then
        first = anm2.m_overlayAnimationState
        second = anm2.m_animationState
    end

    RenderAnimation(context, first, position, topLeftClamp, bottomRightClamp)
    RenderAnimation(context, second, position, topLeftClamp, bottomRightClamp)
end

--#region Module

Module.GetSourceQuad = GetSourceQuad
Module.GetDestQuad = GetDestQuad
Module.Render = Render
Module.RenderAnimation = RenderAnimation
Module.RenderFrame = RenderFrame

--#endregion

return Module