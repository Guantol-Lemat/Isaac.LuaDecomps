--#region Dependencies

local g = require("Isaac.Global")
local IsaacUtils = require("Isaac.Utils.Common")
local VectorUtils = require("General.Math.VectorUtils")
local ColorUtils = require("General.VanillaAPI.Color")
local MathUtils = require("General.Math")
local ISprite = require("Isaac.Interface.ANM2")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local ISoundEffects = require("Isaac.Interface.SoundEffects")
local IEntity = require("Isaac.Interface.Entity")
local IEntityRef = IEntity.EntityRef
local IEntityPtr = IEntity.EntityPtr

--#endregion

---@param entity Component.Entity
---@param field string
---@return boolean
local function tickCountdown(entity, field)
    if entity[field] > 0 then
        entity[field] = entity[field] - 1
        return entity[field] < 1
    end
    return false
end

local BURN_COLORS = {
    Color(1.0, 1.0, 1.0, 1.0),
    Color(1.0, 1.0, 0.80392164, 1.0, 0.1764706, 0.0, 0.0),
    Color(1.0, 1.0, 0.60784316, 1.0, 0.3529412, 0.0, 0.0),
    Color(1.0, 1.0, 0.80392164, 1.0, 0.27450982, 0.098039225, 0.0),
    Color(1.0, 1.0, 1.0, 1.0, 0.19607845, 0.19607845, 0.0),
    Color(1.0, 1.0, 1.0, 1.0, 0.098039225, 0.098039225, 0.0),
}

local BLEED_COLORS = {
    Color(1.0, 1.0, 1.0, 1.0),
    Color(1.0, 0.74509805, 0.74509805, 1.0, 0.1764706, 0.0, 0.0),
    Color(1.0, 0.47058827, 0.47058827, 1.0, 0.3529412, 0.0, 0.0),
    Color(0.86274517, 0.23529413, 0.23529413, 1.0, 0.15686275, 0.0, 0.0),
    Color(0.94117653, 0.7843138, 0.7843138, 1.0, 0.0, 0.0, 0.0),
    Color(1.0, 0.80392164, 0.80392164, 1.0, 0.27450982, 0.0, 0.0),
}

local COLOR_LIGHT_DAMAGE_FLASH = Color(0.5, 0.5, 0.33, 1.0, 0.3921569, 0.0, 0.0)
local COLOR_DAMAGE_FLASH = Color(0.5, 0.5, 0.5, 1.0, 0.7843138, 0.0, 0.0)

--#region Properties

---@param entity Component.Entity
---@return boolean
local function ShouldUpdateSprite(entity)
    local flags = entity.m_flags
    if (flags & EntityFlag.FLAG_NO_SPRITE_UPDATE) ~= 0 then
        return false
    end

    return ((entity.m_flags & EntityFlag.FLAG_FREEZE) == 0 and entity.m_stop_countdown < 1)
        or entity.m_isDead
end

---@param entity Component.Entity
---@return boolean
local function Entity_CanApplyStatusEffects(entity)
    return (entity.m_flags & EntityFlag.FLAG_NO_STATUS_EFFECTS) == 0
        and IEntity.IsEnemy(entity)
end

---@param entity Component.Entity
---@return boolean
local function KnockBack_ShouldContinue(entity)
    return (entity.m_collidesWithGrid
        or entity.m_knockback_velocity:Length() > entity.m_velocity:Length()
        or entity.m_knockback_velocity:Dot(entity.m_velocity) >= 0.0)
        and entity.m_knockback_velocity:Length() >= 2.0
end

--#endregion

--#region Operations

---@param entity Component.Entity
local function KnockBack_ApplyImpactDamage(entity)
    if (entity.m_flags & EntityFlag.FLAG_APPLY_IMPACT_DAMAGE) == 0 then
        return
    end

    local newSpeed = entity.m_knockback_velocity:Length() * 0.8
    entity.m_knockback_velocity = entity.m_velocity:Normalized() * newSpeed

    local damage = (ILevel.GetEffectiveStage(g.Game.m_level) - 1) * 2.0 + 10.0;
    entity:TakeDamage(damage, 0, IEntityRef.New(), 0x1e)
    IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
