--#region Dependencies

local EntityUtils = require("Entity.Utils")

--#endregion

---@class KnifeUtils
local Module = {}

---@param knife EntityKnifeComponent
---@param flags TearFlags | BitSet128
---@return boolean
local function HasTearFlags(knife, flags)
    return (knife.m_tearFlags & flags) == flags
end

---@param knife EntityKnifeComponent
---@return EntityPlayerComponent?
local function GetPlayer(knife)
    local parent = knife.m_parent
    if parent and parent.m_type == EntityType.ENTITY_KNIFE then
        parent = parent.m_parent
    end

    if not parent then
        return nil
    end

    if parent.m_type == EntityType.ENTITY_PLAYER then
        return EntityUtils.ToPlayer(parent)
    end

    if parent.m_type == EntityType.ENTITY_FAMILIAR then
        local familiar = EntityUtils.ToFamiliar(parent)
        assert(familiar, "Familiar failed to convert ToFamiliar")
        return familiar.m_player
    end

    if parent.m_type == EntityType.ENTITY_EFFECT then
        local effectParent = parent.m_parent
        if effectParent and effectParent.m_type == EntityType.ENTITY_PLAYER then
            return EntityUtils.ToPlayer(effectParent)
        end
    end

    if parent.m_type == EntityType.ENTITY_TEAR then
        local spawnerEntity = parent.m_spawnerEntity
        if spawnerEntity and spawnerEntity.m_type == EntityType.ENTITY_PLAYER then
            return EntityUtils.ToPlayer(spawnerEntity)
        end
    end

    return nil
end

---@param knife EntityKnifeComponent
---@return EntityKnifeComponent
local function GetPrimaryKnife(knife)
    ---@type EntityComponent
    local entity = knife
    while entity.m_parent.ref and entity.m_parent.ref.m_type == EntityType.ENTITY_KNIFE do
        entity = entity.m_parent.ref
    end

    local primaryKnife = EntityUtils.ToKnife(knife)
    assert(primaryKnife, "Knife failed to convert ToKnife")
    return primaryKnife
end

local BASE_TYPE = {
    [KnifeVariant.BONE_SCYTHE] = KnifeVariant.BONE_CLUB,
    [KnifeVariant.BERSERK_CLUB] = KnifeVariant.BONE_CLUB,
    [KnifeVariant.BAG_OF_CRAFTING] = KnifeVariant.BONE_CLUB,
    [KnifeVariant.SUMPTORIUM] = KnifeVariant.MOMS_KNIFE,
    [8] = KnifeVariant.BONE_CLUB,
    [KnifeVariant.NOTCHED_AXE] = KnifeVariant.BONE_CLUB,
    [KnifeVariant.TECH_SWORD] = KnifeVariant.SPIRIT_SWORD,
}

---@param knife EntityKnifeComponent
---@return KnifeVariant | integer
local function GetBaseType(knife)
    local variant = knife.m_variant
    return BASE_TYPE[variant] or variant
end

--#region Module

Module.HasTearFlags = HasTearFlags
Module.GetPlayer = GetPlayer
Module.GetPrimaryKnife = GetPrimaryKnife
Module.GetBaseType = GetBaseType

--#endregion

return Module