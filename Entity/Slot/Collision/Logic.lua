--#region Dependencies

local IsaacSFX = require("Admin.Sound.Rules")
local EntityUtils = require("Entity.Common.Utils")
local PlayerRules = require("Entity.Player.Rules")
local PlayerInventory = require("Entity.Player.Inventory.Inventory")
local SlotUtils = require("Entity.Slot.Utils")
local CollisionCommon = require("Entity.Common.Collision")

--#endregion

---@class SlotCollisionLogic
local Module = {}

local ePayCostFlags = {
    SKIP_COLLISION = 1 << 0,
    NO_COLLISION = 1 << 1,
}

---@param slot EntitySlotComponent
---@param collider EntityPlayerComponent
---@return integer flags
local function hook_slot_pay_cost(slot, collider)
    local flags = 0
    -- variant specific logic for payment
    return flags
end

---@param context Context
---@param slot EntitySlotComponent
---@param collider EntityPlayerComponent
local function hook_collision_setup(context, slot, collider)
    local game = context:GetGame()
    local sfxManager = context:GetSFXManager()

    local slotSprite = slot.m_sprite

    ---@type SlotVariant
    local slotVariant = slot.m_variant

    -- TODO: Shell game

    if SlotUtils.IsBeggar(slotVariant) then
        if slotVariant == SlotVariant.BOMB_BUM then
            -- uses different logic
        elseif slotVariant == SlotVariant.KEY_MASTER then
            -- uses different logic
        else
            local sound = slotVariant == SlotVariant.DEVIL_BEGGAR and SoundEffect.SOUND_TEARIMPACTS or SoundEffect.SOUND_SCAMPER
            IsaacSFX.Play(context, sfxManager, sound, 1.0, 2, false, 1.0)

            local donationValue = slot.m_donationValue + 1
            local rng = slot.m_dropRNG

            local successValue = 0
            if (slotVariant == SlotVariant.BATTERY_BUM or slotVariant == SlotVariant.ROTTEN_BEGGAR) then
                successValue = rng:RandomInt(3) + rng:RandomInt(2)
                if game.m_difficulty == Difficulty.DIFFICULTY_HARD then
                    successValue = math.max(successValue, 2)
                end
            else
                successValue = rng:RandomInt(4) + rng:RandomInt(4) + rng:RandomInt(2)
                if game.m_difficulty == Difficulty.DIFFICULTY_HARD then
                    successValue = math.max(successValue, 5)
                end
            end

            if donationValue > successValue then
                donationValue = rng:RandomInt(2) + 2
                if PlayerInventory.HasCollectible(context, collider, CollectibleType.COLLECTIBLE_LUCKY_FOOT, false) then
                    donationValue = donationValue + 1
                end

                slot.m_state = 2
                slotSprite:Play("PayPrize", true)
            else
                slotSprite:Play("PayNothing", true)
            end

            slot.m_donationValue = donationValue
        end

        return
    end
end

---@param slot EntitySlotComponent
---@param collider EntityComponent
local function evaluate_collision_result(slot, collider)
    local colliderType = collider.m_type

    if colliderType ~= EntityType.ENTITY_PLAYER then
        return EntityUtils.IsEnemy(collider) or colliderType == EntityType.ENTITY_BOMB
    end

    if collider.m_variant == PlayerVariant.PLAYER and slot.m_state ~= 3 then
        slot.m_unkShort1 = 4
    end

    return false
end

---@param slot EntitySlotComponent
---@param context Context
---@param collider EntityComponent
local function HandleCollision(slot, context, collider)
    local forcedCollision = CollisionCommon.IsForcedCollision()

    local colliderType = collider.m_type
    local colliderVariant = collider.m_variant

    ---@type SlotVariant
    local slotVariant = slot.m_variant
    local slotState = slot.m_state
    local slotSprite = slot.m_sprite

    if colliderType ~= EntityType.ENTITY_PLAYER then
        return evaluate_collision_result(slot, collider)
    end

    local player = EntityUtils.ToPlayer(collider)
    assert(player, "Player is not a Player")

    if slotVariant == SlotVariant.MOMS_DRESSING_TABLE then
        if colliderVariant == PlayerVariant.PLAYER and slotState ~= 3 and slotSprite:IsFinished("") then
            -- handle moms_dressing_table
        end

        return evaluate_collision_result(slot, collider)
    end

    if slotState == 1 then
        if slot.m_timeout > 0 then
            return evaluate_collision_result(slot, collider)
        end

        if SlotUtils.IsBeggar(slotVariant) and not slotSprite:IsFinished("") then
            local animData = slotSprite:GetCurrentAnimationData()
            if animData and not animData:IsLoopingAnimation() then
                return evaluate_collision_result(slot, collider)
            end
        end
    elseif slotState == 2 then
        if not SlotUtils.IsShellGame(slotVariant) then
            return evaluate_collision_result(slot, collider)
        end
    end

    local effectTarget = PlayerRules.GetEffectTarget(context, player)
    local daemonsTailRNG = effectTarget.m_trinketRNG[TrinketType.TRINKET_DAEMONS_TAIL]

    if not forcedCollision then
        local flags = hook_slot_pay_cost(slot, effectTarget)

        if flags & ePayCostFlags.SKIP_COLLISION ~= 0 then
            return evaluate_collision_result(slot, collider)
        elseif flags & ePayCostFlags.NO_COLLISION == 0 then
            return false
        end
    end

    EntityUtils.SetEntityReference(slot.m_target, effectTarget)
    hook_collision_setup(context, slot, effectTarget)
    return evaluate_collision_result(slot, collider)
end

--#region Module

Module.HandleCollision = HandleCollision

--#endregion

return Module