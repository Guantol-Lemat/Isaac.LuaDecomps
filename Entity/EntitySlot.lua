local super = require("Entity.Entity")
local Table = require("Lib.Table")
local Lib_Slot = require("Lib.EntitySlot")

local g_Game = Game()

---@class Decomp.Object.EntitySlot : Decomp.Class.EntitySlot.Data, Decomp.Class.EntitySlot.API

---@class Decomp.Class.EntitySlot.Data : Decomp.Class.Entity.Data
---@field object EntitySlot
---@field m_UnkShort1 integer
---@field m_Touch integer
---@field m_PrizeSprite Sprite

---@param data Decomp.Class.EntitySlot.Data
local function constructor(data)
    super.constructor(data)
    data.m_UnkShort1 = 0
    data.m_Touch = 0
    data.m_PrizeSprite = Sprite()
end

--#region Update

local s_BeggarSlot = Table.CreateDictionary({
    SlotVariant.BEGGAR, SlotVariant.DEVIL_BEGGAR, SlotVariant.KEY_MASTER,
    SlotVariant.BOMB_BUM, SlotVariant.BATTERY_BUM, SlotVariant.ROTTEN_BEGGAR,
})

---@param slot EntitySlot
local function slot_appear(slot)
    slot:SetState(0)
    slot:SetTimeout(0)
    slot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    ---@type SlotVariant
    local variant = slot.Variant
    if variant == SlotVariant.GREED_DONATION_MACHINE then
        GreedDonation_Appear()
    end
end

---@param slot EntitySlot
---@param sprite Sprite
local function init_donation_sprite(slot, sprite)
    sprite:Update()
    if not sprite:IsFinished("") then
        return
    end

    slot:SetState(1)
    sprite:SetAnimation("Prize", false)
    local coinCount = 0 -- Inaccessible field
    sprite:SetLayerFrame(1, (coinCount / 100) % 10)
    sprite:SetLayerFrame(2, (coinCount / 10) % 10)
    sprite:SetLayerFrame(3, coinCount % 10)
end

---@param slot EntitySlot
local function init_generic_slot(slot)
    local timeout = slot:GetTimeout()

    if timeout == 0 then
        local poofSubType = Lib_Slot.IsBeggar(slot.Variant) and 2 or 3
        g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, slot.Position, Vector(0, 0), nil, poofSubType, Random())
    end

    timeout = timeout + 1
    slot:SetTimeout(timeout)
    if timeout > 2 then
        slot.Visible = true
        slot:SetState(1)
    end
end

---@param slot EntitySlot
local function init_slot(slot)
    local sprite = slot:GetSprite()

    if not sprite:IsPlaying("Appear") then
        init_donation_sprite(slot, sprite)
    else
        init_generic_slot(slot)
    end
end

local s_ShouldAlwayUpdateVelocity = Table.CreateDictionary({
    SlotVariant.SHELL_GAME, SlotVariant.HELL_GAME,
    SlotVariant.DONATION_MACHINE, SlotVariant.GREED_DONATION_MACHINE,
})

---@param slot EntitySlot
local function update_slot_physics(slot)
    local targetPosition = slot.TargetPosition
    if targetPosition.X == 0 and targetPosition.Y == 0 then
        slot.TargetPosition = slot.Position
        slot.Velocity = Vector(0, 0)
    end

    slot.Friction = slot.Friction * 0.8

    if slot:GetState() == 3 then
        slot.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    end

    if slot:GetState() ~= 3 or s_ShouldAlwayUpdateVelocity[slot.Variant] then
        slot.Velocity = slot.TargetPosition - slot.Position
    end
end

---@param slot EntitySlot
local function on_timeout_end(slot)
    --TODO
end

---@param slot EntitySlot
local function should_trigger_prize_logic(slot)
    ---@type SlotVariant
    local variant = slot.Variant
    local sprite = slot:GetSprite()

    if variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME then
        return slot:GetState() == 5
    end

    if slot:GetState() ~= 2 or slot:GetTimeout() ~= 0 then
        return false
    end

    if (Lib_Slot.IsBeggar(variant) or variant == SlotVariant.HOME_CLOSET_PLAYER) and
       (sprite:IsPlaying("PayPrize") and not sprite:IsFinished()) then
        return false
    end

    return true
end

---@param slot EntitySlot
local function update_prize_logic(slot)
    if should_trigger_prize_logic(slot) then
        trigger_prize_logic()
    else
        update_wait_prize_logic()
    end
end

---@param slot Decomp.Object.EntitySlot
local function Update(slot)
    local slotObject = slot.object
    ---@type SlotVariant
    local variant = slotObject.Variant

    if variant == SlotVariant.CRANE_GAME then
        CraneGame_PreUpdate()
    elseif variant == SlotVariant.MOMS_DRESSING_TABLE then
        MomsDressingTable_PreUpdate()
    end

    if slotObject:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
        slot_appear(slotObject)
    end

    if slotObject:GetState() == 0 then
        init_slot(slotObject)
        return
    end

    if variant == SlotVariant.ROTTEN_BEGGAR and g_Game:GetFrameCount() - slotObject.FrameCount == 1 then
        RottenBeggar_SpawnParticles()
    end

    --- The game just assumes the target is a player if not null
    local player = slotObject.Target and slotObject.Target:ToPlayer() or Isaac.GetPlayer(0)
    local daemonsTailRNG = player:GetTrinketRNG(TrinketType.TRINKET_DAEMONS_TAIL)
    local luckyFootRNG = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_LUCKY_FOOT)

    update_slot_physics(slotObject)
    if variant == SlotVariant.SHOP_RESTOCK_MACHINE then
        ShopRestock_TryShopRestock()
    end

    if variant == SlotVariant.BOMB_BUM then
        BombBum_UpdateRage()
    end

    local timeout = slotObject:GetTimeout()
    if timeout > 0 then
        slotObject:SetTimeout(timeout - 1)
    end

    if slotObject:GetTimeout() == 0 then
        on_timeout_end(slotObject)
    end

    update_prize_logic(slotObject)

    if variant == SlotVariant.SHELL_GAME or variant == SlotVariant.HELL_GAME then
        update_shell_game_shuffle_logic()
    end

    if slot.m_UnkShort1 == 0 then
        slot.m_Touch = 0
    else
        slot.m_Touch = slot.m_Touch + 1
        slot.m_UnkShort1 = slot.m_UnkShort1 - 1
    end

    super.API.Update(slotObject)
    slot.m_PrizeSprite:Update()
end

--#endregion

--#region Module

---@class Decomp.Class.EntitySlot.API : Decomp.Class.Entity.API
local API = {}

---@class Decomp.Class.EntitySlot : Decomp.Interface.EntityCreate
local Class_EntitySlot = {
    constructor = constructor,
    API = API
}

---@param slot Decomp.Object.EntitySlot
function API.Update(slot)
    Update(slot)
end

--#endregion