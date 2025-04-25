---@class Decomp.Xml.EntityConfig
local EntityConfigXml = {}
Decomp.Data.EntityConfigXml = EntityConfigXml

local Table = require("Lib.Table")
require("Data.XmlData")
require("Entity.EntityConfig")

local Lib = Decomp.Lib
local XmlData = Decomp.Data.XmlData
local Class = Decomp.Class

---#region BossPortraits.xml

---@param entityConfig Decomp.Class.EntityConfig.Data
---@param gfxRoot string?
---@param xml Decomp.Xml.BossPortraits.Boss
local function init_boss_from_xml(entityConfig, gfxRoot, xml)
    if not xml.id or not (0 <= xml.id or xml.id <= #entityConfig.m_Bosses - 1) then
        return
    end

    local boss = entityConfig.m_Bosses[xml.id - 1]
    boss.m_Name = xml.name or ""
    boss.m_VsNamePath = xml.vsNamePath and gfxRoot .. xml.vsNamePath or ""
    boss.m_VsPortraitPath = xml.vsPortraitPath and gfxRoot .. xml.vsPortraitPath or ""
    local pivotX = xml.pivotX and 96.0 - xml.pivotX or 0.0
    local pivotY = xml.pivotY and 132.0 - xml.pivotY or 0.0
    boss.m_Pivot = Vector(pivotX, pivotY)
    boss.m_Achievement = xml.achievement or 0
    boss.m_Alts = {}

    for index, altXml in ipairs(xml.alts) do
        local alt = Class.EntityConfig.BossAlt.new()
        alt.m_StageId = altXml.stageId or 0
        alt.m_VsPortraitPath = altXml.vsPortraitPath and gfxRoot .. altXml.vsPortraitPath or ""
        table.insert(boss.m_Alts, alt)
    end
end

---@param entityConfig Decomp.Class.EntityConfig.Data
local function LoadBosses(entityConfig) -- No mods can load bosses
    ---@type Decomp.Xml.BossPortraits.Document?
    local doc = XmlData.GetDocument("bossportraits.xml")
    if not doc then
        return
    end

    local root = doc.root
    if not root then
        return
    end

    Table.ResizeArray(entityConfig.m_Bosses, 104, Class.BossPool.Boss.new)

    for _, boss in ipairs(root.bosses) do
        init_boss_from_xml(entityConfig, root.gfxRootDirectory or "", boss)
    end
end

--#endregion

--#region Module

---@param entityConfig Decomp.Class.EntityConfig.Data
function EntityConfigXml.LoadBosses(entityConfig) -- EntityConfig::LoadBosses
    LoadBosses(entityConfig)
end

--#endregion