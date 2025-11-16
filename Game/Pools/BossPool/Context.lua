--#region Dependencies



--#endregion

---@class BossPoolContext
local Module = {}

---@class BossPoolContext.GetBoss
---@field persistentGameData PersistentDataComponent
---@field challenge Challenge | integer
---@field dailyChallenge DailyChallengeComponent
---@field mode integer

---@param context Context
---@param result BossPoolContext.GetBoss
---@return BossPoolContext.GetBoss
local function BuildGetBossContext(context, result)

end

--#region Module

Module.BuildGetBossContext = BuildGetBossContext

--#endregion

return Module