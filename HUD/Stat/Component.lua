---@class StatHUDComponent
---@field m_sprite Sprite
---@field m_playerStats HudPlayerStatsComponent[]
---@field m_combineDeals boolean

---@class HudPlayerStatsComponent
---@field m_player EntityPlayerComponent?
---@field m_speed HudStatComponent
---@field m_tears HudStatComponent
---@field m_damage HudStatComponent
---@field m_range HudStatComponent
---@field m_shotSpeed HudStatComponent
---@field m_luck HudStatComponent
---@field m_devilChance HudStatComponent
---@field m_angelChance HudStatComponent
---@field m_planetariumChance HudStatComponent
---@field m_specialItemChance HudStatComponent

---@class HudStatComponent
---@field m_value number
---@field m_deltaFromPrevious number
---@field m_previousValue number
---@field m_deltaSensitivity number
---@field m_deltaCountdown integer

---@class StatHUDComponentUtils
local Module = {}

--#region Module



--#endregion

return Module