end

---@param entity Component.Entity
local function KnockBack_UpdateEffect(entity)
    if (entity.m_flags & EntityFlag.FLAG_KNOCKED_BACK) == 0 then
        return
    end

    if not KnockBack_ShouldContinue(entity) then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_APPLY_IMPACT_DAMAGE | EntityFlag.FLAG_KNOCKED_BACK)
        entity.m_knockback_countdown = 0
        return
    end

    entity.m_friction = entity.m_initialFriction * 0.95
    if (entity.m_flags & EntityFlag.FLAG_ICE_FROZEN) == 0 then
        entity.m_knockback_velocity = entity.m_knockback_velocity * 0.95
    end

    if entity.m_collidesWithGrid then
        KnockBack_ApplyImpactDamage(entity)
        entity.m_knockback_countdown = entity.m_knockback_countdown / 2
    end

    VectorUtils.Assign(entity.m_velocity, entity.m_knockback_velocity)
end

---@param entity Component.Entity
local function ForceCharm(entity)
    local game = g.Game
    local forceCharm = IGame.HasSeedEffect(game, SeedEffect.SEED_ALWAYS_CHARMED)
        or IGame.HasSeedEffect(game, SeedEffect.SEED_ALWAYS_CHARMED_AND_AFRAID)

    if not forceCharm then
        return
    end

    entity.m_charmedCountdown = 2
    IEntity.AddEntityFlags(entity, EntityFlag.FLAG_CHARM)
end

---@param entity Component.Entity
local function ForceConfusion(entity)
    local forceConfused = IGame.HasSeedEffect(g.Game, SeedEffect.SEED_ALWAYS_CONFUSED)
    if not forceConfused then
        return
    end

    entity.m_confusionCountdown = 2
    IEntity.AddEntityFlags(entity, EntityFlag.FLAG_CONFUSION)
end

---@param entity Component.Entity
local function ForceFear(entity)
    local game = g.Game
    local forceFear = IGame.HasSeedEffect(game, SeedEffect.SEED_ALWAYS_AFRAID)
        or IGame.HasSeedEffect(game, SeedEffect.SEED_ALWAYS_CHARMED_AND_AFRAID)
        or (IGame.HasSeedEffect(game, SeedEffect.SEED_ALWAYS_ALTERNATING_FEAR)
        and (((IEntity.GetFrameCount(entity) / 60) % 2) == 0))

    if not forceFear then
        return
    end

    entity.m_fearCountdown = 2;
    IEntity.AddEntityFlags(entity, EntityFlag.FLAG_FEAR)
end

--#endregion

---@param entity Component.Entity
local function update_color(entity)
    local shouldUpdate = false
    local i = 1
    while i <= #entity.m_temporaryColors do
        local next = i + 1
        local color = entity.m_temporaryColors[i]
        local countdown = color.countdown - 1
        color.countdown = countdown

        if color.fadeout then
            shouldUpdate = true
        end

        if countdown == 0 then
            table.remove(entity.m_temporaryColors, i)
            next = i
            shouldUpdate = true
        end

        i = next
    end

    if not shouldUpdate then
        return
    end

    if #entity.m_temporaryColors == 0 then
        entity:ResetColor()
        return
    end

    local currentColor = entity.m_temporaryColors[1]
    local nextColor = #entity.m_temporaryColors >= 2 and entity.m_temporaryColors[2] or entity.m_color

    local color = currentColor.color
    if currentColor.fadeout then
        color = ColorUtils.Lerp(currentColor.color, nextColor.color, 1.0 - (currentColor.countdown / currentColor.totalDuration))
    end

    entity.m_sprite.m_color = ColorUtils.Copy(color)
