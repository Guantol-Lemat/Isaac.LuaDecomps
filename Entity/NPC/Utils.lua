--#region Dependencies

local TableUtils = require("General.Table")
local Identity = require("Entity.Identity")

local eBabyVariant = Identity.eBabyVariant
local eFallenVariant = Identity.eFallenVariant

--#endregion

---@class NPCUtils
local Module = {}

local MINIBOSS_TYPES = TableUtils.CreateDictionary({
    EntityType.ENTITY_SLOTH, EntityType.ENTITY_LUST, EntityType.ENTITY_WRATH,
    EntityType.ENTITY_GLUTTONY, EntityType.ENTITY_GREED, EntityType.ENTITY_ENVY,
    EntityType.ENTITY_PRIDE
})

---@param entity EntityNPCComponent
local function IsMiniboss(entity)
    local type = entity.m_type
    if MINIBOSS_TYPES[type] then
        return true
    end

    if type == EntityType.ENTITY_BABY and entity.m_variant == eBabyVariant.ULTRA_PRIDE_BABY then
        return true
    end

    if type == EntityType.ENTITY_FALLEN and entity.m_variant == eFallenVariant.KRAMPUS then
        return true
    end

    return false
end

---@param context IsaacContext.PlaySound
---@param soundId SoundEffect | integer
---@param volume number
---@param frameDelay integer
---@param loop boolean
---@param pitch integer
local function PlaySound(context, soundId, volume, frameDelay, loop, pitch)
end

--#region Module

Module.IsMiniboss = IsMiniboss
Module.PlaySound = PlaySound

--#endregion

return Module