--#region Dependencies

local MathUtils = require("General.Math")
local LevelRules = require("Level.Rules")
local PlayerRules = require("Entity.Player.Rules")
local InputRules = require("Admin.Input.Rules")

--#endregion

---@class MinimapLogic
local Module = {}

---@param context Context
local function is_map_button_held(context)
    local playerManager = context:GetPlayerManager()

    for i = 1, #playerManager.m_players, 1 do
        local player = playerManager.m_players[i]
        if not PlayerRules.IsLocalPlayer(context, player) then
            goto continue
        end

        if InputRules.IsActionPressed(context, ButtonAction.ACTION_MAP, player.m_controllerIndex, player) then
            return true
        end
        ::continue::
    end

    return false
end

---@param minimap MinimapComponent
---@param heldButton boolean
local function update_normal_state(_, minimap, heldButton)
    local normalMap = minimap.m_normalMapDesc
    normalMap.m_alpha = MathUtils.MoveTowards(normalMap.m_alpha, 1.0, 0.1)

    local expandedMap = minimap.m_expandedMapDesc
    expandedMap.m_alpha = MathUtils.MoveTowards(expandedMap.m_alpha, 0.0, 0.2)

    if heldButton then
        minimap.m_state = MinimapState.EXPANDED
    end
end

---@param minimap MinimapComponent
---@param heldButton boolean
---@param oldState MinimapState
---@param newState MinimapState
local function update_expand_transition(minimap, heldButton, oldState, newState)
    local expandedMap = minimap.m_expandedMapDesc

    if minimap.m_heldTime < 9 then
        if heldButton then
            expandedMap.m_alpha = expandedMap.m_alpha + 0.1
        else
            minimap.m_state = newState
            minimap.m_keepMapExpanded = not minimap.m_keepMapExpanded
        end
        return
    end

    expandedMap.m_alpha = 1.0
    if not heldButton then
        minimap.m_state = oldState
    end
end

---@param minimap MinimapComponent
---@param heldButton boolean
local function update_expanded_state(_, minimap, heldButton)
    local normalMap = minimap.m_normalMapDesc

    if minimap.m_keepMapExpanded then
        normalMap.m_alpha = 0.0
        update_expand_transition(minimap, heldButton, MinimapState.EXPANDED_OPAQUE, MinimapState.NORMAL)
    else
        normalMap.m_alpha = MathUtils.MoveTowards(normalMap.m_alpha, 0.0, 0.2)
        update_expand_transition(minimap, heldButton, MinimapState.NORMAL, MinimapState.EXPANDED_OPAQUE)
    end
end

---@param context Context
---@param minimap MinimapComponent
---@param heldButton boolean
local function update_expanded_opaque(context, minimap, heldButton)
    minimap.m_heldTime = 0.0

    local normalMap = minimap.m_normalMapDesc
    normalMap.m_alpha = MathUtils.MoveTowards(normalMap.m_alpha, 0.0, 0.2)

    local options = context:GetOptions()
    local expandedMap = minimap.m_expandedMapDesc
    expandedMap.m_alpha = MathUtils.MoveTowards(expandedMap.m_alpha, options.m_mapOpacity, 0.1)
end

local SWITCH_STATE_HANDLER = {
    [MinimapState.NORMAL] = update_normal_state,
    [MinimapState.EXPANDED] = update_expanded_state,
    [MinimapState.EXPANDED_OPAQUE] = update_expanded_opaque,
    default = function () end,
}

---@param context Context
---@param minimap MinimapComponent
---@param heldButton boolean
local function update_state(context, minimap, heldButton)
    local handler = SWITCH_STATE_HANDLER[minimap.m_state] or SWITCH_STATE_HANDLER.default
    return handler(context, minimap, heldButton)
end

---@param context Context
---@param minimap MinimapComponent
local function Update(context, minimap)
    local heldButton = is_map_button_held(context)

    if heldButton then
        minimap.m_heldTime = minimap.m_heldTime + 1
        if minimap.m_heldTime == 10 then
            local level = context:GetLevel()
            LevelRules.ShowName(context, level, true)
        end
    end

    -- update shake duration

    update_state(context, minimap, heldButton)

    if not heldButton then
        minimap.m_heldTime = 0
        -- update streak TextOut logic
    end

    minimap.m_normalMapDesc.m_alpha = MathUtils.Clamp(minimap.m_normalMapDesc.m_alpha, 0.0, 1.0)
    minimap.m_expandedMapDesc.m_alpha = MathUtils.Clamp(minimap.m_expandedMapDesc.m_alpha, 0.0, 1.0)
end

--#region Module

Module.Update = Update

--#endregion

return Module