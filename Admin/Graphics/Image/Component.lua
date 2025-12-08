--#region Dependencies



--#endregion

---@class ImageModule
local Module = {}

---@class ImageComponent
---@field Render_SourceDestQuad fun(self: ImageComponent, context: Context, sourceQuad: SourceQuadComponent, destQuad: DestinationQuadComponent, colorTopLeft: KColor, colorTopRight: KColor, colorBottomLeft: KColor, colorBottomRight: KColor): pointer?
---@field Render_SourceDestQuadFlatColor fun(self: ImageComponent, context: Context, sourceQuad: SourceQuadComponent, destQuad: DestinationQuadComponent, color: KColor): pointer?
---@field GetWidth fun(self: ImageComponent): integer
---@field GetHeight fun(self: ImageComponent): integer
---@field GetPaddedWidth fun(self: ImageComponent): integer
---@field GetPaddedHeight fun(self: ImageComponent): integer
---@field SetFilterMode fun(self: ImageComponent, minFilterMode: integer, magFilterMode: integer)
---@field SetWrapMode fun(self: ImageComponent, wrapSMode: integer, wrapTMode: integer)
---@field Bind fun(self: ImageComponent)
---@field apply_data fun(self: ImageComponent, context: Context, sourceQuad: SourceQuadComponent, destQuad: DestinationQuadComponent, colorTopLeft: KColor, colorTopRight: KColor, colorBottomLeft: KColor, colorBottomRight: KColor): pointer?
---@field apply_image fun(self: ImageComponent)
---@field SwapBatches fun(self: ImageComponent)
---@field m_uvScale Vector
---@field m_flags eImageFlags | integer
---@field m_predefinedShader ePredefinedShader | integer
---@field m_pixelFormat ePixelFormat
---@field m_pixelData pointer -- pointer containing raw pixel data
---@field m_minFilterMode integer
---@field m_magFilterMode integer
---@field m_wrapSMode integer
---@field m_wrapTMode integer
---@field m_vertexAttributesFormat pointer
---@field m_vertexAttributesCount integer
---@field m_vertexStride integer
---@field m_name string
---@field m_opaqueBatches RenderBatchComponent[] -- should be treated as a table indexed by {BlendMode, Shader, ShaderState}
---@field m_lastRenderBatch RenderBatchComponent? -- used to quickly find commonly indexed batches
---@field m_reusableTransparentRenderBatches RenderBatchComponent[] -- should be treated as a table indexed by {BlendMode, Shader, ShaderState}
---@field m_lastTransparentRenderBatch RenderBatchComponent? -- used to quickly find commonly indexed batches
---@field m_quadBatch RenderBatchComponent? -- the current batch in which to submit quads
---@field m_quadBatchRenderingOffset Vector
---@field m_quadBatchPixelScale number
---@field m_quadBatchChangedBlend boolean
---@field m_quadBatchIsTransparent boolean
---@field m_lastRenderTimeStamp integer

---@class ImagePngComponent : ImageComponent
---@field m_width integer
---@field m_height integer
---@field m_paddedWidth integer
---@field m_paddedHeight integer
---@field m_numChannels integer

--#region Module

--#endregion

return Module
