--#region Dependencies



--#endregion

---@param pickup Component.Entity.Pickup
---@param ctx Context.Common
local function PostPickupInit(pickup, ctx)
    local variant = pickup.m_variant
    if variant == PickupVariant.PICKUP_HEART then
        if ctx.game.m_challenge == Challenge.CHALLENGE_ULTRA_HARD then
            pickup:Remove(ctx)
        end
    elseif variant == PickupVariant.PICKUP_TROPHY then
        local game = ctx.game
        local level = game.m_level

        -- remove in Backasswards if not in the first starting room
        local remove = game.m_challenge == Challenge.CHALLENGE_BACKASSWARDS
            and not (level.m_stage == LevelStage.STAGE1_1
            and level.m_roomIdx ~= level.m_startingRoomIdx)

        pickup:Remove(ctx)
    elseif variant == PickupVariant.PICKUP_THROWABLEBOMB then
        pickup.m_gridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    elseif variant == PickupVariant.PICKUP_POOP then
        pickup.m_sprite.FlipX = pickup.m_initSeed % 2 ~= 0
    end
end

---@class Mechanics.Pickup.Events
local Module = {}

--#region Module

Module.PostPickupInit = PostPickupInit

--#endregion

return Module