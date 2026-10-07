--#region Dependencies

local G = require("Isaac.Global")
local C = require("Isaac.Constants")

local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils.Common")
local ColorUtils = require("General.VanillaAPI.Color")
local ISprite = require("Isaac.Interface.ANM2")
local IEntity = require("Isaac.Interface.Entity")

local eShaderType = Renderer.ShaderType

--#endregion

local NO_TARGET_Z = 0xFFFFFFFF

---@alias EntityList.Switch.RenderSlice fun(entity: Component.Entity, offset: Vector)

local function switch_break() return end

---@type EntityList.Switch.RenderSlice
local function render_slice_default(entity, offset)
    entity:Render(offset)
end

local WATER_ABOVE_FLAG_MASK = WaterClipFlag.DISABLE_RENDER_ABOVE_WATER | WaterClipFlag.IGNORE_WATER_RENDERING
local WATER_ABOVE_FLAG_STATE_FALSE = WaterClipFlag.DISABLE_RENDER_ABOVE_WATER

---@type EntityList.Switch.RenderSlice
local function render_slice_water_above(entity, offset)
    if (IEntity.GetWaterClipInfo(entity).flags & WATER_ABOVE_FLAG_MASK) == WATER_ABOVE_FLAG_STATE_FALSE then
        return
    end

    entity:Render(offset)
end

local WATER_REFRACT_BLOCK_FLAG_MASK = WaterClipFlag.DISABLE_RENDER_BELOW_WATER | WaterClipFlag.IGNORE_WATER_RENDERING
local WATER_REFRACT_ALLOW_FLAG_MASK = WaterClipFlag.DISABLE_RENDER_ABOVE_WATER | WaterClipFlag.ENABLE_RENDER_BELOW_WATER

---@type EntityList.Switch.RenderSlice
local function render_slice_water_refract(entity, offset)
    local waterClipInfo = IEntity.GetWaterClipInfo(entity)
    if (waterClipInfo.flags & WATER_REFRACT_BLOCK_FLAG_MASK) ~= 0 then
        return
    end

    if (waterClipInfo.flags & WATER_REFRACT_ALLOW_FLAG_MASK) == 0 then
        return
    end

    entity:Render(offset)
end

local WATER_REFLECT_BLOCK_FLAG_MASK = WaterClipFlag.DISABLE_RENDER_REFLECTION | WaterClipFlag.IGNORE_WATER_RENDERING

---@type EntityList.Switch.RenderSlice
local function render_slice_water_reflect(entity, offset)
    local waterClipInfo = IEntity.GetWaterClipInfo(entity)
    if (waterClipInfo.flags & WATER_REFLECT_BLOCK_FLAG_MASK) ~= 0 then
        return
    end

    local baseOffset = Vector(0.0, 0.0)
    if entity.m_type == EntityType.ENTITY_PLAYER and IEntity.IsFlying(entity) then
        baseOffset.Y = 4.0
    end

    local originalPositionOffset = VectorUtils.Copy(entity.m_positionOffset)
    entity.m_positionOffset.Y = -entity.m_positionOffset.Y
    ISprite.BeginReflectionRendering()

    entity:Render(baseOffset + offset)

    ISprite.EndReflectionRendering()
    VectorUtils.Assign(entity.m_positionOffset, originalPositionOffset)
end

---@type table<RenderMode, EntityList.Switch.RenderSlice>
local Switch_RenderSlice = {
    [RenderMode.RENDER_NORMAL] = render_slice_default,
    [RenderMode.RENDER_SKIP] = switch_break,
    [RenderMode.RENDER_WATER_ABOVE] = render_slice_water_above,
    [RenderMode.RENDER_WATER_REFRACT] = render_slice_water_refract,
    [RenderMode.RENDER_WATER_REFLECT] = render_slice_water_reflect,
}

---@param entityList Component.EntityList
---@param targetZ integer
---@param offset Vector
local function RenderSlice(entityList, targetZ, offset)
    local start = entityList.m_entitiesRendered + 1
    for i = start, #entityList.m_renderEL, 1 do
        local entity = entityList.m_renderEL[i]
        if (targetZ <= entity:GetRenderZ()) then
            return
        end

        local switch = Switch_RenderSlice[entityList.m_renderMode] or render_slice_default
        switch(entity, offset)

        entityList.m_entitiesRendered = entityList.m_entitiesRendered + 1
    end
end

---@param entityList Component.EntityList
---@param offset Vector
local function RenderShadows(entityList, offset)
    local game = G.Game

    local texture = entityList.m_shadowImage
    local textureSize = Vector(texture:GetWidth(), texture:GetHeight())

    IsaacUtils.LoadShader(eShaderType.SHADER_COLOR_OFFSET)
    texture:BeginBatch(true)

    for i = 1, #entityList.m_renderEL, 1 do
        local entity = entityList.m_renderEL[i]
        local shouldRender = entity.m_visible and (entity.m_isDead == false or IEntity.IsEnemy(entity))
        if not shouldRender then
            goto continue
        end

        local override = entity:RenderShadowLayer(offset)
        if override then
            goto continue
        end

        local shadowSize = entity.m_shadowSize * entity.m_sprite.Scale.X
        if shadowSize < 0.001 then -- too small
            goto continue
        end

        local position = entity.m_position + entity.m_shadowOffset
        local renderPosition = (IsaacUtils.GetRenderPosition(position, true) + offset + game.m_screenShake_offset)
        local topLeft = renderPosition - (shadowSize * textureSize * 0.5)
        local bottomRight = topLeft + (shadowSize * textureSize);

        local dest = DestinationQuad.NewFromBounds(topLeft, bottomRight)
        local buffer = texture:Render_DestQuadFlatColor(dest, C.COLOR_WHITE)
        if buffer then
            ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, buffer, texture)
        end
        ::continue::
    end

    texture:EndBatch()
end

---@param entityList Component.EntityList
---@param renderMode RenderMode | integer
local function RenderStart(entityList, renderMode)
    entityList.m_entitiesRendered = 0
    entityList.m_renderMode = renderMode
end

---@param entityList Component.EntityList
---@param offset Vector
---@param renderFinalSlice boolean
local function RenderEnd(entityList, offset, renderFinalSlice)
    if renderFinalSlice then
        RenderSlice(entityList, NO_TARGET_Z, offset)
    end

    for i = 1, entityList.m_entitiesRendered, 1 do
        local entity = entityList.m_renderEL[i]
        entity:PostRender()
    end

    entityList.m_renderMode = RenderMode.RENDER_NULL
end

---@class EntityList.Render
local Module = {}

--#region Module

Module.RenderStart = RenderStart
Module.RenderEnd = RenderEnd
Module.RenderShadows = RenderShadows
Module.RenderSlice = RenderSlice

--#endregion

return Module