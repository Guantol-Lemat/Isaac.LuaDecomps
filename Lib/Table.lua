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

---@generic T: table, V
---@param t T
---@param start integer
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function Lib_Table.CircularIterator(t, start)
    if not (start > 0) then
        error(string.format("Invalid index for circular iterator '%s'", tostring(start)), 2)
    end

    local len = #t
    if len == 0 then
        return function() end, t, 0
    end

    start = ((start - 1) % len)
    local count = 0

    return function(t, i)
        local n = #t
        if count >= len then
            return i
        end

        i = (i % n) + 1
        local value = t[i]
        count = count + 1
        return i, value
    end, t, start
end