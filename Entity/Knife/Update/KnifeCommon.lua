--#region Dependencies

local EntityUtils = require("Entity.Utils")
local MathUtils = require("General.Math")

--#endregion

---@class CommonKnifeUpdateUtils
local Module = {}

---@type WeaponType
local NECESSARY_WEAPON = WeaponType.WEAPON_KNIFE

---@param knife EntityKnifeComponent
---@return number
local function GetPivotRadius(knife)
    local parent = knife.m_parent
    if parent and parent.m_type == EntityType.ENTITY_TEAR then
        local tear = EntityUtils.ToTear(parent)
        assert(tear, "Could not convert tear ToTear")
        return tear.m_fScale * 20.0
    end

    return 30.0
end

---@param knife EntityKnifeComponent
local function UpdateSprite(knife)
    local renderRotation = MathUtils.NormalizeAngle(knife.m_hitboxRotation - 90.0)
    local sprite = knife.m_sprite
    sprite.Rotation = renderRotation

    local layer = sprite:GetLayer(0)
    assert(layer, "Layer 0 doesn't exist")
    local flipX = renderRotation > 0.0
    layer:SetFlipX(flipX)
end

--#region Module

Module.NECESSARY_WEAPON = NECESSARY_WEAPON
Module.GetPivotRadius = GetPivotRadius
Module.UpdateSprite = UpdateSprite

--#endregion

return Module