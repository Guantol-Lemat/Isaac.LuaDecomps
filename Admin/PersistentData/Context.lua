--#region Dependencies



--#endregion

---@class PersistentDataContext
local Module = {}

---@class PersistentDataContext.Unlocked
---@field forceUnlock boolean

---@param admin Admin
---@param game GameComponent
---@return PersistentDataContext.Unlocked
local function BuildUnlockedContext(admin, game)
    local forceUnlock = admin.m_state == 2 and (game.m_dailyChallenge.m_id ~= 0 or game.m_isDebug)
    ---@type PersistentDataContext.Unlocked
    return {
        forceUnlock = forceUnlock
    }
end

--#region Module

Module.BuildUnlockedContext = BuildUnlockedContext

--#endregion

return Module