end

---@param entity Component.Entity
---@param entry Component.Entity.DamageEntry
local function DamageFlash(entity, entry)
    local entityType = entity.m_type
    local color
    if entityType == EntityType.ENTITY_HUSH or entityType == EntityType.ENTITY_BEAST then
        color = COLOR_LIGHT_DAMAGE_FLASH
    else
        color = COLOR_DAMAGE_FLASH
    end

    local duration = (math.floor(entry.damage + 0.5) + 2) // 3
    MathUtils.Clamp(duration, 1, 6)
    entity:SetColor(color, duration, 0, false, false)
end

---@param entity Component.Entity
local function apply_damage(entity)
    local isDead = false

    for i = 1, #entity.m_damage_entries, 1 do
        local entry = entity.m_damage_entries[i]
        if entry.damage <= 0.0 then
            goto continue
        end

        if (g.Game.m_debugFlags & DebugFlag.DAMAGE_VALUES) ~= 0 then
            local color = KColor(0.5647059, 0.93333334, 0.5647059, 1.0)
            IGame.DebugText(g.Game, entity.m_position, color, string.format("dmg %.2f", entry.damage))
        end

        local doesFireHissSound = entry.damageFlags & (DamageFlag.DAMAGE_POOP | DamageFlag.DAMAGE_FIRE) ~= 0
            and entry.damageFlags & (DamageFlag.DAMAGE_EXPLOSION) == 0
        if doesFireHissSound then
            ISoundEffects.Play(g.Manager.m_sfxManager, SoundEffect.SOUND_FIREDEATH_HISS, 1.0, 2, false, 1.0, 0.0)
        end

        local newHealth = entity.m_health - entry.damage
        entity.m_health = newHealth
        if newHealth < 0.0 and (entity.m_flags & DamageFlag.DAMAGE_NOKILL) == 0 then
            isDead = true
        else
            if (entity.m_flags & EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) == 0 then
                -- don't know why they do this only if flashing damage
                if entity.m_health < 0.0 then
                    entity.m_health = 0.0
                end

                DamageFlash(entity, entry)
            end

        end
        ::continue::
    end

    if isDead then
        entity:Kill()
    end
end

