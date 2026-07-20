---@class Interface.FileManager
local Interface = require("Engine.Interface.FileManager")

--#region Stub

local Stub = {}

---@param fileManager Engine.FileManager
---@param filepath string
---@return string
function Stub.GetMountedFilePath(fileManager, filepath) end

---@param fileManager Engine.FileManager
function Stub.Initialize(fileManager) end

---@param fileManager Engine.FileManager
function Stub.Shutdown(fileManager) end

---@param filepath string
---@param param_2 integer
---@param filecount_qqq integer
function Stub.LoadArchiveFile(filepath, param_2, filecount_qqq) end

---@param fileManager Engine.FileManager
---@param filename string
---@return Engine.File?
function Stub.OpenRead(fileManager, filename) end

---@param fileManager Engine.FileManager
---@param filePath string
---@return boolean
---@return Engine.File
function Stub.TryOpenArchive(fileManager, filePath) end

---@param fileManager Engine.FileManager
---@param filePath string
---@return boolean
function Stub.Exists(fileManager, filePath) end

--#endregion

Interface.GetMountedFilePath = Stub.GetMountedFilePath
Interface.Initialize = Stub.Initialize
Interface.Shutdown = Stub.Shutdown
Interface.LoadArchiveFile = Stub.LoadArchiveFile
Interface.OpenRead = Stub.OpenRead
Interface.TryOpenArchive = Stub.TryOpenArchive
Interface.Exists = Stub.Exists