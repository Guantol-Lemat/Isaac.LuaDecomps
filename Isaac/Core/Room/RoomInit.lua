--#region Dependencies

local Globals = require("Isaac.Global")
local LuaEngine = require("LuaEngine.Misc")

local Enums = require("Isaac.Enums")
local IEntityConfig = require("Isaac.Interface.EntityConfig")
local IRoomConfig = require("Isaac.Interface.RoomConfig")
local IGame = require("Isaac.Interface.Game")
local IRoom = require("Isaac.Interface.Room")
local ICamera = require("Isaac.Interface.Camera")
local IBackdrop = require("Isaac.Interface.Backdrop")
local IRailManager = require("Isaac.Interface.RailManager")
local IHellBackdrop = require("Isaac.Interface.HellBackdrop")
local IItemPool = require("Isaac.Interface.ItemPool")
local IEntity = require("Isaac.Interface.Entity")
local IGridEntity = require("Isaac.Interface.GridEntity")
local ITemporaryEffects = require("Isaac.Interface.TemporaryEffects")
local SpriteUtils = require("General.Sprite")
local Log = require("General.Log")
local IsaacUtils = require("Isaac.Utils.Common")
local AnmCache = require("Isaac.Utils.AnmCache")

local ActorMechanics = require("Isaac.Mechanics.Actor")
local GridEntityMechanics = require("Isaac.Mechanics.GridEntity")
local GameEffects = require("Isaac.Interface.Custom.GameEffects")
local PlayerEffects = require("Isaac.Interface.Custom.PlayerEffects")

local RoomShapeConfig = require("Isaac.Config.RoomShape")

local IEntityPtr = IEntity.EntityPtr
local IRoomConfigSpawn = IRoomConfig.Spawn

--#endregion

local eRoomFlags = Enums.eRoomFlags

local VECTOR_ZERO = Vector(0.0, 0.0)

local function Mechanics_on_room_restore()
    PlayerEffects.WombTeleport_RestoreTeleport()
end

local function Mechanics_on_first_visit()
    PlayerEffects.CardReading_TrySpawnPortals()
    PlayerEffects.Stairway_TrySpawnStairs()
    PlayerEffects.IsaacsTomb_TrySpawnChest()
    GameEffects.GFuel_TrySpawnGFuel()
    PlayerEffects.Luna_TrySpawnLight()
end

local function Mechanics_on_visit()
    PlayerEffects.SanguineBond_TrySpawnSpike()
    GameEffects.ShovelQuest_TrySpawnShadow()
    GameEffects.DevilRoom_Visit()
    GameEffects.TreasureRoom_Visit()
    GameEffects.PlanetariumRoom_Visit()
    GameEffects.DungeonRoom_SetupWalls()
end

local function Mechanics_post_room_init()
    GameEffects.ArcadeRoom_Enter()
    GameEffects.IsaacsRoom_SpawnCarpet()
    GameEffects.DiceRoom_SpawnDiceFloor()

    GameEffects.Room_SpawnRoomGfx()
    GameEffects.Room_TrySpawnLevelExit()
end

local function Mechanics_post_evaluate_auto_clear()
    GameEffects.MinibossRoom_DisplayVsSplashText()
    PlayerEffects.DeathList_PostAutoClear()
end

---@param room Component.Room
local function reset_outputs(room)
    for i = 1, 10, 1 do
        room.m_outputsGrids[i] = {}
        room.m_outputRelatedStruct[i] = {}
    end
end

---@param room Component.Room
local function reset(room)
end

---@param room Component.Room
---@param entityConfigHolder Component.EntityConfig
---@param spawn Component.RoomConfig.Spawn
local function try_set_boss_id(room, entityConfigHolder, spawn)
    local entries = spawn.entries
    local entryIdx = 0
    local highestWeight = 0.0

    for i = 1, #entries, 1 do
        local entry = entries[i]
        if entry.weight > highestWeight then
            entryIdx = i
            highestWeight = entry.weight
        end
    end

    local entry = entries[entryIdx]
    local entityConfig = IEntityConfig.GetEntity(entityConfigHolder, entry.type, entry.variant, entry.subType)

    if not entityConfig then
        return
    end

    local bossId = entityConfig.bossID
    if bossId ~= 0 then -- isBoss
        return
    end

    if room.m_bossId == 0 then -- isFirstBoss
        room.m_bossId = bossId
    elseif bossId ~= room.m_bossId then -- isDifferentBoss
        room.m_secondBossId = bossId
    end
