---@class BlendModeComponent
---@field m_srcRGB eBlendFactor
---@field m_dstRGB eBlendFactor
---@field m_srcAlpha eBlendFactor
---@field m_dstAlpha eBlendFactor

---@class BlendModeModule
local Module = {}

---@enum eBlendMode
local eBlendMode = {
    OVERRIDE = 0, -- frame buffer overrides destination buffer
    NORMAL = 1, -- transparent or semi-transparent pixels are a weighted combination of source and destination (works with premultiplied alpha sources and non)
    ADDITIVE = 2, -- source and destination pixels are combination together without weighting by alpha (works with premultiplied alpha sources and non)
}

---@enum eBlendFactor
local eBlendFactor = {
    ZERO = 0,
    ONE = 1,
    SRC_COLOR = 2,
    ONE_MINUS_SRC_COLOR = 3,
    DST_COLOR = 4,
    ONE_MINUS_DST_COLOR = 5,
    SRC_ALPHA = 6,
    ONE_MINUS_SRC_ALPHA = 7,
    DST_ALPHA = 8,
    ONE_MINUS_DST_ALPHA = 9,
}

---@param blendMode BlendModeComponent
---@return BlendModeComponent
local function Copy(blendMode)
    ---@type BlendModeComponent
    return {
        m_srcRGB = blendMode.m_srcRGB,
        m_dstRGB = blendMode.m_dstRGB,
        m_srcAlpha = blendMode.m_srcAlpha,
        m_dstAlpha = blendMode.m_dstAlpha,
    }
end

---@param blendMode BlendModeComponent
---@param other BlendModeComponent
---@return boolean
local function Equals(blendMode, other)
    return blendMode.m_srcRGB == other.m_srcRGB and
        blendMode.m_srcAlpha == other.m_srcAlpha and
        blendMode.m_dstRGB == other.m_dstRGB and
        blendMode.m_dstAlpha == other.m_dstAlpha
end

---@param manager GraphicsAdminComponent
---@return BlendModeComponent
local function GetBlendModeOverride(manager)
    ---@type BlendModeComponent
    return {
        m_srcRGB = eBlendFactor.ONE,
        m_dstRGB = eBlendFactor.ZERO,
        m_srcAlpha = eBlendFactor.ONE,
        m_dstAlpha = eBlendFactor.ZERO,
    }
end

---@param manager GraphicsAdminComponent
---@return BlendModeComponent
local function GetBlendModeNormal(manager)
    ---@type BlendModeComponent
    return {
        m_srcRGB = manager.m_usePremultipliedAlpha and eBlendFactor.ONE or eBlendFactor.SRC_ALPHA,
        m_dstRGB = eBlendFactor.ONE_MINUS_SRC_ALPHA,
        m_srcAlpha = eBlendFactor.ONE,
        m_dstAlpha = eBlendFactor.ONE_MINUS_SRC_ALPHA,
    }
end

---@param manager GraphicsAdminComponent
---@return BlendModeComponent
local function GetBlendModeAdditive(manager)
    ---@type BlendModeComponent
    return {
        m_srcRGB = manager.m_usePremultipliedAlpha and eBlendFactor.ONE or eBlendFactor.SRC_ALPHA,
        m_dstRGB = eBlendFactor.ONE,
        m_srcAlpha = eBlendFactor.ONE,
        m_dstAlpha = eBlendFactor.ONE,
    }
end

local function GetBlendMode(manager, blendType)
    if blendType == eBlendMode.OVERRIDE then
        return GetBlendModeOverride(manager)
    elseif blendType == eBlendMode.NORMAL then
        return GetBlendModeNormal(manager)
    elseif blendType == eBlendMode.ADDITIVE then
        return GetBlendModeAdditive(manager)
    end

    error(string.format("Invalid blend type: %d", blendType))
end

--#region Module

Module.eBlendMode = eBlendMode
Module.eBlendFactor = eBlendFactor
Module.Copy = Copy
Module.Equals = Equals
Module.GetBlendModeOverride = GetBlendModeOverride
Module.GetBlendModeNormal = GetBlendModeNormal
Module.GetBlendModeAdditive = GetBlendModeAdditive
Module.GetBlendMode = GetBlendMode

--#endregion

return Module