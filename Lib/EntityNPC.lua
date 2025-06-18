---@class Decomp.Lib.EntityNPC
local Lib_EntityNPC = {}

---@param env Decomp.EnvironmentObject
---@param type EntityType | integer
---@param variant integer
---@return EntityType | integer redirectType
---@return integer redirectVariant
---@return boolean redirected
local function morph_into_easier_npc(env, type, variant)
    local api = env._API
    local game = api.Isaac.GetGame(env)

    if type == EntityType.ENTITY_BLISTER then
        if api.Game.IsHardMode(game) then
            return EntityType.ENTITY_TICKING_SPIDER, 0, true
        end

        return EntityType.ENTITY_HOPPER, 1, true
    end

    if type == EntityType.ENTITY_MUSHROOM then
        return EntityType.ENTITY_HOST, 0, true
    end

    if type == EntityType.ENTITY_MINISTRO then
        return EntityType.ENTITY_HOPPER, 0, true
    end

    if type == EntityType.ENTITY_NERVE_ENDING then
        return EntityType.ENTITY_NERVE_ENDING, 0, true
    end

    if type == EntityType.ENTITY_POISON_MIND then
        return EntityType.ENTITY_BRAIN, 0, true
    end

    if type == EntityType.ENTITY_STONEY then
        if api.Game.IsHardMode(game) then
            return EntityType.ENTITY_CONJOINED_FATTY, 0, true
        end

        return EntityType.ENTITY_FATTY, 0, true
    end

    if type == EntityType.ENTITY_THE_THING then
        if api.Game.IsHardMode(game) then
            return EntityType.ENTITY_BLIND_CREEP, 0, true
        end

        return EntityType.ENTITY_WALL_CREEP, 0, true
    end

    return type, variant, false
end

local s_StagePortalDefault = {
    [StbType.SPECIAL_ROOMS] = {EntityType.ENTITY_SPIDER, EntityType.ENTITY_BIGSPIDER, 0, 0},
    [StbType.BASEMENT] = {EntityType.ENTITY_GAPER, EntityType.ENTITY_CYCLOPIA, 0, 0},
    [StbType.CELLAR] = {EntityType.ENTITY_SPIDER, EntityType.ENTITY_BIGSPIDER, 0, 0},
    [StbType.BURNING_BASEMENT] = {EntityType.ENTITY_GAPER, EntityType.ENTITY_CYCLOPIA, 0, 0},
    [StbType.CELLAR] = {EntityType.ENTITY_SPIDER, EntityType.ENTITY_BIGSPIDER, 0, 0},
    [StbType.CAVES] = {EntityType.ENTITY_MAGGOT, EntityType.ENTITY_CHARGER, 0, 0},
    [StbType.CATACOMBS] = {EntityType.ENTITY_MAW, EntityType.ENTITY_MAW, 0, 1},
    [StbType.FLOODED_CAVES] = {EntityType.ENTITY_CHARGER, EntityType.ENTITY_CHARGER, 0, 1},
    [StbType.DEPTHS] = {EntityType.ENTITY_FAT_SACK, EntityType.ENTITY_BONY, 0, 0},
    [StbType.NECROPOLIS] = {EntityType.ENTITY_BONY, EntityType.ENTITY_GLOBIN, 0, 1},
    [StbType.DANK_DEPTHS] = {EntityType.ENTITY_GLOBIN, EntityType.ENTITY_BLACK_BONY, 0, 0},
    [StbType.WOMB] = {EntityType.ENTITY_CLOTTY, EntityType.ENTITY_PARA_BITE, 0, 0},
    [StbType.UTERO] = {EntityType.ENTITY_PARA_BITE, EntityType.ENTITY_VIS, 0, 0},
    [StbType.SCARRED_WOMB] = {EntityType.ENTITY_VIS, EntityType.ENTITY_VIS, 0, 1},
    [StbType.BLUE_WOMB] = {EntityType.ENTITY_HUSH_GAPER, EntityType.ENTITY_HUSH_GAPER, 0, 0},
    [StbType.SHEOL] = {EntityType.ENTITY_GURGLE, EntityType.ENTITY_NULLS, 0, 0},
    [StbType.CATHEDRAL] = {EntityType.ENTITY_MAW, EntityType.ENTITY_LEECH, 2, 2},
    [StbType.DARK_ROOM] = {EntityType.ENTITY_WRATH, EntityType.ENTITY_GREED, 1, 1},
    [StbType.CHEST] = {EntityType.ENTITY_DARK_ONE, EntityType.ENTITY_SISTERS_VIS, 0, 0},
    [StbType.THE_VOID] = {EntityType.ENTITY_DELIRIUM, EntityType.ENTITY_DELIRIUM, 0, 0},
    default = nil
}