end

---@param room Component.Room
---@param ctx Context.Common
---@param gridIdx integer
---@param saveState Component.GridEntityDesc
local function restore_entity_from_state(room, ctx, gridIdx, saveState)
    if saveState.m_type == GridEntityType.GRID_NULL then
        return
    end

    local gridEntity = GridEntityMechanics.CreateGridEntity(saveState.m_type, gridIdx)
    room.m_gridEntityList[gridIdx + 1] = gridEntity
    IGridEntity.Init_Desc(gridEntity, ctx, saveState)
end

local function init_outputs()
end

local function make_walls()
end

local function init_train_tracks()
end

local function init_rain()
end

---@param room Component.Room
---@param ctx Context.Common
---@param data Component.RoomConfig.Room
---@param desc Component.RoomDescriptor
local function Init(room, ctx, data, desc)
    local manager = ctx.manager
    local game = ctx.game

    ITemporaryEffects.ClearEffects(room.m_temporaryEffects, ctx, false)
    room.m_corpseList = {}
    reset_outputs(room)
    room.m_waterCurrent = Vector(0.0, 0.0)
    room.m_babyPlum_mercyTimer = 0
    room.m_genesisItems_countdown = 0
    room.m_lavaIntensity = 1.0
    room.m_damoclesItems_invalidate = false
    room.m_pickupVision_invalidate = false
    room.m_shouldPreRenderPits = true
    room.m_firstEnemyDead = false
    room.m_pacifist_qqq = false
    IEntityPtr.SetReference(room.m_deathsList_target, nil)
    room.m_deathsList_inactive = false
    room.m_lastDeathsListEnemyPos = Vector(0.0, 0.0)
    room.m_wallBloodDuration = 0
    room.m_wallBloodCount = 0
    room.m_shockwaveRelated = 0
    room.m_slowdownDuration = 0
    room.m_curseOfTower_countdown = 0
    room.field_0x7110 = 0
    room.m_initialFrameCount = game.m_frameCount
    room.m_removedGridEntities = {}
    IEntityConfig.ResetPreloadFlags(manager.m_entityConfig)
    room.m_teleporterRelated = true

    Log.LogMessage(Log.eLogType.INFO, string.format("Room %d.%d(%s)\n", data.m_type, data.m_variant, data.m_name))
    IItemPool.ResetRoomBlacklist(game.m_itemPool)
    reset(room)

    room.m_gridWidth = data.m_width + 2
    room.m_gridHeight = data.m_height + 2

    if not room.m_lightGradientSprite:IsLoaded() then
        local sprite = room.m_lightGradientSprite
        sprite:Load("gfx/LightGradient.anm2", true)
        local layer = sprite:GetLayer(0)
        ---@cast layer LayerState
        SpriteUtils.LayerState_SetMinFilterMode(layer, 1)
        SpriteUtils.LayerState_SetMagFilterMode(layer, 1)
        sprite:Play(sprite:GetDefaultAnimationName(), false)
        SpriteUtils.LayerState_SetBlendMode(layer, BlendMode.NewFromType(BlendType.NORMAL))
    end

    if not room.m_spotlightSprite:IsLoaded() then
        local sprite = room.m_spotlightSprite
        sprite:Load("gfx/SpotLight.anm2", true)
        local layer = sprite:GetLayer(0)
        ---@cast layer LayerState
        SpriteUtils.LayerState_SetMinFilterMode(layer, 1)
        SpriteUtils.LayerState_SetMagFilterMode(layer, 1)
        sprite:Play(sprite:GetDefaultAnimationName(), false)
    end

    local doorsGridIdx = room.m_doorsGridIdx
    for i = 1, DoorSlot.NUM_DOOR_SLOTS, 1 do
        local slot = i - 1
        local gridIdx = IRoom.GetDoorGridIndex(slot, room.m_gridWidth, room.m_gridHeight, desc.m_data.m_shape)
        doorsGridIdx[i] = gridIdx
    end

    room.m_roomDescriptor = desc
    room.m_type = desc.m_data.m_type
    room.m_bossId = 0
    room.m_secondBossId = 0
    IRailManager.Init(room.m_railManager, ctx)
    IHellBackdrop.Init(room.m_hellBackdrop, ctx)

    -- init boss id
    if room.m_type == RoomType.ROOM_BOSS then
        local entityConfigHolder = manager.m_entityConfig
        local spawnData = desc.m_data
        ---@cast spawnData Component.RoomConfig.Room

        local spawns = spawnData.m_spawns
        for i = #spawns, 1, -1 do
            local spawn = spawns[i]
            try_set_boss_id(room, entityConfigHolder, spawn)
        end
    end

    room.m_surpriseMiniboss = desc.m_flags & eRoomFlags.FLAG_SURPRISE_MINIBOSS ~= 0
    GameEffects.Krampusnacht_CommitSurpriseMinibossSpawn(game, room)

    room.m_hasTriggerPressurePlates = false
    IRoom.RecomputeRoomBounds(room, true)

    room.m_shop_level = GameEffects.Shop_GetShopLevel()
    room.m_shop_restockCountdown = -1
    room.m_shop_indexQueue = {}

    local initBlackboard = {
        hasRaglitch = false,
        hasHeretic = false,
    }

    local waterController = {
        hasWater = false,
        disableWater = false,
        flooded = false,
        noWaterAmount = false,
    }

    local spawnSeed = desc.m_spawnSeed
    Log.LogMessage(Log.eLogType.INFO, string.format("SpawnRNG seed: %u\n", spawnSeed))

    -- spawn configure
    do
        local myCtx = {
            waterController = waterController,
            blackboard = initBlackboard
        }

        local spawnRng = RNG(spawnSeed, 11)
        local spawns = data.m_spawns
        for i = 1, #spawns, 1 do
            local spawn = spawns[i]
            local entries = spawn.entries

            local randFloat = spawnRng:RandomFloat()
            if #spawn.entries ~= 0 then
                local entry = IRoomConfigSpawn.PickEntry(spawn, randFloat)
                ActorMechanics.Spawn_ConfigureRoom(myCtx, entry)
            end
        end
    end

    IRoom.LoadBackdropGraphics(room, ctx)

    -- init water
    room.m_waterAmount = GameEffects.Room_GetWaterAmount(game, ctx)
    room.m_waterLerpColorDuration = -1
    room.m_waterLerpColorCountdown = -1

    local isFlooded = GameEffects.Room_IsFlooded(game, ctx)
        or desc.m_flags & eRoomFlags.FLAG_FLOODED ~= 0
        or waterController.flooded

    if isFlooded then
        room.m_waterAmount = 1.0
    end

    local noWaterAmount = GameEffects.Room_NoWaterAmount(game, ctx)
        or (waterController.noWaterAmount and desc.m_flags & eRoomFlags.FLAG_FLOODED == 0)

    if noWaterAmount then
        room.m_waterAmount = 0.0
    end

    if room.m_waterAmount > 0.0 then
        room.m_lavaIntensity = 0.0
    end

    -- configure descriptor
    if desc.m_visitedCount == 0 then -- is first visit
        room.m_isFirstVisit = true
        local decorationRng = RNG(desc.m_decorationSeed, 35)

        local backdropConfig = room.m_backdrop.m_entries[room.m_backdrop.m_type + 1]
        local hasWater = (GameEffects.Room_HasWater() and manager.m_options.m_waterSurface_enabled == false)
            or backdropConfig.m_waterPitsMode == 2
            or (backdropConfig.m_waterPitsMode == 1 and decorationRng:RandomInt(2) == 0)

        if hasWater then
            desc.m_flags = desc.m_flags | eRoomFlags.FLAG_HAS_WATER
        else
            desc.m_flags = desc.m_flags & ~eRoomFlags.FLAG_HAS_WATER
        end

        local altBossMusic = decorationRng:RandomInt(2) == 0
        if altBossMusic then
            desc.m_flags = desc.m_flags | eRoomFlags.FLAG_ALT_BOSS_MUSIC
        else
            desc.m_flags = desc.m_flags & ~eRoomFlags.FLAG_ALT_BOSS_MUSIC
        end

        GameEffects.Achievement_TryUnlockSchoolBag()
        GameEffects.Room_ConfigureDescriptor()

        if waterController.hasWater then
            desc.m_flags = desc.m_flags | eRoomFlags.FLAG_HAS_WATER
        end

        if waterController.disableWater then
            desc.m_flags = desc.m_flags & ~eRoomFlags.FLAG_HAS_WATER
        end
    end

    -- init grid
    for i = 1, #room.m_gridPaths, 1 do
        room.m_gridPaths[i] = 0
    end

    room.m_clearDelay = 0
    desc.m_pitsCount = 0
    desc.m_poopCount = 0

    local gridEntities = room.m_gridEntityList
    local savedGridEntities = desc.m_gridEntitySaveStates

    -- restore grid entities
    for i = 1, room.m_gridWidth * room.m_gridHeight, 1 do
        local gridSaveState = savedGridEntities[i]
        if not gridSaveState then
            goto continue
        end

        local gridEntity = gridEntities[i]
        if gridEntity then
            gridEntities[i] = nil -- Free
        end

        restore_entity_from_state(room, ctx, i - 1, gridSaveState)
        if gridSaveState.m_type == GridEntityType.GRID_PIT then
            desc.m_pitsCount = desc.m_pitsCount + 1
        elseif gridSaveState.m_type == GridEntityType.GRID_POOP then
            desc.m_poopCount = desc.m_poopCount + 1
        end
        ::continue::
    end

    GameEffects.Corpse_NoWater()
    GameEffects.TintedRock_Initialize()

    -- spawn entities
    local spawnRng = RNG(spawnSeed, 11)
    local spawns = data.m_spawns
    local restrictedIdx = desc.m_restrictedGridIndexes

    for i = 1, #spawns, 1 do
        local spawn = spawns[i]
        local randFloat = spawnRng:RandomFloat()
        if #spawn.entries == 0 then
            goto continue
        end

        local spawnGridIdx = IRoom.GetGridIndexByTile(room, spawn.x + 1, spawn.y + 1)
        local entry = IRoomConfigSpawn.PickEntry(spawn, randFloat)
        if restrictedIdx[spawnGridIdx] ~= nil then -- gridIdx restricted
            goto continue
        end

        IRoom.spawn_entity(room, ctx, spawnGridIdx, entry, spawnRng:GetSeed(), nil, false)
        ::continue::
    end

    GameEffects.Treasure_ApplyCollectibleModifiers()

    init_outputs(room, ctx)

    -- init doors
    for i = 1, DoorSlot.NUM_DOOR_SLOTS, 1 do
        if desc.m_doors[i] ~= 0 then -- door exists
            IRoom.make_door(room, ctx, i - 1)
        end
    end

    IRoom.TrySpawnMegaSatanRoomDoor(room, ctx, false)
    IRoom.TrySpawnSpecialQuestDoor(room, ctx)
    GameEffects.Backasswards_SpawnMegaSatanReturnDoor()

    make_walls(room, ctx)

    GameEffects.DungeonRock_Initialize()
    GameEffects.Dungeon_ApplyModifiers()

    -- spawn decorations
    local hasDecorations = GameEffects.Room_HasDecorations()
        or room.m_backdrop.m_entries[room.m_backdrop.m_type].m_gfx_props ~= 0 -- backdrop has props

    if hasDecorations then
        local decorationRng = RNG((desc.m_decorationSeed & 0x7fffffff) + desc.m_gridIdx)

        local decorationCount = decorationRng:RandomInt(4) + decorationRng:RandomInt(5)
        if data.m_width > 13 or data.m_height > 7 then -- is medium room
            decorationCount = decorationCount + decorationRng:RandomInt(9)
        end
        if data.m_width > 13 and data.m_height > 7 then -- big room
            decorationCount = decorationCount + decorationRng:RandomInt(18)
        end
        decorationCount = decorationCount * 2

        for i = 1, decorationCount, 1 do
            local gridIdx = IRoom.GetRandomTileIndex(room, decorationRng:Next())
            if gridEntities[gridIdx + 1] ~= nil then -- gridIdx occupied
                goto continue
            end

            IRoom.SpawnGridEntity(room, ctx, gridIdx, GridEntityType.GRID_DECORATION, 0, IsaacUtils.Random(), 0)
            ::continue::
        end
    end

    GameEffects.Greed_SpawnGreedDecorations()

    -- Post Init grid entities
    for i = 1, room.m_gridWidth * room.m_gridHeight, 1 do
        local gridEntity = gridEntities[i]
        if gridEntity ~= nil then
            gridEntity:PostInit(ctx)
        end
    end

    init_train_tracks(room, ctx)

    ActorMechanics.FirePlace_SpecialInit(room, initBlackboard)

    -- restore entities
    IRoom.RestoreState(room, ctx)

    local savedEffects = desc.m_savedEffects
    for i = 1, #savedEffects, 1 do
        ---@type Component.SavedEffect
        ---@diagnostic disable-next-line: assign-type-mismatch
        local savedEffect = savedEffects[i]
        local effect = IGame.Spawn(
            ctx, game,
            savedEffect.m_type, savedEffect.m_variant,
            savedEffect.m_position, VECTOR_ZERO, nil,
            savedEffect.m_subtype, savedEffect.m_initSeed
        )

        local scale = savedEffect.m_intStorage1.effect_scale
        effect.m_sprite.Scale = Vector(scale, scale)
        effect:Update(ctx)
    end

    Mechanics_on_room_restore()

    if room.m_isFirstVisit then
        Mechanics_on_first_visit()
    end

    Mechanics_on_visit()

    if GameEffects.Room_HasNoExits() then
        for i = 1, DoorSlot.NUM_DOOR_SLOTS, 1 do
            local slot = i - 1
            IRoom.RemoveDoor(room, ctx, slot)
        end
    end

    room.m_brokenWatch_state = 0
    room.m_isInitialized = true

    Mechanics_post_room_init()

    desc.m_visitedCount = desc.m_visitedCount + 1
    if desc.m_visitedCount == 1 then -- is first visit
        local scoreSheet = game.m_scoreSheet
        local scoreVisitCount = RoomShapeConfig.GetScoreSheetVisitCount(desc.m_data.m_shape)
        scoreSheet.m_visitedRoomCount[room.m_type + 1] = scoreSheet.m_visitedRoomCount[room.m_type + 1] + scoreVisitCount
    end

    GameEffects.BurningBasement_SpawnInitEmbers() -- has no reason to be here an not in post_room_init

    -- auto clear
    local shouldAutoClear = IRoom.GetAliveEnemiesCount(room) <= 0
        and desc.m_flags & eRoomFlags.FLAG_CLEAR == 0
        and room.m_clearDelay == 0

    if shouldAutoClear then
        desc.m_flags = desc.m_flags | eRoomFlags.FLAG_CLEAR
    end

    Mechanics_post_evaluate_auto_clear()

    room.m_redHeartDamage = false
    init_rain(room, ctx)

    GameEffects.Room_SetRoomColor()
    GameEffects.Ashpit_InitFxRays()
    ActorMechanics.Rotgut_TryDisableBossTransition()

    IRoom.ProcessColorModifier(room, ctx)

    GameEffects.AbandonedMineshaft_SetRoomColor()
    GameEffects.SuperSecretRoom_SetRoomColor()

    IRoom.RecomputeRoomBounds(room, false)
    room.m_camera = ICamera.New(ctx, room)
    room.m_shockwaveParams[1].m_durationOnRoomInit_qqq = room.m_shockwaveParams[1].m_duration_qqq
    room.m_shockwaveParams[2].m_durationOnRoomInit_qqq = room.m_shockwaveParams[2].m_duration_qqq
    IBackdrop.LoadGraphics(room.m_backdrop, ctx)

    AnmCache.FreeUnreferencedImages()
    LuaEngine.PostRoomInit(Globals.LuaEngine)
    ActorMechanics.UltraGreed_PostRoomInitTurnGold()
end

---@class Gameplay.Room.Init
local Module = {}

--#region Module

Module.Init = Init

--#endregion

return Module