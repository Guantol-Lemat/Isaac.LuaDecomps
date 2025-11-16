---@class BossPoolsUtils
local Module = {}

---@param bossPool BossPoolComponent
local function ResetLevelBlacklist(bossPool)
    local bossLevelBlacklist = bossPool.m_levelBlacklist
    for i = 1, #bossLevelBlacklist, 1 do
        bossLevelBlacklist[i] = false
    end
end

---@param bossPool BossPoolComponent
local function CommitLevelBlacklist(bossPool)
    local levelBlacklist = bossPool.m_levelBlacklist
    local removedBosses = bossPool.m_removedBosses

    for i = 1, #removedBosses, 1 do
        removedBosses[i] = not not (removedBosses[i] or levelBlacklist[i])
    end
end

--#region Module

Module.ResetLevelBlacklist = ResetLevelBlacklist
Module.CommitLevelBlacklist = CommitLevelBlacklist

--#endregion

return Module