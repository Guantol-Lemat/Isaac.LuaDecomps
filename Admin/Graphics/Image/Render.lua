--#region Dependencies

local SystemTime = require("Admin.System.Time")
local GraphicsAdmin = require("Admin.Graphics.Admin")
local GraphicsQuad = require("Admin.Graphics.Quad")
local Shader = require("Admin.Graphics.Shader.Component")
local BlendMode = require("Admin.Graphics.BlendMode")
local BitsetUtils = require("General.Bitset")
local ImageEnums = require("Admin.Graphics.Image.Enums")
local ImageAdmin = require("Admin.Graphics.Image.Admin.Logic")
local RenderBatch = require("Admin.Graphics.RenderBatch")
local Memory = require("Admin.Memory.Memory")

local eImageFlags = ImageEnums.eImageFlags
local eCoordinateSpace = GraphicsQuad.eCoordinateSpace
local eBlendMode = BlendMode.eBlendMode
local eVertexAttributeFormat = Shader.eVertexAttributeFormat

--#endregion

---@class ImageRenderLogic
local Module = {}

---@param context Context
---@param image ImageComponent
---@param isTransparent boolean
---@return RenderBatchComponent
local function get_batch(context, image, isTransparent)
    local graphics = context:GetGraphicsManager()
    local blendMode = graphics.m_blendMode
    local shader = graphics.m_shader
    -- try find one that matches current blend mode, shader and shader state

    local batch = RenderBatch.CreateRenderBatch(blendMode, shader)
    RenderBatch.ChangeBufferSize(batch.m_indexBuffer, 2)
    RenderBatch.ChangeBufferSize(batch.m_vertexBuffer, image.m_vertexStride)

    if isTransparent then
        image.m_lastTransparentRenderBatch = batch
        return batch
    end

    image.m_lastRenderBatch = batch
    table.insert(image.m_opaqueBatches, batch)
    return batch
end

---@param context Context
---@param image ImageComponent
---@param isTransparent boolean
local function begin_quad_batch(context, image, isTransparent)
    local graphics = context:GetGraphicsManager()
    local blendIsOverride = BlendMode.Equals(graphics.m_blendMode, BlendMode.GetBlendModeOverride(graphics))

    if image.m_predefinedShader ~= 3 and GraphicsAdmin.get_predefined_shader(graphics) ~= image.m_predefinedShader then
        GraphicsAdmin.set_predefined_shader(graphics, image.m_predefinedShader)
    end

    local changeBlendMode = blendIsOverride and isTransparent
    if changeBlendMode then
        GraphicsAdmin.SetBlendMode(graphics, eBlendMode.NORMAL)
    end
    image.m_quadBatchChangedBlend = changeBlendMode

    local isQuadBatchTransparent = isTransparent or (not blendIsOverride)
    local batch = get_batch(context, image, isQuadBatchTransparent)
    image.m_quadBatch = batch

    if isQuadBatchTransparent then
        local imageAdmin = context:GetImageManager()
        ImageAdmin.set_transparent_batch(imageAdmin, image, batch)
    end
    image.m_quadBatchIsTransparent = isQuadBatchTransparent

    image.m_quadBatchPixelScale = GraphicsAdmin.get_pixel_scale(graphics)
end

---@param context Context
---@param image ImageComponent
---@param isTransparent boolean
local function BeginBatch(context, image, isTransparent)
    if BitsetUtils.HasAny(image.m_flags, eImageFlags.BATCH_RUNNING) then
        context:LogMessage(3, "Trying to start an image batch when one is already running")
    end

    begin_quad_batch(context, image, isTransparent)
    image.m_flags = BitsetUtils.Set(image.m_flags, eImageFlags.BATCH_RUNNING)
end

---@param context ImageContext.EndBatch
---@param image ImageComponent
local function EndBatch(context, image)
    if not BitsetUtils.HasAny(image.m_flags, eImageFlags.BATCH_RUNNING) then
        return
    end

    if image.m_quadBatchChangedBlend then
        GraphicsAdmin.SetBlendMode(context.graphics, eBlendMode.OVERRIDE)
    end

    image.m_quadBatch = nil
    image.m_quadBatchRenderingOffset.X = 0.0
    image.m_quadBatchRenderingOffset.Y = 0.0
    image.m_quadBatchPixelScale = 0.0
    image.m_quadBatchChangedBlend = false

    BitsetUtils.Clear(image.m_flags, eImageFlags.BATCH_RUNNING)
