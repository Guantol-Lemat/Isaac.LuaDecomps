--#region Dependencies

local IEntityPlayer = require("Isaac.Interface.Entity_Player")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local LuaCallbacks = require("LuaEngine.Callbacks")

--#endregion

---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@return boolean
local function has_collectible(player, collectible)
    return IEntityPlayer.HasCollectible(player, collectible, false)
end

---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@return boolean
local function has_collectible_or_effect(player, collectible)
    return IEntityPlayer.HasCollectible(player, collectible, false)
        or ITemporaryEffects.HasCollectibleEffect(player.m_temporaryEffects, collectible)
end

---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@return boolean
local function has_zodiac_collectible(player, collectible)
    return IEntityPlayer.HasCollectible(player, collectible, false)
        or IEntityPlayer.GetZodiacEffect(player) == collectible
end

---@param player Component.Entity.Player
---@param trinket TrinketType | integer
---@return boolean
local function has_trinket(player, trinket)
    return IEntityPlayer.HasTrinket(player, trinket, false)
end

---@param player Component.Entity.Player
---@param collectible CollectibleType | integer
---@return boolean
local function has_collectible_effect(player, collectible)
    return ITemporaryEffects.HasCollectibleEffect(player.m_temporaryEffects, collectible)
end

---@param player Component.Entity.Player
---@param item NullItemID | integer
---@return boolean
local function has_null_effect(player, item)
    return ITemporaryEffects.HasNullEffect(player.m_temporaryEffects, item)
end

---@param player Component.Entity.Player
---@param playerType PlayerType | integer
---@return boolean
local function is_player_type(player, playerType)
    return player.m_playerType == playerType
end

---@param player Component.Entity.Player
---@param babySkin BabySubType | integer
---@return boolean
local function is_baby_type(player, babySkin)
    return player.m_babySkin == babySkin
end

---@param player Component.Entity.Player
---@param weaponType WeaponType | integer
---@return boolean
local function has_weapon(player, weaponType)
    return IEntityPlayer.HasWeaponType(player, weaponType)
end

---@param player Component.Entity.Player
---@return boolean
local function is_coop_ghost(player)
    return player.m_isCoopGhost
end

---@param player Component.Entity.Player
---@return boolean
local function has_hallowed_ground_effect(player)
    return player.m_hallowedGround_countdown > 0
end

---@param player Component.Entity.Player
---@return boolean
local function has_astral_projection_effect(player)
    return ITemporaryEffects.GetCollectibleEffectNum(player.m_temporaryEffects, CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) == 1
end

---@param player Component.Entity.Player
---@return boolean
local function has_ipecac_effect(player)
    return IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_IPECAC, false)
        and (not IEntityPlayer.HasWeaponType(player, WeaponType.WEAPON_LUDOVICO_TECHNIQUE) or IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_FLAT_STONE, false))
end

---@param player Component.Entity.Player
---@return boolean
local function has_anti_gravity_effect(player)
    if not IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_ANTI_GRAVITY, false) then
        return false
    end

    return not IEntityPlayer.HasWeaponType(player, WeaponType.WEAPON_LUDOVICO_TECHNIQUE)
        and not IEntityPlayer.HasWeaponType(player, WeaponType.WEAPON_MONSTROS_LUNGS)
        and (not IEntityPlayer.HasWeaponType(player, WeaponType.WEAPON_TEARS)
        or (not IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_CURSED_EYE, false)
        and not IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK, false)))
end

