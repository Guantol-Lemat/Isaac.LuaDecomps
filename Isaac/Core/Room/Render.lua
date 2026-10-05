--#region Dependencies

local Engine = require("Engine.Global")
local G = require("Isaac.Global")
local C = require("Isaac.Constants")
local S = require("Isaac.Core.Room.Static")

local MathUtils = require("General.Math")
local IsaacUtils = require("Isaac.Utils.Common")
local IBlendMode = require("Engine.Interface.BlendMode")
local ISprite = require("Isaac.Interface.ANM2")
local IBackdrop = require("Isaac.Interface.Backdrop")
local ColorUtils = require("General.VanillaAPI.Color")
local IEntityList = require("Isaac.Interface.EntityList")
local IFXLayers = require("Isaac.Interface.FXLayers")
local IGame = require("Isaac.Interface.Game")
local IGridEntityRock = require("Isaac.Interface.GridEntity_Rock")
local IHellBackdrop = require("Isaac.Interface.HellBackdrop")
local ILevel = require("Isaac.Interface.Level")
local IRailManager = require("Isaac.Interface.RailManager")
local IRoom = require("Isaac.Interface.Room")
local IRoomConfig = require("Isaac.Interface.RoomConfig")

local GridEntityProperties = require("Isaac.Content.Grid.Properties")
local RoomProperties = require("Isaac.Content.RoomMechanics.Properties")
local GreedShopBackdrop = require("Isaac.Content.RoomMechanics.Backdrop.GreedShop")
local NightLight = require("Isaac.Content.PlayerEffects.NightLight")
local WaterOverlayGfx = require("Isaac.Content.RoomMechanics.Gfx.WaterOverlay")
local HeatWaveGfx = require("Isaac.Content.RoomMechanics.Gfx.HeatWave")
local ShockwaveGfx = require("Isaac.Content.RoomMechanics.Gfx.Shockwave")
local DizzyGfx = require("Isaac.Content.RoomMechanics.Gfx.Dizzy")
local DustOverlayGfx = require("Isaac.Content.RoomMechanics.Gfx.DustOverlay")
local MirrorGfx = require("Isaac.Content.RoomMechanics.Gfx.Mirror")

local eShaderType = Renderer.ShaderType

--#endregion

local COLOR_BLACK = C.COLOR_BLACK
local COLOR_SHADOW_SURFACE = KColor(1.0, 1.0, 1.0, 0.24)
local COLOR_ROOM_INFO = KColor(1.0, 1.0, 1.0, 128/255)

---@param room Component.Room
---@param filter function
local function render_grids(room, filter)
    local gridSize = room.m_gridWidth * room.m_gridHeight
    for i = 1, gridSize, 1 do
        local idx = i - 1
        local gridEntity = IRoom.GetGridEntity(room, idx)
        if gridEntity and filter(gridEntity) then
            gridEntity:BeginBatches()
            gridEntity:Render(room.m_renderScrollOffset)
        end
    end

    for i = 1, gridSize, 1 do
        local idx = i - 1
        local gridEntity = IRoom.GetGridEntity(room, idx)
        if gridEntity and filter(gridEntity) then
            gridEntity:EndBatches()
        end
    end
end

