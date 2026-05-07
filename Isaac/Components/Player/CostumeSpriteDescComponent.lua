---@class Component.CostumeSpriteDesc
---@field m_sprite Sprite : 0x0
---@field m_itemConfig Component.ItemConfig.Item : 0x114
---@field m_priority integer : 0x118
---@field m_itemAnimPlay boolean : 0x11c
---@field m_isFlying boolean : 0x11d
---@field m_hasOverlay boolean : 0x11e
---@field m_hasSkinAlt boolean : 0x11f
---@field m_defaultSkinColor SkinColor | integer : 0x120
---@field m_skinColor SkinColor | integer : 0x124
---@field m_overwriteColor boolean : 0x128
---@field m_itemStateOnly boolean : 0x129
---@field m_playerType PlayerType | integer : 0x12c

---@param item Component.ItemConfig.Item
---@return Component.CostumeSpriteDesc
local function New(item)
    ---@type Component.CostumeSpriteDesc
    return {
        m_sprite = Sprite(),
        m_itemConfig = item,
        m_priority = 0,
        m_itemAnimPlay = false,
        m_isFlying = false,
        m_hasOverlay = false,
        m_hasSkinAlt = false,
        m_defaultSkinColor = 0,
        m_skinColor = 0,
        m_overwriteColor = false,
        m_itemStateOnly = false,
        m_playerType = -1,
    }
end

---@param desc Component.CostumeSpriteDesc
---@return Component.CostumeSpriteDesc
local function Copy(desc)
    ---@type Component.CostumeSpriteDesc
    return {
        m_sprite = desc.m_sprite:Copy(),
        m_itemConfig = desc.m_itemConfig,
        m_priority = desc.m_priority,
        m_itemAnimPlay = desc.m_itemAnimPlay,
        m_isFlying = desc.m_isFlying,
        m_hasOverlay = desc.m_hasOverlay,
        m_hasSkinAlt = desc.m_hasSkinAlt,
        m_defaultSkinColor = desc.m_defaultSkinColor,
        m_skinColor = desc.m_skinColor,
        m_overwriteColor = desc.m_overwriteColor,
        m_itemStateOnly = desc.m_itemStateOnly,
        m_playerType = desc.m_playerType,
    }
end

---@class Module.Component.CostumeSpriteDesc
local Module = {}

---#region Module

Module.New = New
Module.Copy = Copy

---#endregion