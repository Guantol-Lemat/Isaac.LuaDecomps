--#region Dependencies

local TableUtils = require("General.Table")
local VectorUtils = require("General.Math.VectorUtils")
local EntityUtils = require("Entity.Utils")
local SeedsUtils = require("Admin.Seeds.Utils")

--#endregion

local NUM_TEAR_VARIANTS = 51

local TEAR_SCALE_THRESHOLDS = {
    0.0, 0.25, 0.5, 0.625, 0.75,
    0.875, 1.0, 1.125, 1.375, 1.625,
    1.875, 2.125, 2.5, 2.75,
}

local BLOOD_TEAR_VARIANTS = TableUtils.CreateDictionary({
    TearVariant.BLOOD, TearVariant.CUPID_BLOOD, TearVariant.PUPULA_BLOOD,
    TearVariant.GODS_FLESH_BLOOD, TearVariant.EYE_BLOOD, TearVariant.GLAUCOMA_BLOOD,
})

local TOOTH_TEAR_VARIANTS = TableUtils.CreateDictionary({
    TearVariant.TOOTH, TearVariant.BLACK_TOOTH,
})

local COIN_TEAR_VARIANTS = TableUtils.CreateDictionary({
    TearVariant.COIN
})

local STONE_TRAR_VARIANTS = TableUtils.CreateDictionary({
    TearVariant.STONE, TearVariant.BOOGER, TearVariant.EGG,
    TearVariant.RAZOR, TearVariant.BONE, TearVariant.SPORE,
})

---@class TearScaleLogic._SWITCH_ResetSpriteScaleReturns
---@field spriteSize number

---@alias TearScaleLogic._SWITCH_ResetSpriteScale fun(tear: EntityTearComponent, variant: TearVariant, returns: TearScaleLogic._SWITCH_ResetSpriteScaleReturns)

---@type TearScaleLogic._SWITCH_ResetSpriteScale
local function base_tear_sprite_scale(tear, variant, returns)
    local sizeId = 1
    local scale = tear.m_fScale
    local scaleCheck = variant * 100

    while sizeId < 13 do
        if scale <= TEAR_SCALE_THRESHOLDS[sizeId + 1] + 0.05 then
            break
        end
        sizeId = sizeId + 1
    end

    scaleCheck = scaleCheck + sizeId
    if tear.m_scaleAnimCheck ~= scaleCheck then
        local animFmt
        local animSizeId = sizeId
        if BLOOD_TEAR_VARIANTS[variant] then
            animFmt = "BloodTear%d"
        elseif TOOTH_TEAR_VARIANTS[variant] then
            animFmt = "Tooth%dMove"
            animSizeId = math.max(sizeId/2, 1)
        elseif COIN_TEAR_VARIANTS[variant] then
            animFmt = "Rotate%d"
            animSizeId = math.max(sizeId/2, 1)
        elseif STONE_TRAR_VARIANTS[variant] then
            animFmt = "Stone%dMove"
            animSizeId = math.max(sizeId/2, 1)
        else
            animFmt = "RegularTear%d"
        end
        local animation = string.format(animFmt, animSizeId)
        tear.m_sprite:Play(animation, false)
        tear.m_scaleAnimCheck = scaleCheck
    end

    local spriteSize
    if (sizeId < 13) then
        if tear.m_tearFlags & (TearFlags.TEAR_GROW | TearFlags.TEAR_LUDOVICO) == 0 then
            spriteSize = 1.0
        else
            spriteSize = scale / TEAR_SCALE_THRESHOLDS[sizeId + 1]
        end
    else
        spriteSize = scale / TEAR_SCALE_THRESHOLDS[13 + 1]
    end

    returns.spriteSize = spriteSize
end

---@type TearScaleLogic._SWITCH_ResetSpriteScale
local function default_sprite_scale(tear, variant, returns)
    local scaleCheck = variant * 100
    if tear.m_scaleAnimCheck ~= scaleCheck then
        tear.m_sprite:Play("Idle", false)
        tear.m_scaleAnimCheck = scaleCheck
    end
end

