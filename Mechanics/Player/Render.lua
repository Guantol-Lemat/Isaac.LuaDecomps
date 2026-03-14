--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local Screen = require("Isaac.Screen")
local VectorUtils = require("General.Math.VectorUtils")
local RoomUtils = require("Game.Room.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local SpriteUtils = require("General.Sprite")
local SpriteRender = require("Isaac.ANM2.Render")
local NetPlayUtils = require("Isaac.NetManager.Utils")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")
local PlayerInventory = require("Mechanics.Player.Inventory")

local VectorZero = VectorUtils.VectorZero
--#endregion

local s_PlayerHologramRNG = RNG(424658093, 31)

---@param player EntityPlayerComponent
---@return {shouldRender: boolean, renderBeforePlayer: boolean, pos: Vector, scale: Vector, rotation:number}
local function get_held_entity_render_data(player)
    local heldEntity = player.m_heldEntity.ref
    local data = {
        shouldRender = heldEntity ~= nil,
        renderBeforePlayer = false,
        pos = Vector(0, 0),
        scale = Vector(1.0, 1.0),
        rotation = 0.0
    }

    if not heldEntity then
        return data
    end

    data.renderBeforePlayer = heldEntity.m_renderZOffset < 0

    local isHoldingEntity = player.m_itemState == CollectibleType.COLLECTIBLE_MOMS_BRACELET or player.m_suplex_state >= SuplexState.AIMING
    if not isHoldingEntity then
        return data
    end

    local nullFrame = SpriteUtils.GetNullFrame(player.m_bodySprite, 0) or
        (player.m_suplex_state >= SuplexState.AIMING and SpriteUtils.GetNullFrame(player.m_sprite, 0))

    if not nullFrame then
        data.shouldRender = false
        return data
    end

    data.pos = nullFrame:GetPos()
    if player.m_suplex_state < SuplexState.AIMING then
        return data
    end

    -- suplex held data
    data.renderBeforePlayer = player.m_suplex_state == SuplexState.DESCENDING
    data.scale = nullFrame:GetScale()
    data.rotation = nullFrame:GetRotation()

    local sprite = heldEntity.m_sprite
    local spriteLayers = sprite:GetAllLayers()
    for i = 1, #spriteLayers, 1 do
        local layer = spriteLayers[i]
        local frame = sprite:GetLayerFrameData(i - 1)

        if not frame then
            goto continue
        end

        --TODO: Some transforms based on the heldEntity animation
        ::continue::
    end

    return data
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param frameScale Vector
---@param framePos Vector
---@param frameRotation number
local function render_held_entity(myContext, player, playerRenderOffset, frameScale, framePos, frameRotation)
    local heldEntity = player.m_heldEntity.ref
    if not heldEntity or heldEntity.m_visible then
        return
    end

    local sprite = heldEntity.m_sprite

    local originalScale = sprite.Scale
    local originalRotation = sprite.Rotation

    sprite.Scale = originalScale * frameScale
    sprite.Rotation = originalRotation + frameRotation

    local renderDistance = IsaacUtils.GetRenderDistance(player.m_position - heldEntity.m_position)
    local renderOffset = framePos + renderDistance + playerRenderOffset

    heldEntity.m_visible = true
    heldEntity:Render(myContext, renderOffset)
    heldEntity.m_visible = false

    sprite.Scale = originalScale
    sprite.Rotation = originalRotation
end

---@param player EntityPlayerComponent
---@param layer integer
---@param offset Vector
local function render_individual_layer(player, layer, offset)
    local costume = player.m_costumeMap[layer + 1]
    local costumeIndex = costume.index

    if costumeIndex >= 0 then
        local costumeSprite = player.m_costumeSpriteDesc[costumeIndex + 1]
        costumeSprite.m_sprite:RenderLayer(costume.layerID, offset, VectorZero, VectorZero)
    else
        player.m_sprite:RenderLayer(layer, offset, VectorZero, VectorZero)
    end
end

---@param player EntityPlayerComponent
---@param position Vector
local function RenderGlow(player, position)
    if not player.m_visible then
        return
    end

    if PlayerUtils.IsFullSpriteRendering(player) then
        return
    end

    local layer = 0
    render_individual_layer(player, layer, position)
end

---@param player EntityPlayerComponent
---@param position Vector
local function RenderHeadBack(player, position)
    if not player.m_visible then
        return
    end

    if PlayerUtils.IsFullSpriteRendering(player) then
        return
    end

    local layer = 14
    render_individual_layer(player, layer, position)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param position Vector
local function RenderHead(myContext, player, position)
    if not player.m_visible then
        return
    end

    if PlayerUtils.IsFullSpriteRendering(player) then
        return
    end

    for layer = 4, 10, 1 do
        render_individual_layer(player, layer, position)
    end

    if PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN, false) then
        player.m_darkPrinceCrown_sprite:Render(position, VectorZero, VectorZero)
    end

    if PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT, false) then
        player.m_crownOfLight_sprite:Render(position, VectorZero, VectorZero)
    end
