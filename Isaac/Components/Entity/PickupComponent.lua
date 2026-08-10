---@class Component.Entity.Pickup : Component.Entity
---@field m_priceANM2 Sprite : 0x360
---@field m_charge integer : 0x474
---@field m_optionsPickupIndex integer : 0x478
---@field m_touched boolean : 0x47c
---@field m_probablyUnkBool boolean : 0x47d
---@field m_isBlind boolean : 0x47e
---@field m_payToPlay boolean : 0x47f
---@field m_price eShopItemPrice | integer : 0x480
---@field m_autoUpdatePrice boolean : 0x484
---@field m_shopItemId integer : 0x488
---@field m_timeout integer : 0x48c
---@field m_wait integer : 0x490
---@field m_eternalChest_reCloseCountdown integer : 0x494
---@field m_stickyNickelRelated integer : 0x498
---@field m_dropDelay integer : 0x4a0
---@field m_camoColor_qqq Color : 0x4a4
---@field m_state integer : 0x4d0
---@field m_coopExtra_collectedItems integer : 0x4d4
---@field m_unkEntRef3_qqq Component.EntityPtr : 0x4d8
---@field m_pickupGhost_qqq Component.EntityPtr : 0x4dc
---@field m_megaChestCollectible Component.EntityPtr[] [2] : 0x4e0
---@field m_activeVarData integer : 0x4e8
---@field m_cycle_collectibleList integer[] [8] : 0x4ec
---@field m_cycle_cycleNum integer : 0x50c
---@field m_visibilityDelayTimer_qqq integer : 0x510
---@field m_flip_saveState Component.EntitySaveState? : 0x514
---@field m_flip_collectibleSprite Sprite : 0x51c
---@field m_throw_height number : 0x630
---@field m_throw_speed number : 0x630

local UNINITIALIZED_INT = 0
local UNINITIALIZED_FLOAT = 0.0
local UNINITIALIZED_BOOL = false

local IEntity = require("Isaac.Interface.Entity")
local IEntityPickup = require("Isaac.Interface.Entity_Pickup")
local IEntityPtr = IEntity.EntityPtr

---@param entity Component.Entity
local function init_virtual_functions(entity)
    entity.Init = IEntityPickup.Init
    entity.Update = IEntityPickup.Update
    entity.Interpolate = IEntityPickup.Interpolate
    entity.Render = IEntityPickup.Render
    entity.TakeDamage = IEntityPickup.TakeDamage
    entity.Remove = IEntityPickup.Remove
    entity.ClearReferences = IEntityPickup.ClearReferences
    entity.TryThrow = IEntityPickup.TryThrow
    entity.HandleCollision = IEntityPickup.handle_collision
end

---@return Component.Entity.Pickup
local function New()
    local entity = IEntity.New()
    ---@cast entity Component.Entity.Pickup

    init_virtual_functions(entity)

    entity.m_priceANM2 = Sprite()
    entity.m_charge = UNINITIALIZED_INT
    entity.m_optionsPickupIndex = UNINITIALIZED_INT
    entity.m_touched = UNINITIALIZED_BOOL
    entity.m_probablyUnkBool = UNINITIALIZED_BOOL
    entity.m_isBlind = UNINITIALIZED_BOOL
    entity.m_payToPlay = UNINITIALIZED_BOOL
    entity.m_price = UNINITIALIZED_INT
    entity.m_autoUpdatePrice = UNINITIALIZED_BOOL
    entity.m_shopItemId = UNINITIALIZED_INT
    entity.m_timeout = UNINITIALIZED_INT
    entity.m_wait = UNINITIALIZED_INT
    entity.m_eternalChest_reCloseCountdown = UNINITIALIZED_INT
    entity.m_stickyNickelRelated = UNINITIALIZED_INT
    entity.m_dropDelay = UNINITIALIZED_INT
    entity.m_camoColor_qqq = Color()
    entity.m_state = UNINITIALIZED_INT
    entity.m_coopExtra_collectedItems = UNINITIALIZED_INT
    entity.m_unkEntRef3_qqq = IEntityPtr.New(nil)
    entity.m_pickupGhost_qqq = IEntityPtr.New(nil)
    entity.m_megaChestCollectible = {IEntityPtr.New(nil), IEntityPtr.New(nil)}
    entity.m_activeVarData = UNINITIALIZED_INT
    entity.m_cycle_collectibleList = {}
    entity.m_cycle_cycleNum = UNINITIALIZED_INT
    entity.m_visibilityDelayTimer_qqq = UNINITIALIZED_INT
    entity.m_flip_saveState = nil
    entity.m_flip_collectibleSprite = Sprite()
    entity.m_throw_height = UNINITIALIZED_FLOAT
    entity.m_throw_speed = UNINITIALIZED_FLOAT

    return entity
end


---@class Module.Entity.PickupComponent
local Module = {
    New = New
}

return Module