---@class HUDComponent
---@field m_playerHUD Component.PlayerHUD[] [8] : 0x0
---@field m_font_MPlus_12b Font : 0x3580
---@field m_font_MPlus_10r Font : 0x235bc
---@field m_font_KR_Font14 Font : 0x435f8
---@field m_font_KR_MeatFont14 Font : 0x63634
---@field m_font_KR_Font12 Font : 0x83670
---@field m_font_TeamMeatFont10 Font : 0xa36ac
---@field m_chargeBarSprite Sprite : 0xc36e8
---@field m_heartsSprite Sprite : 0xc37fc
---@field m_pickupHUDSprite Sprite : 0xc3910
---@field m_bossBar_barImage ImageComponent : 0xc3a24
---@field m_bossBar_miniBarImage ImageComponent : 0xc3a2c
---@field m_bossBar_staticImage ImageComponent : 0xc3a34
---@field m_bossBar_stoneImage ImageComponent : 0xc3a3c
---@field m_cardsPillsSprite Sprite : 0xc3a44
---@field m_streakSprite Sprite : 0xc3b58
---@field m_fortuneSprite Sprite : 0xc3c6c
---@field m_oldHUDStatsSprite Sprite : 0xc3d80
---@field m_itemTextSurfaceImage ImageComponent : 0xc3e94
---@field m_spiderMod_healthBarImage ImageComponent : 0xc3e9c
---@field m_bossBar_health number : 0xc3ea4
---@field m_bossBar_damageFlashCountdown integer : 0xc3ea8
---@field m_bossBar_healFlashCountdown integer : 0xc3eac
---@field m_bossBar_forceBottomPosition boolean : 0xc3eb0
---@field m_usedByGideonSpawnNextWave1 integer : 0xc3eb2
---@field m_usedByGideonSpawnNextWave2 integer : 0xc3eb4
---@field m_isVisible boolean : 0xc3eb6
---@field m_graphicsLoaded boolean : 0xc3eb7
---@field m_hudRefreshType integer : 0xc3eb8
---@field m_hudRefreshCountdown_qqq integer : 0xc3ec0
---@field m_coopMenuSprite Sprite : 0xc3ec4
---@field m_inventorySprite Sprite : 0xc3fd8
---@field m_craftingTableSprite Sprite : 0xc40ec
---@field m_poopSpellsSprite Sprite : 0xc4200
---@field m_statHUD StatHUDComponent : 0xc4314
---@field m_historyHUD Component.HistoryHUD : 0xc45c4

---@class HUDComponentUtils
local Module = {}

---@return HUDComponent
local function Create()
end

--#region Module

Module.Create = Create

--#endregion

return Module