--#region Dependencies

local MathUtils = require("General.Math")
local SpriteUtils = require("General.Sprite")

--#endregion

---@class CommonUpdateUtils
local Module = {}

---@param knife EntityKnifeComponent
local function UpdateSwingingKnifeSprite(knife, primaryParent)
    if not knife.m_isFlying then
        local sprite = knife.m_sprite
        local rotation = (knife.m_position - primaryParent.m_position):GetAngleDegrees()
        local renderRotation = MathUtils.NormalizeAngle(rotation - 90.0)
        sprite.Rotation = renderRotation

        local nullFrame = SpriteUtils.GetNullFrame(sprite, 0)
        if nullFrame then
            local rotationUnitVector = Vector.FromAngle(renderRotation)
            knife.m_knifeDepthOffset = nullFrame:GetPos():DistanceSquared(rotationUnitVector)
        end
    else
        local renderRotation = MathUtils.NormalizeAngle(knife.m_hitboxRotation - 90.0)
        knife.m_sprite.Rotation = renderRotation
    end
end

local function UpdateLiquidCreep(context, knife, spawnCommands)
    -- do stuff
end

local function PostRegularUpdate(context, knife, spawnCommands)
    UpdateLiquidCreep(context, knife, spawnCommands)
end

--#region Module

--#endregion

return Module