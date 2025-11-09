--#region Dependencies

local GameRules = require("Game.Rules")
local LevelUtils = require("Level.Utils")
local LevelRules = require("Level.Rules")
local MirrorDimensionRules = require("Level.Dimension.Mirror.Rules")
local MineshaftDimensionRules = require("Level.Dimension.Mineshaft.Rules")
local PlayerManagerUtils = require("PlayerManager.Utils")
local PlayerManagerRules = require("PlayerManager.Rules")
local PlayerRules = require("Entity.Player.Rules")
local PersistentDataRules = require("PersistentData.Rules")
local RoomDescriptorUtils = require("Room.RoomDescriptor.Utils")
local RoomConfigUtils = require("Config.Room.Utils")
local RoomConfigRules = require("Config.Room.Rules")

--#endregion

---@class DungeonRoomPlacementLogic
local Module = {}

---@class DungeonRoomPlacementLogic.Context
---@field GetRandomRoomContext RoomConfigRules.GetRandomRoomContext
---@field stageID StbType | integer
---@field superSecretRoomCount integer
---@field treasureRoomCount integer
---@field planetariunChance number
---@field curseRoomCount integer
---@field superMinibossChance integer
---@field secretRoomCount integer
---@field greedSurpriseChance number
---@field curseOfLabyrinth boolean
---@field forcedMegaSatan boolean
---@field isDarkRoom boolean
---@field isChest boolean
---@field hasMirrorDimension boolean
---@field hasAbandonedMineshaft boolean
---@field hasPhotoDoor boolean
---@field hasMotherBossFight boolean
---@field hasForgottenGrave boolean
---@field forgottenUnlocked boolean
---@field cainBirthright boolean
---@field superSecretAllowed boolean
---@field shopAllowed boolean
---@field shopLvl1 boolean
---@field shopLvl2 boolean
---@field shopLvl3 boolean
---@field shopLvl4 boolean
---@field treasureAllowed boolean
---@field obligatoryTreasureRoom boolean
---@field planetariumAllowed boolean
---@field planetariumUnlocked boolean
---@field diceAllowed boolean
---@field diceRecoveryCondition boolean
---@field sacrificeAllowed boolean
---@field sacrificeRecoveryCondition boolean
---@field libraryAllowed boolean
---@field libraryRecoveryCondition boolean
---@field curseAllowed boolean
---@field minibossAllowed boolean
---@field minibossRecoveryCondition boolean
---@field minibossUltraPrideAllowed boolean
---@field challengeAllowed boolean
---@field challengeRecoveryCondition boolean
---@field challengeNecessaryCondition boolean
---@field chestAllowed boolean
---@field chestRecoveryCondition boolean
---@field chestNecessaryCondition boolean
---@field arcadeAllowed boolean
---@field arcadeNecessaryCondition boolean
---@field isaacsAllowed boolean
---@field isaacsNecessaryCondition boolean
---@field barrenAllowed boolean
---@field secretAllowed boolean
---@field ultraSecretAllowed boolean
---@field onForgottenQuest boolean
---@field canSurpriseSecret boolean
---@field canSurpriseShop boolean

