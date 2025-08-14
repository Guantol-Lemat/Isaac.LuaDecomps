---@class Decomp.Data.XmlData
local XmlData = {}
Decomp.Data.XmlData = XmlData

local s_XmlData = {}

---@alias Decomp.Xml.Node table<string, string> | Decomp.Xml.ChildNode[]

---@class Decomp.Xml.ChildNode
---@field name string
---@field node Decomp.Xml.Node

local s_Documents = {
    ["bossportraits.xml"] = {}
}

---@param filePath string
---@return Decomp.Xml.ChildNode[]?
local function GetXmlData(filePath)
    return s_XmlData[filePath]
end

---@param fileName string
---@param mod Decomp.ModManager.ModEntry?
---@return table?
local function GetDocument(fileName, mod)
    local documents = s_Documents[fileName]
    if not documents then
        return
    end

    if not mod then
        return documents[1]
    end

    return documents[mod]
end

---@param node Decomp.Xml.Node
---@param name string?
---@return Decomp.Xml.ChildNode?
local function first_node(node, name)
    if not string then
        return node[1]
    end

    for _, childNode in ipairs(node) do
        if childNode.name == name then
            return childNode
        end
    end
end

---@param value string?
---@return number?
local function read_number(value)
    return value and tonumber(value)
end

---@param value string?
---@return integer?
local function read_integer(value)
    local int = value and tonumber(value)
    return math.type(int) == "integer" and int or nil
end

---@param value string?
---@return boolean?
local function read_boolean(value)
    if not value then
        return
    end

    if value == "true" or value == "True" then
        return true
    end

    local integer = read_integer(value)
    return (not not integer) and integer ~= 0
end

--#region BossPortraits

local BossPortraits = {}

---@class Decomp.Xml.BossPortraits.Document
---@field root Decomp.Xml.BossPortraits.Root?

---@param document Decomp.Xml.ChildNode[]
function BossPortraits.Document(document)
    ---@type Decomp.Xml.BossPortraits.Document
    local doc = {
        root = nil
    }

    local rootNode = first_node(document, "bosses")
    if rootNode then
        doc.root = BossPortraits.Root(rootNode.node)
    end

    return doc
end

---@class Decomp.Xml.BossPortraits.Root
---@field gfxRootDirectory string?
---@field vsScreenAnm2Path string?
---@field bosses Decomp.Xml.BossPortraits.Boss[]

---@param node Decomp.Xml.Node
---@return Decomp.Xml.BossPortraits.Root
function BossPortraits.Root(node)
    ---@type Decomp.Xml.BossPortraits.Root
    local root = {
        gfxRootDirectory = node.root,
        vsScreenAnm2Path = node.anm2,
        bosses = {}
    }

    for _, childNode in ipairs(node) do
        table.insert(root.bosses, BossPortraits.Boss(childNode.node)) -- all child nodes are considered to be boss nodes regardless of name
    end

    return root
end

---@class Decomp.Xml.BossPortraits.Boss
---@field id integer?
---@field name string?
---@field vsNamePath string?
---@field vsPortraitPath string?
---@field pivotX number?
---@field pivotY number?
---@field achievement integer?
---@field alts Decomp.Xml.BossPortraits.BossAlt[]

---@param node Decomp.Xml.Node
---@return Decomp.Xml.BossPortraits.Boss
function BossPortraits.Boss(node)
    ---@type Decomp.Xml.BossPortraits.Boss
    local boss = {
        id = read_integer(node.id),
        name = node.name,
        vsNamePath = node.nameimage,
        vsPortraitPath = node.portrait,
        pivotX = read_number(node.pivotX),
        pivotY = read_number(node.pivotY),
        achievement = read_integer(node.achievement),
        alts = {}
    }

    for _, childNode in ipairs(node) do
        if childNode.name == "alt" then
            table.insert(boss.alts, BossPortraits.BossAlt(childNode.node))
        end
    end

    return boss
end

---@class Decomp.Xml.BossPortraits.BossAlt
---@field stageId integer?
---@field vsPortraitPath string?

---@param node Decomp.Xml.Node
---@return Decomp.Xml.BossPortraits.BossAlt
function BossPortraits.BossAlt(node)
    ---@type Decomp.Xml.BossPortraits.BossAlt
    local bossAlt = {
        stageId = read_integer(node.stage),
        vsPortraitPath = node.portrait,
    }

    return bossAlt
end

--#endregion

--#region Module

---@param filePath string
---@return Decomp.Xml.ChildNode[]?
function XmlData.GetXmlData(filePath)
    return GetXmlData(filePath)
end

---@param fileName string
---@param mod Decomp.ModManager.ModEntry?
---@return table?
function XmlData.GetDocument(fileName, mod)
    return GetDocument(fileName, mod)
end

--#endregion