--#region Dependencies

local IsaacUtils = require("Isaac.Utils.Common")
local GameSpawn = require("Game.Spawn")
local RoomUtils = require("Game.Room.Utils")
local RoomBounds = require("Game.Room.Bounds")
local EntityCast = require("Entity.TypeCast")
local EntityIdentity = require("Isaac.Enums.EntityIdentity")
local EffectUtils = require("Entity.Effect.Utils")
local GridEntityUtils = require("GridEntity.Utils")
local BackdropUtils = require("Isaac._OLD.Backdrop.Utils")

--#endregion

local eReverseExplosionSubtype = EntityIdentity.eReverseExplosionSubtype
local VECTOR_ZERO = Vector(0, 0)

---@param ctx Context.Common
---@param player Component.Entity.Player
---@param seed integer
local function TriggerEffect(ctx, player, seed)
    local ctx_game = ctx.game
    local room = ctx_game.m_level.m_room
    local rng = RNG(seed, 45)

    local grid_weights = {}
    for i = 1, 448, 1 do
        grid_weights[i] = 0
    end

    local grid_width = room.m_gridWidth
    local grid_height = room.m_gridHeight
    local grid_cells = grid_width * grid_height

    -- map replaceable grids
    for i = 1, grid_cells, 1 do
        local cell_idx = i - 1
        local cell_position = RoomUtils.GetGridPosition(room, cell_idx)

        if not RoomBounds.IsPositionInRoom(room, cell_position, 0.0) then
            goto continue
        end

        local cell_collision = RoomUtils.GetGridCollision(room, cell_idx)
        local cell_gridEntity = RoomUtils.GetGridEntity(room, cell_idx)

        local can_replace = cell_collision == GridCollisionClass.COLLISION_NONE and
            (not cell_gridEntity or not GridEntityUtils.IsHighPriority(cell_gridEntity.m_desc.m_type))

        if can_replace then
            grid_weights[i] = 5
        end
        ::continue::
    end

    local grid_crossesWidth = grid_width - 2
    local grid_crossesHeight = grid_height - 2
    local grid_crosses = grid_crossesWidth * grid_crossesHeight
    for i = 1, grid_crosses, 1 do
        local center_row, center_column = ((i - 1) // grid_crossesWidth) + 1, ((i - 1) % grid_crossesWidth) + 1
        local center_idx = center_row * grid_width + center_column

        local areAdjacentValid = grid_weights[center_idx] ~= 0 and
            grid_weights[center_idx - grid_width] ~= 0 and -- up
            grid_weights[center_idx - 1] ~= 0 and -- left
            grid_weights[center_idx + 1] ~= 0 and -- right
            grid_weights[center_idx + grid_width] ~= 0 -- down

        if areAdjacentValid then
            grid_weights[center_idx] = 2
        end
    end

    for i = 1, 7, 1 do
        -- build picker
        -- you could potentially build it once and then update
        -- each entry manually instead of rebuilding it every loop
        local picker = WeightedOutcomePicker()
        local candidateExists = false
        for j = 1, grid_cells, 1 do
            local weight = grid_weights[j]
            if weight > 0 then
                picker:AddOutcomeWeight(j - 1, grid_weights[j])
                candidateExists = true
            end
        end

        if not candidateExists then
            break -- exit
        end

        local reverseExplosion_lifetime = (i - 1) * 5

        local center_idx = picker:PickOutcome(rng)
        local center_position = RoomUtils.GetGridPosition(room, center_idx)
        local center_column = center_idx % grid_width
        local center_row = center_idx // grid_width

        local randomOffsetY = rng:RandomFloat() * 36.0 - 18.0 -- [-18.0, 18.0]
        local randomOffsetX = rng:RandomFloat() * 36.0 - 18.0 -- [-18.0, 18.0]
        local randomOffset = Vector(randomOffsetX, randomOffsetY)
        local reverseExplosion_position = center_position + randomOffset

        local topLeftColumn = math.min(center_column - 2, 0)
        local topLeftRow = math.min(center_row - 2, 0)
        local bottomRightColumn = math.max(center_column + 2, grid_width - 1)
        local bottomRightRow = math.max(center_row + 2, grid_width - 1)

        local areaWidth = topLeftColumn - bottomRightColumn
        local areaHeight = topLeftRow - bottomRightRow

        for j = 1, areaWidth * areaHeight, 1 do
            -- we iterate every row of every column like the game does to have matching behavior
            local localRow, localColumn = (j - 1) % areaHeight, (j - 1) // areaHeight
            local cell_idx = (localRow + topLeftRow) * grid_width + (localColumn + topLeftColumn)

            if grid_weights[cell_idx + 1] == 0 then
                goto continue
            end

            local cell_position = RoomUtils.GetGridPosition(room, cell_idx)
            local cell_distanceFromExplosion = cell_position:Distance(reverseExplosion_position)
            -- if too distant don't spawn but reduce weight
            if cell_distanceFromExplosion > 75.0 then
                grid_weights[cell_idx + 1] = 1
                goto continue
            end

            assert(cell_idx <= 447)

            grid_weights[cell_idx + 1] = 0
            local debris_seed = rng:Next()
            local debris_position = RoomUtils.GetGridPosition(room, cell_idx)

            local debris_entity = GameSpawn.Spawn(
                ctx, ctx_game,
                EntityType.ENTITY_EFFECT, EffectVariant.REVERSE_EXPLOSION, eReverseExplosionSubtype.DEBRIS,
                debris_seed, debris_position, VECTOR_ZERO,
                player
            )
            debris_entity = EntityCast.StaticToEffect(debris_entity)
            EffectUtils.SetTimeout(debris_entity, reverseExplosion_lifetime)
            debris_entity:Update(ctx)
            ::continue::
        end

        local reverseExplosion_seed = rng:Next()
        local reverseExplosion_entity = GameSpawn.Spawn(
            ctx, ctx_game,
            EntityType.ENTITY_EFFECT, EffectVariant.REVERSE_EXPLOSION, eReverseExplosionSubtype.EXPLOSION,
            reverseExplosion_seed, reverseExplosion_position, VECTOR_ZERO,
            player
        )

        reverseExplosion_entity = EntityCast.StaticToEffect(reverseExplosion_entity)
        EffectUtils.SetTimeout(reverseExplosion_entity, reverseExplosion_lifetime)
        reverseExplosion_entity:Update(ctx)
    end
end

---@param ctx Context.Common
---@param entity Component.Entity.Effect
local function update_explosion(ctx, entity)
    if entity.m_timeout <= 0 and not entity.m_visible then
        entity.m_visible = true
        entity.m_sprite:Play("Explosion", true)
        IsaacUtils.PlaySound(ctx, SoundEffect.SOUND_REVERSE_EXPLOSION, 1.0, 2, false, 1.0)
    end

    if entity.m_visible and entity.m_sprite:IsFinished() then
        entity:Remove(ctx)
    end
end

---@param ctx Context.Common
---@param entity Component.Entity.Effect
local function spawn_rock(ctx, entity)
    local room = ctx.game.m_level.m_room
    if not RoomUtils.CanSpawnObstacleAtWorldPosition(room, entity.m_position, false) then
        return
    end

    local rng = entity.m_dropRNG

    -- build picker
    local picker = WeightedOutcomePicker()
    picker:AddOutcomeWeight(GridEntityType.GRID_ROCK, 80)
    picker:AddOutcomeWeight(GridEntityType.GRID_ROCKT, 3)
    picker:AddOutcomeWeight(GridEntityType.GRID_ROCK_ALT, 17)

    local picker_seed = rng:Next()
    local picker_rng = RNG(picker_seed, 35)

    local rock_type = picker:PickOutcome(picker_rng)
    local rock_seed = rng:Next()
    local rock_gridIdx = RoomUtils.GetGridIdx(room, entity.m_position)
    GameSpawn.SpawnGridEntity(ctx, room, rock_gridIdx, rock_type, 0, rock_seed, 0)
end

---@param ctx Context.Common
---@param entity Component.Entity.Effect
local function update_debris(ctx, entity)
    -- make visible and setup sprite
    if entity.m_timeout <= 0 and not entity.m_visible then
        entity.m_visible = true
        local gfx_rng = RNG(entity.m_initSeed, 3)
        local sprite = entity.m_sprite

        -- set debris rock spritesheet
        local room = ctx.game.m_level.m_room
        local backdropEntry = BackdropUtils.GetCurrentBackdropEntry(room.m_backdrop)
        local gfx_rockPath = backdropEntry.m_gfx_rocks
        local gfx_layerCount = sprite:GetLayerCount()
        for i = 1, #gfx_layerCount, 1 do
            sprite:ReplaceSpritesheet(i - 1, gfx_rockPath, false)
        end
        sprite:LoadGraphics()

        sprite.FlipX = gfx_rng:RandomInt(2) == 0
        local gfx_animation = gfx_rng:RandomInt(2) == 0 and "Rubble02" or "Rubble01"
        sprite:Play(gfx_animation, true)
    end

    -- spawn rock
    if entity.m_visible and entity.m_sprite:IsFinished() then
        entity:Remove(ctx)
        spawn_rock(ctx, entity)
    end
end

---@param ctx Context.EffectUpdate
local function UpdateEntity(ctx)
    local entity = ctx.entity
    local subtype = entity.m_subtype

    if subtype == eReverseExplosionSubtype.DEBRIS then
        update_debris(ctx, entity)
    else
        update_explosion(ctx, entity)
    end
end

---@class Mechanics.Room.ReverseExplosion
local Module = {}

--#region Module

Module.TriggerEffect = TriggerEffect
Module.UpdateEntity = UpdateEntity

--#endregion

return Module