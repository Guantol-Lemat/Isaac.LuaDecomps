--#region Dependencies

local Memory = require("Admin.Memory.Memory")

--#endregion

---@class ShaderUtils
local Module = {}

---!!! ONLY USE THIS FOR COLOR OFFSET SHADERS !!!
---Does not fill the tint values as those are filled by the Image Render functions
---@param context Context
---@param color Color
---@param vertexBuffer pointer
---@param image ImageComponent
local function FillColorOffsetVertexBuffer(context, color, vertexBuffer, image)
    local anm2Manager = context:GetANM2Manager()

    vertexBuffer = Memory.Cast("float*", vertexBuffer)
    vertexBuffer = vertexBuffer + 9 -- skip over Position, Color and TexCoord attributes

    local offset = color:GetOffset()
    local colorize = color:GetColorize()
    local paddedWidth = image and image:GetPaddedWidth() or 1.0
    local paddedHeight = image and image:GetPaddedHeight() or 1.0
    local pixelationAmount = anm2Manager.g_SpritePixelationAmount
    local clipPaneNormal = anm2Manager.g_SpriteClipPaneNormal
    local clipPaneThreshold = anm2Manager.g_SpriteClipPaneThreshold

    for i = 1, 4, 1 do
        -- vec4 ColorizeIn
        vertexBuffer[0] = colorize.R
        vertexBuffer[1] = colorize.G
        vertexBuffer[2] = colorize.B
        vertexBuffer[3] = colorize.A

        -- vec3 ColorOffsetIn
        vertexBuffer[4] = offset.R
        vertexBuffer[5] = offset.G
        vertexBuffer[6] = offset.B

        -- vec2 TextureSize
        vertexBuffer[7] = paddedWidth
        vertexBuffer[8] = paddedHeight

        -- float PixelationAmount
        vertexBuffer[9] = pixelationAmount

        -- vec3 ClipPlane
        vertexBuffer[10] = clipPaneNormal.X
        vertexBuffer[11] = clipPaneNormal.Y
        vertexBuffer[12] = clipPaneThreshold

        vertexBuffer = vertexBuffer + 22 -- add stride
    end
end

---@param context Context
---@param color Color
---@param championColor Color
---@param vertexBuffer pointer
---@param image ImageComponent
local function FillColorOffsetChampionVertexBuffer(context, color, championColor, vertexBuffer, image)
    local anm2Manager = context:GetANM2Manager()

    vertexBuffer = Memory.Cast("float*", vertexBuffer)
    vertexBuffer = vertexBuffer + 9 -- skip over Position, Color and TexCoord attributes

    local offset = color:GetOffset()
    local colorize = color:GetColorize()
    local championTint = championColor:GetTint()
    local paddedWidth = image and image:GetPaddedWidth() or 1.0
    local paddedHeight = image and image:GetPaddedHeight() or 1.0
    local pixelationAmount = anm2Manager.g_SpritePixelationAmount
    local clipPaneNormal = anm2Manager.g_SpriteClipPaneNormal
    local clipPaneThreshold = anm2Manager.g_SpriteClipPaneThreshold

    for i = 1, 4, 1 do
        -- vec4 ColorizeIn
        vertexBuffer[0] = colorize.R
        vertexBuffer[1] = colorize.G
        vertexBuffer[2] = colorize.B
        vertexBuffer[3] = colorize.A

        -- vec3 ColorOffsetIn
        vertexBuffer[4] = offset.R
        vertexBuffer[5] = offset.G
        vertexBuffer[6] = offset.B

        -- vec2 TextureSize
        vertexBuffer[7] = paddedWidth
        vertexBuffer[8] = paddedHeight

        -- float PixelationAmount
        vertexBuffer[9] = pixelationAmount

        -- vec3 ClipPlane
        vertexBuffer[10] = clipPaneNormal.X
        vertexBuffer[11] = clipPaneNormal.Y
        vertexBuffer[12] = clipPaneThreshold

        -- vec4 ChampionColorIn
        vertexBuffer[13] = championTint.R
        vertexBuffer[14] = championTint.G
        vertexBuffer[15] = championTint.B
        vertexBuffer[16] = championTint.A

        vertexBuffer = vertexBuffer + 26 -- add stride
    end
end

--#region Module

Module.FillColorOffsetVertexBuffer = FillColorOffsetVertexBuffer
Module.FillColorOffsetChampionVertexBuffer = FillColorOffsetChampionVertexBuffer

--#endregion

return Module