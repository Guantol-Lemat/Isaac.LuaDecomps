--#region Dependencies

local Log = require("General.Log")
local IGame = require("Isaac.Interface.Game")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

--#endregion

local Actor_SlotMachine = require("Isaac.Actor.Slot.SlotMachine")
local Actor_BloodDonationMachine = require("Isaac.Actor.Slot.BloodDonationMachine")
local Actor_FortuneTellingMachine = require("Isaac.Actor.Slot.FortuneTellingMachine")
local Actor_Beggar = require("Isaac.Actor.Slot.Beggar")
local Actor_DevilBeggar = require("Isaac.Actor.Slot.DevilBeggar")
local Actor_ShellGame = require("Isaac.Actor.Slot.ShellGame")
local Actor_KeyMaster = require("Isaac.Actor.Slot.KeyMaster")
local Actor_DonationMachine = require("Isaac.Actor.Slot.DonationMachine")
local Actor_BombBum = require("Isaac.Actor.Slot.BombBum")
local Actor_ShopRestockMachine = require("Isaac.Actor.Slot.ShopRestockMachine")
local Actor_GreedDonationMachine = require("Isaac.Actor.Slot.GreedDonationMachine")
local Actor_MomsDressingTable = require("Isaac.Actor.Slot.MomsDressingTable")
local Actor_BatteryBum = require("Isaac.Actor.Slot.BatteryBum")
local Actor_HomeClosetPlayer = require("Isaac.Actor.Slot.HomeClosetPlayer")
local Actor_CraneGame = require("Isaac.Actor.Slot.CraneGame")
local Actor_Confessional = require("Isaac.Actor.Slot.Confessional")
local Actor_RottenBeggar = require("Isaac.Actor.Slot.RottenBeggar")

local CLASS_SPECIAL = 0
local CLASS_MACHINE = 1
local CLASS_BEGGAR = 2
local CLASS_SHELL_GAME = 3
local CLASS_DONATION_MACHINE = 4

local ANIMATION_APPEAR = "Appear"
local ANIMATION_PAY_PRIZE = "PayPrize"

-- the game has no conception of a class, it's all hardcoded
local SLOT_CLASS = {
    [SlotVariant.SLOT_MACHINE] = CLASS_MACHINE,
    [SlotVariant.BLOOD_DONATION_MACHINE] = CLASS_MACHINE,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = CLASS_MACHINE,
    [SlotVariant.BEGGAR] = CLASS_BEGGAR,
    [SlotVariant.DEVIL_BEGGAR] = CLASS_BEGGAR,
    [SlotVariant.SHELL_GAME] = CLASS_SHELL_GAME,
    [SlotVariant.KEY_MASTER] = CLASS_BEGGAR,
    [SlotVariant.DONATION_MACHINE] = CLASS_DONATION_MACHINE,
    [SlotVariant.BOMB_BUM] = CLASS_BEGGAR,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = CLASS_SPECIAL,
    [SlotVariant.GREED_DONATION_MACHINE] = CLASS_DONATION_MACHINE,
    [SlotVariant.MOMS_DRESSING_TABLE] = CLASS_SPECIAL,
    [SlotVariant.BATTERY_BUM] = CLASS_BEGGAR,
    [SlotVariant.HOME_CLOSET_PLAYER] = CLASS_SPECIAL,
    [SlotVariant.HELL_GAME] = CLASS_SHELL_GAME,
    [SlotVariant.CRANE_GAME] = CLASS_MACHINE,
    [SlotVariant.CONFESSIONAL] = CLASS_MACHINE,
    [SlotVariant.ROTTEN_BEGGAR] = CLASS_BEGGAR
}

---@alias Slot.Function.TakeDamage fun(slot: Component.Entity.Slot, ctx: Context.Common, damage: number, flags: DamageFlag | integer, source: Component.Entity.EntityRef, damageCountdown: integer)

