---@class Interface.AchievementOverlay
local Interface = require("Isaac.Interface.AchievementOverlay")

--#region Stub

local Stub = {}

---@param achievementOverlay Component.AchievementOverlay
function Stub.Destructor(achievementOverlay) end

---@param achievementOverlay Component.AchievementOverlay
function Stub.Init(achievementOverlay) end

---@param filepath string
function Stub.LoadConfig(filepath) end

---@param achievementOverlay Component.AchievementOverlay
function Stub.Update(achievementOverlay) end

---@param achievementOverlay Component.AchievementOverlay
function Stub.Render(achievementOverlay) end

---@param achievementOverlay Component.AchievementOverlay
function Stub.Show(achievementOverlay) end

---@return Component.AchievementOverlay
function Stub.New(achievementOverlay) end

--#endregion

Interface.Destructor = Stub.Destructor
Interface.Init = Stub.Init
Interface.LoadConfig = Stub.LoadConfig
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.Show = Stub.Show
Interface.New = Stub.New