end

---@param vertexBuffer pointer
---@param destQuad DestinationQuadComponent
---@param vertexOffset integer
---@param renderOffset Vector
---@param depth number
local function submit_position_attribute(vertexBuffer, destQuad, vertexOffset, renderOffset, depth)
    vertexBuffer[0] = destQuad.topLeft.X + renderOffset.X
    vertexBuffer[1] = destQuad.topLeft.Y + renderOffset.Y
    vertexBuffer[2] = depth

    vertexBuffer = vertexBuffer + vertexOffset
    vertexBuffer[0] = destQuad.topRight.X + renderOffset.X
    vertexBuffer[1] = destQuad.topRight.Y + renderOffset.Y
    vertexBuffer[2] = depth

    vertexBuffer = vertexBuffer + vertexOffset
    vertexBuffer[0] = destQuad.bottomLeft.X + renderOffset.X
    vertexBuffer[1] = destQuad.bottomLeft.Y + renderOffset.Y
    vertexBuffer[2] = depth

    vertexBuffer = vertexBuffer + vertexOffset
    vertexBuffer[0] = destQuad.bottomRight.X + renderOffset.X
    vertexBuffer[1] = destQuad.bottomRight.Y + renderOffset.Y
    vertexBuffer[2] = depth
end

---@param vertexBuffer pointer
---@param color KColor
---@param premultiplied boolean
local function submit_single_color(vertexBuffer, color, premultiplied)
    if premultiplied then
        vertexBuffer[0] = color.Red
        vertexBuffer[1] = color.Green
        vertexBuffer[2] = color.Blue
        vertexBuffer[3] = color.Alpha
    else
        local alpha = color.Alpha
        vertexBuffer[0] = color.Red * alpha
        vertexBuffer[1] = color.Green * alpha
        vertexBuffer[2] = color.Blue * alpha
        vertexBuffer[3] = alpha
    end
end

---@param vertexBuffer pointer
---@param colorTopLeft KColor
---@param colorTopRight KColor
---@param colorBottomLeft KColor
---@param colorBottomRight KColor
---@param vertexOffset integer
---@param premultiplied boolean
local function submit_color_attribute(vertexBuffer, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight, vertexOffset, premultiplied)
    submit_single_color(vertexBuffer, colorTopLeft, premultiplied)
    vertexBuffer = vertexBuffer + vertexOffset
    submit_single_color(vertexBuffer, colorTopRight, premultiplied)
    vertexBuffer = vertexBuffer + vertexOffset
    submit_single_color(vertexBuffer, colorBottomLeft, premultiplied)
    vertexBuffer = vertexBuffer + vertexOffset
    submit_single_color(vertexBuffer, colorBottomRight, premultiplied)
end

---@param vertexBuffer pointer
---@param sourceQuad SourceQuadComponent
---@param vertexOffset integer
---@param scale Vector
local function submit_texture_coordinates_attribute(vertexBuffer, sourceQuad, vertexOffset, scale)
    vertexBuffer[0] = sourceQuad.topLeft.X * scale.X
    vertexBuffer[1] = sourceQuad.topLeft.Y * scale.Y

    vertexBuffer = vertexBuffer + vertexOffset
    vertexBuffer[0] = sourceQuad.topRight.X * scale.X
    vertexBuffer[1] = sourceQuad.topRight.Y * scale.Y

    vertexBuffer = vertexBuffer + vertexOffset
    vertexBuffer[0] = sourceQuad.bottomLeft.X * scale.X
    vertexBuffer[1] = sourceQuad.bottomLeft.Y * scale.Y

    vertexBuffer = vertexBuffer + vertexOffset
    vertexBuffer[0] = sourceQuad.bottomRight.X * scale.X
    vertexBuffer[1] = sourceQuad.bottomRight.Y * scale.Y
end

