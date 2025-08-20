---@class StatHudUtils
local Module = {}

local DELTA_DURATION = 150
local DELTA_FADEIN_END = 135
local DELTA_FADEOUT_START = 30

---@enum eHudStat
local eHudStat = {
    SPEED = 1,
    TEARS = 2,
    DAMAGE = 3,
    RANGE = 4,
    SHOT_SPEED = 5,
    LUCK = 6,
    DEVIL_CHANCE = 7,
    ANGEL_CHANCE = 8,
    PLANETARIUM_CHANCE = 9,
    SPECIAL_ITEM_CHANCE = 10,

    NUM_HUD_STATS = 10,
}

local hudStatToKey = {
    [eHudStat.SPEED] = "m_speed",
    [eHudStat.TEARS] = "m_tears",
    [eHudStat.DAMAGE] = "m_damage",
    [eHudStat.RANGE] = "m_range",
    [eHudStat.SHOT_SPEED] = "m_shotSpeed",
    [eHudStat.LUCK] = "m_luck",
    [eHudStat.DEVIL_CHANCE] = "m_devilChance",
    [eHudStat.ANGEL_CHANCE] = "m_angelChance",
    [eHudStat.PLANETARIUM_CHANCE] = "m_planetariumChance",
    [eHudStat.SPECIAL_ITEM_CHANCE] = "m_specialItemChance",
}

---@param playerStats HudPlayerStatsComponent
---@param hudStat eHudStat
---@return HudStatComponent
local function GetStat(playerStats, hudStat)
    local key = hudStatToKey[hudStat]
    return playerStats[key]
end

---@param stat HudStatComponent
---@param newValue number
---@param existingPlayer boolean
local function SetStat(stat, newValue, existingPlayer)
    local currentValue = stat.m_value

    if not existingPlayer then
        stat.m_previousValue = currentValue
        stat.m_deltaFromPrevious = 0.0
        stat.m_deltaCountdown = 0
        stat.m_value = newValue
        return
    end

    if currentValue == newValue then
        return
    end

    if stat.m_deltaCountdown >= DELTA_FADEOUT_START + 1 then
        stat.m_deltaCountdown = math.max(stat.m_deltaCountdown, DELTA_FADEIN_END)
        stat.m_deltaFromPrevious = newValue - stat.m_previousValue
    else
        stat.m_previousValue = currentValue
        stat.m_deltaFromPrevious = newValue - currentValue

        if stat.m_deltaSensitivity <= math.abs(stat.m_deltaFromPrevious) then
            stat.m_deltaCountdown = DELTA_DURATION
        end
    end

    stat.m_value = newValue
end

--#region Module

Module.eHudStat = eHudStat
Module.DELTA_DURATION = DELTA_DURATION
Module.DELTA_FADEIN_END = DELTA_FADEIN_END
Module.DELTA_FADEOUT_START = DELTA_FADEOUT_START

Module.GetStat = GetStat
Module.SetStat = SetStat

--#endregion

return Module