local RULES = {
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT}, flag = TearFlags.TEAR_OCCULT},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_URANUS}, flag = TearFlags.TEAR_ICE},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_TERRA}, flag = TearFlags.TEAR_ROCK},
    {condition = has_trinket, args = {TrinketType.TRINKET_BRAIN_WORM}, flag = TearFlags.TEAR_TURN_HORIZONTAL},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE}, flag = TearFlags.TEAR_RAINBOW},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_SACRED_HEART}, flag = TearFlags.TEAR_HOMING},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_SPOON_BENDER}, flag = TearFlags.TEAR_HOMING},
    {condition = has_collectible_effect, args = {CollectibleType.COLLECTIBLE_TELEPATHY_BOOK}, flag = TearFlags.TEAR_HOMING},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_GODHEAD}, flag = TearFlags.TEAR_HOMING | TearFlags.TEAR_GLOW},
    {condition = is_baby_type, args = {BabySubType.BABY_PSY}, flag = TearFlags.TEAR_HOMING},
    {condition = has_hallowed_ground_effect, args = {}, flag = TearFlags.TEAR_HOMING},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_LUMP_OF_COAL}, flag = TearFlags.TEAR_GROW},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO}, flag = TearFlags.TEAR_LASER},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_PROPTOSIS}, flag = TearFlags.TEAR_SHRINK},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_DEAD_DOVE}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_OUIJA_BOARD}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_weapon, args = {WeaponType.WEAPON_LUDOVICO_TECHNIQUE}, flag = TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_DEAD_ONION}, flag = TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_PUPULA_DUPLEX}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_THE_WIZ}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_player_type, args = {PlayerType.PLAYER_THELOST}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_player_type, args = {PlayerType.PLAYER_THELOST_B}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_player_type, args = {PlayerType.PLAYER_JACOB2_B}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_player_type, args = {PlayerType.PLAYER_THESOUL}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_baby_type, args = {BabySubType.BABY_FOUND_SOUL}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_baby_type, args = {BabySubType.BABY_BOUND}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = is_coop_ghost, args = {}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_astral_projection_effect, args = {}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_null_effect, args = {NullItemID.ID_REVERSE_SUN}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_null_effect, args = {NullItemID.ID_SPIRIT_SHACKLES_SOUL}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_null_effect, args = {NullItemID.ID_LOST_CURSE}, flag = TearFlags.TEAR_SPECTRAL},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_CUPIDS_ARROW}, flag = TearFlags.TEAR_PIERCING},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_DEATHS_TOUCH}, flag = TearFlags.TEAR_PIERCING},
    {condition = has_zodiac_collectible, args = {CollectibleType.COLLECTIBLE_SAGITTARIUS}, flag = TearFlags.TEAR_PIERCING},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_POLYPHEMUS}, flag = TearFlags.TEAR_PERSISTENT},
    {condition = has_zodiac_collectible, args = {CollectibleType.COLLECTIBLE_SCORPIO}, flag = TearFlags.TEAR_POISON},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_PARASITE}, flag = TearFlags.TEAR_SPLIT},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_MY_REFLECTION}, flag = TearFlags.TEAR_BOOMERANG},
    {condition = has_trinket, args = {TrinketType.TRINKET_WIGGLE_WORM}, flag = TearFlags.TEAR_WIGGLE | TearFlags.TEAR_SPECTRAL},
    {condition = has_trinket, args = {TrinketType.TRINKET_HOOK_WORM}, flag = TearFlags.TEAR_SQUARE | TearFlags.TEAR_SPECTRAL},
    {condition = has_ipecac_effect, args = {}, flag = TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_TINY_PLANET}, flag = TearFlags.TEAR_ORBIT | TearFlags.TEAR_SPECTRAL},
    {condition = has_anti_gravity_effect, args = {}, flag = TearFlags.TEAR_WAIT},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_CRICKETS_BODY}, flag = TearFlags.TEAR_QUADSPLIT},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_RUBBER_CEMENT}, flag = TearFlags.TEAR_BOUNCE},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR}, flag = TearFlags.TEAR_ATTRACTOR},
    {condition = has_trinket, args = {TrinketType.TRINKET_PULSE_WORM}, flag = TearFlags.TEAR_PULSE},
    {condition = has_zodiac_collectible, args = {CollectibleType.COLLECTIBLE_PISCES}, flag = TearFlags.TEAR_KNOCKBACK},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_8_INCH_NAILS}, flag = TearFlags.TEAR_KNOCKBACK},
    {condition = has_trinket, args = {TrinketType.TRINKET_BLISTER}, flag = TearFlags.TEAR_KNOCKBACK},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_TERRA}, flag = TearFlags.TEAR_KNOCKBACK},
    {condition = has_trinket, args = {TrinketType.TRINKET_RING_WORM}, flag = TearFlags.TEAR_SPIRAL | TearFlags.TEAR_SPECTRAL},
    {condition = has_trinket, args = {TrinketType.TRINKET_FLAT_WORM}, flag = TearFlags.TEAR_FLAT},
    {condition = has_trinket, args = {TrinketType.TRINKET_OUROBOROS_WORM}, flag = TearFlags.TEAR_BIG_SPIRAL | TearFlags.TEAR_SPECTRAL},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_CONTINUUM}, flag = TearFlags.TEAR_CONTINUUM | TearFlags.TEAR_SPECTRAL},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_TRACTOR_BEAM}, flag = TearFlags.TEAR_TRACTOR_BEAM},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_TRISAGION}, flag = TearFlags.TEAR_LASERSHOT},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_FIRE_MIND}, flag = TearFlags.TEAR_BURN},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID}, flag = TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP},
    {condition = has_collectible_or_effect, args = {CollectibleType.COLLECTIBLE_DARK_MATTER}, flag = TearFlags.TEAR_DARK_MATTER},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE}, flag = TearFlags.TEAR_BONE},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_EYE_OF_BELIAL}, flag = TearFlags.TEAR_PIERCING | TearFlags.TEAR_BELIAL},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_JACOBS_LADDER}, flag = TearFlags.TEAR_JACOBS},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_LACHRYPHAGY}, flag = TearFlags.TEAR_ABSORB},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_POP}, flag = TearFlags.TEAR_POP},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_FLAT_STONE}, flag = TearFlags.TEAR_HYDROBOUNCE},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_LOST_CONTACT}, flag = TearFlags.TEAR_SHIELDED},
    {condition = has_null_effect, args = {NullItemID.ID_SOUL_FORGOTTEN}, flag = TearFlags.TEAR_SHIELDED},
    {condition = has_collectible, args = {CollectibleType.COLLECTIBLE_BACKSTABBER}, flag = TearFlags.TEAR_BACKSTAB},
}

---@param player Component.Entity.Player
local function EvaluateTearFlags(player)
    local flags = TearFlags.TEAR_NORMAL

    for i = 1, #RULES, 1 do
        local rule = RULES[i]
        if rule.condition(player, table.unpack(rule.args)) then
            flags = flags | rule.flag
        end
    end

    player.m_tearFlags = flags
    LuaCallbacks.PostEvaluateItems(player, CacheFlag.CACHE_TEARFLAG)
end

---@class Content.Player.Properties.TearFlags
local Module = {}

--#region Module

Module.EvaluateTearFlags = EvaluateTearFlags

--#endregion

return Module