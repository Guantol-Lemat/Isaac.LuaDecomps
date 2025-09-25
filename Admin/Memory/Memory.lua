---@class MemoryModule
local Module = {}

---@param size integer
---@return pointer
local function Allocate(size)
end

---@param dest pointer
---@param src pointer
---@param size integer
local function Copy(dest, src, size)
end

---@param type string
---@param ptr pointer
---@return pointer
local function Cast(type, ptr)
    
end

---@param luaObject table | userdata
---@return integer
local function GetLuaPtrHash(luaObject)
    local hex = ("%p"):format(luaObject)
    return tonumber(hex, 16)
end

--#region Module

Module.Allocate = Allocate
Module.Copy = Copy
Module.Cast = Cast
Module.GetLuaPtrHash = GetLuaPtrHash

--#endregion

return Module