--#region Dependencies

local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils.Common")
local IGame = require("Isaac.Interface.Game")
local IEntityList = require("Isaac.Interface.EntityList")
local IEntity = require("Isaac.Interface.Entity")
local IEntityTear = require("Isaac.Interface.Entity_Tear")

--#endregion

---@class Closure.Gameplay.TearAbsorbUpdate
---@field player_tearHeight number
---@field player_damage number
---@field player_maxFireDelay number
---@field player_shotSpeed number
---@field burstScale number

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param closure Closure.Gameplay.TearAbsorbUpdate
local function do_burst(ctx, tear, closure)
    local rawNumTears = tear.m_fScale * 5.0
    local numTears = MathUtils.Clamp(rawNumTears, 0, 8)
    numTears = math.floor(numTears)

    local tearFlags = tear.m_tearFlags
    if tearFlags & TearFlags.TEAR_SPLIT ~= 0 then
        numTears = numTears + 4
    end

    if tearFlags & TearFlags.TEAR_QUADSPLIT ~= 0 then
        numTears = math.floor(numTears * 1.5)
    end

    -- not enough tears for burst
    if numTears < 3 then
        tear.m_tearFlags = tearFlags & ~TearFlags.TEAR_ABSORB
        tear.m_fallingSpeed = 0.5
        return
    end

    local randomAngleOffset = IsaacUtils.RandomFloat() * 360.0
    local angleStep = 360.0 / numTears

    for i = 1, numTears, 1 do
        local idx = i - 1
        local bannedFlags = TearFlags.TEAR_SPLIT |
            TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_ABSORB |
            TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_FETUS

        local inheritedFlags = tear.m_tearFlags & ~bannedFlags
        ---@type TearVariant
        local tearVariant = tear.m_variant
        if tearVariant == TearVariant.HUNGRY then
            tearVariant = TearVariant.BLOOD
        end

        local seed = IsaacUtils.Random()

        local angle = idx * angleStep + randomAngleOffset
        local direction = Vector.FromAngle(angle)
        local velocity = direction * closure.player_shotSpeed * 10.0

        local burst_entity = IGame.Spawn(
            ctx, ctx.game,
            EntityType.ENTITY_TEAR, tearVariant,
            tear.m_position, velocity,
            tear.m_spawnerEntity.ref, 0, seed
        )

        local burst_entityTear = IEntity.ToTear(burst_entity)
        assert(burst_entityTear)

        -- init entity data
        local height = math.min(tear.m_height, -6)
        IEntityTear.SetHeight(ctx, burst_entityTear, height)
        IEntityTear.SetScale(ctx, burst_entityTear, tear.m_baseScale * 0.5)
        burst_entityTear.m_tearFlags = inheritedFlags
        burst_entityTear:SetCollisionDamage(ctx, tear.m_collisionDamage * 0.5)
        burst_entityTear:SetColor(ctx, tear.m_sprite.Color, -1, -1, false, true)
        burst_entityTear.m_multidimensional_touched = tear.m_multidimensional_touched
        burst_entityTear.m_prims_touched = tear.m_prims_touched
        burst_entityTear.m_targetPosition = VectorUtils.Copy(tear.m_position)

        if tearFlags & TearFlags.TEAR_HYDROBOUNCE ~= 0 then
            burst_entityTear.m_fallingSpeed = -15.0 - burst_entityTear.m_fallingSpeed
            burst_entityTear.m_fallingAcceleration = 3.0
        end
    end

    tear:Remove(ctx)
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
---@param closure Closure.Gameplay.TearAbsorbUpdate
local function try_absorb(ctx, tear, closure)
    local absorbRadius = tear.m_fScale * tear.m_size * 4.0
    local ctx_entityList = ctx.game.m_level.m_room.m_entityList

    local closeTears = IEntityList.QueryRadius(ctx, ctx_entityList, tear.m_position, absorbRadius, EntityPartition.TEAR)
    for i = 1, #closeTears, 1 do
        local closeTear = IEntity.ToTear(closeTears[i])
        if not closeTear then
            goto continue
        end

        local isAbsorbable = closeTear ~= tear and not closeTear.m_isDead and
            tear.m_flags & TearFlags.TEAR_LUDOVICO == 0

        if not isAbsorbable then
            goto continue
        end

        local rawNewSize = closeTear.m_size + tear.m_size
        local newSize = math.max(rawNewSize, 5.0)

        -- not close enough
        if closeTear.m_position:Distance(tear.m_position) > newSize then
            goto continue
        end

        -- pick which absorbs which
        local isAbsorbed = closeTear.m_fScale >= tear.m_fScale and closeTear.m_tearFlags & TearFlags.TEAR_ABSORB ~= 0
        local absorbed = closeTear
        local absorber = tear
        if isAbsorbed then
            absorbed = tear
            absorber = closeTear
        end

        -- absorb
        local baseScale = absorber.m_baseScale
        local rawScaleIncrease = (baseScale * closure.player_maxFireDelay) / 50.0
        local scaleIncrease = MathUtils.Clamp(rawScaleIncrease, 0.2, 1.0)

        local newScale = math.min(baseScale + scaleIncrease, closure.burstScale)
        IEntityTear.SetScale(ctx, absorber, newScale)
        local tearCollisionDamage = math.max(tear.m_collisionDamage, closeTear.m_collisionDamage)
        absorber:SetCollisionDamage(ctx, closure.player_damage + tearCollisionDamage)

        absorbed:Remove(ctx)

        -- quit if tear itself was absorbed
        if isAbsorbed then
            return
        end
        ::continue::
    end
