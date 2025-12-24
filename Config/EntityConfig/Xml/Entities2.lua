--#region Dependencies

local XmlParser = require("General.Xml.Parser")
local XmlUtils = require("General.Xml.Utils")
local Log = require("General.Log")
local EntityConfigUtils = require("Config.EntityConfig.Utils")

--#endregion

---@class Entities2Parser
local Module = {}

---@class Xml.Entities2.Document : XmlDocument
---@field entities Xml.Entities2.Root

---@class Xml.Entities2.Root : XmlNode
---@field _attr Xml.Entities2.Root.Attributes
---@field _child Xml.Entities2.Node.Entity[]

---@class Xml.Entities2.Node.Entity : XmlNode
---@field _tag "entity"
---@field _attr Xml.Entities2.Node.Entity.Attributes
---@field _child Xml.Entities2.Node.Gib[] | Xml.Entities2.Node.Bestiary[] | Xml.Entities2.Node.Preload[] | Xml.Entities2.Node.PreloadSnd[] | Xml.Entities2.Node.Devolve[]

---@class Xml.Entities2.Node.Gib : XmlNode
---@field _tag "gibs"
---@field _attr Xml.Entities2.Node.Gib.Attributes

---@class Xml.Entities2.Node.Bestiary : XmlNode
---@field _tag "bestiary"
---@field _attr Xml.Entities2.Node.Bestiary.Attributes

---@class Xml.Entities2.Node.Preload : XmlNode
---@field _tag "preload"
---@field _attr Xml.Entities2.Node.Preload.Attributes

---@class Xml.Entities2.Node.PreloadSnd : XmlNode
---@field _tag "preload-snd"
---@field _attr Xml.Entities2.Node.PreloadSnd.Attributes

---@class Xml.Entities2.Node.Devolve : XmlNode
---@field _tag "devolve"
---@field _attr Xml.Entities2.Node.Devolve.Attributes

---@class Xml.Entities2.Root.Attributes
---@field version string? -- integer
---@field anm2root string?
---@field deathanm2 string?

---@class Xml.Entities2.Node.Entity.Attributes
---@field id string? -- integer
---@field variant string? -- integer
---@field subtype string? -- integer
---@field shadowSize string? -- integer
---@field name string?
---@field collisionDamage string? -- number
---@field boss string? -- boolean
---@field bossID string? -- integer
---@field champion string? -- boolean
---@field collisionRadius string? -- number
---@field collisionRadiusXMulti string? -- number
---@field collisionRadiusYMulti string? -- number
---@field collisionMass string? -- number
---@field numGridCollisionPoints string? -- integer
---@field friction string? -- number
---@field baseHP string? -- number
---@field stageHP string? -- number
---@field anm2path string?
---@field portrait string? -- integer
---@field shutdoors string? -- boolean
---@field gridCollision string?
---@field reroll string? -- boolean
---@field hasFloorAlts string? -- boolean
---@field collisionInterval string? -- integer
---@field shieldStrength string? -- number
---@field shieldFrames string? -- integer
---@field tags string?
---@field bestiary string? -- boolean
---@field bestiaryTransform string?
---@field bestiaryAnim string?
---@field bestiaryOverlay string?
---@field gibAmount string? -- integer
---@field gibFlags string?

---@param entity EntityConfig.EntityComponent
---@param node Xml.Entities2.Node.Entity
local function parse_entity(entity, node)
    local attributes = node._attr

    local id = attributes.id
    if id then
        entity.id = XmlUtils.ToInteger(id)
    end

    local variant = attributes.variant
    if variant then
        entity.variant = XmlUtils.ToInteger(variant)
    end

    local subtype = attributes.subtype
    if subtype then
        entity.subtype = XmlUtils.ToInteger(subtype)
    end

    local shadowSize = attributes.shadowSize
    if shadowSize then
        entity.shadowSize = XmlUtils.ToInteger(shadowSize) / 100.0
    end

    local name = attributes.name
    if name then
        entity.name = name
    end

    local collisionDamage = attributes.collisionDamage
    if collisionDamage then
        entity.collisionDamage = XmlUtils.ToFloat(collisionDamage)
    end

    local boss = attributes.boss
    if boss then
        entity.isBoss = XmlUtils.ToBoolean(boss)
    end

    local bossID = attributes.bossID
    if bossID then
        entity.bossID = XmlUtils.ToInteger(bossID)
    end

    local champion = attributes.champion
    if champion then
        entity.isChampion = champion == "1"
    end

    local collisionRadius = attributes.collisionRadius
    if collisionRadius then
        entity.collisionRadius = XmlUtils.ToFloat(collisionRadius)
    end

    -- TODO: Rest of parse
end

---@param entityConfig EntityConfigComponent
---@param filePath string
---@param mod ModEntryComponent?
local function Load(entityConfig, filePath, mod)
    local document = XmlParser.Parse(filePath)
    ---@cast document Xml.Entities2.Document?
    if not document then
        return
    end

    ---@type Xml.Entities2.Root
    local root = document.entities
    if not root then
        local msg = string.format("Could not find root node 'entities' in %s\n", filePath)
        Log.LogMessage(3, msg)
        assert(false, msg)
    end

    local attributes = root._attr
    local version = attributes.version
    if version ~= "5" then
        Log.LogMessage(3, string.format("Invalid version %s for %s\n", version, filePath))
    end

    local anm2root = attributes.anm2root or ""
    local portraitLoaded = false
    if mod then
        local deathanm2 = attributes.deathanm2 or ""
        -- load custom resource
        -- portraitLoaded = sprite:IsLoaded()
    end

    local child = root._child
    for i = 1, #child, 1 do
        local entity = child[i]
        if entity._tag ~= "entity" then
            goto continue
        end

        ---@type EntityConfig.EntityComponent
        local config
        -- local config = new EntityConfigEntity
        parse_entity(config, entity)
        config.modEntry = mod

        local map = entityConfig.m_map
        local hash = EntityConfigUtils.GetHash(config.id, config.variant, config.subtype)

        if mod then
            while map[hash] ~= nil do
                local type = config.id
                if type == EntityType.ENTITY_EFFECT or type == EntityType.ENTITY_TEXT or type < 10 then
                    config.variant = config.variant + 1
                else
                    local nextType = config.id + 1
                    if nextType == EntityType.ENTITY_EFFECT or nextType == EntityType.ENTITY_TEXT then
                        nextType = nextType + 1
                    end

                    config.id = nextType
                end

                hash = EntityConfigUtils.GetHash(config.id, config.variant, config.subtype)
            end
        end

        map[hash] = config
        -- TODO: add to some unk entityConfig list, based on certain criteria
        ::continue::
    end
end

--#region Module

Module.Load = Load

--#endregion

return Module