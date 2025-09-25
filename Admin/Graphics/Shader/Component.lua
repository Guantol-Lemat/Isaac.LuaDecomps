---@class ShaderComponent
---@field prepare_render_state fun(self: ShaderComponent, vertexBuffer: GLvoid, count: GLsizei,stride: GLsizei)
---@field m_vertexAttributes VertexAttributeDesc[]
---@field m_uniformValues UniformValues[]
---@field m_state ShaderState
---@field m_glProgram GLuint

---@alias ShaderState number[]

---@class UniformValues

---@class VertexAttributeDesc
---@field name string
---@field format eVertexAttributeFormat

---@class ShaderModule
local Module = {}

---@enum eVertexAttributeFormat
local eVertexAttributeFormat = {
    FLOAT = 1,
    VEC_2 = 2,
    VEC_3 = 3,
    VEC_4 = 4,
    POSITION = 5,
    COLOR = 6,
    TEX_COORD = 7,
}

local FORMAT_STRIDE = {
    [eVertexAttributeFormat.FLOAT] = 1 * 4,
    [eVertexAttributeFormat.VEC_2] = 2 * 4,
    [eVertexAttributeFormat.VEC_3] = 3 * 4,
    [eVertexAttributeFormat.VEC_4] = 4 * 4,
    [eVertexAttributeFormat.POSITION] = 3 * 4,
    [eVertexAttributeFormat.COLOR] = 4 * 4,
    [eVertexAttributeFormat.TEX_COORD] = 2 * 4,
}

---@param context Context
---@param format eVertexAttributeFormat
---@return integer
local function GetFormatStride(context, format)
    local stride = FORMAT_STRIDE[format]

    if not stride then
        context:LogMessage(3, "Unknown attribute format specified\n")
        return 0
    end

    return stride
end

--#region Module

Module.eVertexAttributeFormat = eVertexAttributeFormat
Module.GetFormatStride = GetFormatStride

--#endregion

return Module