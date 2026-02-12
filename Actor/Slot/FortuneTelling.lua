--#region Dependencies

local MySpriteUtils = require("Actor.Slot.Sprite.FortuneTelling")
local SlotRules = require("Entity.Slot.Rules")
local Inventory = require("Game.Inventory.Inventory")
local SpawnLogic = require("Game.Spawn")
local Fortunes = require("Game.Fortunes")
local SFX = require("Admin.Sound.Rules")

local Animations = MySpriteUtils.Animations
local Events = MySpriteUtils.Events

--#endregion

---@class FortuneTellingSlotLogic
local Module = {}

---@param context Context
---@param slot EntitySlotComponent
---@param player EntityPlayerComponent
local function UpdateDispensePrize(context, slot, player)
    local sprite = slot.m_sprite
    sprite:Play(Animations.PRIZE, false)
    if not sprite:IsEventTriggered(Events.DISPENSE_PRIZE) then
        return
    end

    local game = context:GetGame()
    local rng = slot.m_dropRNG
    local fortuneChance = game.m_difficulty == Difficulty.DIFFICULTY_HARD and 0.85 or 0.65

    if Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) then
        fortuneChance = fortuneChance * 0.46
    end

    local random = rng:RandomFloat()
    if random < fortuneChance then
        if random < 0.02 then
            Fortunes.ShowFortuneSeed(context, game)
        else
            Fortunes.ShowFortuneGeneral(context, game)
        end
        return
    end

    local sfxManager = context:GetSFXManager()
    SFX.Play(context, sfxManager, SoundEffect.SOUND_SLOTSPAWN, 1.0, 2, false, 1.0)

    if rng:RandomInt(20) == 0 then
        local seed = context:Random()
        SpawnLogic.Spawn(context, EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, seed, slot.m_position, Vector.Zero, nil)
        SlotRules.CreateDropsFromExplosion(context, slot)
        sprite:Play(Animations.DEATH, false)
        slot.m_state = 3
        return
    end

    if rng:RandomInt(30) == 0 then
        -- Collectible
        return
    end

    if rng:RandomInt(3) == 0 then
        -- Card
        return
    end

    if rng:RandomInt(3) == 0 and true --[[DeamonsTail Effect]] then
        -- Soul Heart
        return
    end

    -- Trinket
end

--#region Module

Module.UpdateDispensePrize = UpdateDispensePrize

--#endregion

return Module