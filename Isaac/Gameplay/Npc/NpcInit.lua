--#region Dependencies

local EntityPtrComponent = require("Isaac.Components.Entity.EntityPtrComponent")
local IEntity = require("Isaac.Interface.Entity")
local IEntityNpc = require("Isaac.Interface.Entity_NPC")
local INpcPathfinder = require("Isaac.Interface.NPC_Pathfinder")
local IRoom = require("Isaac.Interface.Room")
local Log = require("General.Log")
local LuaCallbacks = require("LuaEngine.Callbacks")

local ChampionSetup = require("Isaac.Gameplay.Npc.ChampionSetup")

--#endregion

---@param ctx Context.Common
---@param npc Component.Entity.Npc
---@param entityType EntityType | integer
---@param variant integer
---@param subtype integer
---@param seed integer
local function Init(ctx, npc, entityType, variant, subtype, seed)
    npc.m_champion_isChampion = false
    npc.m_champion_id = -1
    npc.m_transparencyTime = 0
    npc.m_transparencyAlpha = 1.0
    npc.m_champion_speedMult = 1.0
    npc.m_bossColorIdx = -1
    npc.field_0xb8e = 0
    npc.m_npcScale = 1.0
    npc.m_shieldStrength = 0.0
    npc.m_shieldInterval = 120
    npc.m_delirium_bossType = EntityType.ENTITY_NULL
    npc.m_delirium_bossVariant = 0
    npc.m_delirium_transformationTimer = 0;
    npc.m_delirium_remainingAttacks = 0
    npc.m_delirium_npcState = 0
    npc.m_unkDeliriumRef = nil
    npc.m_addedToBestiary = false
    npc.m_cordFlagRelated = 0
    npc.m_possessor_controllerIdx = -1
    npc.m_parentNotPlayerControlled_qqq = false
    npc.m_possessor_aim = Vector(0, 0)
    npc.m_possessor_crosshair = EntityPtrComponent.New(nil)
    npc.m_walkFrameDir = Vector(0, 0)
    npc.m_forcedTarget = nil
    npc.m_forcedTargetDuration = 0
    npc.m_sirenPlayerEntity = nil
    npc.m_healthRelated = 1.0
    npc.m_unkScaleUsedByLokiVariant = 1.0
    npc.m_poopChampionLastGridIdx = -1

    local pickupGhostRef = npc.m_pickupGhost_entity
    if pickupGhostRef.ref then
        pickupGhostRef.ref:Remove(ctx)
        IEntity.set_entity_ref(pickupGhostRef, nil)
    end

    local unkEntityRef = npc.m_unkEntity
    if unkEntityRef.ref then
        unkEntityRef.ref:Remove(ctx)
        IEntity.set_entity_ref(unkEntityRef, nil)
    end

    IEntity.set_entity_ref(npc.m_unkEntityPtr, nil)

    npc.m_damageEntries2_qqq = {}
    npc.m_damageRelated_qqq = 0.0;
    npc.m_stickyBombDeathSpawnRelated = 0
    npc.m_unkDeathSpawnChampionFlag = 0

    IEntity.Init(ctx, npc, entityType, variant, subtype, seed);

    npc.m_flags = npc.m_flags | EntityFlag.FLAG_APPEAR
    npc.m_state = NpcState.STATE_APPEAR
    npc.m_appear_originalState = NpcState.STATE_INIT
    npc.m_customState = 0
    npc.m_stateFrame = 0
    npc.m_genericIntStorage = 0
    npc.m_appear_frameCount = 0
    npc.field_0xad4 = 0
    npc.m_groupIdx = -1;
    npc.m_targetPosition = Vector(0, 0)
    npc.m_npcTargetPos = Vector(0, 0)
    npc.m_someEvisCordThing = 1.0
    npc.m_V1 = Vector(0, 0)
    npc.m_V2 = Vector(0, 0)
    npc.m_championRegenTimer = 0
    npc.m_onDeathEnemySpawnCount = 0
    npc.m_childTimescale_qqq = 0
    npc.m_I1 = 0
    npc.m_I2 = 0
    npc.m_entityRef = nil
    npc.m_projectileCooldown = 0
    npc.m_projectileDelay = -1
    npc.m_championProjectileCooldown_qqq = 0
    npc.m_childRelated = Vector(0, 0)
    npc.field_0xbb1 = 0
    npc.m_camoColor = Color()
    npc.m_hitList.m_list = {}
    npc.m_hitlist_qqq.m_list = {}
    INpcPathfinder.Reset(npc.m_pathfinder)

    if npc.m_isBoss then
        local room = ctx.game.m_level.m_room
        IRoom.TriggerBossSpawn(room, npc)
    end

    npc.m_totalDamageTaken = 0.0
    LuaCallbacks.PostNpcInit(npc)
end

---@param ctx Context.Common
---@param npc Component.Entity.Npc
local function LoadEntityConfig(ctx, npc)
    npc.m_isBoss = false

    IEntity.load_entity_config(ctx, npc)

    if not npc.m_config then
        Log.LogMessage(0, string.format("[warn] No entity config for NPC %d.%d\n", npc.m_type, npc.m_variant))
        return
    end

    IEntityNpc.load_graphics(ctx, npc, true)

    local sprite = npc.m_sprite
    sprite.Scale = Vector(1, 1)
    sprite:SetAnimation(sprite:GetDefaultAnimationName(), true)

    local config = npc.m_config
    npc.m_canShutDoors = config.canShutDoors
    npc.m_isBoss = config.isBoss
    npc.m_shieldStrength = config.shieldStrength
    npc.m_shieldInterval = config.shieldFrames

    ChampionSetup.ChampionSetup(ctx, npc)
end

---@class Gameplay.NpcInit
local Module = {}

--#region Module

Module.Init = Init
Module.LoadEntityConfig = LoadEntityConfig

--#endregion

return Module