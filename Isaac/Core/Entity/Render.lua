--#region Dependencies

local Constants = require("Isaac.Constants")
local ISprite = require("Isaac.Interface.ANM2")
local EntityMisc = require("Isaac.Core.Entity.Misc")
local EntityUtils = require("Isaac.Core.Entity.Utils")

--#endregion

local VECTOR_ZERO = Constants.VECTOR_ZERO

---@param entity Component.Entity
---@param offset Vector
local function Render(entity, offset)
    if not EntityMisc.ShouldRender(entity) then
        return
    end

    if entity.m_blockSpriteBatch then
        ISprite.BeginBatches(entity.m_sprite)
    end

    EntityUtils.InitScreenPosition(entity, offset)
    ISprite.Render(entity.m_sprite, entity.m_screenPosition, VECTOR_ZERO, VECTOR_ZERO)
end

---@class Entity.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module