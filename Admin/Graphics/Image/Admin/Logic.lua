--#region Dependencies

local BitsetUtils = require("General.Bitset")
local ImageEnums = require("Admin.Graphics.Image.Enums")

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

    table.insert(admin.m_frameImages, image)
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

--#region Module

Module.add_frame_image = add_frame_image
Module.set_transparent_batch = set_transparent_batch

--#endregion

return Module