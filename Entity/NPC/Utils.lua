--#region Dependencies

local TableUtils = require("General.Table")
local Identity = require("Entity.Identity")
local IsaacUtils = require("Isaac.Utils")
local EntityCast = require("Entity.TypeCast")
local GameSpawn = require("Game.Spawn")
local EntityManagerUtils = require("Game.Room.EntityManager.Utils")

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

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@param soundId SoundEffect | integer
---@param volume number
---@param frameDelay integer
---@param loop boolean
---@param pitch integer
local function PlaySound(ctx, npc, soundId, volume, frameDelay, loop, pitch)
    local champion = npc.m_champion_id
    if champion == ChampionColor.TINY then pitch = pitch + 0.5 end
    if champion == ChampionColor.GIANT then pitch = pitch * 0.5 end

    IsaacUtils.PlaySound(ctx, soundId, volume, frameDelay, loop, pitch)
end

---@param ctx Context.Common
---@param subtype integer
---@param pos Vector
---@param spriteOffset Vector
---@param color Color
---@param velocity Vector
---@return EntityEffectComponent
local function MakeBloodEffect(ctx, subtype, pos, spriteOffset, color, velocity)
    local seed = IsaacUtils.Random()

    local entity = GameSpawn.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, subtype,
        seed, pos, velocity, nil
    )

    local effect = EntityCast.StaticToEffect(entity)
    effect:SetColor(ctx, color, -1, -1, false, true)
    effect.m_sprite.Offset = spriteOffset
    effect.m_depthOffset = 10.0

    return effect
end

---@param npc EntityNPCComponent
---@return EntityNPCComponent?
local function GetParentNPC(npc)
    local parent = npc.m_parent.ref
    if parent then
        parent = EntityCast.ToNPC(parent)
    end

    return parent
end

---@param ctx Context.Game
---@param entityType EntityType | integer
---@param variant integer
---@return Component.EL
local function QueryNPCsType(ctx, entityType, variant)
    local entityList = ctx.game.m_level.m_room.m_entityList
    return EntityManagerUtils.QueryType(entityList, entityType, variant, -1, false, false)
end

--#region Module

Module.IsMiniboss = IsMiniboss
Module.PlaySound = PlaySound
Module.MakeBloodEffect = MakeBloodEffect
Module.GetParentNPC = GetParentNPC
Module.QueryNpCsType = QueryNPCsType

--#endregion

return Module