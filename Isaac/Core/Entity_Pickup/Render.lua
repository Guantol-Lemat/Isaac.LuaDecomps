--#region Dependencies

local Constants = require("Isaac.Constants")
local ISprite = require("Isaac.Interface.ANM2")
local IEntity = require("Isaac.Interface.Entity")
local EntityUtils = require("Isaac.Core.Entity.Utils")
local PickupProperty = require("Isaac.Content.Pickup.Properties")
local Collectible = require("Isaac.Core.Entity.Pickup.Render.Collectible")
local LuaCallbacks = require("LuaEngine.Callbacks")

--#endregion

local VECTOR_ZERO = Constants.VECTOR_ZERO

---@param pickup Component.Entity.Pickup
---@param offset Vector
local function render_entity(pickup, offset)
    IEntity.Render(pickup, offset)
end

---@param pickup Component.Entity.Pickup
local function render_price(pickup)
    if pickup.m_priceANM2.m_loaded then
        ISprite.Render(pickup.m_priceANM2, pickup.m_screenPosition, VECTOR_ZERO, VECTOR_ZERO)
    end
end

---@param pickup Component.Entity.Pickup
---@param offset Vector
local function Render(pickup, offset)
    if not PickupProperty.ShouldRender(pickup) then
        return
    end

    -- render entity
    if pickup.m_variant == PickupVariant.PICKUP_COLLECTIBLE then
        if not Collectible.ShouldRender(pickup) then
            return
        end

        EntityUtils.InitScreenPosition(pickup, offset)
        Collectible.RenderEntity(pickup, offset)
    else
        render_entity(pickup, offset)
    end

    render_price(pickup)

    LuaCallbacks.PostPickupRender(offset)
end

---@class Pickup.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module