local Shader = require("Engine.Interface.Shader")
local ShaderType = Renderer.ShaderType

---@class Isaac.Global
local Global = {}

---@type Component.Manager
Global.Manager = nil
---@type Component.MenuManager
Global.MenuManager = nil
---@type Component.Game
Global.Game = nil
Global.LuaEngine = nil

Global.WIDTH = 0 -- width of the screen
Global.HEIGHT = 0 -- height of the screen
Global.RENDER_WIDTH = 0
Global.RENDER_HEIGHT = 0
Global.DISPLAYPIXELSPERPOINT = 0
Global.POINTSCALE = 2.0
Global.REALPOINTSCALE = 2.0

Global.Shaders = {
    [ShaderType.SHADER_COLOR_OFFSET + 1] = Shader.New(),
    [ShaderType.SHADER_PIXELATION + 1] = Shader.New(),
    [ShaderType.SHADER_BLOOM + 1] = Shader.New(),
    [ShaderType.SHADER_COLOR_CORRECTION + 1] = Shader.New(),
    [ShaderType.SHADER_HQ4X + 1] = Shader.New(),
    [ShaderType.SHADER_SHOCKWAVE + 1] = Shader.New(),
    [ShaderType.SHADER_OLDTV + 1] = Shader.New(),
    [ShaderType.SHADER_WATER + 1] = Shader.New(),
    [ShaderType.SHADER_HALLUCINATION + 1] = Shader.New(),
    [ShaderType.SHADER_COLOR_MOD + 1] = Shader.New(),
    [ShaderType.SHADER_COLOR_OFFSET_CHAMPION + 1] = Shader.New(),
    [ShaderType.SHADER_WATER_V2 + 1] = Shader.New(),
    [ShaderType.SHADER_BACKGROUND + 1] = Shader.New(),
    [ShaderType.SHADER_WATER_OVERLAY + 1] = Shader.New(),
    [ShaderType.SHADER_UNK + 1] = Shader.New(),
    [ShaderType.SHADER_COLOR_OFFSET_DOGMA + 1] = Shader.New(),
    [ShaderType.SHADER_COLOR_OFFSET_GOLD + 1] = Shader.New(),
    [ShaderType.SHADER_DIZZY + 1] = Shader.New(),
    [ShaderType.SHADER_HEAT_WAVE + 1] = Shader.New(),
    [ShaderType.SHADER_MIRROR + 1] = Shader.New(),
}

return Global