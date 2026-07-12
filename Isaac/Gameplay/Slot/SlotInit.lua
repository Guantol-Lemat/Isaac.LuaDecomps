--#region Dependencies

local IGame = require("Isaac.Interface.Game")
local IEntity = require("Isaac.Interface.Entity")

local Actor_ShellGame = require("Isaac.Actor.Slot.ShellGame")
local Actor_DonationMachine = require("Isaac.Actor.Slot.DonationMachine")
local Actor_ShopRestockMachine = require("Isaac.Actor.Slot.ShopRestockMachine")
local Actor_GreedDonationMachine = require("Isaac.Actor.Slot.GreedDonationMachine")
local Actor_MomsDressingTable = require("Isaac.Actor.Slot.MomsDressingTable")
local Actor_HomeClosetPlayer = require("Isaac.Actor.Slot.HomeClosetPlayer")

--#endregion

---@alias Slot.Switch.Init fun(slot: Component.Entity.Slot, ctx: Context.Common)

---@type Slot.Switch.Init
local function machine_init(slot, ctx)
    slot.m_positionOffset.Y = -8.0
    slot.m_sizeMulti = Vector(1.5, 0.75)
end

---@type Slot.Switch.Init
local function blood_donation_machine_init(slot, ctx)
    machine_init(slot, ctx)
    slot.m_positionOffset.X = -5.0
end

---@type Slot.Switch.Init
local function beggar_init(slot)
    slot.m_positionOffset.Y = 8.0
end

local Switch_Init = {
    [SlotVariant.SLOT_MACHINE] = machine_init,
    [SlotVariant.BLOOD_DONATION_MACHINE] = blood_donation_machine_init,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = machine_init,
    [SlotVariant.BEGGAR] = beggar_init,
    [SlotVariant.DEVIL_BEGGAR] = beggar_init,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.Init,
    [SlotVariant.KEY_MASTER] = beggar_init,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.Init,
    [SlotVariant.BOMB_BUM] = beggar_init,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.Init,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.Init,
    [SlotVariant.MOMS_DRESSING_TABLE] = Actor_MomsDressingTable.Init,
    [SlotVariant.BATTERY_BUM] = beggar_init,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.Init,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.Init,
    [SlotVariant.CRANE_GAME] = machine_init,
    [SlotVariant.CONFESSIONAL] = machine_init,
    [SlotVariant.ROTTEN_BEGGAR] = beggar_init,
}

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param entityType EntityType | integer
---@param variant integer
---@param subType integer
---@param seed integer
local function Init(slot, ctx, entityType, variant, subType, seed)
    if IGame.IsGreedMode(ctx.game) and variant == SlotVariant.BLOOD_DONATION_MACHINE then
        variant = SlotVariant.DEVIL_BEGGAR
    end

    IEntity.Init(ctx, slot, entityType, variant, subType, seed)

    local myConfig = slot.m_config
    if myConfig then
        local mySprite = slot.m_sprite
        mySprite:Load(myConfig.anm2Path, true)
        mySprite:Play(mySprite:GetDefaultAnimation(), false)
    end

    slot.m_targetPosition = Vector(0, 0)
    slot.m_positionOffset = Vector(0, 0)
    slot.m_sizeMulti = Vector(1, 1)
    slot.m_donationValue = 0
    slot.m_triggerTimer = 0
    slot.m_unkShort1 = 0
    slot.m_touch = 0
    slot.m_state = SlotState.IDLE
    slot.m_shellGame_prizeSprite:Reset()
    slot.m_prizeCollectible = CollectibleType.COLLECTIBLE_NULL

    local InitLogic = Switch_Init[slot.m_variant]
    if InitLogic then
        InitLogic(slot, ctx)
    end

    slot.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    slot.m_timeout = 0
end

---@class Gameplay.Slot.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module