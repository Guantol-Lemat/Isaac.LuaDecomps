---@class ANM2InternalUtils
local Module = {}

---@param layerState LayerStateComponent
---@return ImageComponent?
local function GetSpriteSheetImage(layerState)
    local spriteSheet = layerState.m_spriteSheet
    if not spriteSheet then
        return nil
    end

    -- Lazy sync sprite and layer fields
    if spriteSheet.m_minFilterMode ~= layerState.m_minFilterMode or spriteSheet.m_magFilterMode ~= layerState.m_magFilterMode then
        spriteSheet:SetFilterMode(layerState.m_minFilterMode, layerState.m_magFilterMode)
    end

    if spriteSheet.m_wrapSMode ~= layerState.m_wrapSMode or spriteSheet.m_wrapTMode ~= layerState.m_wrapTMode then
        spriteSheet:SetWrapMode(layerState.m_wrapSMode, layerState.m_wrapTMode)
    end

    return spriteSheet
end

--#region Module

Module.GetSpriteSheetImage = GetSpriteSheetImage

--#endregion

return Module