end

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function Update(ctx, tear)
    local player = IEntityTear.GetPlayer(tear)
    local player_tearHeight = 23.75
    local player_damage = 3.5
    local player_maxFireDelay = 10.0
    local player_shotSpeed = 1.0

    if player then
        player_tearHeight = player.m_tearHeight
        player_damage = player.m_damage
        player_maxFireDelay = player.m_maxFireDelay
        player_shotSpeed = player.m_shotSpeed
    end

    local rawBurstTearScale = ((player_maxFireDelay / 10.0) ^ 2) * math.sqrt(player_damage)
    local burstTearScale = MathUtils.Clamp(rawBurstTearScale, 3.0, 10.0)

    ---@type Closure.Gameplay.TearAbsorbUpdate
    local closure = {
        player_tearHeight = player_tearHeight,
        player_damage = player_damage,
        player_maxFireDelay = player_maxFireDelay,
        player_shotSpeed = player_shotSpeed,
        burstScale = burstTearScale
    }


    IEntityTear.SetHeight(ctx, tear, player_tearHeight)
    tear.m_fallingAcceleration = 0.0
    tear.m_fallingSpeed = 0.0

    if tear.m_tearFlags & (TearFlags.TEAR_ORBIT | TearFlags.TEAR_ORBIT_ADVANCED) == 0 then
        tear.m_friction = tear.m_friction * 0.95
    end

    local frameCount = IEntity.GetFrameCount(ctx, tear)
    local MIN_BURST_FRAME_COUNT = 10
    if frameCount <= MIN_BURST_FRAME_COUNT then
        return
    end

    local shouldBurst = tear.m_fScale >= burstTearScale
    if not shouldBurst then
        local rawMaxBurstFrameCount = player_maxFireDelay * 5.0
        local maxBurstFrameCount = MathUtils.Clamp(rawMaxBurstFrameCount, 80, 150)

        shouldBurst = frameCount >= maxBurstFrameCount or tear.m_collidesWithGrid
    end

    if shouldBurst then
        do_burst(ctx, tear, closure)
    end

    if not tear.m_isDead then
        try_absorb(ctx, tear, closure)
    end
end

---@class Gameplay.TearAbsorbUpdate
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module