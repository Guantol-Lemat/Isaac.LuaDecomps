--#region Dependencies

local NetManagerUtils = require("Isaac.NetManager.Utils")
local Enums = require("General.Enums")

local eCoopStat = Enums.eCoopStat
--#endregion

---@class CoopStatsLogic
local Module = {}

---@class CoopStatsContext.Finalize
---@field netManager NetManagerComponent

---@param awardDesc CoopAwardDescComponent
---@param playerInfos CoopStats.PlayerInfoComponent
local function get_award_winners(awardDesc, playerInfos)
    local highestWins = awardDesc.highestWins
    local allowsMultipleWinners = awardDesc.allowsMultipleWinners
    local minimumStages = awardDesc.minimumStages
    local statId = awardDesc.stat

    local bestScore = not highestWins and math.huge or 0.0

    if statId == eCoopStat.NUM_COOP_STATS then
        return
    end

    local finalizedWinners = {}

    for i = 1, #playerInfos, 1 do
        local playerInfo = playerInfos
        local stat = playerInfo.m_stats[statId + 1] -- use lua 1-indexed

        local isBetterScore = highestWins == (stat > bestScore)
        local isEqualScore = stat == bestScore

        if not (isBetterScore or isEqualScore) then
            goto continue
        end

        if minimumStages > playerInfo.m_stats[eCoopStat.STAT_STAGE_TRANSITION + 1] then
            goto continue
        end

        if isEqualScore then
            if not allowsMultipleWinners then
                -- in case of parity then no one gets the award
                finalizedWinners = {}
                goto continue
            end
        elseif isBetterScore then
            -- reset table
            finalizedWinners = {}
            bestScore = stat
        end

        table.insert(finalizedWinners, playerInfo.m_userId)
        ::continue::
    end

    awardDesc.finalizedWinners = finalizedWinners
end

---@param context CoopStatsContext.Finalize
---@param coopStats CoopStatsComponent
local function Finalize(context, coopStats)
    local netManager = context.netManager
    local playerInfos = coopStats.m_playerInfos

    if NetManagerUtils.IsNetPlay(netManager) and #playerInfos > 4 then
        -- Remove no longer connected players until we trim the list to 4 players
        local count = #playerInfos
        for i = count, 1, -1 do
            local playerInfo = playerInfos[i]
            local device = NetManagerUtils.GetDeviceByUserId(netManager, playerInfo.m_userId)

            if not device then
                goto continue
            end

            table.remove(playerInfos, i)
            count = count - 1

            if count <= 4 then
                break
            end
            ::continue::
        end
    end

    local awards = coopStats.m_awards
    for i = 1, #awards, 1 do
        get_award_winners(awards[i], playerInfos)
    end

    coopStats.m_finalized = true
end

--#region Module

Module.Finalize = Finalize

--#endregion

return Module