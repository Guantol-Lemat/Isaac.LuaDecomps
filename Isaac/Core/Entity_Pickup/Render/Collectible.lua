--#region Dependencies

local g = require("Isaac.Global")
local Behavior = require("General.Behavior")
local Constants = require("Isaac.Constants")
local IsaacUtils = require("Isaac.Utils.Common")
local ISprite = require("Isaac.Interface.ANM2")
local IAnimationState = ISprite.AnimationState

--#endregion

---@class Pickup.Blackboard.Render.Collectible
---@field pickup Component.Entity.Pickup
---@field collectibleOffset Vector

local VECTOR_ZERO = Constants.VECTOR_ZERO

---@param pickup Component.Entity.Pickup
---@return boolean
local function ShouldRender(pickup)
    return pickup.m_megaChestCollectible_parent.ref == nil
end

local FLIP_COLLECTIBLE_FLICKER_RNG = RNG(424658093, 31)

---@Bug: This specific render modifies state due to the RNG, meaning that two subsequent
---renders are not guaranteed to produce the same result.
---@param ctx any
local function render_flip_collectible(ctx)
    local pickup = ctx.pickup
    local flipSprite = pickup.m_flip_collectibleSprite
    local shouldRender = flipSprite.m_loaded and g.Game.m_level.m_room.m_entityList.m_renderMode ~= RenderMode.RENDER_WATER_REFLECT

    if not shouldRender then
        return
    end

    flipSprite.m_color.A = FLIP_COLLECTIBLE_FLICKER_RNG:RandomFloat() * 0.15 + 0.05
    local flipSpriteOffset = Vector(0.0, pickup.m_subtype == 0 and 0.0 or -2.6)
    ISprite.RenderLayer(flipSprite, 1, pickup.m_screenPosition + flipSpriteOffset, VECTOR_ZERO, VECTOR_ZERO)
    ctx.collectibleOffset = 2.6
end

local function render_pedestal(ctx)
    local pickup = ctx.pickup
    local mySprite = pickup.m_sprite

    local collectibleLayer = ISprite.GetLayer_Idx(mySprite, 1)
    collectibleLayer.m_isVisible = false
    IAnimationState.Render(mySprite.m_overlayAnimState, pickup.m_screenPosition, VECTOR_ZERO, VECTOR_ZERO)
    IAnimationState.Render(mySprite.m_animState, pickup.m_screenPosition, VECTOR_ZERO, VECTOR_ZERO)
    collectibleLayer.m_isVisible = true
end

local function render_mega_chest_collectibles(ctx)
    local pickup = ctx.pickup
    local mySprite = pickup.m_sprite

    if pickup.m_megaChestCollectible_child.ref ~= nil then
        local position = pickup.m_screenPosition + IsaacUtils.WorldToScreenDistance(mySprite.m_scale * Vector(-16.0, 0.0))
        ISprite.RenderLayer(mySprite, 1, position, VECTOR_ZERO, VECTOR_ZERO)
        position = pickup.m_screenPosition + IsaacUtils.WorldToScreenDistance(mySprite.m_scale * Vector(16.0, 0.0))
        ISprite.RenderLayer(pickup.m_megaChestCollectible_child.ref.m_sprite, 1, position, VECTOR_ZERO, VECTOR_ZERO)
    end
end

local function render_collectible(ctx)
    local pickup = ctx.pickup
    local position = pickup.m_screenPosition + ctx.collectibleOffset
    ISprite.RenderLayer(pickup.m_sprite, 1, position, VECTOR_ZERO, VECTOR_ZERO)
end

---@param pickup Component.Entity.Pickup
---@param offset Vector
local function RenderEntity(pickup, offset)
    local ctx = {
        pickup = pickup,
        collectibleOffset = 0.0
    }

    render_flip_collectible(ctx)
    render_pedestal(ctx)
    Behavior.first_of({render_mega_chest_collectibles, render_collectible}, ctx)
end

---@class Pickup.Render.Collectible
local Module = {}

--#region Module

Module.ShouldRender = ShouldRender
Module.RenderEntity = RenderEntity

--#endregion

return Module