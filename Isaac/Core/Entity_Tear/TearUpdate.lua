--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")
local IEntity = require("Isaac.Interface.Entity")
local IEntityTear = require("Isaac.Interface.Entity_Tear")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")

local TearGridCollision = require("Isaac.Core.Tear.TearGridCollisionUpdate")
local TearOrbit = require("Isaac.Core.Tear.TearEffects.TearOrbitUpdate")
local TearStick = require("Isaac.Core.Tear.TearEffects.TearStickUpdate")
local TearFetus = require("Isaac.Core.Tear.TearEffects.TearFetusUpdate")
local TearAbsorb = require("Isaac.Core.Tear.TearEffects.TearAbsorbUpdate")
local TearLudovico = require("Isaac.Core.Tear.TearEffects.TearLudovicoUpdate")

--#endregion

---@class Context.Gameplay.TearUpdate : Context.Common
---@field tear_scaleFactor number
---@field stick_scaleFactor number

---@param ctx Context.Common
---@param tear Component.Entity.Tear
local function Update(ctx, tear)
    local ctx_game = ctx.game
    local ctx_room = ctx_game.m_level.m_room

    if tear.m_needsInit then
        
    end

    local isLudovicoTear = (tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0) and (tear.m_subtype & 4) ~= 0
    if isLudovicoTear and not tear.m_parent.ref then
        tear:Remove(ctx)
        return
    end

    local playerOwner = IEntityTear.GetPlayer(tear)

    local timeScale = IRoom.GetTimeScale(ctx, ctx_room, tear)
    if IRoom.HasSlowDown(ctx_room) then
        timeScale = timeScale * 0.75
    end
    tear.m_timeScale = timeScale

    s_local_6c0 = 0.75

    if tear.m_unkCountdown > 0 then
        
    end

    s_local_68c = 3.0

    if tear.m_tearFlags & TearFlags.TEAR_DETONATE ~= 0 and playerOwner then
        
    end

    if IRoom.IsDungeon(ctx_room) and tear.m_height >= -5.1 and tear.m_tearRange * 0.6 < tear.m_localFrame then
        
    end

    ---@type TearVariant
    local tearVariant = tear.m_variant
    if tearVariant == TearVariant.NAIL or tearVariant == TearVariant.NAIL_BLOOD then
        
    end

    local scaleFactor = 1.0

    if tear.m_tearFlags & TearFlags.TEAR_WAIT ~= 0 then

    elseif tear.m_wait_frames > 0 then

    end

    if tear.m_tearFlags & TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_LASER ~= 0 then

    else

    end

    if tear.m_tearFlags & TearFlags.TEAR_LASERSHOT ~= 0 then

    else

    end

    s_local_6b4 = tear.m_fallingSpeed
    if tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 then
        
    end

    if tear.m_isDead and tearVariant ~= TearVariant.CHAOS_CARD then
        -- trigger death

        if tear.m_isDead then
            tear:Remove(ctx)
            return
        end
    end

    if tear.m_tearFlags & TearFlags.TEAR_SQUARE ~= 0 and IEntity.GetFrameCount(ctx, tear) >= 3 then
        
    end

    if tear.m_tearFlags & (TearFlags.TEAR_ORBIT | TearFlags.TEAR_ORBIT_ADVANCED) ~= 0 and not tear.m_target.ref then
        TearOrbit.Update(tear)
    end

    if tear.m_tearFlags & TearFlags.TEAR_FETUS ~= 0 then
        TearFetus.Update(ctx, tear)
    else

    end

    if tear.m_tearFlags & TearFlags.TEAR_OCCULT ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_GROW ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_SHRINK ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_SPECTRAL ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_BOOMERANG ~= 0 and tear.m_parent.ref then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_WIGGLE ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_SPIRAL ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_BIG_SPIRAL ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_ATTRACTOR ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_PULSE ~= 0 then
        
    end

    -- make a copy of the scaleFactor now, as the later sticky tears logic
    -- should not be affected by their own scaling logic
    local sticky_scaleFactor = scaleFactor

    if tear.m_tearFlags & TearFlags.TEAR_STICKY ~= 0 then
        
    end

    local sprite = tear.m_sprite
    sprite.Rotation = 0.0

    if tear.m_tearEffectSprite:IsLoaded() then

    else

    end

    if tear.m_tearFlags & TearFlags.TEAR_FLAT ~= 0 and tearVariant ~= TearVariant.BOBS_HEAD then
        
    end

    if tearVariant == TearVariant.NAIL or tearVariant == TearVariant.NAIL_BLOOD and IGame.HasSeedEffect(ctx_game, SeedEffect.SEED_G_FUEL) then
        
    end

    if tearVariant == TearVariant.PUPULA or tearVariant == TearVariant.PUPULA_BLOOD then

    else

    end

    if tearVariant == TearVariant.FETUS then
        
    end

    if not s_local_692 or not s_local_691 then
        
    end

    local isBalloon = tearVariant == TearVariant.BALLOON or tearVariant == TearVariant.BALLOON_BRIMSTONE or tearVariant == TearVariant.BALLOON_BOMB
    if isBalloon and IEntity.IsFrame(ctx, tear, 2, 0) then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_GLOW ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_DECELERATE ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_ACCELERATE ~= 0 then
        
    end

    -- absorb is only applied if not ludovico
    if tear.m_tearFlags & (TearFlags.TEAR_ABSORB | TearFlags.TEAR_LUDOVICO) == TearFlags.TEAR_ABSORB then
        TearAbsorb.Update(ctx, tear)
    end

    if tear.m_tearFlags & TearFlags.TEAR_CHAIN ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_TRACTOR_BEAM ~= 0 then
        
    end

    local entityFlags = tear.m_flags
    if entityFlags & EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE ~= 0 then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_POP ~= 0 then
        
    end

    TearGridCollision.Update(ctx, tear)

    local isKey = tearVariant == TearVariant.KEY or tearVariant == TearVariant.KEY_BLOOD
    if isKey and not tear.m_isDead and IEntity.ToPlayer(tear.m_spawnerEntity.ref) then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 then
        TearLudovico.Update(ctx, tear)
    end

    tear.m_fScale = tear.m_baseScale * scaleFactor
    tear.m_fScale = math.max(tear.m_fScale, 0.01)
    IEntityTear.reset_sprite_scale(ctx, tear)

    if tearVariant == TearVariant.FIRE then
        
    end

    if IGame(ctx_game, SeedEffect.SEED_BLACK_ISAAC) then
        
    end

    IEntity.Update(ctx, tear)

    local initialTearPos = VectorUtils.Copy(tear.m_position)

    if tear.m_target.ref then
        
    end

    if tear.m_tearFlags & (TearFlags.TEAR_STICKY | TearFlags.TEAR_BOOGER | TearFlags.TEAR_SPORE) ~= 0 then
        TearStick.Update(ctx, tear)
    end

    local evaluateBooger = tear.m_tearFlags & TearFlags.TEAR_BOOGER ~= 0 and
        IEntity.IsFrame(ctx, tear, 30, tear.m_index) and
        tear.m_stick_target.ref and
        IEntity.IsVulnerableEnemy(tear.m_stick_target.ref, nil)

    if evaluateBooger then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_LUDOVICO ~= 0 and IEntityTear.IsMainTear(tear) then
        
    end

    tear.m_posDisplacement = local_1200 - initialTearPos

    if tear.m_wait_frames < 1 then
        
    end

    if IRoom.IsDungeon(ctx_room) and not IRoom.IsPositionInRoom(ctx_room, tear.m_posDisplacement, -256.0) then
        
    end

    if tear.m_tearFlags & TearFlags.TEAR_CONTINUUM ~= 0 then
        
    end

    if IRoom.HasSlowDown(ctx_room) then
        
    end


end

---@class Gameplay.TearUpdate
local Module = {}

--#region Module



--#endregion

return Module