local ROOM_TYPE_NAME = {
    [RoomType.ROOM_NULL + 1] = "Null",
    [RoomType.ROOM_DEFAULT + 1] = "Default",
    [RoomType.ROOM_SHOP + 1] = "Shop",
    [RoomType.ROOM_ERROR + 1] = "Error",
    [RoomType.ROOM_TREASURE + 1] = "Treasure",
    [RoomType.ROOM_BOSS + 1] = "Boss",
    [RoomType.ROOM_MINIBOSS + 1] = "Miniboss",
    [RoomType.ROOM_SECRET + 1] = "Secret",
    [RoomType.ROOM_SUPERSECRET + 1] = "SSecret",
    [RoomType.ROOM_ARCADE + 1] = "Arcade",
    [RoomType.ROOM_CURSE + 1] = "Curse",
    [RoomType.ROOM_CHALLENGE + 1] = "Ambush",
    [RoomType.ROOM_LIBRARY + 1] = "Library",
    [RoomType.ROOM_SACRIFICE + 1] = "Sacrifice",
    [RoomType.ROOM_DEVIL + 1] = "Devil",
    [RoomType.ROOM_ANGEL + 1] = "Angel",
    [RoomType.ROOM_DUNGEON + 1] = "Dungeon",
    [RoomType.ROOM_BOSSRUSH + 1] = "Bossrush",
    [RoomType.ROOM_ISAACS + 1] = "Isaac",
    [RoomType.ROOM_BARREN + 1] = "Barren",
    [RoomType.ROOM_CHEST + 1] = "Chest",
    [RoomType.ROOM_DICE + 1] = "Dice",
    [RoomType.ROOM_BLACK_MARKET + 1] = "Market",
    [RoomType.ROOM_GREED_EXIT + 1] = "Exit",
    [RoomType.ROOM_PLANETARIUM + 1] = "Planetarium",
    [RoomType.ROOM_TELEPORTER + 1] = "TeleEntrance",
    [RoomType.ROOM_TELEPORTER_EXIT + 1] = "TeleExit",
    [RoomType.ROOM_SECRET_EXIT + 1] = "SecretExit",
    [RoomType.ROOM_BLUE + 1] = "Blue",
    [RoomType.ROOM_ULTRASECRET + 1] = "USecret",
}

---@param room Component.Room
---@param roomTopLeftPosition Vector
local function render_background_layer(room, roomTopLeftPosition)
    IBackdrop.RenderFloor(room.m_backdrop, roomTopLeftPosition, room.m_floorColor)
    if room.m_backdrop.hasFloor2 then
        IBackdrop.RenderFloor2(room.m_backdrop, roomTopLeftPosition, room.m_floorColor)
    end

    IFXLayers.RenderVeins(room.m_fxLayers)
    render_grids(room, GridEntityProperties.IsBackgroundLayer)
    IEntityList.RenderSlice(room.m_entityList, 5000, room.m_renderScrollOffset)

    if room.m_backdrop.m_type == BackdropType.DUNGEON_BEAST then
        IHellBackdrop.RenderLayer(room.m_hellBackdrop, 1)
    end
end

---@param room Component.Room
---@param roomTopLeftPosition Vector
local function render_ground_layer(room, roomTopLeftPosition)
    local railManager = room.m_railManager
    ISprite.BeginBatches(railManager.m_sprite)
    IRailManager.RenderGroundRails(railManager, room.m_renderScrollOffset)
    ISprite.EndBatches(railManager.m_sprite)

    render_grids(room, GridEntityProperties.IsGroundLayer)

    if room.m_backdrop.m_type == BackdropType.MINES and (room.m_roomDescriptor.m_flags & RoomDescriptor.FLAG_HAS_WATER) ~= 0 then
        IRoom.render_pit_surface(room, roomTopLeftPosition)

        local gridSize = room.m_gridWidth * room.m_gridHeight
        for i = 1, gridSize, 1 do
            local idx = i - 1
            local gridEntity = IRoom.GetGridEntity(room, idx)
            if not (gridEntity and gridEntity.m_desc.m_type == GridEntityType.GRID_PIT) then
                return
            end

            local layer = ISprite.GetLayer_Idx(gridEntity.m_sprite, 0)
            ---@cast layer Component.Sprite.LayerState
            layer.m_isVisible = false
            gridEntity:Render(room.m_renderScrollOffset)
            layer.m_isVisible = true
        end
    end

    ISprite.BeginBatches(railManager.m_sprite)
    IRailManager.RenderPitRails(railManager, room.m_renderScrollOffset)
    ISprite.EndBatches(railManager.m_sprite)
end

