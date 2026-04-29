--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local QuestUtils = require("Mechanics.Game.Quest.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local PlayerInventory = require("Mechanics.Player.Inventory")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")
local LuaCallbacks = require("LuaEngine.Callbacks")
local Log = require("General.Log")

local CardEffects = require("Mechanics.Player.Card.CardEffects")

--#endregion

---@class Context.Player.UseCard : Context.Common
---@field card_rng RNG
---@field player EntityPlayerComponent

---@param ctx Context.Player.UseCard
---@param cardType Card | integer
local function switch_card_effect_default(ctx, cardType)
    local itemConfig = ctx.manager.m_itemConfig
    local card_config = ItemConfigUtils.GetCard(itemConfig, cardType)
    if not card_config then
        Log.LogMessage(0, string.format("Warning: Card % don't exist\n", cardType)) -- I know it's messed up
    end
end

local switch_card_effect = {
    [Card.CARD_REVERSE_TOWER] = CardEffects.UseReverseTower,
}

---@param ctx Context.Common
---@param player EntityPlayerComponent
---@param cardType Card | integer
---@param useFlags UseFlag | integer
local function UseCard(ctx, player, cardType, useFlags)
    local ctx_isaac = ctx.manager
    local ctx_game = ctx.game

    local announcer_mode = ctx_isaac.m_options.m_announcerVoiceMode
    local announcer_frameDelay = announcer_mode == AnnouncerVoiceMode.RANDOM and 900 or 2

    ---@return boolean
    local function should_play_announcer()
        if announcer_mode == AnnouncerVoiceMode.NEVER then
            return false
        end

        if announcer_mode == AnnouncerVoiceMode.RANDOM and IsaacUtils.RandomInt(2) ~= 0 then
            return false
        end

        if useFlags & UseFlag.USE_NOANNOUNCER ~= 0 then
            return false
        end

        local level = ctx_game.m_level
        if QuestUtils.IsBackwardsPath(ctx, level) or level.m_stage == LevelStage.STAGE8 then
            return false
        end

        return true
    end

    local announcer_shouldPlay = should_play_announcer()

    if ctx_game.m_challenge == Challenge.CHALLENGE_APRILS_FOOL then
        local rng = PlayerUtils.GetCardRNG(player, cardType)
        cardType = rng:RandomInt(Card.NUM_CARDS - 1) + 1
    end

    local card_config = ItemConfigUtils.GetCard(ctx_isaac.m_itemConfig, cardType)
    local card_rng = PlayerUtils.GetCardRNG(player, cardType)

    local flag_isMimic = useFlags & UseFlag.USE_MIMIC ~= 0
    local flag_extraEffect = useFlags & UseFlag.USE_CARBATTERY ~= 0
    local flag_costumeAllowed = useFlags & UseFlag.USE_NOCOSTUME == 0
    local flag_animate = useFlags & UseFlag.USE_NOANIM == 0

    ---@return boolean
    local function should_do_extra_effect()
        if not PlayerInventory.HasCollectible(ctx, player, CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
            return false
        end

        if not card_config then
            return false
        end

        local pocketType = card_config.m_cardType
        return pocketType == ItemConfig.CARDTYPE_TAROT or pocketType == ItemConfig.CARDTYPE_TAROT_REVERSE
    end

    if should_do_extra_effect() then
        if useFlags & UseFlag.USE_OWNED ~= 0 and flag_extraEffect == false then
            UseCard(ctx, player, cardType, UseFlag.USE_CARBATTERY)
        end
    end

    ---@type Context.Player.UseCard
    local ctx_useCard = {
        manager = ctx_isaac,
        game = ctx_game,
        card_rng = card_rng,
    }

    local cardEffect = switch_card_effect[cardType] or switch_card_effect_default
    cardEffect(ctx_useCard, cardType)

    if flag_animate then
        PlayerUtils.AnimateCard(ctx, player, cardType, "UseItem")
    end

    if announcer_shouldPlay and card_config and card_config.m_announcerVoice ~= 0 then
        PlayerUtils.PlayDelayedSfx(ctx, player, card_config.m_announcerVoice, card_config.m_announcerDelay, announcer_frameDelay, 1.0)
    end

    LuaCallbacks.UseCard(cardType, player, useFlags)
end

---@class Mechanics.Player.Card.Main
local Module = {}

--#region Module

Module.UseCard = UseCard

--#endregion

return Module