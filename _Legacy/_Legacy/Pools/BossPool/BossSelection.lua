---@class Decomp.Pools.BossPool.BossSelection
local BossSelection = {}
Decomp.Pools.BossPool.BossSelection = BossSelection

local Table = require("Lib.Table")
require("Room.RoomConfig")
require("Pools.BossPool")

local Class = Decomp.Class

local g_Game = Game()
local g_PersistentGameData = Isaac.GetPersistentGameData()

local function switch_break()
end

local function is_alt_path(stageType)
    return stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
end

--#region StaticBosses

local s_HalloweenBosses = {
    [LevelStage.STAGE1_1] = BossType.LITTLE_HORN,
    [LevelStage.STAGE1_2] = BossType.HAUNT,
    [LevelStage.STAGE2_1] = BossType.DARK_ONE,
    [LevelStage.STAGE2_2] = BossType.FALLEN,
    [LevelStage.STAGE3_1] = BossType.ADVERSARY,
    [LevelStage.STAGE4_1] = BossType.LOKI,
}

---@param stage LevelStage
---@return BossType? boss
local function get_halloween_boss(stage)
    return s_HalloweenBosses[stage]
end

local function get_stage_3_final_boss(stageType)
    return is_alt_path(stageType) and BossType.MOM_MAUSOLEUM or BossType.MOM
end

local function get_stage_4_final_boss(stageType)
    if is_alt_path(stageType) then
        return BossType.MOTHER
    end

    return g_PersistentGameData:Unlocked(Achievement.IT_LIVES) and BossType.IT_LIVES or BossType.MOMS_HEART
end

local function get_stage_5_final_boss(stageType)
    if is_alt_path(stageType) then
        return BossType.BLUE_BABY
    end

    return stageType == StageType.STAGETYPE_WOTL and BossType.ISAAC or BossType.SATAN
end

local function get_stage_6_final_boss(stageType)
    if is_alt_path(stageType) then
        return BossType.BLUE_BABY
    end

    return stageType == StageType.STAGETYPE_WOTL and BossType.BLUE_BABY or BossType.LAMB
end

local function get_stage_7_final_boss(stageType)
    return BossType.DELIRIUM
end

local switch_GetFinalBoss = {
    [LevelStage.STAGE3_2] = get_stage_3_final_boss,
    [LevelStage.STAGE4_2] = get_stage_4_final_boss,
    [LevelStage.STAGE5] = get_stage_5_final_boss,
    [LevelStage.STAGE6] = get_stage_6_final_boss,
    [LevelStage.STAGE7] = get_stage_7_final_boss,
    default = switch_break,
}

---@param stage LevelStage
---@param stageType StageType
---@return BossType? boss
local function get_final_boss(stage, stageType)
    local GetFinalBoss = switch_GetFinalBoss[stage] or switch_GetFinalBoss.default
    return GetFinalBoss(stageType)
end

---@param stage LevelStage
---@param stageType StageType
---@return BossType? boss
local function get_static_boss(stage, stageType)
    if g_Game.Challenge == Challenge.CHALLENGE_APRILS_FOOL then
        return BossType.BLOAT
    end

    if false then -- Halloween Daily Challenge
        local boss = get_halloween_boss(stage)
        if boss then
            return boss
        end
    end

    return get_final_boss(stage, stageType)
end

--#endregion

--#region SpecialBosses

---@param bossPool Decomp.Class.BossPool.Data
---@return BossType? boss
local function get_stage_1_horsemen(bossPool)
    if Class.BossPool.WasBossRemoved(BossType.FAMINE) then
        return
    end

    bossPool.m_LevelBlacklist[BossType.FAMINE] = true
    return BossType.FAMINE
end

---@param bossPool Decomp.Class.BossPool.Data
---@return BossType? boss
local function get_stage_2_horsemen(bossPool)
    if Class.BossPool.WasBossRemoved(BossType.PESTILENCE) then
        return
    end

    bossPool.m_LevelBlacklist[BossType.PESTILENCE] = true
    return BossType.PESTILENCE
end

---@param bossPool Decomp.Class.BossPool.Data
---@return BossType? boss
local function get_stage_3_horsemen(bossPool)
    if Class.BossPool.WasBossRemoved(BossType.WAR) then
        return
    end

    bossPool.m_LevelBlacklist[BossType.WAR] = true
    return BossType.WAR
end

---@param bossPool Decomp.Class.BossPool.Data
---@param conquest boolean
---@return BossType? boss
local function get_stage_4_horsemen(bossPool, conquest)
    if Class.BossPool.WasBossRemoved(BossType.DEATH) then
        return
    end

    bossPool.m_LevelBlacklist[BossType.DEATH] = true
    if conquest then
        bossPool.m_LevelBlacklist[BossType.CONQUEST] = true
    end

    return conquest and BossType.CONQUEST or BossType.DEATH
end

local switch_GetHorsemenBoss = {
    [LevelStage.STAGE1_1] = get_stage_1_horsemen,
    [LevelStage.STAGE2_1] = get_stage_2_horsemen,
    [LevelStage.STAGE3_1] = get_stage_3_horsemen,
    [LevelStage.STAGE4_1] = get_stage_4_horsemen,
    default = switch_break
}

