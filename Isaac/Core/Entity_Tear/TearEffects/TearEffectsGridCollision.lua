--#region Dependencies

local Enums = require("Isaac.Enums")
local HitListUtils = require("Isaac.Utils.HitList")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IRoom = require("Isaac.Interface.Room")
local IEntity = require("Isaac.Interface.Entity")
local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local IEntityTear = require("Isaac.Interface.Entity_Tear")
local IGridEntity = require("Isaac.Interface.GridEntity")
local IGridEntityRock = require("Isaac.Interface.GridEntity_Rock")

--#endregion

---@class Switch.Gameplay.TearRerollRockOutcomes
---@field rng RNG
---@field type GridEntityType
---@field variant integer

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function BounceTear(ctx, tear)
    local ctx_room = ctx.game.m_level.m_room

    tear.m_gridCollisionClass = tear.m_tearFlags & TearFlags.TEAR_SPECTRAL ~= 0
        and EntityGridCollisionClass.GRIDCOLL_WALLS
        or EntityGridCollisionClass.GRIDCOLL_NOPITS

    if tear.m_collidesWithGrid then
        -- do bounce
        local velocity = tear.m_velocity
        local damagePosition = tear.m_position - velocity
        IEntityTear.damage_grid(ctx, tear, damagePosition)

        local newSpeed = tear.m_velocityOnGridCollide:Length()
        velocity:Resize(newSpeed)

        local tearFlags = tear.m_tearFlags
        tearFlags = tearFlags & ~TearFlags.TEAR_TRACTOR_BEAM

        HitListUtils.Clear(tear.m_hitList)
        if ctx_room.m_type == RoomType.ROOM_DUNGEON then
            tearFlags = tearFlags & ~TearFlags.TEAR_BOUNCE
        end

        tear.m_tearFlags = tearFlags
    end
end

---@param closure Switch.Gameplay.TearRerollRockOutcomes
local function outcome_poop(closure)
    local rng = closure.rng
    local randomOutcome = rng:RandomFloat()

    closure.type = GridEntityType.GRID_POOP

    if randomOutcome >= 0.98 then
        closure.variant = GridPoopVariant.GOLDEN
        return
    end

    if randomOutcome >= 0.97 then
        closure.variant = GridPoopVariant.RAINBOW
        return
    end

    if randomOutcome >= 0.95 then
        closure.variant = GridPoopVariant.BLACK
        return
    end

    if randomOutcome >= 0.8 then
        closure.variant = GridPoopVariant.RED
        return
    end

    if randomOutcome >= 0.6 then
        closure.variant = GridPoopVariant.CORN
        return
    end

    -- default is GridPoopVariant.NORMAL
end

---@param closure Switch.Gameplay.TearRerollRockOutcomes
local function outcome_rock_bomb(closure)
    closure.type = GridEntityType.GRID_ROCK_BOMB
end

---@param closure Switch.Gameplay.TearRerollRockOutcomes
local function outcome_rock_alt(closure)
    closure.type = GridEntityType.GRID_ROCK_ALT
end

---@param closure Switch.Gameplay.TearRerollRockOutcomes
local function outcome_rock_b(closure)
    closure.type = GridEntityType.GRID_ROCKB
end

---@param closure Switch.Gameplay.TearRerollRockOutcomes
local function outcome_tnt(closure)
    closure.type = GridEntityType.GRID_TNT
end

local REROLL_ROCK_OUTCOMES = {
    [1] = outcome_poop,
    [2] = outcome_rock_bomb,
    [3] = outcome_rock_alt,
    [4] = outcome_rock_b,
    [5] = outcome_tnt
}

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function RerollRockWisp(ctx, tear)
    local ctx_room = ctx.game.m_level.m_room
    local gridIdx = IRoom.GetGridIndex(ctx_room, tear.m_position)

    local gridEntity = IRoom.GetGridEntity(ctx_room, gridIdx)
    if not (gridEntity and IGridEntity.IsBreakableRock(gridEntity)) then
        return
    end

    tear.m_tearFlags = tear.m_tearFlags & ~TearFlags.TEAR_REROLL_ROCK_WISP
    ---@cast gridEntity Component.GridEntity.Rock
    gridEntity.m_desc.m_state = 2
    IGridEntityRock.UpdateNeighbors(ctx, gridEntity)

    local rng = tear.m_dropRNG
    local randomOutcome = rng:RandomInt(6) + 1
    local newGridType = ctx_room.m_tintedRockIdx == gridIdx
        and GridEntityType.GRID_ROCKT
        or GridEntityType.GRID_ROCK

    if ctx_room.m_tintedRockIdx == gridIdx and rng:RandomInt(20) == 0 then
        local ctx_persistentData = ctx.manager.m_persistentGameData
        if IPersistentGameData.Unlocked(ctx_persistentData, ctx, Achievement.SUPER_SPECIAL_ROCKS) then
            newGridType = GridEntityType.GRID_ROCK_SS
        end
    end

    local newGridVariant = 0

    ---@type Switch.Gameplay.TearRerollRockOutcomes
    local switch_closure = { rng = rng, type = newGridType, variant = newGridVariant}
    local switch_case = REROLL_ROCK_OUTCOMES[randomOutcome]
    switch_case(switch_closure)

    newGridType, newGridVariant = switch_closure.type, switch_closure.variant
    IRoom.SetGridPath(ctx_room, gridIdx, 0)

    local seed = rng:Next()
    IRoom.SpawnGridEntity(ctx, ctx_room, gridIdx, newGridType, newGridVariant, seed, 0)
end

---@class Gameplay.TearEffectsGridCollision
local Module = {}

--#region Module

Module.BounceTear = BounceTear
Module.RerollRockWisp = RerollRockWisp

--#endregion

return Module