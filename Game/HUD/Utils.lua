--#region Dependencies



--#endregion

---@class HUDUtils
local Module = {}

---@param hud HUDComponent
---@param health number
local function SetBossHealth(hud, health)
    local previousHealth = hud.m_bossBar_health
    if previousHealth > health then
        hud.m_bossBar_damageFlashCountdown = 8
    elseif previousHealth < health and previousHealth ~= -1 then
        hud.m_bossBar_damageFlashCountdown = -1
        hud.m_bossBar_healFlashCountdown = 8
    end

    hud.m_bossBar_health = health
end

--#region Module

Module.SetBossHealth = SetBossHealth

--#endregion

return Module