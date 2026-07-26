--#region Dependencies

local Memory = require("Admin.Memory.Memory")
local BlendMode = require("Admin.Graphics.BlendMode")

--#endregion

---@class RenderBatchComponent
---@field m_blendMode BlendModeComponent
---@field m_shader ShaderComponent
---@field m_shaderState ShaderState
---@field m_vertexBuffer GraphicsBufferObject -- maintains the vertex buffer and allocates slices to be used when batching image renders
---@field m_indexBuffer GraphicsBufferObject -- maintains the index buffer and allocates slices to be used when batching image renders

---@class GraphicsBufferObject
---@field m_buffers GraphicsBuffer[]
---@field m_activeBuffer integer
---@field m_elementSize integer

---@class GraphicsBuffer
---@field m_data pointer
---@field m_size integer
---@field m_capacity integer
---@field m_processed integer

---@class RenderBatchModule
local Module = {}

---@param shader ShaderComponent
---@return ShaderState
local function copy_shader_state(shader)
    local result = {}
    local state = shader.m_state
    for i = 1, #state, 1 do
        result[i] = state[i]
    end

    return result
end

---@return GraphicsBuffer
local function create_graphics_buffer()
    ---@type GraphicsBuffer
    return {
---@diagnostic disable-next-line: assign-type-mismatch
        m_data = nil,
        m_size = 0,
        m_capacity = 0,
        m_processed = 0,
    }
end

---@return GraphicsBufferObject
local function create_graphics_buffer_object()
    ---@type GraphicsBufferObject
    return {
        m_buffers = {create_graphics_buffer()},
        m_activeBuffer = 0,
        m_elementSize = 0,
    }
end

---@param blendMode BlendModeComponent
---@param shader ShaderComponent
local function CreateRenderBatch(blendMode, shader)
    ---@type RenderBatchComponent
    return {
        m_blendMode = BlendMode.Copy(blendMode),
        m_shader = shader,
        m_shaderState = copy_shader_state(shader),
        m_vertexBuffer = create_graphics_buffer_object(),
        m_indexBuffer = create_graphics_buffer_object(),
    }
end

---@param bufferObject GraphicsBufferObject
---@param newSize integer
local function ChangeBufferSize(bufferObject, newSize)
    if bufferObject.m_elementSize == newSize then
        return
    end

    bufferObject.m_elementSize = newSize
    local buffer = bufferObject.m_buffers[1]
    if buffer.m_capacity == 0 then
        return
    end

    local oldBuffer = buffer.m_data
    local newBuffer = Memory.Allocate(buffer.m_capacity * newSize)
    buffer.m_data = newBuffer

    if not newBuffer then
        return
    end

    Memory.Copy(newBuffer, oldBuffer, buffer.m_size * bufferObject.m_elementSize)
    -- Free
end

---@param bufferObject GraphicsBufferObject
---@param elementCount number
---@return pointer
local function AllocateBuffer(bufferObject, elementCount)

end

--#region Module

Module.CreateRenderBatch = CreateRenderBatch
Module.ChangeBufferSize = ChangeBufferSize
Module.AllocateBuffer = AllocateBuffer

--#endregion

return Module
