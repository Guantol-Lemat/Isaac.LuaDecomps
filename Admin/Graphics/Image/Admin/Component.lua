---@class ImageAdminComponent
---@field m_cachedImages table<string, ImageComponent> -- uses a custom hash, for the string and a vector of smart pointers for the images, but we don't need them in Lua
---@unused m_mutex -- unnecessary as we don't multi thread.
---@field m_opaqueBatches ImageComponent[]
---@field m_drawnImages ImageComponent[] -- already rendered images, need to be cleared
---@field m_transparentBatches Pair<RenderBatchComponent, ImageComponent>[]
---@field m_lastTransparentBatch Pair<RenderBatchComponent, ImageComponent>

---@class ImageAdminModule
local Module = {}

--#region Module

--#endregion

return Module