---@param context Context
---@param image ImageComponent
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
---@param colorTopLeft KColor
---@param colorTopRight KColor
---@param colorBottomLeft KColor
---@param colorBottomRight KColor
local function submit_quads(context, image, vertexBuffer, indexBuffer, lastProcessedIndex, sourceQuad, destQuad, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight)
    local graphics = context:GetGraphicsManager()
    local depth = graphics.s_depth
    local colorPremultiplied = graphics.m_usePremultipliedAlpha

    local vertexOffset = image.m_vertexStride // 4 -- should always be aligned to a float
    local positionOffset = image.m_quadBatchRenderingOffset

    indexBuffer = Memory.Cast("unsigned short*", indexBuffer)
    vertexBuffer = Memory.Cast("float*", vertexBuffer)
    local currentVertexBuffer = vertexBuffer

    -- setup quad
    indexBuffer[0] = lastProcessedIndex
    indexBuffer[1] = lastProcessedIndex + 2
    indexBuffer[2] = lastProcessedIndex + 1
    indexBuffer[3] = lastProcessedIndex + 1
    indexBuffer[4] = lastProcessedIndex + 2
    indexBuffer[5] = lastProcessedIndex + 3

    local attributeFormat = image.m_vertexAttributesFormat

    for i = 0, image.m_vertexAttributesCount - 1, 1 do
        ---@type eVertexAttributeFormat
        local format = attributeFormat[i]

        if format == eVertexAttributeFormat.POSITION then
            submit_position_attribute(currentVertexBuffer, destQuad, vertexOffset, positionOffset, depth)
        elseif format == eVertexAttributeFormat.COLOR then
            submit_color_attribute(currentVertexBuffer, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight, vertexOffset, colorPremultiplied)
        elseif format == eVertexAttributeFormat.TEX_COORD then
            submit_texture_coordinates_attribute(currentVertexBuffer, sourceQuad, vertexOffset, image.m_uvScale)
        end

        currentVertexBuffer = currentVertexBuffer + (Shader.GetFormatStride(context, format) // 4)
    end
end

---@param image ImageComponent
---@param destQuad DestinationQuadComponent
local function texel_snap(image, destQuad)
    local pixelScale = image.m_quadBatchPixelScale

    local topLeft = destQuad.topLeft
    local bottomRight = destQuad.bottomRight

    local x1 = math.floor(topLeft.X * pixelScale + 0.5) / pixelScale
    local y1 = math.floor(topLeft.Y * pixelScale + 0.5) / pixelScale
    local x2 = math.floor(bottomRight.X * pixelScale + 0.5) / pixelScale
    local y2 = math.floor(bottomRight.Y * pixelScale + 0.5) / pixelScale

    return GraphicsQuad.CreateDestinationQuadAxisAligned(
        Vector(x1, y1),
        Vector(x2, y2)
    )
end

---@param image ImageComponent
---@param context Context
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
---@param colorTopLeft KColor
---@param colorTopRight KColor
---@param colorBottomLeft KColor
---@param colorBottomRight KColor
---@return pointer?
local function apply_data(image, context, sourceQuad, destQuad, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight)
    local graphics = context:GetGraphicsManager()
    if graphics.m_cullOffscreenRendering and not GraphicsAdmin.IsQuadOnScreen(graphics, destQuad) then
        return
    end

    if not BitsetUtils.HasAny(image.m_flags, eImageFlags.BATCH_RUNNING) then
        local isTransparent = colorTopLeft.Alpha + colorTopRight.Alpha + colorBottomLeft.Alpha + colorBottomRight.Alpha < 4.0
        begin_quad_batch(context, image, isTransparent)
    end

    destQuad = GraphicsQuad.CopyDestinationQuad(destQuad)
    local shouldSnap = (image.m_minFilterMode == 0 or image.m_magFilterMode) and -- nearest-neighbor filtering
        (graphics.m_useTexelFix and destQuad.topLeft.X == destQuad.bottomLeft.X) -- texel fix is enabled and quad is vertical-aligned

    if shouldSnap then
        destQuad = texel_snap(image, destQuad)
    end

    ---@type RenderBatchComponent
    local batch = image.m_quadBatch

    local vertexBuffers = batch.m_vertexBuffer
    local activeBuffer = vertexBuffers.m_buffers[vertexBuffers.m_activeBuffer]
    local lastProcessedIndex = activeBuffer.m_size - activeBuffer.m_capacity

    local indexBuffer = RenderBatch.AllocateBuffer(batch.m_indexBuffer, 6)
    local vertexBuffer = RenderBatch.AllocateBuffer(batch.m_vertexBuffer, 4)

    submit_quads(context, image, vertexBuffer, indexBuffer, lastProcessedIndex, sourceQuad, destQuad, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight)
    graphics.s_depth = graphics.s_depth - 0.01

    local imageAdmin = context:GetImageManager()
    ImageAdmin.add_frame_image(imageAdmin, image)

    EndBatch(context, image)

    return vertexBuffer
end

---@param image ImageComponent
---@param context Context
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
---@param colorTopLeft KColor
---@param colorTopRight KColor
---@param colorBottomLeft KColor
---@param colorBottomRight KColor
---@return pointer?
local function RenderSourceDestQuad(image, context, sourceQuad, destQuad, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight)
    sourceQuad = GraphicsQuad.CopySourceQuad(sourceQuad)
    GraphicsQuad.ConvertToCoordinateSpace(sourceQuad, eCoordinateSpace.NORMALIZED_UV_SPACE)
    return apply_data(image, context, sourceQuad, destQuad, colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight)
end

---@param image ImageComponent
---@param context Context
---@param sourceQuad SourceQuadComponent
---@param destQuad DestinationQuadComponent
---@param color KColor
---@return pointer?
local function RenderSourceDestQuadFlatColor(image, context, sourceQuad, destQuad, color)
    return RenderSourceDestQuad(image, context, sourceQuad, destQuad, color, color, color, color)
end

---@param context ImageContext.DrawBatch
---@param image ImageComponent
---@param batch RenderBatchComponent
---@param bindImage boolean
local function DrawBatch(context, image, batch, bindImage)
    local graphics = context.graphics

    local vertexBufferDesc = batch.m_vertexBuffer
    local indexBufferDesc = batch.m_indexBuffer

    local indexBuffer = indexBufferDesc.m_buffers[indexBufferDesc.m_activeBuffer]
    local indexCount = indexBuffer.m_size - indexBuffer.m_processed

    if indexCount < 0 then
        return
    end

    if bindImage then
        image:Bind()
    end

    local timeStamp = SystemTime.GetMilliseconds()
    image.m_lastRenderTimeStamp = timeStamp

    graphics:apply_blend_mode(batch.m_blendMode)
    graphics:bind_shader(batch.m_shader, batch.m_shaderState)

    local vertexBuffer = vertexBufferDesc.m_buffers[vertexBufferDesc.m_activeBuffer]
    local vertexCount = vertexBuffer.m_size - vertexBuffer.m_processed
    local startOfVertexBuffer = vertexBuffer.m_data + (vertexBufferDesc.m_elementSize * vertexBuffer.m_processed)
    local startOfIndexBuffer = indexBuffer.m_data + (indexBufferDesc.m_elementSize * indexBuffer.m_processed)

    graphics:render_vertices(startOfVertexBuffer, vertexCount, vertexBufferDesc.m_elementSize, startOfIndexBuffer, indexCount)
    vertexBuffer.m_processed = vertexBuffer.m_size
    indexBuffer.m_processed = indexBuffer.m_size
end

---@param bufferObject GraphicsBufferObject
local function empty_graphics_buffer(bufferObject)
    bufferObject.m_activeBuffer = 0
    local buffer = bufferObject.m_buffers[1]
    buffer.m_size = 0
    buffer.m_processed = 0
end

---@param image ImageComponent
local function SwapBatches(image)
    local opaqueBatches = image.m_opaqueBatches
    local transparentBatches = image.m_reusableTransparentRenderBatches

    for i = 1, opaqueBatches, 1 do
        local batch = opaqueBatches[i]
        empty_graphics_buffer(batch.m_vertexBuffer)
        empty_graphics_buffer(batch.m_indexBuffer)
    end

    for i = 1, transparentBatches, 1 do
        local batch = transparentBatches[i]
        empty_graphics_buffer(batch.m_vertexBuffer)
        empty_graphics_buffer(batch.m_indexBuffer)
    end
end

---Render Image's render batches onto current RenderTarget
---@param image ImageComponent
---@param context ImageContext.DrawBatch
local function apply_image(image, context)
    image:Bind()

    local renderBatches = image.m_opaqueBatches
    for i = 1, #renderBatches, 1 do
        DrawBatch(context, image, renderBatches[i], false)
    end
end

--#region Module

Module.BeginBatch = BeginBatch
Module.EndBatch = EndBatch
Module.RenderSourceDestQuad = RenderSourceDestQuad
Module.RenderSourceDestQuadFlatColor = RenderSourceDestQuadFlatColor
Module.DrawBatch = DrawBatch
Module.SwapBatches = SwapBatches
Module.apply_data = apply_data
Module.apply_image = apply_image

--#endregion

return Module