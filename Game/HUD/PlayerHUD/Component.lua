---@class PlayerHUDComponent
---@field m_player EntityPlayerComponent : 0x0
---@field m_hud HUDComponent : 0x4
---@field m_playerHudIndex integer : 0x8
---@field m_redHeartFlashCountdown integer : 0xc
---@field m_heartInfo HeartHudComponent[] [24] : 0x10
---@field m_activeItem ActiveItemDescComponent[] [4] : 0x190
---@field m_trinket TrinketHudComponent[] [2] : 0x200
---@field m_pocketItem PocketItemComponent[] [4] : 0x220
---@field m_hasHolyMantle boolean : 0x690
---@field m_inventoryVector_qqq InventoryStruct[] : 0x694
---@field m_invalidateItemHistory boolean : 0x6a0
---@field m_invalidateBOC boolean : 0x6a1
---@field m_bagResultImage_qqq ImageComponent : 0x6a4

---@class HeartHudComponent
---@field visibility_qqq boolean : 0x0
---@field eternalHeartVisibility_qqq boolean : 0x1
---@field goldenHeartVisibility_qqq boolean : 0x2
---@field isFadeoutHeart boolean : 0x3
---@field flashType integer : 0x4
---@field spriteAnimation string : 0x8
---@field overlaySpriteAnimation string : 0xc

---@class TrinketHudComponent
---@field id TrinketType | integer
---@field slot integer
---@field image ImageComponent

---@class InventoryStruct
