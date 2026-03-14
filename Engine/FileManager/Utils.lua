--#region Dependencies



--#endregion

---@param path string
---@return string
local function GetMountedFilePath(path)
end

---@param path string
---@return boolean
local function Exists(path)
    return GetMountedFilePath(path) ~= nil
end

local Module = {}

--#region Module

Module.GetMountedFilePath = GetMountedFilePath
Module.Exists = Exists

--#endregion

return Module