--#region Dependencies

local RoomUtils = require("Room.Utils")
local EntityUtils = require("Entity.Common.Utils")
local TearUtils = require("Entity.Tear.Utils")
local TearRules = require("Entity.Tear.Rules")
local VectorUtils = require("General.Math.VectorUtils")
local EffectsUtils = require("Entity.Player.Inventory.TemporaryEffects")
local SeedsUtils = require("Admin.Seeds.Utils")

local TearDeath = require("Mechanics.Tear.TearDeath")

--#endregion

---@class TearUpdateLogic
local Module = {}

---@param room RoomComponent
---@param entity EntityTearComponent
local function get_time_scale(room, entity)
    local timeScale = 1.0
    -- Room:GetTimescale
    if room.m_slowdownDuration > 0 then
        timeScale = timeScale * 0.75
    end

    return timeScale
end

---@param context Context
---@param tear EntityTearComponent
local function bounce_tear(context, tear)
    local spectralTears = TearUtils.HasAnyTearFlag(tear, TearFlags.TEAR_SPECTRAL)
    tear.m_gridCollisionClass = spectralTears and EntityGridCollisionClass.GRIDCOLL_WALLS or EntityGridCollisionClass.GRIDCOLL_NOPITS

    if not tear.m_collidesWithGrid then
        return
    end

    local velocity = tear.m_velocity
    local collisionPoint = tear.m_position - velocity
    TearRules.DamageGrid(context, tear, collisionPoint)

    velocity:Normalize()
    local speedOnGridCollide = tear.m_velocityOnGridCollide:Length()
    tear.m_velocity = velocity * speedOnGridCollide

    local clearedFlags = TearFlags.TEAR_TRACTOR_BEAM
    local room = context:GetRoom()
    if RoomUtils.IsDungeon(room) then
        clearedFlags = clearedFlags | TearFlags.TEAR_BOUNCE
    end

    TearUtils.ClearTearFlags(tear, clearedFlags)
end

---@param context TearMechanicsContext.Update
---@param tear EntityTearComponent
local function Update(context, tear)
    local room = context.room
    local IsDungeon = context.isDungeon
    local seeds = context.seeds

    if tear.m_needsInit then
        -- TODO: init tear
        tear.m_needsInit = false
    end

    ---@type TearVariant | integer
    local variant = tear.m_variant
    local tearFlags = tear.m_tearFlags
    local ludovico = (tearFlags & TearFlags.TEAR_LUDOVICO) ~= 0

    if ludovico and (tear.m_subtype & 4) ~= 0 and not tear.m_parent then
        tear:Remove(context)
        return
    end

    local lastSpawner = EntityUtils.GetLastSpawner(tear)
    local playerOwner = EntityUtils.ToPlayer(lastSpawner)

    tear.m_timescale = get_time_scale(room, tear)

    -- this seems to be completely unused,
    -- maybe an older version of the Wait flag implementation?
    local unkCountdown = tear.m_unkCountdown
    if unkCountdown > 0 then
        unkCountdown = unkCountdown - 1
        tear.m_unkCountdown = unkCountdown

        if unkCountdown ~= 0 then
            local parent = tear.m_parent.ref
            if parent then
                tear.m_position = tear.m_position + tear.m_unkVector
            end

            tear.m_velocity = Vector(0, 0)
            local height = tear.m_height
            if (unkCountdown % (16 * 2)) < 16 then
                height = height + 0.5
            else
                height = height - 0.5
            end

            TearUtils.SetHeight(context, tear, height)
            -- TODO: Base update
            return
        end

        tear.m_velocity = VectorUtils.Copy(tear.m_unkVelocity)
    end

    local detonate = (tearFlags & TearFlags.TEAR_DETONATE) ~= 0
    if detonate and playerOwner then
        local effects = playerOwner.m_temporaryEffects
        if EffectsUtils.HasCollectibleEffect(effects, CollectibleType.COLLECTIBLE_REMOTE_DETONATOR) then
            tearFlags = tearFlags & ~TearFlags.TEAR_DETONATE
            tearFlags = tearFlags | TearFlags.TEAR_EXPLOSIVE
            tear.m_tearFlags = tearFlags
            tear:SetCollisionDamage(context, tear.m_collisionDamage * 3.0 + 9.0)
            tear.m_isDead = true
            tear.m_unkFlags = 0x40
        end
    end

    if IsDungeon and -5.1 <= tear.m_height and (tear.m_range * 0.6 < tear.m_localFrame) then
        if not ludovico then
            tear.m_isDead = true
            tear.m_unkFlags = 0x40
        end
    end

    local gfuel = SeedsUtils.HasSeedEffect(seeds, SeedEffect.SEED_G_FUEL)
    if (variant == TearVariant.NAIL or variant == TearVariant.NAIL_BLOOD) and gfuel then
        tearFlags = tearFlags & ~TearFlags.TEAR_LASERSHOT
        tear.m_tearFlags = tearFlags
    end

    local wait = (tearFlags & TearFlags.TEAR_WAIT) ~= 0
    -- TODO: Wait (Anti-Gravity) Tears

    local mysteriousLiquid = (tearFlags & TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP) ~= 0
    -- TODO: Mysterious Tears

    local laser = (tearFlags & TearFlags.TEAR_LASER) ~= 0
    -- TODO: Laser Tears

    local laserShot = (tearFlags & TearFlags.TEAR_LASERSHOT) ~= 0
    -- TODO: Laser Shot Tears

    local hydrobounce = (tearFlags & TearFlags.TEAR_HYDROBOUNCE) ~= 0
    -- TODO: Ludovico + Hydrobounce synergy

    if tear.m_isDead and not variant == TearVariant.CHAOS_CARD then
        local override = TearDeath.TriggerDeath(tear)
        if override then
            return
        end
    end

    -- TODO: Rest of Update

    local bouncingTear = TearUtils.HasAnyTearFlag(tear, TearFlags.TEAR_BOUNCE | TearFlags.TEAR_BOUNCE_WALLSONLY) or tear.m_variant == TearVariant.FIRE
    if bouncingTear and not RoomUtils.IsBeastDungeon(room) then
        bounce_tear(context, tear)
    end

    -- TODO
end

--#region Module

Module.Update = Update

--#endregion

return Module