-- TODO: Non base tear sprite scale functions
local switch_ResetSpriteScale = {
    [TearVariant.BLUE] = base_tear_sprite_scale,
    [TearVariant.BLOOD] = base_tear_sprite_scale,
    [TearVariant.TOOTH] = base_tear_sprite_scale,
    [TearVariant.METALLIC] = base_tear_sprite_scale,
    [TearVariant.LOST_CONTACT] = base_tear_sprite_scale,
    [TearVariant.CUPID_BLUE] = base_tear_sprite_scale,
    [TearVariant.CUPID_BLOOD] = base_tear_sprite_scale,
    [TearVariant.NAIL] = base_tear_sprite_scale,
    [TearVariant.PUPULA] = base_tear_sprite_scale,
    [TearVariant.PUPULA_BLOOD] = base_tear_sprite_scale,
    [TearVariant.GODS_FLESH] = base_tear_sprite_scale,
    [TearVariant.GODS_FLESH_BLOOD] = base_tear_sprite_scale,
    [TearVariant.DIAMOND] = base_tear_sprite_scale,
    [TearVariant.EXPLOSIVO] = base_tear_sprite_scale,
    [TearVariant.COIN] = base_tear_sprite_scale,
    [TearVariant.MULTIDIMENSIONAL] = base_tear_sprite_scale,
    [TearVariant.STONE] = base_tear_sprite_scale,
    [TearVariant.NAIL_BLOOD] = base_tear_sprite_scale,
    [TearVariant.GLAUCOMA] = base_tear_sprite_scale,
    [TearVariant.GLAUCOMA_BLOOD] = base_tear_sprite_scale,
    [TearVariant.BOOGER] = base_tear_sprite_scale,
    [TearVariant.EGG] = base_tear_sprite_scale,
    [TearVariant.RAZOR] = base_tear_sprite_scale,
    [TearVariant.BONE] = base_tear_sprite_scale,
    [TearVariant.BLACK_TOOTH] = base_tear_sprite_scale,
    [TearVariant.NEEDLE] = base_tear_sprite_scale,
    [TearVariant.BELIAL] = base_tear_sprite_scale,
    [TearVariant.EYE] = base_tear_sprite_scale,
    [TearVariant.EYE_BLOOD] = base_tear_sprite_scale,
    [TearVariant.BALLOON] = base_tear_sprite_scale,
    [TearVariant.HUNGRY] = base_tear_sprite_scale,
    [TearVariant.BALLOON_BRIMSTONE] = base_tear_sprite_scale,
    [TearVariant.BALLOON_BOMB] = base_tear_sprite_scale,
    [TearVariant.FIST] = base_tear_sprite_scale,
    [TearVariant.ICE] = base_tear_sprite_scale,
    [TearVariant.SPORE] = base_tear_sprite_scale,
    default = default_sprite_scale
}

---@param myContext Context.Seeds
---@param tear EntityTearComponent
local function reset_sprite_scale(myContext, tear)
    local seeds = myContext.seeds

    ---@type TearVariant
    local variant = tear.m_variant
    local baseSpriteSize = 1.0

    local switch = switch_ResetSpriteScale[variant] or switch_ResetSpriteScale.default
    ---@type TearScaleLogic._SWITCH_ResetSpriteScaleReturns
    local switchReturns = {
        spriteSize = baseSpriteSize
    }
    switch(tear, variant, switchReturns)

    baseSpriteSize = switchReturns.spriteSize
    local sizeMultiplier = VectorUtils.Copy(tear.m_sizeMulti)
    local sprite = tear.m_sprite

    if variant >= NUM_TEAR_VARIANTS then
        baseSpriteSize = tear.m_fScale
    end

    if variant == TearVariant.NAIL or variant == TearVariant.NAIL_BLOOD then
        if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL) then
            sizeMultiplier.X = sizeMultiplier.X / 3.0
        end
    end

    -- Set Sprite Size
    local spriteSize = sizeMultiplier * baseSpriteSize
    local layers = sprite:GetAllLayers()
    for i = 1, #layers, 1 do
        local layer = layers[i]
        layer:SetSize(spriteSize)
    end

    -- Effects Sprite Scale
    local effectsScale = sizeMultiplier * (tear.m_fScale * 0.45)

    if (tear.m_tearFlags & TearFlags.TEAR_GLOW) ~= 0 then
        local glowSprite = tear.m_tearGlowSprite
        glowSprite.Scale = effectsScale
        glowSprite:Update()
    end

    local effectSprite = tear.m_tearEffectSprite
    if effectSprite:IsLoaded() then
        effectSprite.Scale = effectsScale
        effectSprite:Update()
    end

    if tear.m_deadEye_sprite ~= 0.0 then
        local deadEyeSprite = tear.m_deadEye_sprite
        deadEyeSprite.Scale = effectsScale
        deadEyeSprite:Update()
    end

    local config = tear.m_config
    EntityUtils.SetSize(tear, config.collisionRadius * tear.m_fScale, tear.m_sizeMulti, config.gridCollisionPoints)
    tear.m_shadowSize = config.shadowSize * tear.m_fScale * (sizeMultiplier.X + sizeMultiplier.Y) * 0.5
end

---@param myContext Context.Seeds
---@param tear EntityTearComponent
---@param scale number
local function SetScale(myContext, tear, scale)
    scale = math.max(scale, 0.01)
    tear.m_baseScale = scale
    tear.m_fScale = scale
    reset_sprite_scale(myContext, tear)
end

---@param myContext Context.Game
---@param tear EntityTearComponent
---@param height number
local function SetHeight(myContext, tear, height)
end

---@param tear EntityTearComponent
---@param flags TearFlags | BitSet128
local function SetTearFlags(tear, flags)
end

local Module = {}

--#region Module

Module.SetScale = SetScale
Module.SetHeight = SetHeight
Module.SetTearFlags = SetTearFlags

--#endregion

return Module