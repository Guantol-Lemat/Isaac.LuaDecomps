--#region Dependencies

local BitsetUtils = require("General.Bitset")
local ImageEnums = require("Admin.Graphics.Image.Enums")

local eImageFlags = ImageEnums.eImageFlags

--#endregion

---@class ImageUtils
local Module = {}

---@param image ImageComponent
---@return boolean
local function IsBatching(image)
    return BitsetUtils.HasAny(image.m_flags, eImageFlags.BATCH_RUNNING)
end

--#region Module

Module.IsBatching = IsBatching

--#endregion

return Module