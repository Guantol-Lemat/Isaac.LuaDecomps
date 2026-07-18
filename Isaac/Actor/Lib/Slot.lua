--#region Dependencies

local IManager = require("Isaac.Interface.Manager")
local IGame = require("Isaac.Interface.Game")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityRef = IEntity.EntityRef
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

---@alias Slot.Function.GetTargetDonationValue fun(slot: Component.Entity.Slot, ctx: Context.Common): integer

local VECTOR_ZERO = Vector(0, 0)

local ANIMATION_SLOT_INITIATE = "Initiate"
local ANIMATION_BEGGAR_PRIZE = "PayPrize"
local ANIMATION_BEGGAR_NO_PRIZE = "PayNothing"
local ANIMATION_DONATION_COIN_INSERT = {
    [1] = "CoinInsert", -- Normal
    [2] = "CoinInsert2", -- Fast
    [3] = "CoinInsert3", -- Fastest
}

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount integer
---@return boolean payed
---@return boolean? ignoreCollision
local function PayCoins(ctx, player, amount)
    if player.m_numCoins < amount then
        return false
    end

    IEntityPlayer.AddCoins(ctx, player, -amount)
    return true
end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount integer
---@return boolean payed
---@return boolean? ignoreCollision
local function PayKeys(ctx, player, amount)
    if player.m_numKeys < amount then
        return false
    end

    IEntityPlayer.AddKeys(ctx, player, -amount)
    return true
end

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount integer
---@return boolean payed
---@return boolean? ignoreCollision
local function PayBombs(ctx, player, amount)
    if player.m_numBombs < amount then
        return false
    end

    IEntityPlayer.AddBombs(ctx, player, -amount)
    return true
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param amount number -- as damage to inflict on the player
---@return boolean payed
---@return boolean? ignoreCollision
local function PayHeart(slot, ctx, player, amount)
    if IEntityPlayer.IsP2Appearing(player) then
        return false, true
    end

    if player.m_damageCooldown > 14 then
        return false
    end

    player.m_damageCooldown = 0
    local flags = DamageFlag.DAMAGE_RED_HEARTS
    if ctx.game.m_challenge == Challenge.CHALLENGE_GUARDIAN then
        flags = flags | DamageFlag.DAMAGE_ISSAC_HEART
    end

    local ref = IEntityRef.New(slot)
    player:TakeDamage(ctx, amount, flags, ref, 30)
    return true
end

---@param slot Component.Entity.Slot
local function SlotMachine_SetupPrize(slot)
    slot.m_state = SlotState.REWARD
    slot.m_timeout = 30
    slot.m_sprite:Play(ANIMATION_SLOT_INITIATE, false)
end

---@param slot Component.Entity.Slot
local function Beggar_SetupPrize(slot)
    slot.m_state = SlotState.REWARD
    slot.m_sprite:Play(ANIMATION_BEGGAR_PRIZE, true)
end

---@param slot Component.Entity.Slot
local function Beggar_SetupNoPrize(slot)
    slot.m_sprite:Play(ANIMATION_BEGGAR_NO_PRIZE, true)
end

---@type Slot.Function.GetTargetDonationValue
local function Beggar_LowTargetDonationValue(slot, ctx)
    local myRng = slot.m_dropRNG

    local targetDonationValue = myRng:RandomInt(3) + myRng:RandomInt(2)
    if ctx.game.m_difficulty == Difficulty.DIFFICULTY_HARD then
        targetDonationValue = math.max(targetDonationValue, 2)
    end

    return targetDonationValue
end

---@type Slot.Function.GetTargetDonationValue
local function Beggar_HighTargetDonationValue(slot, ctx)
    local myRng = slot.m_dropRNG

    local targetDonationValue = myRng:RandomInt(4) + myRng:RandomInt(4) + myRng:RandomInt(2)
    if ctx.game.m_difficulty == Difficulty.DIFFICULTY_HARD then
        targetDonationValue = math.max(targetDonationValue, 5)
    end

    return targetDonationValue
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param interactSound SoundEffect | integer
---@param GetTargetDonationValue Slot.Function.GetTargetDonationValue
local function Beggar_PlayerInteraction(slot, ctx, player, interactSound, GetTargetDonationValue)
    IManager.PlaySound(ctx, interactSound, 1.0, 2, false, 0.0)
    slot.m_donationValue = slot.m_donationValue + 1

    local targetDonationValue = GetTargetDonationValue(slot, ctx)
    local prize = slot.m_donationValue <= targetDonationValue

    if not prize then
        Beggar_SetupNoPrize(slot)
        return
    end

    local resetDonationValue = slot.m_dropRNG:RandomInt(2) + 2
    if IEntityPlayer.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) then
        resetDonationValue = resetDonationValue + 1
    end

    slot.m_donationValue = resetDonationValue
    Beggar_SetupPrize(slot)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function Beggar_Destroy(slot, ctx)
    local bloodExplode = IGame.Spawn(
        ctx, ctx.game,
        EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION,
        slot.m_position, VECTOR_ZERO, nil,
        0, IsaacUtils.Random()
    )

    bloodExplode.m_sprite.Offset = Vector(0.0, -10.0)
    IEntity.BloodExplode(ctx, slot)
    slot:Remove(ctx)
end

---@type Slot.Switch.PlayerInteraction
local function DonationMachine_PlayerInteraction(slot)
    local consecutiveCollisionFrames = math.max(slot.m_consecutiveCollisionFrames - 1, 0)
    local speedIndex = math.min(consecutiveCollisionFrames // 60, 2) + 1

    local animation = ANIMATION_DONATION_COIN_INSERT[speedIndex]
    slot.m_sprite:PlayOverlay(animation, true)
    slot.m_state = SlotState.REWARD
end

---@class Actor.Lib.Slot
local Module = {}

--#region Module

Module.PayCoins = PayCoins
Module.PayKeys = PayKeys
Module.PayBombs = PayBombs
Module.PayHeart = PayHeart
Module.SlotMachine_SetupPrize = SlotMachine_SetupPrize
Module.Beggar_SetupPrize = Beggar_SetupPrize
Module.Beggar_SetupNoPrize = Beggar_SetupNoPrize
Module.Beggar_PlayerInteraction = Beggar_PlayerInteraction
Module.Beggar_LowTargetDonationValue = Beggar_LowTargetDonationValue
Module.Beggar_HighTargetDonationValue = Beggar_HighTargetDonationValue
Module.Beggar_Destroy = Beggar_Destroy
Module.DonationMachine_PlayerInteraction = DonationMachine_PlayerInteraction

--#endregion

return Module