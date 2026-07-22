---@class Interface.ImageManager
local Interface = require("Engine.Interface.ImageManager")

--#region Stub

local Stub = {}

---@param imageManager Engine.ImageManager
---@param param_2 unknown
function Stub.FreeImage(imageManager, param_2) end

---@param imageManager Engine.ImageManager
function Stub.Shutdown(imageManager) end

---@param imageManager Engine.ImageManager
---@param param_2 string
---@param param_3 unknown
---@param param_4 string
---@return Engine.Image
function Stub.LoadImage(imageManager, param_2, param_3, param_4) end

---@param imageManager Engine.ImageManager
---@param width integer
---@param height integer
---@param name string
---@param color KColor
---@return Engine.ProceduralImage
function Stub.CreateProceduralImage(imageManager, width, height, name, color) end

function Stub.clear_frame_images() end

function Stub.apply_frame_images() end

--#endregion

Interface.FreeImage = Stub.FreeImage
Interface.Shutdown = Stub.Shutdown
Interface.LoadImage = Stub.LoadImage
Interface.CreateProceduralImage = Stub.CreateProceduralImage
Interface.clear_frame_images = Stub.clear_frame_images
Interface.apply_frame_images = Stub.apply_frame_images