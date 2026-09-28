---@class Interface.Leaderboard
local Interface = require("Isaac.Interface.Leaderboard")

--#region Stub

local Stub = {}

---@return Component.Leaderboard
function Stub.constructor() end

---@param leaderboard Component.Leaderboard
function Stub.Destructor(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.Init(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.ReloadGraphics(leaderboard) end

---@param leaderboard Component.Leaderboard
---@return boolean
function Stub.CanGoLeft(leaderboard) end

---@param leaderboard Component.Leaderboard
---@return boolean
function Stub.CanGoRight(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.ProcessInput(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.Update(leaderboard) end

---@param param_1 Vector
---@param param_2 unknown
---@param param_3 unknown
function Stub.render_score_line(param_1, param_2, param_3) end

---@param param_1 integer
---@return string
function Stub.get_ordinal_suffix(param_1) end

---@param leaderboard Component.Leaderboard
function Stub.render_score(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.render_leaderboard(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.Render(leaderboard) end

---@param param_2_00 unknown
---@param param_3 unknown
---@param param_4 integer
---@return string
function Stub.GetLeaderboardName(param_2_00, param_3, param_4) end

---@param leaderboard Component.Leaderboard
---@param param_1 integer
---@param param_2 unknown
function Stub.get_leaderboard(leaderboard, param_1, param_2) end

---@param leaderboard Component.Leaderboard
---@param param_1 unknown
---@param param_2 unknown
function Stub.show_leaderboard(leaderboard, param_1, param_2) end

---@param leaderboard Component.Leaderboard
---@param Date integer
---@param ScoreSheet Component.ScoreSheet
---@param SubmitScore boolean
function Stub.Show(leaderboard, Date, ScoreSheet, SubmitScore) end

---@param leaderboard Component.Leaderboard
function Stub.Hide(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.PreLanguageSwitch(leaderboard) end

---@param leaderboard Component.Leaderboard
function Stub.PostLanguageSwitch(leaderboard) end

---@param param_1 unknown
---@param param_2 Component.Leaderboard
function Stub.OnScoreLeaderboardFound(param_1, param_2) end

---@param param_1 unknown
---@param param_2 Component.Leaderboard
function Stub.OnTimeLeaderboardFound(param_1, param_2) end

---@param param_1 boolean
---@param param_2 unknown
---@param param_3 unknown
---@param param_4 integer
---@param param_5 Component.Leaderboard
---@return unknown
function Stub.OnScoreUploaded(param_1, param_2, param_3, param_4, param_5) end

---@param param_1 unknown
---@param param_2 unknown
---@param param_3 unknown
---@param param_4 unknown
---@param param_5 Component.Leaderboard
function Stub.OnTimeUploaded(param_1, param_2, param_3, param_4, param_5) end

---@param param_1 integer
---@param param_2 integer
---@param param_3 Component.Leaderboard
function Stub.OnScoresDownloaded(param_1, param_2, param_3) end

---@param param_1 Engine.DateTime
---@return integer
function Stub.DailyChallengeFromDate(param_1) end

---@param param_1 integer
---@param param_2 integer
---@return integer
function Stub.DateFromDailyChallenge(param_1, param_2) end

--#endregion

Interface.constructor = Stub.constructor
Interface.Destructor = Stub.Destructor
Interface.Init = Stub.Init
Interface.ReloadGraphics = Stub.ReloadGraphics
Interface.CanGoLeft = Stub.CanGoLeft
Interface.CanGoRight = Stub.CanGoRight
Interface.ProcessInput = Stub.ProcessInput
Interface.Update = Stub.Update
Interface.render_score_line = Stub.render_score_line
Interface.get_ordinal_suffix = Stub.get_ordinal_suffix
Interface.render_score = Stub.render_score
Interface.render_leaderboard = Stub.render_leaderboard
Interface.Render = Stub.Render
Interface.GetLeaderboardName = Stub.GetLeaderboardName
Interface.get_leaderboard = Stub.get_leaderboard
Interface.show_leaderboard = Stub.show_leaderboard
Interface.Show = Stub.Show
Interface.Hide = Stub.Hide
Interface.PreLanguageSwitch = Stub.PreLanguageSwitch
Interface.PostLanguageSwitch = Stub.PostLanguageSwitch
Interface.OnScoreLeaderboardFound = Stub.OnScoreLeaderboardFound
Interface.OnTimeLeaderboardFound = Stub.OnTimeLeaderboardFound
Interface.OnScoreUploaded = Stub.OnScoreUploaded
Interface.OnTimeUploaded = Stub.OnTimeUploaded
Interface.OnScoresDownloaded = Stub.OnScoresDownloaded
Interface.DailyChallengeFromDate = Stub.DailyChallengeFromDate
Interface.DateFromDailyChallenge = Stub.DateFromDailyChallenge