end

---@param player EntityPlayerComponent
---@param position Vector
local function RenderTop(player, position)
    if not player.m_visible then
        return
    end

    if PlayerUtils.IsFullSpriteRendering(player) then
        return
    end

    local layer = 11
    render_individual_layer(player, layer, position)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param position Vector
local function RenderBody(myContext, player, position)
    if not player.m_visible then
        return
    end

    if PlayerUtils.IsFullSpriteRendering(player) then
        return
    end

    local headOffset = 0.0
    local rendered = false
    for layer = 1, 3, 1 do
        local costume = player.m_costumeMap[layer + 1]
        local costumeIndex = costume.index

        if costumeIndex < 0 then
            player.m_sprite:RenderLayer(layer, position, VectorZero, VectorZero)
            rendered = true
            goto continue
        end

        local costumeSprite = player.m_costumeSpriteDesc[costumeIndex + 1]
        if player.m_canFly == true and not costumeSprite.m_isFlying then
            goto continue -- don't render anything
        end

        local sprite = costumeSprite.m_sprite
        local item = costumeSprite.m_itemConfig
        local id = item.m_id

        if item.m_itemType == ItemType.ITEM_NULL and (NullItemID.ID_JUPITER_BODY <= id and id <= NullItemID.ID_JUPITER_BODY_WHITEPONY) then
            headOffset = math.max(sprite.Scale.Y * -15.0, headOffset)
        elseif ItemConfigUtils.IsCollectible(item) and (id == CollectibleType.COLLECTIBLE_MEGA_MUSH) then
            headOffset = math.max(sprite.Scale.Y * -65.0, headOffset)
        end

        sprite:RenderLayer(costume.layerID, position, VectorZero, VectorZero)
        local frame = sprite:GetLayerFrameData(costume.layerID)
        if frame and frame:IsVisible() then
            rendered = true
        end
        ::continue::
    end

    if rendered and PlayerUtils.IsHeadless(myContext, player) then
        local headRenderPosition = position + IsaacUtils.GetRenderDistance(Vector(0.0, headOffset))
        player.m_bloodGushSprite:RenderLayer(0, headRenderPosition, VectorZero, VectorZero)
    end
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param offset Vector
---@param real boolean
local function render_player_sprite(myContext, player, offset, real)
    local renderMode = RoomUtils.GetRenderMode(myContext.game.m_level.m_room)
    local shouldRenderBackupPlayerReflection = renderMode == RenderMode.RENDER_WATER_REFLECT and
        (player.m_variant == PlayerVariant.PLAYER and not player.m_isCoopGhost) and
        (player.m_playerType == PlayerType.PLAYER_LAZARUS_B or player.m_playerType == PlayerType.PLAYER_LAZARUS2_B) and
        player.m_backupPlayer and player.m_valid

    if shouldRenderBackupPlayerReflection then
        -- TODO
    end

    if player.m_variant == PlayerVariant.CO_OP_BABY or player.m_isCoopGhost then
        -- TODO
    end

    local isHologram = PlayerUtils.IsHologram(player)
    if isHologram then
        -- TODO: Push Color override
    end

    local lilithSpecialRender = player.m_playerType == PlayerType.PLAYER_LILITH_B and PlayerUtils.IsHeldItemVisible(player)
    if lilithSpecialRender then
        -- TODO
    elseif PlayerUtils.IsFullSpriteRendering(player) then
        -- TODO
    else
        local renderPosition = Screen.GetRenderPosition(player.m_position, true)
        local screenPosition = player.m_screenPosition + renderPosition
        player.m_screenPosition = screenPosition
        local headless = PlayerUtils.IsHeadless(myContext, player)

        if not headless then
            RenderGlow(player, screenPosition)
        end

        local renderOutline = real and not isHologram and
            (NetPlayUtils.IsNetPlay(myContext.manager.m_netPlayManager) and PlayerUtils.IsLocalPlayer(myContext, player))

        if renderOutline then
            local outlineColor = Color(0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.0, 0.0, 0.0, 0.0)
            SpriteRender.PushColorOverride(outlineColor)

            for i = 0, 3, 1 do
                local outlineOffset = IsaacUtils.GetAxisAlignedUnitVectorFromDirection(i)
                local outlinePosition = screenPosition + outlineOffset
                if headless then
                    RenderBody(myContext, player, outlinePosition)
                else
                    RenderHeadBack(player, outlinePosition)
                    RenderBody(myContext, player, outlinePosition)
                    RenderHead(myContext, player, outlinePosition)
                end
                RenderTop(player, outlinePosition)
            end

            SpriteRender.PopColorOverride()
        end

        if headless then
            RenderBody(myContext, player, screenPosition)
        else
            RenderHeadBack(player, screenPosition)
            RenderBody(myContext, player, screenPosition)
            RenderHead(myContext, player, screenPosition)
        end
        RenderTop(player, screenPosition)
    end

    if isHologram then
        SpriteRender.PopColorOverride()
    end
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param offset Vector
local function Render(myContext, player, offset)
    local target = player.m_target.ref
    if player.m_variant == 2 and not target then
        return
    end

    if target then
        if not PlayerUtils.IsLocalPlayer(myContext, player) then
            return
        end

        local renderPosition = Screen.GetRenderPosition(player.m_position, true)
        renderPosition = renderPosition + offset
        renderPosition = renderPosition + Vector(0.0, -40.0)

        local color = KColor(1.0, 0.6, 0.6, 1.0)
        local font = myContext.manager.m_entityTextFont
        font:DrawStringScaled("v", renderPosition.X - 50.0, renderPosition.Y, 1.0, 1.0, color, 100, true)
        return
    end

    if not player.m_visible then
        return
    end

    local game = myContext.game
    local damageCooldown = player.m_damageCooldown

    -- Damage Blink
    local shouldBlink = (damageCooldown > 0 and damageCooldown % 6 < 3) and
        PlayerUtils.IsExtraAnimationFinished(player) and
        game.m_challenge ~= Challenge.CHALLENGE_GUARDIAN and (player.m_flags & EntityFlag.FLAG_NO_DAMAGE_BLINK) ~= 0

    if shouldBlink then
        return
    end

    local realOffset = offset
    if (player.m_flags & EntityFlag.FLAG_HELD) ~= 0 then
        realOffset = realOffset + IsaacUtils.GetRenderDistance(player.m_positionOffset)
    end

    if player.m_canFly then
        realOffset = realOffset + PlayerUtils.GetFlyingOffset(myContext, player)
    end

    local heldEntityRenderData = get_held_entity_render_data(player)
    if heldEntityRenderData.shouldRender and heldEntityRenderData.renderBeforePlayer then
        render_held_entity(myContext, player, realOffset, heldEntityRenderData.scale, heldEntityRenderData.pos, heldEntityRenderData.rotation)
    end

    -- TODO: Render after image

    render_player_sprite(myContext, player, realOffset, true)

    if heldEntityRenderData.shouldRender and not heldEntityRenderData.renderBeforePlayer then
        render_held_entity(myContext, player, realOffset, heldEntityRenderData.scale, heldEntityRenderData.pos, heldEntityRenderData.rotation)
    end

    -- TODO: Rest of Render
end

local Module = {}

--#region Module

Module.RenderGlow = RenderGlow
Module.RenderHeadBack = RenderHeadBack
Module.RenderHead = RenderHead
Module.RenderTop = RenderTop
Module.RenderBody = RenderBody
Module.Render = Render

--#endregion

return Module