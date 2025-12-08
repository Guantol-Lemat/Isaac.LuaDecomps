--#region Dependencies

local BitsetUtils = require("General.Bitset")
local ImageEnums = require("Admin.Graphics.Image.Enums")
local ImageRender = require("Admin.Graphics.Image.Render")

local eImageFlags = ImageEnums.eImageFlags

--#endregion

---@class ImageAdminLogic
local Module = {}

---@param admin ImageAdminComponent
---@param image ImageComponent
local function add_frame_image(admin, image)
    if image.m_quadBatchIsTransparent then
        return
    end

    if BitsetUtils.HasAny(image.m_flags, eImageFlags.FRAME_IMAGE_ADDED) then
        return
    end

    table.insert(admin.m_opaqueBatches, image)
    image.m_flags = BitsetUtils.Set(image.m_flags, eImageFlags.FRAME_IMAGE_ADDED)
end

---@param admin ImageAdminComponent
---@param image ImageComponent
---@param batch RenderBatchComponent
local function set_transparent_batch(admin, image, batch)
    ---@type Pair<RenderBatchComponent, ImageComponent>
    local transparentBatch = {batch, image}
    local lastBatch = admin.m_lastTransparentBatch

    if lastBatch[1] == transparentBatch[1] then
        return
    end

    if lastBatch[2] then
        lastBatch[2].m_lastTransparentRenderBatch = nil
    end

    table.insert(admin.m_transparentBatches, transparentBatch)
    admin.m_lastTransparentBatch = transparentBatch -- should theoretically copy but these are read only value
end

---@param context ImageAdminContext.apply_frame_images
---@param admin ImageAdminComponent
local function apply_frame_images(context, admin)
    local graphics = context.graphics

    local opaqueBatches = admin.m_opaqueBatches
    local transparentBatches = admin.m_transparentBatches
    local drawnImages = admin.m_drawnImages

    -- draw opaque images
    for i = 1, opaqueBatches, 1 do
        local image = opaqueBatches[i]

        ImageRender.EndBatch(context, image)
        image:apply_image()

        if not BitsetUtils.HasAny(image.m_flags, eImageFlags.DRAWN) then
            table.insert(drawnImages, image)
            BitsetUtils.Set(image.m_flags, eImageFlags.DRAWN)
        end
    end

    -- draw transparent images
    for i = 1, transparentBatches, 1 do
        local transparentBatch = transparentBatches[i]
        local batch = transparentBatch[1]
        local image = transparentBatch[2]

        ImageRender.EndBatch(context, image)
        ImageRender.DrawBatch(context, image, batch, true)

        if not BitsetUtils.HasAny(image.m_flags, eImageFlags.DRAWN) then
            table.insert(drawnImages, image)
            BitsetUtils.Set(image.m_flags, eImageFlags.DRAWN)
        end

        table.insert(image.m_reusableTransparentRenderBatches, batch)
    end

    -- reset
    admin.m_transparentBatches = {}
    if admin.m_lastTransparentBatch then
        admin.m_lastTransparentBatch[2].m_lastTransparentRenderBatch = nil
    end
    admin.m_lastTransparentBatch = nil

    if not graphics.m_renderTargetTexture then
        for i = 1, drawnImages, 1 do
            local image = drawnImages[i]
            image:SwapBatches()
        end
    end
end

--#region Module

Module.add_frame_image = add_frame_image
Module.set_transparent_batch = set_transparent_batch
Module.apply_frame_images = apply_frame_images

--#endregion

return Module