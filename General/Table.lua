---@class TableUtils
local Module = {}

---@param tbl table
---@return table dictionary
local function CreateDictionary(tbl)
    local dictionary = {}
    for _, value in ipairs(tbl) do
        dictionary[value] = true
    end

    return dictionary
end

---@param tbl table
---@param newSize integer
---@param constructor function
local function Vector_Resize(tbl, newSize, constructor, ...)
    local currentSize = #tbl

    if currentSize > newSize then
        for i = newSize + 1, currentSize, 1 do
            tbl[i] = nil
        end
    elseif currentSize < currentSize then
        for i = currentSize + 1, newSize, 1 do
            tbl[i] = constructor(...)
        end
    end
end

--#region Module

Module.CreateDictionary = CreateDictionary
Module.Vector_Resize = Vector_Resize

--#endregion

return Module