---@param context Context
---@param level LevelComponent
---@param getRandomRoomContext RoomConfigRules.GetRandomRoomContext
local function init_dungeon_room_placement_context(context, level, getRandomRoomContext)
    ---@type DungeonRoomPlacementLogic.Context
    ---@diagnostic disable-next-line: missing-fields
    local placementContext = {}
    placementContext.GetRandomRoomContext = getRandomRoomContext

    local game = context:GetGame()
    local playerManager = context:GetPlayerManager()
    local persistentGameData = context:GetPersistentGameData()

    local challengeParams = GameRules.GetChallengeParams(context, game)
    local roomSet = challengeParams.m_roomSet
    local gameStateFlags = game.m_gameStateFlags
    local stage = level.m_stage
    local stageType = level.m_stageType

    local preChapter4 = stage < LevelStage.STAGE4_1
    local preChapter6 = stage < LevelStage.STAGE6
    local isAltPath = stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
    local effectiveStage = isAltPath and stage + 1 or stage
    local curseOfLabyrinth = (LevelRules.GetCurses(context, level) & LevelCurse.CURSE_OF_LABYRINTH) ~= 0
    local gameStateFlags = game.m_gameStateFlags

    placementContext.isDarkRoom = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_ORIGINAL
    placementContext.isChest = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_WOTL
    placementContext.curseOfLabyrinth = curseOfLabyrinth
    placementContext.forcedMegaSatan = challengeParams.m_isMegaSatan and stage == LevelStage.STAGE6
    placementContext.hasMirrorDimension = MirrorDimensionRules.LevelHasMirrorDimension(context, game, level)
    placementContext.hasAbandonedMineshaft = MineshaftDimensionRules.LevelHasAbandonedMineshaft(context, level) and PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)
    placementContext.hasPhotoDoor = LevelRules.HasPhotoDoor(context, level) and PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.STRANGE_DOOR)
    placementContext.hasMotherBossFight = (stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_1 and curseOfLabyrinth)) and isAltPath
    placementContext.hasForgottenGrave = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_ORIGINAL
    placementContext.forgottenUnlocked = PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.FORGOTTEN)
    placementContext.onForgottenQuest = PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1)
    placementContext.shopLvl1 = PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.STORE_UPGRADE_LV1)
    placementContext.shopLvl2 = PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.STORE_UPGRADE_LV2)
    placementContext.shopLvl3 = PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.STORE_UPGRADE_LV3)
    placementContext.shopLvl4 = PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.STORE_UPGRADE_LV4)
    placementContext.canSurpriseSecret = stage >= LevelStage.STAGE3_1
    placementContext.canSurpriseShop = stage >= LevelStage.STAGE2_2

    -- SUPER SECRET
    local superSecretAllowed = not roomSet[RoomType.ROOM_SUPERSECRET]
    local superSecretCount = 0
    if superSecretAllowed then
        superSecretCount = PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_LUNA) and 2 or 1
    end

    placementContext.superSecretAllowed = superSecretAllowed
    placementContext.superSecretRoomCount = superSecretCount

    -- SHOP
    local shopAllowed = true
    if not preChapter4 then
        shopAllowed = false

        if stage <= LevelStage.STAGE4_2 then
            shopAllowed = PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_SILVER_DOLLAR)
        elseif stage == LevelStage.STAGE5 then
            if stageType == StageType.STAGETYPE_ORIGINAL then
                shopAllowed = PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_WICKED_CROWN)
            elseif stageType == StageType.STAGETYPE_WOTL then
                shopAllowed = PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_HOLY_CROWN)
            end
        end
    end

    placementContext.shopAllowed = shopAllowed and not roomSet[RoomType.ROOM_SHOP] and game.m_victoryLap < 3

    -- TREASURE
    local treasureAllowed = true
    if not preChapter4 then
        treasureAllowed = false

        if stage <= LevelStage.STAGE4_2 then
            treasureAllowed = PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_BLOODY_CROWN)
        elseif stage == LevelStage.STAGE5 then
            if stageType == StageType.STAGETYPE_ORIGINAL then
                treasureAllowed = PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_WICKED_CROWN)
            elseif stageType == StageType.STAGETYPE_WOTL then
                treasureAllowed = PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_HOLY_CROWN)
            end
        end
    end

    treasureAllowed = treasureAllowed and not roomSet[RoomType.ROOM_TREASURE]
    local treasureRoomCount = 0
    if treasureAllowed then
        treasureRoomCount = placementContext.curseOfLabyrinth and 2 or 1
    end

    placementContext.treasureAllowed = treasureAllowed
    placementContext.treasureRoomCount = treasureRoomCount
    placementContext.obligatoryTreasureRoom = placementContext.hasMirrorDimension and challengeParams.m_isSecretPath

    -- PLANETARIUM
    placementContext.planetariunChance = LevelRules.GetPlanetariumChance(context, level)
    placementContext.planetariumAllowed = not roomSet[RoomType.ROOM_PLANETARIUM] and not roomSet[RoomType.ROOM_TREASURE]
    placementContext.planetariumUnlocked = PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.PLANETARIUMS)

    -- DICE
    placementContext.diceAllowed = preChapter6 and not roomSet[RoomType.ROOM_DICE]

    -- SACRIFICE
    placementContext.sacrificeAllowed = preChapter6 and not roomSet[RoomType.ROOM_SACRIFICE]

    -- LIBRARY
    placementContext.libraryAllowed = preChapter6 and not roomSet[RoomType.ROOM_LIBRARY]
    placementContext.libraryRecoveryCondition = (gameStateFlags & GameStateFlag.STATE_BOOK_PICKED_UP) ~= 0

    -- CURSE
    placementContext.curseAllowed = preChapter6 and not roomSet[RoomType.ROOM_SACRIFICE]
    placementContext.curseRoomCount = PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_VOODOO_HEAD) and 2 or 1

    -- MINIBOSS
    placementContext.minibossUltraPrideAllowed = effectiveStage >= LevelStage.STAGE2_1
    placementContext.minibossAllowed = preChapter6 and not roomSet[RoomType.ROOM_MINIBOSS]

    local superMinibossChance = 0

    if effectiveStage >= LevelStage.STAGE2_1 then
        superMinibossChance = 80
        if PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.WOMB) then
            superMinibossChance = 30
        end

        if PersistentDataRules.IsUnlocked(context, persistentGameData, Achievement.EVERYTHING_IS_TERRIBLE) then
            superMinibossChance = 10
        end

        if persistentGameData.m_eventCounters[EventCounter.BLUE_BABY_KILLS] + persistentGameData.m_eventCounters[EventCounter.LAMB_KILLS] ~= 0 then
            superMinibossChance = 5
        end
    end

    placementContext.superMinibossChance = superMinibossChance

    -- CHALLENGE
    placementContext.challengeAllowed = preChapter6 and not roomSet[RoomType.ROOM_CHALLENGE]

    -- CHEST
    local cainBirthright = PlayerManagerRules.AnyoneHasBirthright(context, playerManager, PlayerType.PLAYER_CAIN)
    placementContext.cainBirthright = cainBirthright
    placementContext.chestAllowed = preChapter6 and not roomSet[RoomType.ROOM_CHEST] and not cainBirthright

    -- ARCADE
    placementContext.arcadeAllowed = preChapter6 and not roomSet[RoomType.ROOM_ARCADE]

    -- ISAACS
    placementContext.isaacsAllowed = preChapter4 and not roomSet[RoomType.ROOM_ISAACS]

    -- BARREN
    placementContext.barrenAllowed = preChapter4 and not roomSet[RoomType.ROOM_BARREN] and LevelRules.CanSpawnTrapDoor(context, level)

    -- SECRET
    local secretAllowed = not roomSet[RoomType.ROOM_SECRET]
    local secretRoomCount = 0

    if secretAllowed then
        secretRoomCount = 1

        if PlayerManagerRules.AnyoneHasTrinket(context, playerManager, TrinketType.TRINKET_FRAGMENTED_CARD) then
            secretRoomCount = secretRoomCount + 1
        end

        if PlayerManagerRules.AnyoneHasCollectible(context, playerManager, CollectibleType.COLLECTIBLE_LUNA) then
            secretRoomCount = secretRoomCount + 1
        end
    end

    placementContext.secretAllowed = secretAllowed
    placementContext.secretRoomCount = secretRoomCount

    -- ULTRA SECRET
    placementContext.ultraSecretAllowed = not roomSet[RoomType.ROOM_ULTRASECRET]

    local numCoins = PlayerManagerUtils.GetNumCoins(playerManager)
    local numKeys = PlayerManagerUtils.GetNumKeys(playerManager)
    placementContext.diceRecoveryCondition = numKeys >= 2
    placementContext.chestRecoveryCondition = numKeys >= 2

    local evenStage = effectiveStage == LevelStage.STAGE1_2 or effectiveStage == LevelStage.STAGE2_2 or effectiveStage == LevelStage.STAGE3_2 or effectiveStage == LevelStage.STAGE4_2
    local isValidArcadeStage = evenStage or (cainBirthright or effectiveStage < LevelStage.STAGE6)
    placementContext.chestNecessaryCondition = numKeys >= 2 and isValidArcadeStage
    placementContext.arcadeNecessaryCondition = numCoins >= 5 and isValidArcadeStage

    local anger = 1.0
    if (numCoins >= 20) then
        anger = anger + 0.05
    end
    if (gameStateFlags & GameStateFlag.STATE_DONATION_SLOT_BLOWN) ~= 0 then
        anger = anger + 0.1
    end
    if (gameStateFlags & GameStateFlag.STATE_SHOPKEEPER_KILLED) ~= 0 then
        anger = anger + 0.02
    end

    local gratitude = math.min(game.m_donationModGreed, 5) * 0.05
    placementContext.greedSurpriseChance = (anger - gratitude) * 0.33333334

    local anyoneHasFullHeartsSoulHearts = PlayerManagerRules.HasFullHeartsSoulHearts(context, playerManager, false)
    placementContext.sacrificeRecoveryCondition = anyoneHasFullHeartsSoulHearts or PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_LAZARUS) or PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_LAZARUS2)
    placementContext.minibossRecoveryCondition = effectiveStage == LevelStage.STAGE1_1
    placementContext.challengeRecoveryCondition = effectiveStage >= LevelStage.STAGE2_1
    placementContext.challengeNecessaryCondition = anyoneHasFullHeartsSoulHearts and effectiveStage > LevelStage.STAGE1_1

    local anyoneIsAtLowHealth = false
    local players = playerManager.m_players
    local numPlayers = #players

    for i = 1, numPlayers, 1 do
        local player = players[i]
        if player.m_variant ~= PlayerVariant.PLAYER then
            goto continue
        end

        local maxHearts = PlayerRules.GetEffectiveMaxHearts(context, player)
        local lowHealth = (player.m_redHearts < 2 and player.m_soulHearts < 1) or (maxHearts < 1 and player.m_soulHearts < 3)
        if lowHealth then
            anyoneIsAtLowHealth = true
            break
        end
        ::continue::
    end

    placementContext.isaacsNecessaryCondition = anyoneIsAtLowHealth

    return placementContext
