--#region Dependencies



--#endregion

---@class Lib.XML.Document

---@class Lib.XML.NodeRef
---@field node Lib.XML.Node
---@field idx integer

---@class Lib.XML.Node
---@field m_name string
---@field m_attributes table<string, string> | nil
---@field m_children Lib.XML.Node[] | nil
---@field m_value string | nil -- text content

---@param file Engine.File
---@return Lib.XML.Document
local function Parse(file) end

---@param nodes Lib.XML.Node[]
---@return Lib.XML.NodeRef?
local function FirstNode(nodes)
end

---@param nodes Lib.XML.Node[]
---@param name string
---@return Lib.XML.NodeRef?
local function FirstNode_Name(nodes, name)
end

---@param nodes Lib.XML.Node[]
---@param current Lib.XML.NodeRef
---@return Lib.XML.NodeRef?
local function NextSibling(nodes, current)
end

---@param nodes Lib.XML.Node[]
---@param current Lib.XML.NodeRef
---@param name string
---@return Lib.XML.NodeRef?
local function NextSibling_Name(nodes, current, name)
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
Module.FirstNode_Name = FirstNode_Name
Module.NextSibling = NextSibling
Module.NextSibling_Name = NextSibling_Name
Module.ToInt = ToInt
Module.ToFloat = ToFloat
Module.ToBool = ToBool

--#endregion

return Module