---@alias Slot.Switch.Init fun(slot: Component.Entity.Slot, ctx: Context.Common)
---@alias Slot.Switch.UpdatePrize fun(slot: Component.Entity.Slot, ctx: Context.Common, player: Component.Entity.Player, extraRng: RNG)
---@alias Slot.Switch.OnSetPrizeCollectible fun(slot: Component.Entity.Slot, ctx: Context.Common, collectible: CollectibleType | integer)
---@alias Slot.Switch.CustomExplosionDrops fun(slot: Component.Entity.Slot, ctx: Context.Common, closure: Slot.Closure.CustomExplosionDrops)
---@alias Slot.Switch.PaySlot fun(slot: Component.Entity.Slot, ctx: Context.Common, player: Component.Entity.Player): boolean, boolean?
---@alias Slot.Switch.PlayerInteraction fun(slot: Component.Entity.Slot, ctx: Context.Common, player: Component.Entity.Player, collider: Component.Entity.Player)
---@alias Slot.Switch.CustomDestroy Slot.Function.TakeDamage
---@alias Slot.Switch.PreDestroy fun(slot: Component.Entity.Slot, ctx: Context.Common, damage: number, flags: DamageFlag | integer, source: Component.Entity.EntityRef, damageCountdown: integer): boolean
---@alias Slot.Switch.OnDestroy Slot.Function.TakeDamage

---@class Slot.Closure.CustomExplosionDrops
---@field extraRng RNG
---@field daemonsTailRng RNG?

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

---@type Slot.Switch.UpdatePrize
local function UpdatePrize_default(slot)
    Log.LogMessage(0, string.format("Slot type %d is not implemented!\n", slot.m_variant))
end

local Switch_UpdatePrize = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.UpdatePrize,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.UpdatePrize,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = Actor_FortuneTellingMachine.UpdatePrize,
    [SlotVariant.BEGGAR] = Actor_Beggar.UpdatePrize,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.UpdatePrize,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.UpdatePrize,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.UpdatePrize,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.UpdatePrize,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.UpdatePrize,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.UpdatePrize,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.UpdatePrize,
    [SlotVariant.MOMS_DRESSING_TABLE] = UpdatePrize_default,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.UpdatePrize,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.UpdatePrize,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.UpdatePrize,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.UpdatePrize,
    [SlotVariant.CONFESSIONAL] = Actor_Confessional.UpdatePrize,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.UpdatePrize
}

---@type Slot.Switch.PaySlot
local function PaySlot_default(slot)
    return false
end

---@type table<SlotVariant, Slot.Switch.PaySlot>
local Switch_PaySlot = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.PaySlot,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.PaySlot,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = Actor_FortuneTellingMachine.PaySlot,
    [SlotVariant.BEGGAR] = Actor_Beggar.PaySlot,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.PaySlot,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.ShellGame_PaySlot,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.PaySlot,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.PaySlot,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.PaySlot,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.PaySlot,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.PaySlot,
    [SlotVariant.MOMS_DRESSING_TABLE] = PaySlot_default,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.PaySlot,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.PaySlot,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.HellGame_PaySlot,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.PaySlot,
    [SlotVariant.CONFESSIONAL] = Actor_Confessional.PaySlot,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.PaySlot
}

---@type Slot.Switch.PlayerInteraction
local function PlayerInteraction_default(slot, ctx, player)
end

---@type table<SlotVariant, Slot.Switch.PlayerInteraction>
local Switch_PlayerInteraction = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.PlayerInteraction,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.PlayerInteraction,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = Actor_FortuneTellingMachine.PlayerInteraction,
    [SlotVariant.BEGGAR] = Actor_Beggar.PlayerInteraction,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.PlayerInteraction,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.PlayerInteraction,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.PlayerInteraction,
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.PlayerInteraction,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.PlayerInteraction,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.PlayerInteraction,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.PlayerInteraction,
    [SlotVariant.MOMS_DRESSING_TABLE] = PlayerInteraction_default,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.PlayerInteraction,
    [SlotVariant.HOME_CLOSET_PLAYER] = Actor_HomeClosetPlayer.PlayerInteraction,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.PlayerInteraction,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.PlayerInteraction,
    [SlotVariant.CONFESSIONAL] = Actor_Confessional.PlayerInteraction,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.PlayerInteraction
}

---@type table<SlotVariant, Slot.Switch.CustomDestroy>
local Switch_CustomDestroy = {
    [SlotVariant.DONATION_MACHINE] = Actor_DonationMachine.CustomDestroy,
    [SlotVariant.GREED_DONATION_MACHINE] = Actor_GreedDonationMachine.CustomDestroy,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.CustomDestroy
}

---@type table<SlotVariant, Slot.Switch.PreDestroy>
local Switch_PreDestroy = {
    [SlotVariant.BOMB_BUM] = Actor_BombBum.PreDestroy
}

