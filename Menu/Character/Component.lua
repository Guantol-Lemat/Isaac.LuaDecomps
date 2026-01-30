---@class MenuCharacterComponent
---@field m_state integer
---@field m_position Vector
---@field m_seedEntrySprite Sprite
---@field m_characterMenuBGSprite Sprite
---@field m_taintedMenuBGDecoSprite Sprite
---@field m_pageSwapWidgetSprite Sprite
---@field m_pageSwapMenuRenderSurface Image -- an image used to make the rendered character menu flow well with the swap animation

---@enum eMenuCharacterState
local eMenuCharacterState = {
    SEEDS_MENU = 1,
    PAGE_SWAP = 4
}

local Module = {}

--#region Module

Module.eMenuCharacterState = eMenuCharacterState

--#endregion

return Module