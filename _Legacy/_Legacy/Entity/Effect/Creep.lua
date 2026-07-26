---@class Decomp.Entity.Effect.Creep
local Creep = {}

--#region Requirements

local Lib = {
    Math = require("Lib.Math"),
    Color = require("Lib.Color"),
    EntityEffect = require("Lib.EntityEffect")
}

--#endregion

local function switch_break()
end

--#region Init

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function should_increase_creep_size(effect, env)
    local api = env._API

    local spawnerEntity = effect.m_SpawnerEntity
    if not spawnerEntity then
        return false
    end

    local spawner = api.Entity.GetLastSpawner(spawnerEntity)
    if not spawner then
        return false
    end

    local playerSpawner = api.Entity.ToPlayer(spawner)
    if not playerSpawner then
        return false
    end

    return api.EntityPlayer.HasTrinket(playerSpawner, TrinketType.TRINKET_LOST_CORK, false)
end

---@param effect Decomp.Object.EntityEffect
---@param size number
---@param env Decomp.EnvironmentObject
local function increase_creep_size(effect, size, env)
    if size >= 2.1 then
        effect.m_FScale = effect.m_FScale * 1.65
        return size
    end

    if size >= 0.99 then
        return size * 1.65
    end

    return size + 1.0
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
---@return number
local function get_init_size(effect, env)
    local size = effect.m_Sprite.Scale.X

    if should_increase_creep_size(effect, env) then
        size = increase_creep_size(effect, size, env)
    end

    return size
end

---@param effect Decomp.Object.EntityEffect
---@param size number
---@param env Decomp.EnvironmentObject
local function get_creep_animation(effect, size, env)
    local api = env._API

    if size < 0.99 then
        return string.format("SmallBlood%02u", api.Isaac.RandomInt(env, 6))
    end

    if effect.m_Variant == EffectVariant.PLAYER_CREEP_BLACKPOWDER then
        return string.format("SmallBlood%02u", api.Isaac.RandomInt(env, 6))
    end

    if size < 1.3 then
        return string.format("Blood%02u", api.Isaac.RandomInt(env, 6))
    end

    if size < 2.1 then
        return string.format("BigBlood%02u", api.Isaac.RandomInt(env, 6))
    end

    return string.format("BiggestBlood%02u", api.Isaac.RandomInt(env, 6))
end

--#region SwitchInitSprite

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function init_non_flashing_creep(effect, env)
    local sprite = effect.m_Sprite
    sprite:SetFrame(0)
    sprite:Stop()
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function init_black_player_creep_sprite(effect, env)
    local sprite = effect.m_Sprite
    sprite:SetFrame(2)
    sprite:Stop()
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function init_holywater_trail_sprite(effect, env)
    init_non_flashing_creep(effect, env)
    local sprite = effect.m_Sprite

    local color = sprite.Color
    local colorOffset = Lib.Color.CreateFromHex(135, 165, 201, 255)
    colorOffset = Lib.Color.ApplyColorMod(colorOffset, color)

    color:SetTint(0.0, 0.0, 0.0, 1.0)
    color:SetColorize(0.0, 0.0, 0.0, 0.0)
    color:SetOffset(colorOffset.r, colorOffset.g, colorOffset.b)
    sprite.Color = color
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function init_brown_creep_sprite(effect, env)
    local sprite = effect.m_Sprite

    local color = sprite.Color
    local colorOffset = Lib.Color.CreateFromHex(166, 104, 41, 255)

    color:Reset()
    color:SetTint(0.0, 0.0, 0.0, 1.0)
    color:SetOffset(colorOffset.r, colorOffset.g, colorOffset.b)
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function init_slippery_brown_creep_sprite(effect, env)
    local sprite = effect.m_Sprite

    local color = sprite.Color
    local colorOffset = Lib.Color.CreateFromHex(153, 102, 0, 255)

    color:Reset()
    color:SetTint(0.0, 0.0, 0.0, 1.0)
    color:SetOffset(colorOffset.r, colorOffset.g, colorOffset.b)
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function init_yellow_player_creep_sprite(effect, env)
    local sprite = effect.m_Sprite

    local color = sprite.Color
    local colorOffset = Lib.Color.CreateFromHex(146, 146, 10, 255)

    color:Reset()
    color:SetTint(0.0, 0.0, 0.0, 1.0)
    color:SetOffset(colorOffset.r, colorOffset.g, colorOffset.b)
