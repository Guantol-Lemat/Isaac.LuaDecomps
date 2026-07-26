local Lib = {}
---@class Decomp.Lib.EntityConfig
Lib.EntityConfig = {}

local g_PersistentGameData = Isaac.GetPersistentGameData()

---@class Decomp.EntityData
---@field Type integer
---@field Variant integer
---@field SubType integer
---@field Achievement Achievement | integer
---@field EntityConfig EntityConfigEntity?
---@field StbType integer
---@field StbVariant integer
---@field StbSubType integer

---@class Decomp.API.EntityData
---@field Type integer
---@field Base table?
---@field Variant integer?
---@field SubType integer?
---@field Achievement Achievement | integer | nil
---@field StbType integer?
---@field StbVariant integer?
---@field StbSubType integer?

---@type Decomp.EntityData[]
local s_EntityDesc = {}
local s_GameIdentifierLookup = {}
local s_StbIdentifierLookup = {}

local EntityDataSchema = {
    Type = {["integer"] = true},
    Variant = {["integer"] = true, ["nil"] = true},
    SubType = {["integer"] = true, ["nil"] = true},
    Achievement = {["integer"] = true, ["nil"] = true},
    StbType = {["integer"] = true, ["nil"] = true},
    StbVariant = {["integer"] = true, ["nil"] = true},
    StbSubType = {["integer"] = true, ["nil"] = true},
}

---@param inputData Decomp.API.EntityData
---@return Decomp.EntityData
local function init_data(inputData)
    local type = inputData.Type
    local variant = inputData.Variant or 0
    local subType = inputData.SubType or 0

    ---@type Decomp.EntityData
    local data = {
        Type = type,
        Variant = variant,
        SubType = subType,
        Achievement = inputData.Achievement or -1,
        EntityConfig = EntityConfig.GetEntity(type, variant, subType),
        StbType = inputData.StbType or type,
        StbVariant = inputData.StbVariant or variant,
        StbSubType = inputData.StbSubType or subType,
    }

    return data
end

---@param type integer
---@param variant integer
---@param subType integer
---@return string
local function get_game_identifier(type, variant, subType)
    return string.format("%d_%d_%d", type, variant, subType)
end

---@param stbType integer
---@param stbVariant integer
---@param stbSubType integer
---@return string
local function get_stb_identifier(stbType, stbVariant, stbSubType)
    return string.format("%d_%d_%d", stbType, stbVariant, stbSubType)
end

---@param inputData Decomp.API.EntityData
---@return integer id
function Lib.EntityConfig.Declare(inputData)
    assert(inputData.Type and inputData.Type ~= EntityType.ENTITY_PLAYER, "Players should be added in their respective configs")
    local data = init_data(inputData)
    table.insert(s_EntityDesc, data)
    local id = #s_EntityDesc
    s_GameIdentifierLookup[get_game_identifier(data.Type, data.Variant, data.SubType)] = id
    s_StbIdentifierLookup[get_stb_identifier(data.StbType, data.StbVariant, data.StbSubType)] = id
    return id
end

function Lib.EntityConfig.GetIdFromGameIdentifier(type, variant, subType)
    if subType then
        local id = s_GameIdentifierLookup[get_game_identifier(type, variant or 0, subType)]
        if id then
            return id
        end
    end

    if variant then
        local id = s_GameIdentifierLookup[get_game_identifier(type, variant, 0)]
        if id then
            return id
        end
    end

    local id = s_GameIdentifierLookup[get_game_identifier(type, 0, 0)]
    if id then
        return id
    end

    return -1
end

---@param id integer
---@return integer type
---@return integer variant
---@return integer subType
function Lib.EntityConfig.GetGameIdentifier(id)
    assert(1 <= id and id <= #s_EntityDesc, "Invalid id passed")
    local entityDesc = s_EntityDesc[id]
    return entityDesc.Type, entityDesc.Variant or 0, entityDesc.SubType or 0
end

---@param id integer
---@return boolean unlocked
function Lib.EntityConfig.IsUnlocked(id)
    assert(1 <= id and id <= #s_EntityDesc, "Invalid id passed")
    local pickupData = s_EntityDesc[id]
    return not pickupData[3] or g_PersistentGameData:Unlocked(pickupData[3])
end

return Lib.EntityConfig