---@param bossPool Decomp.Class.BossPool.Data
---@param stage LevelStage
---@param stageType StageType
---@param conquestSeed integer
---@param horsemenSeed integer
---@param headlessHorsemanSeed integer
---@return BossType? boss
local function get_horsemen_boss(bossPool, stage, stageType, conquestSeed, horsemenSeed, headlessHorsemanSeed)
    local conquest = conquestSeed % 2 == 0 and g_PersistentGameData:Unlocked(Achievement.CONQUEST)

    if horsemenSeed % 10 ~= 0 or not g_PersistentGameData:Unlocked(Achievement.HORSEMEN) or
       not switch_GetHorsemenBoss[stage] or is_alt_path(stageType) then
        return
    end

    if headlessHorsemanSeed % 10 == 0 and not Class.BossPool.WasBossRemoved(BossType.HEADLESS_HORSEMAN) then
        bossPool.m_LevelBlacklist[BossType.HEADLESS_HORSEMAN] = true
        return BossType.HEADLESS_HORSEMAN
    end

    local GetHorsemenBoss = switch_GetHorsemenBoss[stage] or switch_GetHorsemenBoss.default
    return GetHorsemenBoss(bossPool, conquest)
end

---@param stage LevelStage
---@return integer?
local function get_double_trouble_chance(stage)
    if g_Game.Challenge == Challenge.CHALLENGE_ULTRA_HARD then
        return 1
    end

    if stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return 50
    end

    if stage == LevelStage.STAGE3_1 then
        return 25
    end

    if stage == LevelStage.STAGE4_1 then
        return 40
    end
end

---@param pool Decomp.Pools.BossPool.Pool.Data
---@param stage LevelStage
---@param seed integer
local function get_double_trouble_boss(pool, stage, seed)
    local doubleTrouble = pool.m_DoubleTroubleVariantStart
    if not doubleTrouble then
        return
    end

    local chance = get_double_trouble_chance(stage)
    if not chance or seed % chance ~= 0 then
        return
    end

    return -doubleTrouble
end

---@param bossPool Decomp.Class.BossPool.Data
---@param stageType StageType
---@param seed integer
---@return BossType? boss
local function get_fallen_boss(bossPool, stageType, seed)
    if seed % 10 ~= 0 or is_alt_path(stageType) then
        return
    end

    if Class.BossPool.WasBossRemoved(BossType.FALLEN) or not g_Game:GetStateFlag(GameStateFlag.STATE_DEVILROOM_VISITED) then
        return
    end

    bossPool.m_LevelBlacklist[BossType.FALLEN] = true
    return BossType.FALLEN
end

---@param bossPool Decomp.Class.BossPool.Data
---@param pool Decomp.Pools.BossPool.Pool.Data
---@param stage LevelStage
---@param stageType StageType
---@param rng RNG
---@return BossType? boss
local function get_special_boss(bossPool, pool, stage, stageType, rng)
    local conquestSeed = rng:Next()
    local horsemenSeed = rng:Next()
    local headlessHorsemanSeed = rng:Next()
    local doubleTroubleSeed = rng:Next()
    local fallenSeed = rng:Next()
    rng:Next()
    rng:Next()

    local horsemenBoss = get_horsemen_boss(bossPool, stage, stageType, conquestSeed, horsemenSeed, headlessHorsemanSeed)
    if horsemenBoss then
        return horsemenBoss
    end

    local doubleTroubleBoss = get_double_trouble_boss(pool, stage, doubleTroubleSeed)
    if doubleTroubleBoss then
        return doubleTroubleSeed
    end

    local fallen = get_fallen_boss(bossPool, stageType, fallenSeed)
    if fallen then
        return fallen
    end
end

--#endregion

--#region RandomBoss

---@param bossEntry Decomp.Pools.BossPool.Boss.Data
---@return boolean
local function is_boss_entry_available(bossEntry)
    if bossEntry.m_BossId == BossType.REAP_CREEP and g_Game.Challenge == Challenge.CHALLENGE_SCAT_MAN then
        return false
    end

    return bossEntry.m_Achievement < 0 or g_PersistentGameData:Unlocked(bossEntry.m_Achievement)
end

---@param bossEntry Decomp.Pools.BossPool.Boss.Data
---@return boolean
local function can_pick_boss_entry(bossEntry)
    if bossEntry.m_Weight <= 0.0 then
        return false
    end

    if not is_boss_entry_available(bossEntry) or Class.BossPool.WasBossRemoved(bossEntry.m_BossId) then
        return false
    end

    return true
end

---@param bossEntry Decomp.Pools.BossPool.Boss.Data
---@param totalWeight number
---@param targetWeight number
---@return boolean
local function should_pick_boss_entry(bossEntry, totalWeight, targetWeight)
    return bossEntry.m_Weight + totalWeight > targetWeight and can_pick_boss_entry(bossEntry)
end