end

local switch_InitSprite = {
    [EffectVariant.PLAYER_CREEP_WHITE] = init_non_flashing_creep,
    [EffectVariant.PLAYER_CREEP_RED] = init_non_flashing_creep,
    [EffectVariant.PLAYER_CREEP_GREEN] = init_non_flashing_creep,
    [EffectVariant.PLAYER_CREEP_BLACK] = init_black_player_creep_sprite,
    [EffectVariant.PLAYER_CREEP_BLACKPOWDER] = init_black_player_creep_sprite,
    [EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL] = init_holywater_trail_sprite,
    [EffectVariant.CREEP_BROWN] = init_brown_creep_sprite,
    [EffectVariant.CREEP_SLIPPERY_BROWN] = init_slippery_brown_creep_sprite,
    [204] = init_yellow_player_creep_sprite,
    default = switch_break,
}

--#endregion

---@param effect Decomp.Object.EntityEffect
---@param animation string
---@param env Decomp.EnvironmentObject
local function initialize_creep_sprite(effect, animation, env)
    local api = env._API
    local sprite = effect.m_Sprite

    sprite.Scale = Vector(1, 1) * effect.m_FScale
    sprite:Play(animation, false)

    local game = api.Isaac.GetGame(env)
    local frameCount = api.Game.GetFrameCount(game)
    local animationLength = sprite:GetCurrentAnimationData():GetLength()
    sprite:SetFrame(frameCount % animationLength)

    local InitSprite = switch_InitSprite[effect.m_Variant] or switch_InitSprite.default
    InitSprite(effect, env)
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function initialize_creep(effect, env)
    effect.m_State = effect.m_State + 1

    local size = get_init_size(effect, env)
    local animation = get_creep_animation(effect, size, env)
    effect.m_Size = 20.0 * size * effect.m_FScale

    initialize_creep_sprite(effect, animation, env)
    effect.m_RadiusMin = effect.m_Sprite.Color.A

    if effect.m_Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL then
        effect.m_Timeout = effect.m_Timeout // 2
    end
end

--#endregion

--#region Update

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
---@return boolean
local function should_creep_die(effect, env)
    local api = env._API

    if Lib.EntityEffect.IsPlayerCreep(effect.m_Variant) or api.Entity.HasEntityFlags(effect, EntityFlag.FLAG_FRIENDLY) then
        return false
    end

    local room = api.Isaac.GetRoom(env)
    if api.Room.IsClear(room) then
        local entityList = api.Room.GetEntityList(room)
        if api.EntityList.GetNPCCount(entityList) <= 0 then
            return true
        end
    end

    local waterAmount = api.Room.GetWaterAmount(room)
    if waterAmount <= 0.1 then
        return false
    end

    local level = api.Isaac.GetLevel(env)
    local stageId = api.Level.GetStageID(level)

    if stageId ~= StbType.SCARRED_WOMB or stageId ~= StbType.CORPSE then
        return false
    end

    return true
end

--#region SwitchApplyEffect

---@param player Decomp.EntityPlayerObject
---@param env Decomp.EnvironmentObject
---@return boolean
local function can_player_be_hit_by_creep(player, env)
    local api = env._API

    if api.Entity.IsDead(player) then
        return false
    end

    if api.Entity.GetEntityCollisionClass(player) == EntityCollisionClass.ENTCOLL_NONE then
        return false
    end

    if api.Entity.GetGridCollisionClass(player) ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
        return false
    end

    if api.EntityPlayer.HasTrinket(player, TrinketType.TRINKET_CALLUS, false) then
        return false
    end

    if api.EntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_SOCKS, false) then
        return false
    end

    return true
end

---@param effect Decomp.Object.EntityEffect
---@param player Decomp.EntityObject
---@param env Decomp.EnvironmentObject
---@return boolean, KColor?
local function is_player_in_creep_effect_zone(effect, player, env)
    local api = env._API

    local playerPosition = api.Entity.GetPosition(player)
    local effectPosition = effect.m_Position

    local distance = (playerPosition - effectPosition):Length()
    local creepRadius = effect.m_Sprite.Scale.X * effect.m_Size

    if distance >= api.Entity.GetSize(player) + creepRadius then
        return false
    end

    local renderPos = effectPosition * 0.65
    local samplePos = playerPosition * 0.65

    local texel = effect.m_Sprite:GetTexel(samplePos, renderPos, 0.5, -1) -- Should do it on Current animation rather than on Sprite, when that gets exposed (could only be a problem if there is an overlay animation)
    if texel.Alpha <= 0.5 then
        return false
    end

    return true, texel
