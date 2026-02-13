--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local VectorUtils = require("General.Math.VectorUtils")
local NpcUtils = require("Entity.NPC.Utils")
local NpcAi = require("Actor.NpcAi")
local SpawnLogic = require("Game.Spawn")
local EntityUtils = require("Entity.Utils")
local SfxUtils = require("Isaac.SoundManager.Utils")

local VectorZero = VectorUtils.VectorZero

--#endregion

---@class NPCAppearLogic
local Module = {}

---@param context NpcMechanicsContext.Appear
---@param npc EntityNPCComponent
local function init_npc(context, npc)
    local npcRead = npc
    local npcWrite = npc

    local flags = npcRead.m_flags
    local championColor = npcRead.m_champion_id

    npcWrite.m_state = NpcState.STATE_INIT

    if championColor == ChampionColor.WHITE then
        npcWrite.m_invincible = true
        npcWrite.m_flags = flags | EntityFlag.FLAG_NO_STATUS_EFFECTS
    end

    NpcAi.UpdateAi(npcWrite)
    npcRead = npcWrite -- commit
    flags = npcRead.m_flags
    championColor = npcRead.m_champion_id

    if championColor == ChampionColor.FLY_PROTECTED or championColor == ChampionColor.RAINBOW then
        local eternalFly = SpawnLogic.Spawn(context, EntityType.ENTITY_ETERNALFLY, 0, 0, IsaacUtils.Random(), npcRead.m_position, VectorZero, npcWrite)
        EntityUtils.SetParent(eternalFly, npcWrite)
    end

    if (flags & EntityFlag.FLAG_APPEAR) ~= 0 then
        npcWrite.m_visible = false
        npcWrite.m_appear_originalState = npcRead.m_state
        npcWrite.m_state = NpcState.STATE_APPEAR
    end

    -- TODO: Apply Tick damage
    -- TODO: Update Dirt color
    -- TODO: Add encountered boss
end

---@param context NpcMechanicsContext.Appear
---@param npc EntityNPCComponent
local function spawn_poof(context, npc)
    local npcRead = npc
    local npcWrite = npc

    local size = npcRead.m_size
    local shadowSize = npcRead.m_shadowSize

    local poofType = size >= 13.0 and 2 or 1
    if size >= 18.0 or shadowSize > 30.0 then
        poofType = 3
    end

    local poofEnt = SpawnLogic.Spawn(context, EntityType.ENTITY_EFFECT, EffectVariant.POOF01, poofType, IsaacUtils.Random(), npcRead.m_position, VectorZero, npcWrite)
    local poof = EntityUtils.ToEffect(poofEnt)
    assert(poof, "poof is not an Effect.")

    local positionOffset = npcRead.m_positionOffset
    VectorUtils.Assign(poof.m_positionOffset, positionOffset)
    poof.m_depthOffset_qqq = positionOffset.Y + 1.0

    if npcRead.m_champion_isChampion then
        -- TODO: Set ChampionColor
    end

    local sfxManager = context.sfxManager
    SfxUtils.Stop(sfxManager, SoundEffect.SOUND_SUMMON_POOF)
    NpcUtils.PlaySound(context, SoundEffect.SOUND_SUMMON_POOF, 1.0, 2, false, 1.0)

    -- custom sound
    local npcType = npcRead.m_type
    if npcType == EntityType.ENTITY_STAIN then
        IsaacUtils.PlaySound(context, SoundEffect.SOUND_MAGGOT_BURST_OUT, 1.0, 2, false, 1.0)
        NpcUtils.PlaySound(context, SoundEffect.SOUND_THE_STAIN_BURST, 1.0, 2, false, 1.0)
    elseif npcType == EntityType.ENTITY_FORSAKEN then
        NpcUtils.PlaySound(context, SoundEffect.SOUND_THE_FORSAKEN_LAUGH, 1.0, 2, false, 1.0)
    elseif npcType == EntityType.ENTITY_BIG_HORN and npcRead.m_variant == 0 then
        NpcUtils.PlaySound(context, SoundEffect.SOUND_BOSS_LITE_ROAR, 2.0, 2, false, 1.0)
    end
end

---@param npc EntityNPCComponent
local function appear(npc)
    local npcRead = npc
    local npcWrite = npc

    local npcType = npcRead.m_type
    if npcType ~= EntityType.ENTITY_PIN then
        npcWrite.m_visible = true
    end

    local sprite = npcWrite.m_sprite
    local animData = sprite:GetAnimationData("Appear")
    if animData then
        if npcType == EntityType.ENTITY_MAMA_GURDY then
            sprite:RemoveOverlay()
        end

        sprite:Play("Appear", true)
    end
end

---@param npc EntityNPCComponent
---@return boolean
local function should_trigger_appear_end(npc)
    local sprite = npc.m_sprite
    if sprite:IsFinished("Appear") then
        return true
    end

    local animationData = sprite:GetAnimationData("Appear")
    if not animationData then
        return true
    end

    if sprite:GetAnimation() ~= "Appear" then
        return true
    end

    return false
end

---@param context NpcMechanicsContext.Appear
---@param npc EntityNPCComponent
local function Update(context, npc)
    local npcRead = npc
    local npcWrite = npc

    if (npcRead.m_flags & EntityFlag.FLAG_APPEAR) == 0 then
        npcWrite.m_state = npcRead.m_appear_originalState
        return
    end

    local appearFrame = npcRead.m_appear_frameCount

    if appearFrame == 0 then
        init_npc(context, npc)
    elseif appearFrame == 1 then
        spawn_poof(context, npc)
    elseif appearFrame == 4 then
        appear(npc)
    elseif appearFrame >= 20 then
        if should_trigger_appear_end(npc) then
            npcWrite.m_state = npcRead.m_appear_originalState
            npcWrite.m_friction = npcRead.m_initialFriction
        end
    end

    npcRead = npcWrite
    -- TODO: entity specific sprite events
    if npcRead.m_state == NpcState.STATE_APPEAR then
        npcWrite.m_friction = npcRead.m_friction * 0.01
    end

    npcWrite.m_appear_frameCount = appearFrame + 1
end

--#region Module

Module.Update = Update

--#endregion

return Module