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

--#region Module

Module.CreateDictionary = CreateDictionary

--#endregion

return Module