end

---Added in Rep+
---@param player Decomp.EntityPlayerObject
---@param creepVariant integer
---@param env Decomp.EnvironmentObject
---@return boolean
local function has_player_creep_immunity(player, creepVariant, env)
    local api = env._API

    if api.EntityPlayer.TryTriggerEvilEyeImmunity(player, EntityType.ENTITY_EFFECT, creepVariant) then
        return true
    end

    if api.EntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_SOCKS, false) then
        return true
    end

    return false
end

---@param effect Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
---@return Decomp.EntityObject[]
local function get_creep_enemy_list(effect, env)
    local api = env._API

    local room = api.Isaac.GetRoom(env)
    local entityList = api.Room.GetEntityList(room)

    local radius = effect.m_Sprite.Scale.X * effect.m_Size
    return api.EntityList.QueryRadius(entityList, effect.m_Position, radius, EntityPartition.ENEMY)
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
---@return boolean
local function can_enemy_be_hit_by_creep(creep, enemy, env)
    local api = env._API

    --Rep+ Deathmatch
    if api.Entity.GetType(enemy) == EntityType.ENTITY_PLAYER then
        local player = api.Entity.ToPlayer(enemy)
        if player and has_player_creep_immunity(player, creep.m_Variant, env) then
            return false
        end
    end

    if not api.Entity.IsVulnerableEnemy(enemy, nil) then
        return false
    end

    local spawnerEntity = creep.m_SpawnerEntity
    if spawnerEntity and api.Entity.IsInFamilyTree(spawnerEntity) then
        return false
    end

    if not api.Entity.IsFlying(enemy) then
        return false
    end

    return true
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
---@return boolean
local function is_enemy_in_creep_effect_zone(creep, enemy, env)
    local api = env._API

    local creepRadius = creep.m_Sprite.Scale.X * creep.m_Size
    local enemyPosition = api.Entity.GetPosition(enemy)

    local positionOffset = (enemyPosition - creep.m_Position)
    positionOffset.Y = positionOffset.Y * 1.75
    local distance = positionOffset:LengthSquared()

    if distance >= (creepRadius + api.Entity.GetSize(enemy)) ^ 2 then
        return false
    end

    return true
end

---@param creep Decomp.Object.EntityEffect
---@param player Decomp.EntityPlayerObject
---@param env Decomp.EnvironmentObject
local function try_apply_enemy_damaging_creep_effect(creep, player, env)
    if not can_player_be_hit_by_creep(player, env) then
        return
    end

    local inEffectZone, hitTexel = is_player_in_creep_effect_zone(creep, player, env)
    if not inEffectZone then
        return
    end

    local api = env._API

    if not has_player_creep_immunity(player, creep.m_Variant, env) then
        local source = api.EntityRef.Create(creep)
        player:TakeDamage(1.0, DamageFlag.DAMAGE_ACID, source, 30)
    end

    if creep.m_Variant ~= EffectVariant.CREEP_STATIC then
        assert(hitTexel, "Creep's hitTexel is nil, despite being in effect radius")
        api.EntityPlayer.SetFootprintColor(player, hitTexel, false);
    end
end

---@param creep Decomp.Object.EntityEffect
---@param player Decomp.EntityPlayerObject
---@param env Decomp.EnvironmentObject
local function try_apply_enemy_slowing_creep_effect(creep, player, env)
    if not can_player_be_hit_by_creep(player, env) then
        return
    end

    local inEffectZone, hitTexel = is_player_in_creep_effect_zone(creep, player, env)
    if not inEffectZone then
        return
    end

    local api = env._API

    if has_player_creep_immunity(player, creep.m_Variant, env) then
        local source = api.EntityRef.Create(creep)
        local slowColor = Color()
        slowColor:Reset()
        slowColor:SetTint(1.0, 1.0, 1.3, 1.0)
        slowColor:SetOffset(40, 40, 40)

        local slowValue = creep.m_Variant == EffectVariant.CREEP_WHITE and 0.75 or 0.85
        api.Entity.AddSlowing(player, source, -10, slowValue, slowColor)
    end

    assert(hitTexel, "Creep's hitTexel is nil, despite being in effect radius")
    api.EntityPlayer.SetFootprintColor(player, hitTexel, false);