---@param room Component.Room
local function render_normal_layer(room)
    render_grids(room, GridEntityProperties.IsNormalLayer)

    local gridWidth = room.m_gridWidth
    for i = 1, room.m_gridHeight, 1 do
        local y = i - 1
        local gridRow = IRoom.GetGridIndexByTile(room, 0, y) // gridWidth
        local rowZOffset = ((gridRow * 40.0 + 120.0 + 20.0) * 100.0 + 10030.0 + 0.5)
        rowZOffset = math.max(math.floor(rowZOffset), 10000)
        IEntityList.RenderSlice(room.m_entityList, rowZOffset, room.m_renderScrollOffset)

        for j = 1, gridWidth, 1 do
            local x = j - 1
            local gridEntity = IRoom.GetGridEntityByXY(room, x, y)
            if not gridEntity and not GridEntityProperties.HasTop(gridEntity) then
                goto continue
            end

            gridEntity:BeginBatches()
            ---@cast gridEntity Component.GridEntity.Rock
            IGridEntityRock.RenderTop(gridEntity, room.m_renderScrollOffset)
            ::continue::
        end
    end

    IEntityList.RenderSlice(room.m_entityList, 10000 + 5000, room.m_renderScrollOffset)

    local gridSize = room.m_gridWidth * room.m_gridHeight
    for i = 1, gridSize, 1 do
        local idx = i - 1
        local gridEntity = IRoom.GetGridEntity(room, idx)
        if not gridEntity or not GridEntityProperties.HasTop(gridEntity) then
            return
        end

        gridEntity:EndBatches()
    end
end

---@param room Component.Room
local function render_lighting(room)
    local graphics = Engine.GraphicsManager
    local game = G.Game

    local amount = IRoom.GetLightingAlpha(room)
    local lightingStrength = MathUtils.Clamp(game.m_lightning_strength, 0.0, 1.0)

    amount = amount - lightingStrength * 0.2
    if amount <= 0.0 then
        return
    end

    local surface = S.LightOverlaySurface
    local restoreBlend = graphics:GetBlendMode()
    graphics:SetBlendMode(IBlendMode.New(BlendFactor.DST_COLOR, BlendFactor.ONE_MINUS_SRC_ALPHA, BlendFactor.DST_ALPHA, BlendFactor.ONE_MINUS_SRC_ALPHA))

    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local color = KColor(1.0, 1.0, 1.0, amount)
    local buffer = surface:Render_DestQuadFlatColor(dest, color)
    ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, buffer, surface)

    if game.m_lightning_strength > 0.0 then
        local fxLayersAmount = MathUtils.Clamp(game.m_lightning_strength, 0.0, 0.5)
        graphics:SetBlendMode_Type(BlendType.ADDITIVE)
        local fxLayersColor = KColor(fxLayersAmount * 0.85, fxLayersAmount * 0.9, fxLayersAmount, fxLayersAmount)
        IFXLayers.RenderLighting(room.m_fxLayers, fxLayersColor)
    end

    graphics:SetBlendMode(restoreBlend)
end

---@param room Component.Room
local function render_debug_room_info(room)
    local manager = G.Manager
    local game = G.Game
    local stageName = IRoomConfig.GetStageName(game.m_roomConfig, room.m_roomDescriptor.m_data.m_stageId, 0)

    local roomDescriptor = room.m_roomDescriptor
    local roomData = roomDescriptor.m_data
    ---@cast roomData Component.RoomConfig.Room
    local str = string.format("%s %s %d %s (group %d)", stageName, ROOM_TYPE_NAME[room.m_type], roomData.m_variant, roomData.m_name, roomDescriptor.m_group)

    local font = manager.m_font_2
    local stringWidth = font:GetStringWidth(str)
    font:DrawStringScaled(str, G.WIDTH * 0.5 - stringWidth, G.HEIGHT - 12.0, 1.0, 1.0, COLOR_ROOM_INFO, 0, false)
end

