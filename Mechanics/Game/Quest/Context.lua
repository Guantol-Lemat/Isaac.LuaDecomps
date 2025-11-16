--#region Dependencies



--#endregion

---@class QuestContext
local Module = {}

---@class QuestContext.IsBackwardsPath
---@field mode integer
---@field gameStateFlags GameStateFlag | integer

---@class QuestContext.HasMirrorDimension : QuestContext.IsBackwardsPath
---@field curses LevelCurse | integer
---@field mode integer
---@field gameStateFlags GameStateFlag | integer

---@class QuestContext.HasAbandonedMineshaft : QuestContext.IsBackwardsPath
---@field curses LevelCurse | integer
---@field mode integer
---@field gameStateFlags GameStateFlag | integer

---@class QuestContext.HasPhotoDoor : QuestContext.IsBackwardsPath
---@field curses LevelCurse | integer
---@field mode integer
---@field gameStateFlags GameStateFlag | integer

---@class QuestContext.IsBackwardsPathEntrance : QuestContext.IsBackwardsPath
---@field curses LevelCurse | integer
---@field mode integer
---@field gameStateFlags GameStateFlag | integer

--#region Module



--#endregion

return Module