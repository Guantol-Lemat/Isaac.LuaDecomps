---@class Decomp.Collectible.BagOfCrafting
local BagOfCrafting = {}
Decomp.Item.Collectible.BagOfCrafting = BagOfCrafting

BagOfCrafting.COLLECTIBLE_ID = CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING

local g_Game = Game()
local g_HUD = g_Game:GetHUD()
local g_ItemConfig = Isaac.GetItemConfig()
local g_SFXManager = SFXManager()

local Lib = {
    ItemConfig = require("Lib.ItemConfig"),
    EntityPlayer = require("Lib.EntityPlayer")
}

--#region ControlActiveItem

---@param player EntityPlayer
---@param slot ActiveSlot
local function should_update_bag_of_crafting_control(player, slot)
    return slot == ActiveSlot.SLOT_POCKET and not player:HasEntityFlags(EntityFlag.FLAG_INTERPOLATION_UPDATE)
end

---@param player EntityPlayer
---@param controllingActiveItem boolean
---@return boolean craftingItem
local function is_crafting_item(player, controllingActiveItem)
    if player:GetItemState() ~= CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING then
        return false
    end

    if not player:AreControlsEnabled() or not controllingActiveItem then
        return false
    end

    return player:GetBagOfCraftingOutput() ~= CollectibleType.COLLECTIBLE_NULL
end

---@param player EntityPlayer
---@return integer craftingTimer
local function get_crafting_timer(player)
    local playerData = player:GetData()

    if not playerData.craftingTimer then
        playerData.craftingTimer = 0
    end

    return playerData.craftingTimer
end

---@param player EntityPlayer
---@param value integer
local function set_crafting_timer(player, value)
    player:GetData().craftingTimer = value
end

---@param player EntityPlayer
---@return boolean craftItem
local function should_craft_item(player)
    return get_crafting_timer(player) >= 30
end

---@param player EntityPlayer
local function salvage_active_item(player)
    local heldItem = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Item
    player:RemoveCollectible(heldItem, false, ActiveSlot.SLOT_PRIMARY, false)
    local pool = g_Game:IsGreedMode() and ItemPoolType.POOL_GREED_TREASURE or ItemPoolType.POOL_TREASURE
    player:SalvageCollectible(heldItem, player.Position, player:GetCollectibleRNG(heldItem), pool)
end

---@param player EntityPlayer
---@param collectible CollectibleType
local function queue_crafting_item(player, collectible)
    local collectibleConfig = g_ItemConfig:GetCollectible(collectible)
    if not collectibleConfig then
        return
    end

    player:AnimateCollectible(collectible, "Pickup", "PlayerPickupSparkle")

    if collectibleConfig.Type == ItemType.ITEM_ACTIVE then
        player:FlushQueueItem()
        if not Lib.EntityPlayer.HasFreeActiveSlot(player) then
            salvage_active_item(player)
        end
    end

    g_HUD:ShowItemText(player, collectibleConfig)
    player:QueueItem(collectibleConfig, collectibleConfig.InitCharge, false, false, -1)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, false) then
        local wisp = EntityFamiliar.GetRandomWisp(player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING))
        player:AddWisp(wisp, player.Position, false, false)
    end
end

---@param player EntityPlayer
local function craft_item(player)
    player:ResetItemState()

    queue_crafting_item(player, player:GetBagOfCraftingOutput())

    set_crafting_timer(player, 0)
    player:SetBagOfCraftingOutput(CollectibleType.COLLECTIBLE_NULL, ItemPoolType.POOL_NULL)
    player:SetBagOfCraftingContent({0, 0, 0, 0, 0, 0, 0, 0})
    g_HUD:InvalidateCraftingItem(player)
    g_SFXManager:Play(SoundEffect.SOUND_POWERUP_SPEWER, 1.0, 2, false, 1.0, 0)
end

---@param player EntityPlayer
---@param slot ActiveSlot
---@param controllingActiveItem boolean
function BagOfCrafting.ControlActiveItem(player, slot, controllingActiveItem)
    if not should_update_bag_of_crafting_control(player, slot) then
        return
    end

    if not is_crafting_item(player, controllingActiveItem) then
        set_crafting_timer(player, 0)
        return
    end

    local craftingTimer = get_crafting_timer(player) + 1
    set_crafting_timer(player, craftingTimer)

    if should_craft_item(player) then
        craft_item(player)
    end
end

--#endregion