---@param room Component.Room
local function Render(room)
    IsaacUtils.SetSpritePixelationAmount(IGame.GetPixelationRenderAmount())
    local isGlitchRendering = RoomProperties.IsGlitchRendering(room)
    if isGlitchRendering then
        ISprite.EnableGlitchRendering()
    end

    local graphics = Engine.GraphicsManager
    local manager = G.Manager
    local game = G.Game

    local useWaterOverlayGraphics = false
    local useHeatWaveGraphics = false
    local renderHellBackdrop = room.m_backdrop.m_type == BackdropType.DUNGEON_BEAST

    if WaterOverlayGfx.UseGraphics(room) then
        useWaterOverlayGraphics = true
    elseif HeatWaveGfx.UseGraphics(room) then
        useHeatWaveGraphics = true
    end

    local renderFloorColor = true
    local useMirroredGraphics = IRoom.UseMirroredGraphics()
    if useMirroredGraphics then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.MirrorSurface, true)
        graphics:Clear()
        graphics:SetBlendMode_Type(BlendType.NORMAL)
        renderFloorColor = false
    end

    if DizzyGfx.UseGraphics(game) then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.DizzyOverlaySurface, true)
        graphics:Clear()
        graphics:SetBlendMode_Type(BlendType.NORMAL)
        renderFloorColor = false
    end

    if ShockwaveGfx.UseGraphics(room) then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.ShockwaveSurface, true)
        graphics:Clear()
        graphics:SetBlendMode_Type(BlendType.NORMAL)
        renderFloorColor = false
    end

    if useWaterOverlayGraphics then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.WaterOverlaySurface, true)
        graphics:Clear()
        graphics:SetBlendMode_Type(BlendType.NORMAL)
        renderFloorColor = false
    end

    if useHeatWaveGraphics then
        IsaacUtils.PushRenderTarget()
        graphics:SetRenderTargetTexture(S.HeatWaveSurface, true)
        graphics:Clear()
        graphics:SetBlendMode_Type(BlendType.NORMAL)
        renderFloorColor = false
    end

    if renderHellBackdrop then
        IHellBackdrop.RenderLayer(room.m_hellBackdrop, 0)
    end

    graphics:SetBlendMode_Type(BlendType.NORMAL)

    IFXLayers.RenderBehind(room.m_fxLayers)

    if renderFloorColor then
        if room.m_backdrop.m_type == BackdropType.GREED_SHOP then
            GreedShopBackdrop.RenderFloorColor(room)
        else
            -- render floor color
            local topLeft = game.m_screenShake_offset + room.m_renderSurfaceTopLeft + room.m_renderScrollOffset + 52.0
            local bottomRight = (Vector(room.m_gridWidth, room.m_gridHeight) - 2.0) * 26.0
            local dest = DestinationQuad.NewFromBounds(topLeft, bottomRight)
            local color = ColorUtils.ApplyColorMod(COLOR_BLACK, room.m_floorColor)
            if not ColorUtils.KColor_Equals(color, COLOR_BLACK) then
                Engine.ShapeRenderer:FillQuad(dest, color)
            end
        end
    end

    if not G.Manager.m_options.m_shockwave_enabled and ShockwaveGfx.IsActive(room) then
        ShockwaveGfx.RenderDisabled(room)
    end

    local originalBlendMode = graphics:GetBlendMode()
    local useWaterSurface = room.m_waterAmount > 0.0 and manager.m_options.m_waterSurface_enabled

    local roomTopLeftPosition = room.m_renderSurfaceTopLeft + game.m_screenShake_offset + room.m_renderScrollOffset
    -- render background layer
    if useWaterSurface then
        IRoom.render_water_surface(room, roomTopLeftPosition)
        IEntityList.RenderStart(room.m_entityList, RenderMode.RENDER_WATER_ABOVE)
        IEntityList.RenderSlice(room.m_entityList, 5000, room.m_renderScrollOffset)
    else
        IEntityList.RenderStart(room.m_entityList, RenderMode.RENDER_NORMAL)
        if IRoom.IsDungeon(room) then
            render_grids(room, function() return true end)
        else
            render_background_layer(room, roomTopLeftPosition)
        end
    end

    if not IRoom.IsDungeon(room) then
        IBackdrop.RenderWalls(room.m_backdrop, roomTopLeftPosition, room.m_wallColor)

        local shouldRenderCaustics = manager.m_options.m_caustics_enabled
            and (game.m_darknessModifier <= 0.0 and (ILevel.GetCurses(game.m_level) & LevelCurse.CURSE_OF_DARKNESS == 0))

        if shouldRenderCaustics then
            graphics:SetBlendMode_Type(BlendType.ADDITIVE)
            IRoom.render_caustics(room, false)
            graphics:SetBlendMode(originalBlendMode)
        end

        if not useWaterSurface then
            render_ground_layer(room, roomTopLeftPosition)
        end
    end

    IEntityList.RenderSlice(room.m_entityList, 10000, room.m_renderScrollOffset)

    if useHeatWaveGraphics then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        HeatWaveGfx.Render(graphics, room, S.HeatWaveSurface)
    end

    if renderHellBackdrop then
        IHellBackdrop.RenderLayer(room.m_hellBackdrop, 2)
    end

    if not IRoom.IsDungeon(room) then
        render_grids(room, GridEntityProperties.IsDoorLayer)

        if S.ShadingSurface then
            S.ShadingSurface:Render_PositionFlatColor(roomTopLeftPosition, C.COLOR_WHITE)
        end

        IsaacUtils.PushShader(eShaderType.SHADER_COLOR_OFFSET)
        local buffer = S.ShadowSurface:Render_PositionFlatColor(C.VECTOR_ZERO, COLOR_SHADOW_SURFACE)
        ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, buffer, S.ShadowSurface)
        IsaacUtils.PopShader()
    end

    IFXLayers.RenderBackground(room.m_fxLayers)

    if useWaterOverlayGraphics then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        WaterOverlayGfx.Render(graphics, room, S.WaterOverlaySurface)
    end

    room.m_lightGradientSprite.Color:Reset()
    room.m_entityLightRelated = {}

    for i = 1, #room.m_entityList.m_roomEL, 1 do
        IRoom.render_entity_glow(room, room.m_entityList.m_roomEL[i], room.m_renderScrollOffset)
    end

    if not IRoom.IsDungeon(room) then
        render_normal_layer(room)
    end

    if useWaterSurface then
        room.m_entityList.m_renderMode = RenderMode.RENDER_NORMAL
    end

    IEntityList.RenderEnd(room.m_entityList, room.m_renderScrollOffset, true)

    local possessors = game.m_playerManager.m_possessors
    for i = 1, #possessors, 1 do
        possessors[i]:Render(room.m_renderScrollOffset)
    end

    NightLight.RenderNightLightLayer(game)

    if game.m_debugFlags & DebugFlag.GRID ~= 0 then
        IRoom.RenderDebugInformation(room, room.m_renderScrollOffset)
    end

    if game.m_debugFlags & DebugFlag.GRID_INFO ~= 0 then
        IRoom.RenderDebugGridInfo(room, room.m_renderScrollOffset)
    end

    IsaacUtils.LoadShader(eShaderType.SHADER_COLOR_OFFSET)

    if manager.m_options.m_lighting_enabled then
        render_lighting(room)
    end

    if renderHellBackdrop then
        IHellBackdrop.RenderLayer(room.m_hellBackdrop, 3)
    end

    IFXLayers.RenderForeground(room.m_fxLayers)

    if DustOverlayGfx.UseGraphics() then
        DustOverlayGfx.Render(graphics, room, S.DustOverlaySurface)
    end

    if ShockwaveGfx.UseGraphics(room) then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        ShockwaveGfx.Render(graphics, room, S.ShockwaveSurface)
    end

    if isGlitchRendering then
        ISprite.DisableGlitchRendering()
    end

    IFXLayers.RenderOverlay(room.m_fxLayers)

    if DizzyGfx.UseGraphics(game) then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        DizzyGfx.Render(graphics, room, S.DizzyOverlaySurface)
    end

    if useMirroredGraphics then
        graphics:Present()
        IsaacUtils.PopRenderTarget()
        MirrorGfx.Render(graphics, room, S.MirrorSurface)
    end

    IsaacUtils.SetSpritePixelationAmount(0.0)

    if game.m_debugFlags & DebugFlag.ROOM_INFO ~= 0 then
        render_debug_room_info(room)
    end
end

---@class Room.Render
local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module