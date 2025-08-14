---@class Decomp.Lib.EntityPlayer
local Lib_EntityPlayer = {}
Decomp.Lib.EntityPlayer = Lib_EntityPlayer

local Lib = Decomp.Lib

---@param player EntityPlayer
---@return boolean mainTwin
function Lib_EntityPlayer.IsMainTwin(player)
    return GetPtrHash(player) == GetPtrHash(player:GetMainTwin())
end

---@param player EntityPlayer
---@return boolean jacobControls
function Lib_EntityPlayer.UsesJacobControls(player)
    local playerType = player:GetPlayerType()
    if not (playerType == PlayerType.PLAYER_JACOB or playerType == PlayerType.PLAYER_ESAU) then
        return false
    end

    return player:GetOtherTwin() ~= nil and Lib_EntityPlayer.IsMainTwin(player)
end

---@param player EntityPlayer
---@return boolean esauControls
function Lib_EntityPlayer.UsesEsauControls(player)
    local playerType = player:GetPlayerType()
    if not (playerType == PlayerType.PLAYER_JACOB or playerType == PlayerType.PLAYER_ESAU) then
        return false
    end

    return player:GetOtherTwin() ~= nil and not Lib_EntityPlayer.IsMainTwin(player)
end

---@param player EntityPlayer
---@param slot ActiveSlot
---@return ButtonAction
function Lib_EntityPlayer.GetActiveSlotButtonAction(player, slot)
    if (Lib_EntityPlayer.UsesEsauControls(player) and Options.JacobEsauControls == 0) or slot ~= ActiveSlot.SLOT_PRIMARY then
        return ButtonAction.ACTION_PILLCARD
    end

    return ButtonAction.ACTION_ITEM
end

---@param player EntityPlayer
function Lib_EntityPlayer.CanJacobEsauUseItem(player)
    local betterJacobEsauControls = Options.JacobEsauControls ~= 0
    local pressingDropAction = Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex)

    if betterJacobEsauControls then
        if Lib_EntityPlayer.UsesJacobControls(player) and pressingDropAction then
            return false
        end
    end

    if Lib_EntityPlayer.UsesEsauControls(player) and not pressingDropAction then
        return false
    end

    return true
end

---@param player EntityPlayer
---@param slot ActiveSlot
function Lib_EntityPlayer.IsControllingActiveItem(player, slot)
    if player:HasEntityFlags(EntityFlag.FLAG_BURN) or player:HasCurseMistEffect() or player:IsCoopGhost() then
        return false
    end

    local playerType = player:GetPlayerType()
    local isJacobEsau = playerType == PlayerType.PLAYER_JACOB or playerType == PlayerType.PLAYER_ESAU
    local buttonAction = Lib_EntityPlayer.GetActiveSlotButtonAction(player, slot)

    if not Input.IsActionPressed(buttonAction, player.ControllerIndex) then
        return false
    end

    if isJacobEsau and not Lib_EntityPlayer.CanJacobEsauUseItem(player) then
        return false
    end

    return true
end

---@param player EntityPlayer
---@param pickup EntityPickup
function Lib_EntityPlayer.CanQueueItem(player, pickup)
    return pickup.SubType ~= 0 and pickup.Wait <= 0 and
        not player:IsHoldingItem() and player:CanAddCollectible(pickup.SubType)
end

---@param player EntityPlayer
---@return boolean salvage
function Lib_EntityPlayer.HasFreeActiveSlot(player)
    local heldItem = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Item
    if not Lib.ItemConfig.IsValidCollectible(heldItem) or heldItem == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
        return true
    end

    heldItem = player:GetActiveItemDesc(ActiveSlot.SLOT_SECONDARY).Item
    if player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG, false) and (not Lib.ItemConfig.IsValidCollectible(heldItem) or heldItem == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        return true
    end

    return false
end