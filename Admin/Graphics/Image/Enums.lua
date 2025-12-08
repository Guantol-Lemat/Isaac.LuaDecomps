---@class ImageEnums
local Module = {}

---@enum eImageFlags
local eImageFlags = {
    LOADED = 1 << 0,
    PROCEDURAL = 1 << 1,
    FRAME_IMAGE_ADDED = 1 << 2,
    DRAWN = 1 << 4,
    BATCH_RUNNING = 1 << 5,
}

---@enum ePixelFormat
local ePixelFormat = {
    LUMINANCE = 0,
    RGB = 1,
    RGBA = 2,
    INVALID = 6,
}

--#region Module

Module.eImageFlags = eImageFlags
Module.ePixelFormat = ePixelFormat

--#endregion

return Module
