---@class Decomp.Lib.Table
local Lib_Table = {}

---@param tbl table
---@return table inverted
local function InvertKeyValuePairs(tbl)
    local inverted = {}
    for key, value in pairs(tbl) do
        inverted[value] = key
    end
    return inverted
end

---@param tbl table
---@return table dictionary
local function CreateDictionary(tbl)
    local dictionary = {}
    for _, value in ipairs(tbl) do
        dictionary[value] = true
    end

    return dictionary
end

---@alias Decomp.Lib.Table.SchemaEntry table<type, function | boolean>

---@param tbl table
---@param schema Decomp.Lib.Table.SchemaEntry[]
---@return boolean isValid
local function ValidateSchema(tbl, schema)
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
---@param tbl T
---@param start integer
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
local function CircularIterator(tbl, start)
    if not (start > 0) then
        error(string.format("Invalid index for circular iterator '%s'", tostring(start)), 2)
    end

    local len = #tbl
    if len == 0 then
        return function() end, tbl, 0
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
    end, tbl, start
end

---@param array table
---@param newSize integer
---@param initFn function
---@param ... unknown
local function ResizeArray(array, newSize, initFn, ...)
    local size = #array
    if size >= newSize + 1 then
        for i = size, newSize + 1, -1 do
            array[i] = nil
        end
        return
    end

    if size < newSize then
        for i = size, newSize, 1 do
            array[i] = initFn(...)
        end
    end
end

--#region Module

---@param tbl table
---@return table inverted
function Lib_Table.InvertKeyValuePairs(tbl)
    return InvertKeyValuePairs(tbl)
end

---@param tbl table
---@return table dictionary
function Lib_Table.CreateDictionary(tbl)
    return CreateDictionary(tbl)
end

---@param tbl table
---@param schema Decomp.Lib.Table.SchemaEntry[]
function Lib_Table.ValidateSchema(tbl, schema)
    return ValidateSchema(tbl, schema)
end

---@generic T: table, V
---@param tbl T
---@param start integer
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function Lib_Table.CircularIterator(tbl, start)
    return CircularIterator(tbl, start)
end

---@param array table
---@param newSize integer
---@param initFn function
---@param ... unknown
function Lib_Table.ResizeArray(array, newSize, initFn, ...)
    return ResizeArray(array, newSize, initFn, ...)
end

--#endregion

return Lib_Table