---@type table<SlotVariant, Slot.Switch.OnDestroy>
local Switch_OnDestroy = {
    [SlotVariant.SLOT_MACHINE] = Actor_SlotMachine.OnDestroy,
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.OnDestroy,
    [SlotVariant.BEGGAR] = Actor_Beggar.OnDestroy,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.OnDestroy,
    [SlotVariant.SHELL_GAME] = Actor_ShellGame.OnDestroy,
    [SlotVariant.KEY_MASTER] = Actor_KeyMaster.OnDestroy,
    [SlotVariant.BOMB_BUM] = Actor_BombBum.OnDestroy,
    [SlotVariant.MOMS_DRESSING_TABLE] = Actor_MomsDressingTable.OnDestroy,
    [SlotVariant.BATTERY_BUM] = Actor_BatteryBum.OnDestroy,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.OnDestroy,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.OnDestroy,
}

---@type table<SlotVariant, Slot.Switch.OnSetPrizeCollectible>
local Switch_OnSetPrizeCollectible = {
    [SlotVariant.HELL_GAME] = Actor_ShellGame.HellGame_OnSetPrizeCollectible,
    [SlotVariant.CRANE_GAME] = Actor_CraneGame.OnSetPrizeCollectible,
}

---@type table<SlotVariant, Slot.Switch.CustomExplosionDrops>
local Switch_CustomExplosionDrops = {
    [SlotVariant.BLOOD_DONATION_MACHINE] = Actor_BloodDonationMachine.CustomExplosionDrops,
    [SlotVariant.DEVIL_BEGGAR] = Actor_DevilBeggar.CustomExplosionDrops,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = Actor_ShopRestockMachine.CustomExplosionDrops,
    [SlotVariant.MOMS_DRESSING_TABLE] = Actor_MomsDressingTable.CustomExplosionDrops,
    [SlotVariant.HELL_GAME] = Actor_ShellGame.HellGame_CustomExplosionDrops,
    [SlotVariant.ROTTEN_BEGGAR] = Actor_RottenBeggar.CustomExplosionDrops,
}

---@param slot Component.Entity.Slot
local function IsMachine(slot)
    return SLOT_CLASS[slot.m_variant] == CLASS_MACHINE
end

---@param slot Component.Entity.Slot
local function IsBeggar(slot)
    return SLOT_CLASS[slot.m_variant] == CLASS_BEGGAR
end

---@param slot Component.Entity.Slot
local function IsShellGame(slot)
    return SLOT_CLASS[slot.m_variant] == CLASS_SHELL_GAME
end

---@param slot Component.Entity.Slot
local function IsDonationMachine(slot)
    return SLOT_CLASS[slot.m_variant] == CLASS_DONATION_MACHINE
end

---@param slot Component.Entity.Slot
---@return boolean
local function IsPrizeState(slot)
    local state = slot.m_state
    local variant = slot.m_variant
    if IsShellGame(slot) and state == SlotState.REWARD_SHELL_GAME then
        return true
    end

    local waitPayPrizeAnimation = IsBeggar(slot)
        or variant == SlotVariant.HOME_CLOSET_PLAYER

    if waitPayPrizeAnimation and slot.m_sprite:IsPlaying(ANIMATION_PAY_PRIZE) and not slot.m_sprite:IsFinished() then
        return false
    end

    return state == SlotState.REWARD and slot.m_timeout == 0
end