end

---@param creep Decomp.Object.EntityEffect
---@param player Decomp.EntityPlayerObject
---@param env Decomp.EnvironmentObject
local function try_apply_enemy_slippery_creep_effect(creep, player, env)
    if not can_player_be_hit_by_creep(player, env) then
        return
    end

    local inEffectZone, hitTexel = is_player_in_creep_effect_zone(creep, player, env)
    if not inEffectZone then
        return
    end

    local api = env._API
    api.Entity.AddEntityFlags(player, EntityFlag.FLAG_SLIPPERY_PHYSICS)

    assert(hitTexel, "Creep's hitTexel is nil, despite being in effect radius")
    api.EntityPlayer.SetFootprintColor(player, hitTexel, false);
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
local function try_apply_friendly_slowing_effect(creep, enemy, env)
    if not can_enemy_be_hit_by_creep(creep, enemy, env) then
        return
    end

    if not is_enemy_in_creep_effect_zone(creep, enemy, env) then
        return
    end

    local api = env._API

    local source = api.EntityRef.Create(creep)
    local slowColor = Color()
    slowColor:Reset()
    slowColor:SetTint(1.0, 1.0, 1.3, 1.0)
    slowColor:SetOffset(40, 40, 40)

    api.Entity.AddSlowing(enemy, source, -1, 0.9, slowColor)
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
local function apply_strongest_creep(creep, enemy, env)
    local api = env._API

    local creepDamage = creep.m_CollisionDamage
    local damageEntries = api.Entity.GetDamageEntries(enemy)

    for _, entry in ipairs(damageEntries) do
        if (api.DamageEntry.GetDamageFlags(entry) & DamageFlag.DAMAGE_ACID) ~= 0 then
            api.DamageEntry.SetDamage(entry, math.max(creepDamage, api.DamageEntry.GetDamage(entry)))
            break
        end
    end
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
local function apply_friendly_damaging_effect(creep, enemy, env)
    local api = env._API

    if (api.Entity.GetDamageFlags(enemy) & DamageFlag.DAMAGE_ACID) == 0 then
        local source = api.EntityRef.Create(creep)
        enemy:TakeDamage(creep.m_CollisionDamage, DamageFlag.DAMAGE_ACID, source, 30)
    else
        apply_strongest_creep(creep, enemy, env)
    end

    if creep.m_Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL then
        api.EntityTear.ApplyTearFlagEffects(enemy, creep.m_Position, creep.m_VarData, creep, creep.m_CollisionDamage)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
local function try_apply_friendly_damaging_effect(creep, enemy, env)
    if not can_enemy_be_hit_by_creep(creep, enemy, env) then
        return
    end

    local api = env._API

    if api.HitList.IsEntityInHitList(creep.m_HitList, enemy) then
        return
    end

    if not is_enemy_in_creep_effect_zone(creep, enemy, env) then
        return
    end

    apply_friendly_damaging_effect(creep, enemy, env)
end

