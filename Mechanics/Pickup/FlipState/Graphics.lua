--#region Dependencies

local SpriteUtils = require("General.Sprite")
local RoomUtils = require("Room.Utils")
local PickupGraphicRules = require("Entity.Pickup.Graphics.Rules")
local PickupRules = require("Entity.Pickup.Rules")
local CollectibleSprite = require("Entity.Pickup.Sprite.Collectible")

--#endregion

---@class FlipStateGraphics
local Module = {}

---@param context Context
---@param pickup EntityPickupComponent
---@param hasFlip boolean
local function handle_sprite_setup(context, pickup, hasFlip)
    local shouldShow = true
    if not hasFlip or not pickup.m_flipState or pickup.m_variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        shouldShow = false
    end

    local sprite = pickup.m_flipCollectibleSprite
    if shouldShow == sprite:IsLoaded() then
        return
    end

    if not shouldShow then
        sprite:Reset()
        return
    end

    sprite = SpriteUtils.Copy(pickup.m_sprite)
    pickup.m_flipCollectibleSprite = sprite

    local isBlind = PickupRules.IsBlindEffectActive(context)
    local layer = CollectibleSprite.Layers.COLLECTIBLE
    local collectible = pickup.m_flipState.subtype
    local seed = pickup.m_flipState.initSeed
    PickupGraphicRules.SetupCollectibleGraphics(context, sprite, layer, collectible, seed, isBlind)

    sprite:LoadGraphics()
    local animation = pickup.m_sprite:GetAnimation()
    sprite:Play(animation, true)
end

---@param context Context
---@param pickup EntityPickupComponent
---@param hasFlip boolean
local function UpdateGraphics(context, pickup, hasFlip)
    handle_sprite_setup(context, pickup, hasFlip)
    pickup.m_flipCollectibleSprite:Update()
end

---@return RNG
local function __init_flicker_rng()
    local rng = RNG(); rng:SetSeed(424658093, 31)
    return rng
end

---@param context Context
---@param pickup EntityPickupComponent
---@return number collectibleLayerOffset
local function RenderGraphics(context, pickup, screenPosition)
    local sprite = pickup.m_flipCollectibleSprite
    local room = context:GetRoom()

    if not sprite:IsLoaded() or RoomUtils.GetRenderMode(room) == RenderMode.RENDER_WATER_REFLECT then
        return 0.0
    end

    local static = context:GetStaticContext()

    local rng = static.FLIP_COLLECTIBLE_FLICKER_RNG
    local alpha = rng:RandomFloat() * 0.15 + 0.5
    sprite.Color.A = alpha

    local layer = CollectibleSprite.Layers.COLLECTIBLE
    local positionOffset = pickup.m_subtype == 0 and 0.0 or -2.6
    screenPosition = screenPosition + positionOffset
    sprite:RenderLayer(layer, screenPosition, Vector(0, 0), Vector(0, 0))

    return 2.6
end

--#region Module

Module.UpdateGraphics = UpdateGraphics
Module.RenderGraphics = RenderGraphics
Module.__init_flicker_rng = __init_flicker_rng

--#endregion

return Module