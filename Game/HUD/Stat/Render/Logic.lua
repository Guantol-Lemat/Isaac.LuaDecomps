--#region Dependencies

local FontUtils = require("General.Font")
local StatHudUtils = require("HUD.Stat.Utils")
local StatHudSpriteUtils = require("HUD.Stat.Sprite")
local StatHudRenderRules = require("HUD.Stat.Render.Rules")

local eFonts = FontUtils.eFonts
local eHudStat = StatHudUtils.eHudStat

--#endregion

---@class StatsHudRenderLogic
local Module = {}

---@param statHud StatHUDComponent
---@param hudStat eHudStat
---@param renderPos Vector
---@param nextIconOffset number
---@return Vector? override
local function handle_combined_deals_icon_render(statHud, hudStat, renderPos, nextIconOffset)
    if not statHud.m_combineDeals then
        return nil
    end

    if hudStat == eHudStat.ANGEL_CHANCE then
        return Vector(0, 0)
    end

    if hudStat ~= eHudStat.DEVIL_CHANCE then
        return nil
    end

    local sprite = statHud.m_sprite
    StatHudSpriteUtils.SetFrameToCombinedDeals(sprite)
    StatHudRenderRules.RenderStatIcon(sprite, renderPos)
    return Vector(0, nextIconOffset)
end

---@param statHud StatHUDComponent
---@param hudStat eHudStat
---@param renderPos Vector
---@param nextIconOffset number
---@return Vector? override
local function hook_handle_stat_icon_render(statHud, hudStat, renderPos, nextIconOffset)
    local override = handle_combined_deals_icon_render(statHud, hudStat, renderPos, nextIconOffset)
    if override then
        return override
    end
end

---@param statHud StatHUDComponent
---@param hudStat eHudStat
---@param renderPos Vector
---@param nextIconOffset number
---@return Vector nextPosOffset
local function handle_stat_icon_render(statHud, hudStat, renderPos, nextIconOffset)
    if hudStat == eHudStat.PLANETARIUM_CHANCE or hudStat == eHudStat.SPECIAL_ITEM_CHANCE then
        return Vector(0, 0)
    end

    local hookResult = hook_handle_stat_icon_render(statHud, hudStat, renderPos, nextIconOffset)
    if hookResult then
        return hookResult
    end

    local sprite = statHud.m_sprite
    StatHudSpriteUtils.SetFrameToStat(sprite, hudStat)
    StatHudRenderRules.RenderStatIcon(sprite, renderPos)
    return Vector(0, nextIconOffset)
end

---@param context Context
---@param playerStats HudPlayerStatsComponent
---@param hudStat eHudStat
---@param font Font
---@param renderPos Vector
---@param playerIndex integer
---@param nextIconOffset number
local function handle_jacob_esau_stat_value_draw(context, playerStats, hudStat, font, renderPos, playerIndex, nextIconOffset)
    if hudStat ~= eHudStat.SPEED then
        return
    end

    local playerType = playerStats.m_player.m_playerType
    if playerType ~= PlayerType.PLAYER_JACOB and playerType ~= PlayerType.PLAYER_ESAU then
        return
    end

    if playerIndex == 1 then
        local stat = StatHudUtils.GetStat(playerStats, eHudStat.SPEED)
        StatHudRenderRules.DrawGlobalStat(context, font, stat, false, renderPos)
    end

    return Vector(0, nextIconOffset)
end

---@param statHud StatHUDComponent
---@param hudStat eHudStat
---@return Vector? override
local function handle_combined_deals_stat_value_draw(statHud, hudStat)
    if not statHud.m_combineDeals then
        return
    end

    if hudStat == eHudStat.ANGEL_CHANCE then
        return Vector(0, 0)
    end
end

---@param context Context
---@param statHud StatHUDComponent
---@param font Font
---@param hudStat eHudStat
---@param renderPos Vector
---@param playerIndex integer
---@param nextIconOffset number
---@return Vector? override
local function hook_handle_stat_value_draw(context, statHud, hudStat, font, renderPos, playerIndex, nextIconOffset)
    local override = handle_jacob_esau_stat_value_draw(context, statHud.m_playerStats, hudStat, font, renderPos, playerIndex, nextIconOffset)
    if override then
        return override
    end

    override = handle_combined_deals_stat_value_draw(statHud, hudStat)
    if override then
        return override
    end
end

---@param context Context
---@param statHud StatHUDComponent
---@param hudStat eHudStat
---@param font Font
---@param renderPos Vector
---@param playerIndex integer
---@param isMultiplayer boolean
---@param nextIconOffset number
---@return Vector nextPosOffset
local function handle_stat_value_draw(context, statHud, hudStat, font, renderPos, playerIndex, isMultiplayer, nextIconOffset)
    if hudStat == eHudStat.PLANETARIUM_CHANCE or hudStat == eHudStat.SPECIAL_ITEM_CHANCE then
        return Vector(0, 0)
    end

    local override = hook_handle_stat_value_draw(context, statHud, hudStat, font, renderPos, playerIndex, nextIconOffset)
    if override then
        return override
    end

    local stat = StatHudUtils.GetStat(statHud.m_playerStats[playerIndex], hudStat)
    if hudStat == eHudStat.DEVIL_CHANCE or hudStat == eHudStat.ANGEL_CHANCE then
        if playerIndex == 1 then
            local isPercentage = true
            StatHudRenderRules.DrawGlobalStat(context, font, stat, isPercentage, renderPos)
        end
    else
        local isPercentage = false
        StatHudRenderRules.DrawPlayerStat(context, font, playerIndex, stat, isMultiplayer, isPercentage, renderPos)
    end

    return Vector(0, nextIconOffset)
end

---@param context Context
---@param statHud StatHUDComponent
---@param renderPos Vector
local function Render(context, statHud, renderPos)
    local playerStats = statHud.m_playerStats
    if not playerStats[1].m_player and not playerStats[2].m_player then
        return
    end

    local font = context:GetFont(eFonts.LUA_MINI_OUTLINED)
    local iconOffset = 12.0
    local isMultiplayer = not not (playerStats[1].m_player and playerStats[2].m_player)

    if isMultiplayer then
        iconOffset = 14.0
    end

    local iconRenderPos = renderPos
    for i = 1, eHudStat.NUM_HUD_STATS, 1 do
        local nextOffset = handle_stat_icon_render(statHud, i, iconRenderPos, iconOffset)
        iconRenderPos = iconRenderPos + nextOffset
    end

    for playerIndex = 1, 2, 1 do
        if not playerStats[playerIndex].m_player then
            break
        end

        local textRenderPos = renderPos
        for hudStat = 1, eHudStat.NUM_HUD_STATS, 1 do
            local nextOffset = handle_stat_value_draw(context, statHud, hudStat, font, textRenderPos, playerIndex, isMultiplayer, iconOffset)
            textRenderPos = textRenderPos + nextOffset
        end
    end
end

--#region Module

Module.Render = Render

--#endregion

return Module