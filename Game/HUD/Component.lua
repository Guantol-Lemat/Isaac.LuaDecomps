---@class HUDComponent
---@field m_statHUD StatHUDComponent
---@field m_hudRefreshType integer
---@field m_isVisible boolean
---@field m_bossBar_health number
---@field m_bossBar_damageFlashCountdown integer
---@field m_bossBar_healFlashCountdown integer

---@class HUDComponentUtils
local Module = {}

---@return HUDComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module