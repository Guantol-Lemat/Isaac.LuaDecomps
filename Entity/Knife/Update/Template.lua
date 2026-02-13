--#region Dependencies

local EntityUtils = require("Entity.Utils")
local EntityRules = require("Entity.Common.Rules")
local KnifeUtils = require("Entity.Knife.Utils")
local Inventory = require("Game.Inventory.Inventory")
local MathUtils = require("General.Math")

--#endregion

---@class KnifeUpdateTemplate
local Module = {}

---@param knife EntityKnifeComponent
---@param context Context
---@param player EntityPlayerComponent?
local function update_held_rotation(knife, context, player)
    local game = context:GetGame()

    local targetRotation = knife.m_rotation + knife.m_rotationOffset

    if EntityRules.GetFrameCount(game, knife) < 2 or math.abs(knife.m_effectiveRotation - knife.m_rotation) <= 0.1 then
        knife.m_effectiveRotation = targetRotation
        return
    end

    local interpolationFactor = 0.3
    if player and Inventory.HasCollectible(context, player, CollectibleType.COLLECTIBLE_TRACTOR_BEAM, false) then
        interpolationFactor = 1.0
    end

    knife.m_effectiveRotation = MathUtils.InterpolateAngle(knife.m_effectiveRotation, targetRotation, interpolationFactor)
end

---@param knife EntityKnifeComponent
---@param context Context
---@param primaryKnife EntityKnifeComponent
---@param player EntityPlayerComponent?
---@param pivotRadius number
local function update_held_knife(knife, context, primaryKnife, player, pivotRadius)
    if knife == primaryKnife then
        update_held_rotation(knife, context, player)
    else
        knife.m_isFlying = false
    end

    knife.m_targetPosition = Vector(0, 0)
    EntityUtils.SetTarget(knife, nil)

    -- distance related evaluations

    ---@type EntityComponent
    local primaryParent = primaryKnife.m_parent
    knife.m_position = MathUtils.PolarToCartesian(pivotRadius, knife.m_effectiveRotation) + primaryParent.m_position
    knife.m_holderPosition = primaryParent.m_position
    knife.m_hitboxRotation = (knife.m_position - primaryParent.m_position):GetAngleDegrees()
end

---@param knife EntityKnifeComponent
---@param context Context
---@param primaryKnife EntityKnifeComponent
---@param player EntityPlayerComponent?
local function update_thrown_knife(knife, context, primaryKnife, player)
    if primaryKnife == knife then
        -- update rotation
        -- update distance
        -- update velocity

        if knife.m_distance < 0.0 then
            -- trigger hold knife
        end
    else
        -- set animation
        -- conditionally clear hitlist
    end

    -- update swing parent pos

    if primaryKnife ~= knife then
        knife.m_isFlying = true
        knife.m_distance = primaryKnife.m_distance
        knife.m_maxDistance = primaryKnife.m_maxDistance
        knife.m_charge = primaryKnife.m_charge
        knife.m_knifeVelocity = primaryKnife.m_knifeVelocity
    end

    -- update swing parent pos again

    if KnifeUtils.HasTearFlags(knife, TearFlags.TEAR_ORBIT) then
        -- update position
        -- update size
    else
        -- update position
    end

    if knife.m_distanceRelated_qqq >= 0.0 then
        if knife.m_distance <= knife.m_distanceRelated_qqq then
            if knife.m_distance < knife.m_distanceRelated_qqq and primaryKnife ~= knife then
                -- remove and do a full return
            end
        else
            -- update position
        end
    end

    -- update visibility

    -- apply screen wrap if continuum
    -- apply homing if homing
    -- apply wiggle if wiggle

    -- apply spiral if big spiral or spiral
    -- apply square if square
    -- brimstone synergy
end

---@param knife EntityKnifeComponent
---@param context Context
---@param player EntityPlayerComponent?
local function update_knife(knife, context, player)
    local primaryKnife = KnifeUtils.GetPrimaryKnife(knife)
    -- check weapon
        -- return completely if player does not own weapon

    if knife ~= primaryKnife then
        -- if bone or sword
            -- animation related
        -- end
        -- inherit some fields from primary
    end

    local hasSwung = false
    -- if sword
        -- evaluate attack
    -- end
    
    if primaryKnife.m_isSwinging and not primaryKnife.m_isFlying and not hasSwung then
        -- update_bone_swing()
        hasSwung = true
    end

    -- if sword and not isSwinging
        -- update animation
        -- test for update_bone_swing again
    -- end
    
    if not primaryKnife.m_isFlying then
        update_held_knife(knife, context, primaryKnife, player)
    else
        update_thrown_knife(knife, context, primaryKnife, player)
    end

    hook_post_regular_update()
    -- update sprite rotation (and some other sprite things)
    -- mysterious liquid synergy
    -- evaluate another remove
end

---@param knife EntityKnifeComponent
---@param context Context
local function update_0(knife, context)
    -- get unk multipler

    -- hook_9_change color

    if KnifeUtils.HasTearFlags(knife, TearFlags.TEAR_LUDOVICO) then
        -- update ludovico knife
    else
        -- update regular knife
    end

    -- hydrobounce update
    
    if not knife.m_interpolated then
        -- something with color
        -- technology synergy
        -- some remove logic
    end
end

---@param knife EntityKnifeComponent
---@param context Context
local function main_update(knife, context)
    local subtype = knife.m_subtype
    if subtype == 0 then
       update_0(knife, context)
    elseif subtype == KnifeSubType.PROJECTILE then
        -- update_1
    elseif subtype == 3 then
        -- update 3
    elseif subtype == KnifeSubType.CLUB_HITBOX then
        -- update 4
    end
end

---@param knife EntityKnifeComponent
---@param context Context
local function Update(knife, context)
    if not knife.m_interpolated then
        knife.m_friction = knife.m_friction * 0.7
    end

    -- get metadata (skipped)
    local player = KnifeUtils.GetPlayer(knife)
    if not knife.m_parent then
        knife:Remove(context)
    else
        main_update()
    end

    -- apply some tear effects + lua callback
    -- Entity::Update
end

--#region Module



--#endregion

return Module