---@param entity Component.Entity
local function update_countdowns(entity)
    tickCountdown(entity, "m_fireDamageCountdown")
    tickCountdown(entity, "m_damageCountdown")

    -- Freeze
    if tickCountdown(entity, "m_freezeCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_FREEZE)
    end

    -- Poison
    if tickCountdown(entity, "m_poisonCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_POISON)
        entity.m_poisonDamage = 2.0
    end

    -- Slow
    if tickCountdown(entity, "m_slowingCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_SLOW)
    end

    -- Charm
    if tickCountdown(entity, "m_charmedCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_CHARM)
        IEntityPtr.SetReference(entity.m_target)
    end

    -- Confusion
    if tickCountdown(entity, "m_confusionCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_CONFUSION)
    end

    -- Fear
    if tickCountdown(entity, "m_fearCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_FEAR)
    end

    -- Shrink
    entity.m_shrink_scale = MathUtils.Lerp(entity.m_shrink_scale, entity.m_shrink_targetScale, 5.0 * 0.033333335)

    if tickCountdown(entity, "m_shrinkCountdown") then
        IEntity.ShrinkEnd(entity)
    end

    -- Burn
    if entity.m_burnCountdown > 0 then
        entity.m_burnCountdown = entity.m_burnCountdown - 1
        if entity.m_burnCountdown < 1 then
            IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_BURN)
            entity.m_burnDamage = 2.0
        end

        -- Flicker through the burn palette every frame
        local idx = IEntity.GetFrameCount(entity) % 6 + 1
        entity:SetColor(BURN_COLORS[idx], 1, -1, false, true)
    end

    -- Midas freeze
    if tickCountdown(entity, "m_midasFreezeCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_MIDAS_FREEZE)
    end

    -- Bleeding
    if entity.m_bleedingCountdown > 0 then
        entity.m_bleedingCountdown = entity.m_bleedingCountdown - 1
        if entity.m_bleedingCountdown < 1 then
            IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_BLEED_OUT)
            entity.m_bleedDamageDistance_qqq = 0.0
        end

        local dist = entity.m_position:Distance(entity.m_preUpdatePos)
        local t = MathUtils.Clamp((dist * 0.02) / entity.m_timeScale, 0, 1)

        local idx = IEntity.GetFrameCount(entity) % 6 + 1
        local color = ColorUtils.Lerp(Color(), BLEED_COLORS[idx], t)
        entity:SetColor(color, 1, -1, false, true)
    end

    -- Magnetized
    if tickCountdown(entity, "m_magnetizedCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_MAGNETIZED)
    end

    -- Baited
    if tickCountdown(entity, "m_baitedCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_BAITED)

        -- drop targets aiming at this entity
        local room = g.Game.m_level.m_room
        for _, ent in ipairs(room.m_entityList.m_roomEL) do
            if IEntity.IsEnemy(ent) then
                local shouldDropTarget = ent.m_target.ref == entity
                    and (ent.m_flags & (EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)) == 0
                if shouldDropTarget then
                    IEntityPtr.SetReference(ent.m_target, nil)
                end
            end
        end
    end

    -- Weakness
    if tickCountdown(entity, "m_weaknessCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_WEAKNESS)
    end

    -- Remove the magnetized pull effect if the entity is not magnetized
    if entity.m_magnetizedPullingEffect.ref ~= nil and (entity.m_flags & EntityFlag.FLAG_MAGNETIZED) == 0 then
        entity.m_magnetizedPullingEffect.ref:Remove()
    end

    -- Knockback
    if tickCountdown(entity, "m_knockback_countdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_KNOCKED_BACK)
    end

    -- Ice
    if tickCountdown(entity, "m_iceCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_ICE)
    end

    -- Brimstone mark
    if tickCountdown(entity, "m_brimstoneMarkCountdown") then
        IEntity.ClearEntityFlags(entity, EntityFlag.FLAG_BRIMSTONE_MARKED)
    end

    tickCountdown(entity, "m_statusImmunity_cooldown")
    tickCountdown(entity, "m_stop_countdown")
end

---@param entity Component.Entity
local function Update(entity)
    -- update
    if (entity.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) == 0 then
        entity.m_lastLocalFrame = entity.m_localFrame
        entity.m_localFrame = entity.m_timeScale + entity.m_localFrame

        if ShouldUpdateSprite(entity) then
            local mySprite = entity.m_sprite
            local originalPlaybackSpeed = mySprite.m_playbackSpeed
            mySprite.m_playbackSpeed = originalPlaybackSpeed * entity.m_timeScale
            ISprite.Update(mySprite)
            mySprite.m_playbackSpeed = originalPlaybackSpeed
        end
    end

    KnockBack_UpdateEffect(entity)

    -- update physics
    entity.m_velocity = entity.m_velocity * IsaacUtils.TimeScaledFriction(entity.m_friction, entity.m_timeScale)
    entity.m_friction = entity.m_initialFriction
    entity.m_position = entity.m_position + entity.m_velocity * entity.m_timeScale

    if (entity.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) == 0 then
        update_color(entity)

        if Entity_CanApplyStatusEffects(entity) then
            ForceCharm(entity)
            ForceConfusion(entity)
            ForceFear(entity)
        end

        update_countdowns(entity)
    end

    if (entity.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE) == 0 then
        if not entity.m_invincible then
            apply_damage(entity)
        end

        entity.m_damage_entries = {}
        entity.m_damage_damageTaken = 0.0
        entity.m_damage_flagsTaken = 0
    end

    -- TODO
end

---@class Core.Entity.Update
local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module