end

---@param context Context
---@param placementContext DungeonRoomPlacementLogic.Context
---@param level LevelComponent
---@param levelGenerator LevelGeneratorComponent
---@param minDifficulty integer
---@param maxDifficulty integer
---@return boolean
local function place_rooms(context, placementContext, level, levelGenerator, minDifficulty, maxDifficulty)
    local game = context:GetGame()
    local roomConfig = context:GetRoomConfig()
    local randomRoomContext = placementContext.GetRandomRoomContext
    local rng = level.m_generationRNG

    local stageID = placementContext.stageID

    local minibossNotPlaced = true
    local unk_Int = -1
    local stage = level.m_stage
    local local_148 = 1
    local surpriseShopRoomIdx = -1
    local surpriseSecretRoomIdx = -1

    if placementContext.forcedMegaSatan then
        local megaSatanRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_MEGA_SATAN_IDX, Dimension.CURRENT)
        ---@cast megaSatanRoom RoomDescriptorComponent
        level.m_lastBossRoomIdx = megaSatanRoom.m_listIdx
    else
        -- boss placement
    end

    if placementContext.secretAllowed then
        -- super secret placement
    end

    -- TODO: other rooms placement

    -- reset now, since we succeeded
    local gameStateFlags = game.m_gameStateFlags
    game.m_gameStateFlags = gameStateFlags | (GameStateFlag.STATE_DONATION_SLOT_BLOWN | GameStateFlag.STATE_SHOPKEEPER_KILLED)
    game.m_donationModGreed = 0

    local greedAvailable = (gameStateFlags & (GameStateFlag.STATE_GREED_SPAWNED | GameStateFlag.STATE_SUPERGREED_SPAWNED)) == 0
    greedAvailable = greedAvailable and minibossNotPlaced

    if rng:RandomFloat() < placementContext.greedSurpriseChance and greedAvailable and surpriseSecretRoomIdx >= 0 and placementContext.canSurpriseSecret then
        local surpriseRNG = RNG(rng:GetSeed(), 12)
        greedAvailable = surpriseRNG:RandomInt(1000) == 0

        local surpriseSecretRoom = level.m_roomList[surpriseSecretRoomIdx]
        surpriseSecretRoom.m_flags = surpriseSecretRoom.m_flags | RoomDescriptor.FLAG_SURPRISE_MINIBOSS
    end

    if rng:RandomFloat() < placementContext.greedSurpriseChance and greedAvailable and surpriseShopRoomIdx >= 0 and placementContext.canSurpriseShop then
        local surpriseRNG = RNG(rng:GetSeed(), 12)
        surpriseRNG:Next()

        local surpriseShopRoom = level.m_roomList[surpriseShopRoomIdx]
        surpriseShopRoom.m_flags = surpriseShopRoom.m_flags | RoomDescriptor.FLAG_SURPRISE_MINIBOSS
    end

    local errorRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_ERROR_IDX, Dimension.CURRENT)
    ---@cast errorRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(errorRoom, rng)
    errorRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, -1)

    local blackMarketRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_BLACK_MARKET_IDX, Dimension.CURRENT)
    ---@cast blackMarketRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(blackMarketRoom, rng)
    blackMarketRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_BLACK_MARKET, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, -1)

    local dungeonRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_DUNGEON_IDX, Dimension.CURRENT)
    ---@cast dungeonRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(dungeonRoom, rng)
    dungeonRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_DUNGEON, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, -1)

    local bossRushRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_BOSSRUSH_IDX, Dimension.CURRENT)
    ---@cast bossRushRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(bossRushRoom, rng)

    if placementContext.onForgottenQuest then
        rng:Next()
        bossRushRoom.m_data = RoomConfigUtils.GetRoom(roomConfig, StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSSRUSH, 0, -1)
    else
        bossRushRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSSRUSH, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, -1)
    end

    local megaSatanRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_MEGA_SATAN_IDX, Dimension.CURRENT)
    ---@cast megaSatanRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(megaSatanRoom, rng)
    megaSatanRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSS, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, BossType.MEGA_SATAN, -1)

    local portalIdx = GridRooms.ROOM_BLUE_WOOM_IDX
    if stageID == StbType.BLUE_WOMB then
        portalIdx = GridRooms.ROOM_THE_VOID_IDX
    end

    local portalRoom = LevelUtils.GetRoomByIdx(level, portalIdx, Dimension.CURRENT)
    ---@cast portalRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(portalRoom, rng)
    portalRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, StbType.BLUE_WOMB, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, 0, 0, 0, 1, -1)

    local evenUpgrades = 1
    if placementContext.shopLvl2 then
        evenUpgrades = evenUpgrades + 1
    end
    if placementContext.shopLvl4 then
        evenUpgrades = evenUpgrades + 1
    end

    local oddUpgrades = 1
    if placementContext.shopLvl3 then
        oddUpgrades = oddUpgrades + 1
    end

    local secretShopRNG = RNG(rng:Next(), 19)
    local secretShopLevel = secretShopRNG:RandomInt(oddUpgrades) + secretShopRNG:RandomInt(evenUpgrades)
    local secretShop = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_SECRET_SHOP_IDX, Dimension.CURRENT)
    ---@cast secretShop RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(secretShop, secretShopRNG)
    secretShop.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, secretShopRNG:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, secretShopLevel, -1)

    local angelShopRNG = RNG(rng:Next(), 20)
    local angelShop = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_ANGEL_SHOP_IDX, Dimension.CURRENT)
    ---@cast angelShop RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(angelShop, angelShopRNG)
    angelShop.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, angelShopRNG:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ANGEL, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, RoomSubType.ANGEL_STAIRWAY, -1)

    if placementContext.hasMotherBossFight then
        rng:Next()
        local motherRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_SECRET_EXIT_IDX, Dimension.CURRENT)
        ---@cast motherRoom RoomDescriptorComponent
        RoomDescriptorUtils.InitSeeds(motherRoom, rng)
        motherRoom.m_data = RoomConfigRules.GetRandomRoom(randomRoomContext, roomConfig, rng:Next(), true, stageID, RoomType.ROOM_BOSS, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, BossType.MOTHER, -1)
    end

    return true
end

--#region Module



--#endregion

return Module