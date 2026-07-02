--#region Dependencies



--#endregion

---@class Lib.XML.Document
---@field [string] Lib.XML.Node -- top level element

---@class Lib.XML.Node
---@field m_name string
---@field m_attributes table<string, string> | nil
---@field m_children Lib.XML.Node[] | nil
---@field m_value string | nil -- text content

---@param file Engine.File
---@return Lib.XML.Document
local function Parse(file) end

---@param nodes Lib.XML.Node[]
---@param name string
---@return Lib.XML.Node? node
---@return integer? i
local function FirstNode(nodes, name)
end

---@param nodes Lib.XML.Node[]
---@param name string
---@return Lib.XML.Node? node
---@return integer? i
local function NextSibling(nodes, i, name)
end

---@param value string
---@return integer
local function ToInt(value) end

---@param value string
---@return number
local function ToFloat(value) end

---@param value string
---@return boolean
local function ToBool(value) end

---@class Lib.XML
local Module = {}

--#region Module

Module.Parse = Parse
Module.FirstNode = FirstNode
Module.NextSibling = NextSibling
Module.ToInt = ToInt
Module.ToFloat = ToFloat
Module.ToBool = ToBool

--#endregion

return Module