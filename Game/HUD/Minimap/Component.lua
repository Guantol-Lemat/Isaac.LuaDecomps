---@class MinimapComponent
---@field m_state MinimapState
---@field m_keepMapExpanded boolean
---@field m_heldTime integer
---@field m_normalMapDesc MinimapConfigComponent
---@field m_expandedMapDesc MinimapConfigComponent

---@class MinimapConfigComponent
---@field m_sprite Sprite
---@field m_image ImageComponent
---@field m_cellPixelSize Vector
---@field m_borderPadding number
---@field m_cellPixelDistance number
---@field m_renderGridWidth integer -- using cell number as a unit of measure
---@field m_renderGridHeight integer -- using cell number as a unit of measure
---@field m_renderAreaTopLeftPixel Vector -- the top left most rendered pixel
---@field m_imageBottomRightPixel Vector -- the bottom right most rendered pixel
---@field m_numDisplayedIcons integer
---@field m_centerCurrentRoom Vector
---@field m_alpha number
---@field m_minimap MinimapComponent

---@class MinimapComponentUtils
local Module = {}

---@return MinimapComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module