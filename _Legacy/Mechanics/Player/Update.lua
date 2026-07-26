--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")

local VECTOR_ZERO = VectorUtils.VectorZero
--#endregion

---@param player Component.Entity.Player
---@param pickupAnimation boolean
local function update_body_sprite(player, pickupAnimation)
    local flying = player.m_canFly
    local notInTransition = true

    -- additional flags evaluation

    local baseAnimation = pickupAnimation and "PickupWalkDown" or "WalkDown"

    local playbackSpeed = 1.0
    local isIdle = VectorUtils.Equals(get_body_mov_direction(), VECTOR_ZERO)

    if isIdle then
        -- something related to t forgotten

        local costumeMap = player.m_costumeMap
        local spriteDesc = player.m_costumeSpriteDesc

        for i = 0, 14, 1 do
            local costume = costumeMap[i + 1]
            local index = costume.index
            if index < 0 or not costume.isBodyLayer then
                goto continue
            end

            if player.m_variant == PlayerVariant.CO_OP_BABY or player.m_isCoopGhost then
                goto continue
            end

            local costume_spriteDesc = spriteDesc[index + 1]
            local costume_item = costume_spriteDesc.m_itemConfig

            if costume_item and (costume_item.m_itemType == ItemType.ITEM_NULL and costume_item.m_id == NullItemID.ID_JUPITER_BODY_ANGEL) then
                playbackSpeed = playbackSpeed * 2
            end

            if costume_spriteDesc.m_itemAnimPlay then
                goto continue
            end

            if pickupAnimation and (not costume_item.m_itemType == ItemType.ITEM_NULL and costume_item.m_id == NullItemID.ID_LILITH_B) then
                costume_spriteDesc.m_sprite:Stop()
                goto continue
            end

            if costume_item.m_itemType == ItemType.ITEM_ACTIVE and costume_item.m_id == CollectibleType.COLLECTIBLE_MEGA_MUSH then
                costume_spriteDesc.m_sprite:SetFrame("WalkIdle", 0)
                goto continue
            end

            if flying then
                costume_spriteDesc.m_sprite:Play(baseAnimation, false)
            else
                local idleAnimation = string.format("%s%s", baseAnimation, "_Idle")
                local costume_sprite = costume_spriteDesc.m_sprite

                if costume_sprite:GetAnimationData(idleAnimation) then
                    costume_sprite:Play(idleAnimation, false)
                else
                    costume_sprite:SetFrame(baseAnimation, 0)
                end
            end

            if costume_spriteDesc.m_hasOverlay then
                local overlayAnimation = string.format("%s%s", baseAnimation, "_Overlay")
                local costume_sprite = costume_spriteDesc.m_sprite

                if flying then
                    costume_sprite:PlayOverlay(overlayAnimation, false)
                else
                    costume_sprite:SetFrame(overlayAnimation, 0) -- this is what the game does, it does not call SetOverlayFrame
                end
            end
            ::continue::
        end
    end
    for i = 1, 10, 1 do
        
    end
end

---@param ctx Context.Common
---@param player Component.Entity.Player
local function Update(ctx, player)
    -- TODO

    if player.m_parent and player.m_variant == PlayerVariant.PLAYER and not player.m_playerHUD then
        -- TODO
    end

    if player.m_playerHUD then
        -- TODO
    end

    if player.m_salvation_effect then
        -- TODO
    end

    if player.m_playerType == PlayerType.PLAYER_LAZARUS_B or player.m_playerType == PlayerType.PLAYER_LAZARUS2_B then
        -- TODO
    end

    local interpolationUpdate = player.m_flags & EntityFlag.FLAG_INTERPOLATION_UPDATE ~= 0
    if not interpolationUpdate then
        -- TODO
    end

    if not player.m_valid and player.m_spawnerType == EntityType.ENTITY_SIREN then
        -- TODO
    end

    -- TODO: A lot more Blocks
    
    if not player.m_isDead then
        if player.m_variant == PlayerVariant.PLAYER and not player.m_isCoopGhost then
            -- TODO
        end

        call update_ladder()

        player.m_damageCooldown = math.max(player.m_damageCooldown - 1, 0)
        player.m_controlsCooldown = math.max(player.m_controlsCooldown - 1, 0)
        player.m_firingCooldown = math.max(player.m_firingCooldown - 1, 0)
        player.m_itemHoldCooldown = math.max(player.m_itemHoldCooldown - 1, 0)
        player.m_unkRedFlashCondition = math.max(player.m_unkRedFlashCondition - 1, 0)

        if player.m_unkDamageCacheCountdown > 0 then
            local countdown = player.m_unkDamageCacheCountdown - 1
            player.m_unkDamageCacheCountdown = countdown
            if countdown == 0 then
                player.m_cacheFlags = player.m_cacheFlags | CacheFlag.CACHE_DAMAGE
                call EvaluateItems()
            end
        end

        if player.m_unkFireDelayCacheCountdown > 0 then
            local countdown = player.m_unkFireDelayCacheCountdown - 1
            player.m_unkFireDelayCacheCountdown = countdown
            if countdown == 0 then
                player.m_cacheFlags = player.m_cacheFlags | CacheFlag.CACHE_FIREDELAY
                call EvaluateItems()
            end
        end

        if player.m_unkDamageCacheCountdown > 0 then
            local countdown = player.m_unkDamageCacheCountdown - 1
            player.m_unkDamageCacheCountdown = countdown
            if countdown == 0 then
                player.m_cacheFlags = player.m_cacheFlags | CacheFlag.CACHE_DAMAGE
                call EvaluateItems()
            end
        end

        if player.m_unkDamageCacheCountdown > 0 then
            local countdown = player.m_unkDamageCacheCountdown - 1
            player.m_unkDamageCacheCountdown = countdown
            if countdown == 0 then
                player.m_cacheFlags = player.m_cacheFlags | CacheFlag.CACHE_DAMAGE
                call EvaluateItems()
            end
        end
    end
end

local Module = {}

--#region Module



--#endregion

return Module