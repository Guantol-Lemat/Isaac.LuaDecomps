---@class Decomp.Class.EntityConfig
local Class_EntityConfig = {}
Decomp.Class.EntityConfig = Class_EntityConfig

---@class Decomp.EntityConfig.Boss
---@field m_BossId BossType | integer
---@field m_Name string
---@field m_VsNamePath string
---@field m_VsPortraitPath string
---@field m_Pivot Vector
---@field m_Achievement Achievement | integer
---@field m_Alts Decomp.EntityConfig.BossAlt[]

Class_EntityConfig.Boss = {}

---@return Decomp.EntityConfig.Boss
function Class_EntityConfig.Boss.new()
    ---@type Decomp.EntityConfig.Boss
    local boss = {
        m_BossId = 0,
        m_Name = "",
        m_VsNamePath = "",
        m_VsPortraitPath = "",
        m_Pivot = Vector(0, 0),
        m_Achievement = 0,
        m_Alts = {},
    }

    return boss
end

---@class Decomp.EntityConfig.BossAlt
---@field m_StageId StbType | integer
---@field m_VsPortraitPath string

Class_EntityConfig.BossAlt = {}

---@return Decomp.EntityConfig.BossAlt
function Class_EntityConfig.BossAlt.new()
    ---@type Decomp.EntityConfig.BossAlt
    local bossAlt = {
        m_StageId = 0,
        m_VsPortraitPath = "",
    }

    return bossAlt
end

---@class Decomp.Class.EntityConfig.Data
---@field m_Bosses Decomp.EntityConfig.Boss[]

---@return Decomp.Class.EntityConfig.Data
function Class_EntityConfig.new()
    ---@type Decomp.Class.EntityConfig.Data
    local entityConfig = {
        m_Bosses = {}
    }

    for i = 1, 104, 1 do
        local boss = Class_EntityConfig.Boss.new()
        boss.m_BossId = i - 1
        entityConfig.m_Bosses = boss
    end

    return entityConfig
end

--#region Class

function Class_EntityConfig.LoadBosses()
end

--#endregion