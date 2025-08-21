--#region Dependencies

local BitsetUtils = require("General.Bitset")

--#endregion

---@class ChallengeParamsUtils
local Module = {}

---@param challengeParams ChallengeParamsComponent
---@param curses LevelCurse | integer
---@return LevelCurse | integer
local function ApplyCurseModifiers(challengeParams, curses)
    curses = BitsetUtils.Set(curses, challengeParams.m_curses)
    curses = BitsetUtils.Clear(curses, challengeParams.m_curseFilter)
    return curses
end

--#region Module

Module.ApplyCurseModifiers = ApplyCurseModifiers

--#endregion

return Module