---@param oldTargetWeight number
---@param totalWeight number
---@param pool Decomp.Pools.BossPool.Pool.Data
---@param bossEntry Decomp.Pools.BossPool.Boss.Data
local function get_new_target_weight(oldTargetWeight, totalWeight, pool, bossEntry)
    local float = (totalWeight - oldTargetWeight) / bossEntry.m_InitialWeight
    return float * pool.m_TotalWeight
end

---@param pool Decomp.Pools.BossPool.Pool.Data
---@param targetWeight number
---@return Decomp.Pools.BossPool.Boss.Data? boss
local function pick_boss(pool, targetWeight)
    local lastIndex = 0

    for i = 1, 10, 1 do
        local totalWeight = 0.0

        for index, bossEntry in ipairs(pool.m_Bosses) do
            lastIndex = index

            if bossEntry.m_InitialWeight + totalWeight > targetWeight then
                if not should_pick_boss_entry(bossEntry, totalWeight, targetWeight) then
                    targetWeight = get_new_target_weight(targetWeight, totalWeight, pool, bossEntry)
                    break
                end

                return bossEntry
            end

            totalWeight = totalWeight + bossEntry.m_InitialWeight
        end
    end

    Isaac.DebugString("boss pool ran out of repicks")

    for index, bossEntry in Table.CircularIterator(pool.m_Bosses, lastIndex + 1) do
        if can_pick_boss_entry(bossEntry) then
            return bossEntry
        end
    end

    Isaac.DebugString("failed to pick random boss from pool")
end

---@param bossPool Decomp.Class.BossPool.Data
---@param pool Decomp.Pools.BossPool.Pool.Data
---@param targetWeight number
---@return Decomp.Pools.BossPool.Boss.Data? boss
local function PickBoss(bossPool, pool, targetWeight)
    if #pool.m_Bosses == 0 then
        return
    end

    if pool.m_TotalWeight < 0.0 then
        return
    end

    local bossEntry = pick_boss(pool, targetWeight)
    if bossEntry then
        bossPool.m_LevelBlacklist[bossEntry.m_BossId] = true
        return bossEntry
    end
end

---@param bossPool Decomp.Class.BossPool.Data
local function reset_removed_bosses(bossPool)
    for i = 1, #bossPool.m_RemovedBosses, 1 do
        bossPool.m_RemovedBosses[i] = false
        bossPool.m_LevelBlacklist[i] = false
    end
end

---@param bossPool Decomp.Class.BossPool.Data
---@param pool Decomp.Pools.BossPool.Pool.Data
---@param rng RNG
---@return BossType? boss
local function try_get_random_boss(bossPool, pool, rng)
    local bossEntry = Class.BossPool.PickBoss(pool, rng:RandomFloat() * pool.m_TotalWeight)

    if not bossEntry then
        reset_removed_bosses(bossPool)
        return
    end

    if not is_boss_entry_available(bossEntry) then
        return
    end

    if bossEntry.m_RoomVariantStart ~= 0 then
        return -bossEntry.m_RoomVariantStart
    end

    return bossEntry.m_BossId
end

---@param bossPool Decomp.Class.BossPool.Data
---@param pool Decomp.Pools.BossPool.Pool.Data
---@param rng RNG
---@return BossType? boss
local function get_random_boss(bossPool, pool, rng)
    for i = 1, 10, 1 do
        local boss = try_get_random_boss(bossPool, pool, rng)
        if boss then
            return boss
        end
    end
end

---@param bossPool Decomp.Class.BossPool.Data
---@param stage LevelStage
---@param stageType StageType
---@param rng RNG? -- unused in Rep+
---@return integer BossType
local function GetBossId(bossPool, stage, stageType, rng)
    local stageId = Class.RoomConfig.GetStageID(stage, stageType, -1)
    local pool = bossPool.m_Pools[stageId + 1]
    rng = pool.m_RNG

    local staticBoss = get_static_boss(stage, stageType)
    if staticBoss then
        return staticBoss
    end

    local specialBoss = get_special_boss(bossPool, pool, stage, stageType, rng)
    if specialBoss then
        return specialBoss
    end

    local pickRNG = RNG(); pickRNG:SetSeed(rng:GetSeed(), rng:GetShiftIdx())
    local randomBoss = get_random_boss(bossPool, pool, pickRNG)
    if randomBoss then
        return randomBoss
    end

    Isaac.DebugString("Failed to pick a boss room variant, defaulting to Monstro")
    return BossType.MONSTRO
end

--#endregion

--#region Module

---@param bossPool Decomp.Class.BossPool.Data
---@param pool Decomp.Pools.BossPool.Pool.Data
---@param targetWeight number
---@return Decomp.Pools.BossPool.Boss.Data? boss
function BossSelection.PickBoss(bossPool, pool, targetWeight) -- BossPool::PickBoss
    PickBoss(bossPool, pool, targetWeight)
end

---@param bossPool Decomp.Class.BossPool.Data
---@param stage LevelStage
---@param stageType StageType
---@param rng RNG? -- unused in Rep+
---@return integer BossType
function BossSelection.GetBossId(bossPool, stage, stageType, rng) -- BossPool::GetBossId
    return GetBossId(bossPool, stage, stageType, rng)
end

--#endregion