---@param slot Component.Entity.Slot
local function IsDisappearState(slot)
    return slot.m_state == SlotState.PAYOUT
        and slot.m_variant ~= SlotVariant.CRANE_GAME -- (state 4 is special for crane game)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function InitLogic(slot, ctx)
    local InitLogic = Switch_Init[slot.m_variant]
    if InitLogic then InitLogic(slot, ctx) end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function PreUpdate(slot, ctx)
    local variant = slot.m_variant
    if variant == SlotVariant.CRANE_GAME then
        Actor_CraneGame.PreUpdate(slot, ctx)
    elseif variant == SlotVariant.MOMS_DRESSING_TABLE then
        Actor_MomsDressingTable.PreUpdate(slot, ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@return boolean
local function PreStateAppearUpdate(slot, ctx)
    -- if only there was a way to check if the slot was specifically a GreedDonationMachine
    local isGreedDonationMachine = slot.m_sprite:GetAnimation() == ANIMATION_APPEAR
    if isGreedDonationMachine then
        Actor_GreedDonationMachine.CustomUpdateAppear(slot, ctx)
        return true
    end

    return false
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function SetupAppear(slot, ctx)
    if slot.m_variant == SlotVariant.GREED_DONATION_MACHINE then
        Actor_GreedDonationMachine.CustomSetupAppear(slot, ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function PrePhysicsUpdate(slot, ctx)
    if slot.m_variant == SlotVariant.ROTTEN_BEGGAR then
        Actor_RottenBeggar.SpawnWorms(slot, ctx) -- there's no reason for it to be here
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function UpdateTriggerTimerLogic(slot, ctx)
    local variant = slot.m_variant
    if variant == SlotVariant.SHOP_RESTOCK_MACHINE then
        Actor_ShopRestockMachine.HandleRestock(slot, ctx)
    elseif variant == SlotVariant.BOMB_BUM then
        Actor_BombBum.BombedSpawnBomb(slot, ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function OnTimeoutEnd(slot, ctx)
    if slot.m_variant == SlotVariant.SLOT_MACHINE then
        Actor_SlotMachine.OnTimeoutEnd(slot, ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param target Component.Entity.Player
local function PostTimeoutUpdate(slot, ctx, target)
    local variant = slot.m_variant
    if variant == SlotVariant.SLOT_MACHINE then
        Actor_SlotMachine.TrySetPrize(slot, ctx, target)
    elseif variant == SlotVariant.CRANE_GAME then
        Actor_CraneGame.UpdateTimeoutPrize(slot, ctx)
    elseif variant == SlotVariant.CONFESSIONAL then
        Actor_Confessional.UpdateTimeoutPrize(slot, ctx, target)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function UpdateStateWaitPrize(slot, ctx)
    if slot.m_variant == SlotVariant.HOME_CLOSET_PLAYER then
        Actor_HomeClosetPlayer.UpdateStateWaitPrize(slot, ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function UpdateStateSpecial(slot, ctx)
    if slot.m_variant == SlotVariant.BOMB_BUM then
        Actor_BombBum.UpdateStateSpecial(slot, ctx)
    end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
---@param extraRng RNG
local function UpdatePrize(slot, ctx, player, extraRng)
    local fn = Switch_UpdatePrize[slot.m_variant] or UpdatePrize_default
    fn(slot, ctx, player, extraRng)
end

---@param slot Component.Entity.Slot
---@return boolean
local function PrizeWaitAnimationEnd(slot)
    local variant = slot.m_variant
    return variant ~= SlotVariant.SLOT_MACHINE
        and variant ~= SlotVariant.DONATION_MACHINE
        and variant ~= SlotVariant.SHOP_RESTOCK_MACHINE
        and variant ~= SlotVariant.GREED_DONATION_MACHINE
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
local function ShellGame_Shuffle(slot, ctx)
    Actor_ShellGame.Shuffle(slot, ctx)
end

---@param slot Component.Entity.Slot
local function ShellGame_PostRender(slot)
    Actor_ShellGame.PostRender(slot)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collider Component.Entity.Player
---@return boolean
local function CustomHandlePlayerCollision(slot, ctx, collider)
    if slot.m_variant == SlotVariant.MOMS_DRESSING_TABLE then
        Actor_MomsDressingTable.CustomHandlePlayerCollision(slot, ctx, collider)
        return true
    end

    return false
end

---@param slot Component.Entity.Slot
---@return boolean
local function CanInteractWithPlayer(slot)
    if slot.m_state == SlotState.CHOICE then
        return IsShellGame(slot)
    end

    if slot.m_state == SlotState.IDLE then
        if slot.m_timeout > 0 then
            return false
        end

        if IsBeggar(slot) then
            local isBusy = not slot.m_sprite:GetCurrentAnimationData():IsLoopingAnimation() and slot.m_sprite:IsPlaying()
            if isBusy then
                return false
            end
        end

        return true
    end

    return false
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
---@return boolean, boolean?
local function PaySlot(slot, ctx, player)
    local fn = Switch_PaySlot[slot.m_variant] or PaySlot_default
    return fn(slot, ctx, player)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param target Component.Entity.Player
---@param collider Component.Entity.Player
local function PlayerInteraction(slot, ctx, target, collider)
    local fn = Switch_PlayerInteraction[slot.m_variant] or PlayerInteraction_default
    fn(slot, ctx, target, collider)
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param damage number
---@param flags integer
---@param source Component.Entity.EntityRef
---@param damageCountdown integer
---@return boolean
local function CustomTakeDamage(slot, ctx, damage, flags, source, damageCountdown)
    if slot.m_variant == SlotVariant.HOME_CLOSET_PLAYER then
        Actor_HomeClosetPlayer.CustomTakeDamage(slot)
        return true
    end

    return false
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param damage number
---@param flags integer
---@param source Component.Entity.EntityRef
---@param damageCountdown integer
---@return boolean
local function CustomDestroy(slot, ctx, damage, flags, source, damageCountdown)
    local fn = Switch_CustomDestroy[slot.m_variant]
    if fn then fn(slot, ctx, damage, flags, source, damageCountdown) end
    return fn ~= nil
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param damage number
---@param flags integer
---@param source Component.Entity.EntityRef
---@param damageCountdown integer
---@return boolean destroy
local function PreDestroy(slot, ctx, damage, flags, source, damageCountdown)
    local destroy = true
    local fn = Switch_PreDestroy[slot.m_variant]
    if fn then destroy = fn(slot, ctx, damage, flags, source, damageCountdown) end

    return destroy
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param damage number
---@param flags integer
---@param source Component.Entity.EntityRef
---@param damageCountdown integer
local function OnDestroy(slot, ctx, damage, flags, source, damageCountdown)
    local fn = Switch_OnDestroy[slot.m_variant]
    if fn then fn(slot, ctx, damage, flags, source, damageCountdown) end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param collectible CollectibleType | integer
local function OnSetPrizeCollectible(slot, ctx, collectible)
    local fun = Switch_OnSetPrizeCollectible[slot.m_variant]
    if fun then fun(slot, ctx, collectible) end
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param closure Slot.Closure.CustomExplosionDrops
local function CustomExplosionDrops(slot, ctx, closure)
    local fn = Switch_CustomExplosionDrops[slot.m_variant]
    if fn then fn(slot, ctx, closure) end
    return fn ~= nil
end

---@param slot Component.Entity.Slot
---@param ctx Context.Common
---@param player Component.Entity.Player
local function Effects_OnPaySlot(slot, ctx, player)
    if IsBeggar(slot) then
        PlayerEffects.BethsEssence_OnBeggarPay(player, ctx, slot)
    end
end

---@param variant SlotVariant | integer
---@param ctx Context.Common
---@return SlotVariant | integer
local function Effects_SelectSlotType(ctx, variant)
    if IGame.IsGreedMode(ctx.game) and variant == SlotVariant.BLOOD_DONATION_MACHINE then
        variant = SlotVariant.DEVIL_BEGGAR
    end

    return variant
end

---@class Mechanics.Actor.Slot
local Module = {}

--#region Module

Module.IsMachine = IsMachine
Module.IsBeggar = IsBeggar
Module.IsShellGame = IsShellGame
Module.IsDonationMachine = IsDonationMachine
Module.IsPrizeState = IsPrizeState
Module.IsDisappearState = IsDisappearState
Module.InitLogic = InitLogic
Module.PreUpdate = PreUpdate
Module.SetupAppear = SetupAppear
Module.PreStateAppearUpdate = PreStateAppearUpdate
Module.PrePhysicsUpdate = PrePhysicsUpdate
Module.UpdateTriggerTimerLogic = UpdateTriggerTimerLogic
Module.OnTimeoutEnd = OnTimeoutEnd
Module.PostTimeoutUpdate = PostTimeoutUpdate
Module.UpdateStateWaitPrize = UpdateStateWaitPrize
Module.UpdateStateSpecial = UpdateStateSpecial
Module.UpdatePrize = UpdatePrize
Module.PrizeWaitAnimationEnd = PrizeWaitAnimationEnd
Module.ShellGame_Shuffle = ShellGame_Shuffle
Module.ShellGame_PostRender = ShellGame_PostRender
Module.CustomHandlePlayerCollision = CustomHandlePlayerCollision
Module.CanInteractWithPlayer = CanInteractWithPlayer
Module.PaySlot = PaySlot
Module.PlayerInteraction = PlayerInteraction
Module.CustomTakeDamage = CustomTakeDamage
Module.OnSetPrizeCollectible = OnSetPrizeCollectible
Module.CustomExplosionDrops = CustomExplosionDrops
Module.CustomDestroy = CustomDestroy
Module.PreDestroy = PreDestroy
Module.OnDestroy = OnDestroy
Module.Effects_OnPaySlot = Effects_OnPaySlot
Module.Effects_SelectSlotType = Effects_SelectSlotType

--#endregion

return Module