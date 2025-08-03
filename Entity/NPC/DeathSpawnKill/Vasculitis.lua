--#region Dependencies

local SpawnCommands = require("Lib.SpawnCommands")

--#endregion

---@class DeathSpawnKill.Vasculitis
local Module = {}

---@class DeathSpawnKill.VasculitisSystem
---@field package m_context Decomp.Context
---@field package m_LevelApi Decomp.ILevel
---@field package m_EntityApi Decomp.IEntity
---@field package m_EntityTearApi Decomp.IEntityTear
local System = {}

---@class DeathSpawnKill.VasculitisTearData
---@field damage number
---@field tearCount integer
---@field variant TearVariant
---@field flags BitSet128
---@field color Color

---@param system DeathSpawnKill.VasculitisSystem
---@param admin Decomp.Admin
local function InitSystemContext(system, admin)
    system.m_context = admin.context
    system.m_LevelApi = admin.Systems.Level.API
    system.m_EntityApi = admin.Systems.Entity.API
    system.m_EntityTearApi = admin.Systems.EntityTear.API
    system.TriggerVasculitisEffect = System.TriggerVasculitisEffect
end

---@param system DeathSpawnKill.VasculitisSystem
---@param npc Decomp.EntityObject
---@return number damage
---@return integer tearCount
local function get_tear_damage_data(system, npc)
    local maxHealth = system.m_EntityApi.GetMaxHitPoints(npc)
    local level = system.m_context:GetLevel()

    local baseDamage = system.m_LevelApi.GetStage(level) * 0.3 + 3.2

    local tearCount = maxHealth / baseDamage
    tearCount = math.ceil(tearCount)
    tearCount = math.min(tearCount, 16) -- cap at 16

    local damagePerTear = maxHealth / tearCount;
    return math.max(baseDamage, damagePerTear), tearCount
end

---@param system DeathSpawnKill.VasculitisSystem
---@param npc Decomp.EntityObject
local function get_tear_modifiers(system, npc)
    local variant = TearVariant.BLOOD
    local flags = BitSet128(0, 0)
    local color = Color()
    color:Reset()

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_SLOW) then
        flags = flags | TearFlags.TEAR_SLOW
        color:SetTint(2.0, 2.0, 2.0, 1.0)
        color:SetOffset(0.196, 0.196, 0.196)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_POISON) then
        flags = flags | TearFlags.TEAR_POISON
        color:SetTint(0.5, 0.97, 0.5, 1.0)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_FREEZE) then
        flags = flags | TearFlags.TEAR_FREEZE
        color:SetTint(1.25, 0.05, 0.15, 1.0)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_CHARM) then
        flags = flags | TearFlags.TEAR_CHARM
        color:SetTint(1.0, 0.0, 1.0, 1.0)
        color:SetOffset(0.196, 0.0, 0.0)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_CONFUSION) then
        flags = flags | TearFlags.TEAR_CONFUSION
        color:SetTint(0.5, 0.5, 0.5, 1.0)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_FEAR) then
        flags = flags | TearFlags.TEAR_FEAR
        color:SetTint(1.0, 1.0, 0.455, 1.0)
        color:SetOffset(0.169, 0.145, 0.0)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_BURN) then
        flags = flags | TearFlags.TEAR_BURN
        variant = TearVariant.FIRE_MIND
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_MAGNETIZED) then
        flags = flags | TearFlags.TEAR_MAGNETIZE
        color:SetColorize(0.5, 0.5, 0.5, 1.0)
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_ICE) then
        flags = flags | TearFlags.TEAR_ICE
        variant = TearVariant.ICE
    end

    if system.m_EntityApi.HasEntityFlags(npc, EntityFlag.FLAG_BAITED) then
        flags = flags | TearFlags.TEAR_CHARM
        color:SetTint(0.7, 0.14, 0.1, 1.0)
        color:SetOffset(0.3, 0.0, 0.0)
    end

    return variant, flags, color
end

---@param system DeathSpawnKill.VasculitisSystem
---@param tearData DeathSpawnKill.VasculitisTearData
local function make_post_tear_spawn_function(system, tearData)
    ---@param entity Decomp.EntityObject
    return function(entity)
        local tear = system.m_EntityApi.ToTear(entity)
        assert(tear, "Spawned Vasculis tear cannot be converted ToTear")
        system.m_EntityApi.SetSpawnerType(tear, EntityType.ENTITY_PLAYER)
        tear:SetCollisionDamage(tearData.damage)
        system.m_EntityTearApi.SetTearFlags(tear, tearData.flags)
        tear:SetColor(tearData.color)
        tear:Update()
    end
end

---@param system DeathSpawnKill.VasculitisSystem
---@param npc Decomp.EntityObject
---@param tearData DeathSpawnKill.VasculitisTearData
---@return Decomp.SpawnCommands
local function spawn_tears(system, npc, tearData)
    if tearData.tearCount <= 0 then
        return {}
    end

    local spawnCommands = SpawnCommands.Create()
    local PostSpawnFunction = make_post_tear_spawn_function(system, tearData)

    local position = system.m_EntityApi.GetPosition(npc)
    local rng = RNG(system.m_EntityApi.GetInitSeed(npc), 17)
    local randomAngle = rng:RandomFloat() * 360.0
    local angleIncrement = 360.0 / tearData.tearCount

    for i = 1, tearData.tearCount, 1 do
        local velocityMultiplier = rng:RandomFloat() * 4.0 + 8.0
        local angleVariation = angleIncrement * (rng:RandomFloat() - 0.5)

        local angle = randomAngle + (i - 1) * angleIncrement + angleVariation
        local velocity = Vector.FromAngle(angle) * velocityMultiplier

        SpawnCommands.SpawnEntity(spawnCommands, EntityType.ENTITY_TEAR, tearData.variant, 0, Random(), position, velocity, nil, PostSpawnFunction)
    end

    return spawnCommands
end

---@param system DeathSpawnKill.VasculitisSystem
---@param npc Decomp.EntityObject
---@return Decomp.SpawnCommands
function TriggerVasculitisEffect(system, npc)
    local damage, tearCount = get_tear_damage_data(system, npc)
    local variant, flags, color = get_tear_modifiers(system, npc)

    ---@type DeathSpawnKill.VasculitisTearData
    local tearData = {damage = damage, tearCount = tearCount, variant = variant, flags = flags, color = color}
    return spawn_tears(system, npc, tearData)
end

--#region Module

Module.InitSystemContext = InitSystemContext

--#endregion

--#region System

System.TriggerVasculitisEffect = TriggerVasculitisEffect

--#endregion

return Module