---@param creep Decomp.Object.EntityEffect
---@param enemy Decomp.EntityObject
---@param env Decomp.EnvironmentObject
local function try_apply_friendly_uncapped_damage_effect(creep, enemy, env)
    if not can_enemy_be_hit_by_creep(creep, enemy, env) then
        return
    end

    if not is_enemy_in_creep_effect_zone(creep, enemy, env) then
        return
    end

    local api = env._API

    local source = api.EntityRef.Create(creep)
    enemy:TakeDamage(creep.m_CollisionDamage, 0, source, 30)
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_enemy_damaging_creep_effect(creep, env)
    local api = env._API

    local playerManger = api.Isaac.GetPlayerManager(env)
    for i = 0, api.PlayerManager.GetNumPlayers(playerManger) - 1 do
        local player = api.PlayerManager.GetPlayer(playerManger, i)
        try_apply_enemy_damaging_creep_effect(creep, player, env)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_enemy_slowing_creep_effect(creep, env)
    local api = env._API

    local playerManger = api.Isaac.GetPlayerManager(env)
    for i = 0, api.PlayerManager.GetNumPlayers(playerManger) - 1 do
        local player = api.PlayerManager.GetPlayer(playerManger, i)
        try_apply_enemy_slowing_creep_effect(creep, player, env)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_enemy_slippery_creep_effect(creep, env)
    local api = env._API

    local playerManger = api.Isaac.GetPlayerManager(env)
    for i = 0, api.PlayerManager.GetNumPlayers(playerManger) - 1 do
        local player = api.PlayerManager.GetPlayer(playerManger, i)
        try_apply_enemy_slippery_creep_effect(creep, player, env)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_friendly_slowing_creep_effect(creep, env)
    local enemies = get_creep_enemy_list(creep, env)
    for _, enemy in ipairs(enemies) do
        try_apply_friendly_slowing_effect(creep, enemy, env)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_friendly_damaging_creep_effect(creep, env)
    local enemies = get_creep_enemy_list(creep, env)
    for _, enemy in ipairs(enemies) do
        try_apply_friendly_damaging_effect(creep, enemy, env)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_friendly_uncapped_damage_creep_effect(creep, env)
    local enemies = get_creep_enemy_list(creep, env)
    for _, enemy in ipairs(enemies) do
        try_apply_friendly_uncapped_damage_effect(creep, enemy, env)
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function evaluate_creep_static_effect(creep, env)
    local api = env._API
    local isFriendly = api.Entity.HasEntityFlags(creep, EntityFlag.FLAG_FRIENDLY)

    if not isFriendly then
        evaluate_enemy_damaging_creep_effect(creep, env)
        return
    end

    -- This next check is incorrect and it leads to the friendly behavior being unused
    if not isFriendly then
        evaluate_friendly_damaging_creep_effect(creep, env)
        return
    end
end

local switch_ApplyEffect = {
    [EffectVariant.CREEP_RED] = evaluate_enemy_damaging_creep_effect,
    [EffectVariant.CREEP_GREEN] = evaluate_enemy_damaging_creep_effect,
    [EffectVariant.CREEP_YELLOW] = evaluate_enemy_damaging_creep_effect,
    [EffectVariant.CREEP_WHITE] = evaluate_enemy_slowing_creep_effect,
    [EffectVariant.CREEP_BLACK] = evaluate_enemy_slowing_creep_effect,
    [EffectVariant.CREEP_BROWN] = evaluate_enemy_slowing_creep_effect,
    [EffectVariant.CREEP_SLIPPERY_BROWN] = evaluate_enemy_slippery_creep_effect,
    [EffectVariant.PLAYER_CREEP_WHITE] = evaluate_friendly_slowing_creep_effect,
    [EffectVariant.PLAYER_CREEP_BLACK] = evaluate_friendly_slowing_creep_effect,
    [EffectVariant.PLAYER_CREEP_RED] = evaluate_friendly_damaging_creep_effect,
    [EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL] = evaluate_friendly_damaging_creep_effect,
    [204] = evaluate_friendly_damaging_creep_effect,
    [EffectVariant.PLAYER_CREEP_GREEN] = evaluate_friendly_uncapped_damage_creep_effect,
    [EffectVariant.CREEP_STATIC] = evaluate_creep_static_effect,
    default = switch_break,
}

--#endregion

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function update_creep(creep, env)
    local api = env._API

    if creep.m_IsDead or api.Entity.HasEntityFlags(creep, EntityFlag.FLAG_NO_BLOOD_SPLASH) then
        return
    end

    local ApplyEffect = switch_ApplyEffect[creep.m_Variant] or switch_ApplyEffect.default
    ApplyEffect(creep, env)

    if creep.m_Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL then
        update_homing_effect()
    end
end

---@param creep Decomp.Object.EntityEffect
---@param env Decomp.EnvironmentObject
local function update_dead_creep(creep, env)
    local sprite = creep.m_Sprite
    sprite.Scale = sprite.Scale * 0.98

    local alpha = (40 - creep.m_State) / 40.0
    sprite.Color.A = Lib.Math.Clamp(alpha, 0.0, 1.0)

    creep.m_State = creep.m_State + 1
    if creep.m_State > 40 then
        creep:Remove()
    end
end

---@param creep Decomp.Object.EntityEffect
local function Update(creep)
    local env = creep._ENV
    local api = env._API

    if creep.m_State == 0 then
        initialize_creep(creep, env)
    end

    if should_creep_die(creep, env) then
        api.Entity.Die(creep)
    end

    if not creep.m_IsDead then
        update_creep(creep, env)
    end

    if creep.m_IsDead then
        update_dead_creep(creep, env)
    end
end

--#endregion

--#region Module

Creep.Update = Update

--#endregion

return Creep