local s_GreedPortalDefault = {
    [LevelStage.STAGE1_GREED] = s_StagePortalDefault[StbType.BASEMENT],
    [LevelStage.STAGE2_GREED] = s_StagePortalDefault[StbType.CAVES],
    [LevelStage.STAGE3_GREED] = s_StagePortalDefault[StbType.DEPTHS],
    [LevelStage.STAGE4_GREED] = s_StagePortalDefault[StbType.UTERO],
    [LevelStage.STAGE5_GREED] = s_StagePortalDefault[StbType.SHEOL],
    [LevelStage.STAGE6_GREED] = {EntityType.ENTITY_GREED, EntityType.ENTITY_GREED, 0, 1},
    default = {EntityType.ENTITY_GREED_GAPER, EntityType.ENTITY_GREED_GAPER, 0, 0},
}

---@param env Decomp.EnvironmentObject
---@return table? redirectedEntity
local function morph_unavailable_portal(env)
    local api = env._API
    local game = api.Isaac.GetGame(env)
    local level = api.Isaac.GetLevel(env)
    local room = api.Isaac.GetRoom(env)

    local isHardMode = api.Game.IsHardMode(game)
    local morphTable = nil -- Forward Declaration

    if api.Game.IsGreedMode(game) then
        morphTable = s_GreedPortalDefault[api.Level.GetStage(level)] or s_GreedPortalDefault.default
    else
        morphTable = s_StagePortalDefault[api.Room.GetRoomConfigStage(room)] or s_StagePortalDefault.default
    end

    if not morphTable then
        return nil
    end

    local morphType = isHardMode and 2 or 1
    local morphVariant = isHardMode and 4 or 3
    return {morphTable[morphType], morphTable[morphVariant]}
end

---@param type EntityType | integer
---@param variant integer
---@return EntityType | integer redirectType
---@return integer redirectVariant
local function g_fuel_morph(type, variant)
    if type == EntityType.ENTITY_HOST then
        return EntityType.ENTITY_HOST, 1
    end

    if type == EntityType.ENTITY_MOBILE_HOST then
        return EntityType.ENTITY_FLESH_MOBILE_HOST, variant
    end

    if type == EntityType.ENTITY_FLOATING_HOST then
        return EntityType.ENTITY_BOOMFLY, 1
    end

    if type == EntityType.ENTITY_COD_WORM then
        return EntityType.ENTITY_PARA_BITE, variant
    end

    return type, variant
end

---@param env Decomp.EnvironmentObject
---@param type EntityType | integer
---@param variant integer
---@return EntityType | integer redirectType
---@return integer redirectVariant
---@return boolean
local function Redirect(env, type, variant)
    local api = env._API
    local persistentGameData = api.Isaac.GetPersistentGameData(env)

    if type == EntityType.ENTITY_SUCKER and variant == 5 and not api.PersistentGameData.Unlocked(persistentGameData, Achievement.EVERYTHING_IS_TERRIBLE) then
        type = EntityType.ENTITY_FLY
        variant = 0
    end

    if not api.PersistentGameData.Unlocked(persistentGameData, Achievement.THE_GATE_IS_OPEN) then
        local redirected = false
        type, variant, redirected = morph_into_easier_npc(env, type, variant)
        if redirected then
            return type, variant, true
        end

        if type == EntityType.ENTITY_PORTAL then
            local redirectedEntity = morph_unavailable_portal(env)
            if redirectedEntity then
                return redirectedEntity[1], redirectedEntity[2], true
            end
        end
    end

    local seeds = api.Isaac.GetSeeds(env)
    if api.Seeds.HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL) then
        type, variant = g_fuel_morph(type, variant)
    end

    return type, variant, false
end

--#region Module

Lib_EntityNPC.Redirect = Redirect

--#endregion

return Lib_EntityNPC