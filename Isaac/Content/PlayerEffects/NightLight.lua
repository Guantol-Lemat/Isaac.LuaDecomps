--#region Dependencies

local C = require("Isaac.Constants")

local IsaacUtils = require("Isaac.Utils.Common")
local ISprite = require("Isaac.Interface.ANM2")
local ILayerState = ISprite.LayerState
local IEntityPlayer = require("Isaac.Interface.Entity_Player")

--#endregion

local COLOR_NIGHT_LIGHT = Color(1.0, 1.0, 1.0, 0.2)

---@param game Component.Game
local function RenderNightLightLayer(game)
    local players = game.m_playerManager.m_players
    local room = game.m_level.m_room
    for i = 1, #players, 1 do
        local player = players[i]
        if IEntityPlayer.HasCollectible(player, CollectibleType.COLLECTIBLE_NIGHT_LIGHT, false) then
            local spotlightSprite = room.m_spotlightSprite
            spotlightSprite.m_rotation = player.m_smoothBodyRotation - 90.0
            ISprite.SetColor(spotlightSprite, COLOR_NIGHT_LIGHT)

            local blendMode = BlendMode.NewFromType(BlendType.ADDITIVE)
            local layer = ISprite.GetLayer_Idx(spotlightSprite, 0)
            ---@cast layer Component.Sprite.LayerState
            ILayerState.SetBlendMode(layer, blendMode)

            local position = (IsaacUtils.GetRenderPosition(player.m_position, true) + room.m_renderScrollOffset)
            ISprite.Render(spotlightSprite, position, C.VECTOR_ZERO, C.VECTOR_ZERO)
        end
    end
end

---@class Content.Player.NightLight
local Module = {}

--#region Module

Module.RenderNightLightLayer = RenderNightLightLayer

--#endregion

return Module