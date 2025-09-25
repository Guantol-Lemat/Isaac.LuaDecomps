---@diagnostic disable: missing-return
---@class OpenGL
local gl = {}

---@alias GLenum number
---@alias GLbitfield number
---@alias GLboolean boolean|integer
---@alias GLbyte number
---@alias GLshort number
---@alias GLint number
---@alias GLsizei number
---@alias GLubyte number
---@alias GLushort number
---@alias GLuint number
---@alias GLfloat number
---@alias GLclampf number
---@alias GLdouble number
---@alias GLclampd number
---@alias GLvoid userdata|nil

--- Return the location of an attribute variable
---@param program GLuint
---@param name string
---@return GLint
function gl.glGetAttribLocation(program, name) end

--- Enable a generic vertex attribute array
---@param index GLuint
function gl.glEnableVertexAttribArray(index) end

--- Define an array of generic vertex attribute data
---@param index GLuint
---@param size GLint
---@param type GLenum
---@param normalized GLboolean
---@param stride GLsizei
---@param pointer GLvoid
function gl.glVertexAttribPointer(index, size, type, normalized, stride, pointer) end

--- Render primitives from array data
---@param mode GLenum
---@param count GLsizei
---@param type GLenum
---@param indices GLvoid
function gl.glDrawElements(mode, count, type, indices) end