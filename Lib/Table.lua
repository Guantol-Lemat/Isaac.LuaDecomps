---@class Decomp.Lib.Table
local Lib_Table = {}
Decomp.Lib.Table = Lib_Table

---@param tbl table
---@return table dictionary
function Lib_Table.CreateDictionary(tbl)
    local dictionary = {}
    for _, value in ipairs(tbl) do
        dictionary[value] = true
    end

    return dictionary
end

---@alias Decomp.Lib.Table.SchemaEntry table<type, function | boolean>

---@param tbl table
---@param schema Decomp.Lib.Table.SchemaEntry[]
function Lib_Table.ValidateSchema(tbl, schema)
    for key, valueValidator in pairs(schema) do
        local value = tbl[key]
        local typeValidator = valueValidator[type(value)]

        if not typeValidator then
            return false
        end

        if type(typeValidator) == "function" and not typeValidator(value) then
            return false
        end
    end

    return true
end