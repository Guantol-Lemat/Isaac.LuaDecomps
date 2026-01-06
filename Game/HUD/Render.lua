--#region Dependencies

local RoomUtils = require("Room.Utils")
local SeedsUtils = require("Admin.Seeds.Utils")
local StatHUDRender = require("HUD.Stat.Render.Logic")

--#endregion

---@class HUDRender
local Module = {}

---@param context Context
---@param hud HUDComponent
---@param shouldEvaluate boolean
---@return boolean
local function hook_evaluate_hud_render(context, hud, shouldEvaluate)
    local seeds = context:GetSeeds()
    if SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_NO_HUD) then
        return false
    end

    return shouldEvaluate
end

---@param context Context
---@param hud HUDComponent
---@return boolean
local function evaluate_hud_render(context, hud)
    if not hud.m_isVisible then
        return false
    end

    local shouldEvaluate = true
    shouldEvaluate = hook_evaluate_hud_render(context, hud, shouldEvaluate)
    return shouldEvaluate
end

---@param context Context
---@param hud HUDComponent
---@param shouldEvaluate boolean
---@return boolean
local function hook_evaluate_hud_stats_render(context, hud, shouldEvaluate)
    local room = context:GetRoom()
    if RoomUtils.IsBeastDungeon(room) then
        return false
    end

    return shouldEvaluate
end

---@param context Context
---@param hud HUDComponent
---@return boolean
local function evaluate_hud_stats_render(context, hud)
    local shouldEvaluate = true
    shouldEvaluate = hook_evaluate_hud_render(context, hud, shouldEvaluate)
    return true
end

---@param hud HUDComponent
---@param screen ScreenComponent
---@param hudOffset number
---@return Vector
local function get_history_hud_render_position(hud, screen, hudOffset)
    local xOffset = hudOffset * 24.0
    local yOffset = hudOffset * -14.0
    -- GetMinimapDisplayedSize
    local minimapSize = Vector(0, 0)

    local positionX = screen.m_width - 87.0 + xOffset
    local positionY = minimapSize.Y + 32.0 + yOffset

    return Vector(positionX, positionY)
end

---@param context Context
---@param hud HUDComponent
local function Render(context, hud)
    if not evaluate_hud_render(context, hud) then
        return
    end

    local renderPlayerStats = evaluate_hud_stats_render(context, hud)

    local options = context:GetOptions()
    local screen = context:GetScreen()
    local hudOffset = 1.0 - options.m_hudOffset

    if options.m_historyHudMode > 0 and renderPlayerStats then
        local renderPos = get_history_hud_render_position(hud, screen, hudOffset)
        -- Render history hud
    end

    -- render minimap

    local currentRenderPos = get_pickup_hud_render_position(hud, hudOffset)
    local pickupHudDisplayedSize = render_pickup_hud()

    currentRenderPos.Y = currentRenderPos.Y + pickupHudDisplayedSize.Y

    -- draw achievement unlock, difficulty, victory lap destination and greed break chance

    if renderPlayerStats and options.m_enableFoundHUD then
        local renderPos = Vector(currentRenderPos.X, currentRenderPos.Y + 16.0)
        StatHUDRender.Render(context, hud.m_statHUD, renderPos)
    end

    -- render streak
    -- render players hud (hearts, trinkets + pocket item, etc...)
    -- render coop select wheel
    -- render boss hp bar
end

--#region Module



--#endregion

return Module