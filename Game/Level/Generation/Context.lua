--#region Dependencies

local Enums = require("General.Enums")
local LevelUtils = require("Level.Utils")
local QuestUtils = require("Mechanics.Game.Quest.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local PersistentDataUtils = require("Admin.PersistentData.Utils")
local RoomConfigUtils = require("Config.Room.Utils")
local GenerationUtils = require("Level.Generation.Utils")

local eSpecialDailyRuns = Enums.eSpecialDailyRuns

--#endregion

---@class LevelGenerationContext
local Module = {}

---@class LevelGenerationContext.GetPlanetariumChance : InventoryContext.HasCollectible, InventoryContext.GetTrinketMultiplier
---@field level LevelComponent
---@field room RoomComponent
---@field persistentGameData PersistentDataComponent
---@field itemConfig ItemConfigComponent
---@field proceduralItemManager ProceduralItemManagerComponent
---@field seeds SeedsComponent
---@field playerManager PlayerManagerComponent
---@field challengeParams ChallengeParamsComponent
---@field planetariumsVisited integer
---@field treasureRoomsVisited integer
---@field frameCount integer
---@field challenge Challenge | integer
---@field dailyChallenge DailyChallengeComponent
---@field defaultPlayer EntityPlayerComponent?
---@field forceUnlock boolean

---@class LevelGenerationContext.GenerateDungeon : LevelGenerationContext.GenerateMirrorWorld, LevelGenerationContext.GenerateMinesDungeon, LevelContext.CanSpawnTrapDoor, QuestContext.HasMirrorDimension, QuestContext.HasAbandonedMineshaft, QuestContext.HasPhotoDoor, PersistentDataContext.Unlocked, InventoryContext.HasCollectible, InventoryContext.GetTrinketMultiplier
---@field game GameComponent
---@field level LevelComponent
---@field room RoomComponent
---@field itemConfig ItemConfigComponent
---@field proceduralItemManager ProceduralItemManagerComponent
---@field seeds SeedsComponent
---@field playerManager PlayerManagerComponent
---@field persistentGameData PersistentDataComponent
---@field roomConfig RoomConfigComponent
---@field bossPool BossPoolComponent
---@field difficulty Difficulty | integer
---@field challenge Challenge | integer
---@field dailyChallenge DailyChallengeComponent
---@field challengeParams ChallengeParamsComponent
---@field curses LevelCurse | integer
---@field gameStateFlags GameStateFlag | integer
---@field frameCount integer
---@field defaultPlayer EntityPlayerComponent?
---@field mode integer
---@field forceUnlock boolean
---@field inChallenge boolean

---@class LevelGenerationContext.GenerateMirrorWorld

---@class LevelGenerationContext.GenerateMinesDungeon

---@class LevelGenerationContext.PlaceRooms : LevelContext.PlaceRoomContext, RoomConfigContext.GetRandomRoom, RoomConfigContext.GetRandomBossRoom, BossPoolContext.GetBoss
---@field game GameComponent
---@field persistentGameData PersistentDataComponent
---@field roomConfig RoomConfigComponent
---@field bossPool BossPoolComponent
---@field stageID StbType | integer
---@field mode integer
---@field challenge Challenge | integer
---@field dailyChallenge DailyChallengeComponent
---@field superSecretRoomCount integer
---@field treasureRoomCount integer
---@field goldenHorseShoeMultiplier integer
---@field planetariumChance number
---@field curseRoomCount integer
---@field superMinibossChance integer
---@field secretRoomCount integer
---@field greedSurpriseChance number
---@field hardMode boolean
---@field curseOfLabyrinth boolean
---@field forcedMegaSatan boolean
---@field isChapter6 boolean
---@field isDarkRoom boolean
---@field isChest boolean
---@field isChristmas boolean
---@field hasMirrorDimension boolean
---@field hasAbandonedMineshaft boolean
---@field hasPhotoDoor boolean
---@field hasMotherBossFight boolean
---@field hasForgottenGrave boolean
---@field forgottenUnlocked boolean
---@field voodooHead boolean
---@field cainBirthright boolean
---@field anyoneIsTaintedKeeper boolean
---@field superSecretAllowed boolean
---@field shopAllowed boolean
---@field shopLvl1 boolean
---@field shopLvl2 boolean
---@field shopLvl3 boolean
---@field shopLvl4 boolean
---@field treasureAllowed boolean
---@field obligatoryTreasureRoom boolean
---@field hasPayToWin boolean
---@field planetariumAllowed boolean
---@field planetariumNecessaryCondition boolean
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
---@field hasBossChallenge boolean
---@field chestAllowed boolean
---@field chestRecoveryCondition boolean
---@field chestNecessaryCondition boolean
---@field arcadeAllowed boolean
---@field arcadeNecessaryCondition boolean
---@field isaacsAllowed boolean
---@field isaacsRecoveryCondition boolean
---@field barrenAllowed boolean
---@field secretAllowed boolean
---@field ultraSecretAllowed boolean
---@field onForgottenQuest boolean
---@field canSurpriseSecret boolean
---@field canSurpriseShop boolean

---@param level LevelComponent
---@param generationContext LevelGenerationContext.GenerateDungeon
---@return LevelGenerationContext.PlaceRooms
local function BuildPlaceRoomsContext(level, generationContext)
    local game = generationContext.game
    local playerManager = generationContext.playerManager
    local persistentGameData = generationContext.persistentGameData
    local challengeParams = generationContext.challengeParams
    local roomConfig = generationContext.roomConfig
    local bossPool = generationContext.bossPool
    local curses = generationContext.curses
    local mode = generationContext.mode

    local roomFilter = challengeParams.m_roomFilter
    local difficulty = game.m_difficulty
    local gameStateFlags = game.m_gameStateFlags
    local stage = level.m_stage
    local stageType = level.m_stageType
    local preChapter4 = stage < LevelStage.STAGE4_1
    local preChapter6 = stage < LevelStage.STAGE6
    local isAltPath = LevelUtils.IsAltPath(level)
    local effectiveStage = isAltPath and stage + 1 or stage
    local curseOfLabyrinth = (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0
    local curseOfGiant = (curses & LevelCurse.CURSE_OF_GIANT) ~= 0

    local hasMirrorDimension = QuestUtils.HasMirrorDimension(generationContext, level)
    local localStageId = LevelUtils.GetStageID(generationContext, level)
    local stageId = RoomConfigUtils.GetStageId(stage, stageType, mode)

    ---@type LevelGenerationContext.GetPlanetariumChance
    local GetPlanetariumContext = {
        level = level,
        room = generationContext.room,
        persistentGameData = persistentGameData,
        itemConfig = generationContext.itemConfig,
        proceduralItemManager = generationContext.proceduralItemManager,
        seeds = generationContext.seeds,
        frameCount = generationContext.frameCount,
        challenge = game.m_challenge,
        dailyChallenge = game.m_dailyChallenge,
        forceUnlock = generationContext.forceUnlock,
        treasureRoomsVisited = game.m_treasureRoomsVisited,
        planetariumsVisited = game.m_planetariumsVisited,
        playerManager = playerManager,
        challengeParams = challengeParams,
    }
    local planetariumChance = GenerationUtils.GetPlanetariumChance(GetPlanetariumContext, level)

    local challengeAllowsSuperSecret = not roomFilter[RoomType.ROOM_SUPERSECRET]
    local challengeAllowsShop = not roomFilter[RoomType.ROOM_SHOP]
    local challengeAllowsTreasure = not roomFilter[RoomType.ROOM_TREASURE]
    local challengeAllowsPlanetarium = not roomFilter[RoomType.ROOM_PLANETARIUM]
    local challengeAllowsDice = not roomFilter[RoomType.ROOM_DICE]
    local challengeAllowsSacrifice = not roomFilter[RoomType.ROOM_SACRIFICE]
    local challengeAllowsLibrary = not roomFilter[RoomType.ROOM_LIBRARY]
    local challengeAllowsCurse = not roomFilter[RoomType.ROOM_CURSE]
    local challengeAllowsMiniboss = not roomFilter[RoomType.ROOM_MINIBOSS]
    local challengeAllowsChallenge = not roomFilter[RoomType.ROOM_CHALLENGE]
    local challengeAllowsChest = not roomFilter[RoomType.ROOM_CHEST]
    local challengeAllowsArcade = not roomFilter[RoomType.ROOM_ARCADE]
    local challengeAllowsIssacs = not roomFilter[RoomType.ROOM_ISAACS]
    local challengeAllowsBarren = not roomFilter[RoomType.ROOM_BARREN]
    local challengeAllowsSecret = not roomFilter[RoomType.ROOM_SECRET]
    local challengeAllowsUltraSecret = not roomFilter[RoomType.ROOM_ULTRASECRET]

    local forgottenUnlocked = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.FORGOTTEN)
    local shopLvl1 = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.STORE_UPGRADE_LV1)
    local shopLvl2 = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.STORE_UPGRADE_LV2)
    local shopLvl3 = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.STORE_UPGRADE_LV3)
    local shopLvl4 = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.STORE_UPGRADE_LV4)
    local planetariumsUnlocked = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.PLANETARIUMS)
    local wombUnlocked = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.WOMB)
    local everythingIsTerrible = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.EVERYTHING_IS_TERRIBLE)
    local strangeDoor = PersistentDataUtils.Unlocked(generationContext, persistentGameData, Achievement.STRANGE_DOOR)
    local chapter6BossKills = persistentGameData.m_eventCounters[EventCounter.BLUE_BABY_KILLS] + persistentGameData.m_eventCounters[EventCounter.LAMB_KILLS]

    local superMinibossChance = 0

    if effectiveStage >= LevelStage.STAGE2_1 then
        superMinibossChance = 80
        if wombUnlocked then
            superMinibossChance = 30
        end

        if everythingIsTerrible then
            superMinibossChance = 10
        end

        if chapter6BossKills ~= 0 then
            superMinibossChance = 5
        end
    end

    -- PlayerManager
    local numCoins = PlayerManagerUtils.GetNumCoins(playerManager)
    local numKeys = PlayerManagerUtils.GetNumKeys(playerManager)

    local hasFirstKnifePiece = PlayerManagerUtils.AnyoneHasCollectible(generationContext, playerManager, CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)
    local hasFirstBrokenShovel = PlayerManagerUtils.AnyoneHasCollectible(generationContext, playerManager, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1)
    local hasLuna = PlayerManagerUtils.AnyoneHasCollectible(generationContext, playerManager, CollectibleType.COLLECTIBLE_LUNA)
    local hasVoodooHead = PlayerManagerUtils.AnyoneHasCollectible(generationContext, playerManager, CollectibleType.COLLECTIBLE_VOODOO_HEAD)
    local hasCainBirthright = PlayerManagerUtils.AnyoneHasBirthright(generationContext, playerManager, PlayerType.PLAYER_CAIN)
    local hasFragmentedCard = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_FRAGMENTED_CARD)
    local hasSilverDollar = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_SILVER_DOLLAR)
    local hasBloodyCrown = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_BLOODY_CROWN)
    local hasWickedCrown = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_WICKED_CROWN)
    local hasHolyCrown = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_HOLY_CROWN)
    local hasPayToWin = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_PAY_TO_WIN)
    local hasDevilsCrown = PlayerManagerUtils.AnyoneHasTrinket(generationContext, playerManager, TrinketType.TRINKET_DEVILS_CROWN)
    local goldenHorseShoeMultiplier = PlayerManagerUtils.GetTrinketMultiplier(generationContext, playerManager, TrinketType.TRINKET_GOLDEN_HORSE_SHOE)

    local anyoneIsLazarus = PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_LAZARUS) or PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_LAZARUS2)
    local anyoneIsTaintedKeeper = PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_KEEPER_B)
    local anyoneHasFullHeartsSoulHearts = PlayerManagerUtils.HasFullHeartsSoulHearts(playerManager, false)

    local anyoneIsAtLowHealth = false
    local players = playerManager.m_players

    for i = 1, #players, 1 do
        local player = players[i]
        if player.m_variant ~= PlayerVariant.PLAYER then
            goto continue
        end

        local maxHearts = PlayerUtils.GetEffectiveMaxHearts(player)
        local lowHealth = (player.m_redHearts < 2 and player.m_soulHearts < 1) or (maxHearts < 1 and player.m_soulHearts < 3)
        if lowHealth then
            anyoneIsAtLowHealth = true
            break
        end
        ::continue::
    end

    local superSecretRoomCount
    if challengeAllowsSuperSecret then
        superSecretRoomCount = hasLuna and 2 or 1
    else
        superSecretRoomCount = 0
    end

    local secretAllowed = challengeAllowsSecret
    local secretRoomCount = 0
    if secretAllowed then
        secretRoomCount = 1

        if hasFragmentedCard then
            secretRoomCount = secretRoomCount + 1
        end

        if hasLuna then
            secretRoomCount = secretRoomCount + 1
        end
    end

    local shopAvailable = true
    if not preChapter4 then
        shopAvailable = false

        if stage <= LevelStage.STAGE4_2 then
            shopAvailable = hasSilverDollar
        elseif stage == LevelStage.STAGE5 then
            if stageType == StageType.STAGETYPE_ORIGINAL then
                shopAvailable = hasWickedCrown
            elseif stageType == StageType.STAGETYPE_WOTL then
                shopAvailable = hasHolyCrown
            end
        end
    end

    local treasureAvailable = true
    if not preChapter4 then
        treasureAvailable = false

        if stage <= LevelStage.STAGE4_2 then
            treasureAvailable = hasBloodyCrown
        elseif stage == LevelStage.STAGE5 then
            if stageType == StageType.STAGETYPE_ORIGINAL then
                treasureAvailable = hasWickedCrown
            elseif stageType == StageType.STAGETYPE_WOTL then
                treasureAvailable = hasHolyCrown
            end
        end
    end

    local treasureAllowed = treasureAvailable and challengeAllowsTreasure
    local treasureRoomCount = 0
    if treasureAllowed then
        treasureRoomCount = curseOfLabyrinth and 2 or 1
    end

    local evenStage = effectiveStage == LevelStage.STAGE1_2 or effectiveStage == LevelStage.STAGE2_2 or effectiveStage == LevelStage.STAGE3_2 or effectiveStage == LevelStage.STAGE4_2
    local isValidArcadeStage = evenStage or (hasCainBirthright or effectiveStage < LevelStage.STAGE6)

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
    local greedSurpriseChance = (anger - gratitude) * 0.33333334

    ---@type LevelGenerationContext.PlaceRooms
    return {
        game = game,
        roomConfig = roomConfig,
        bossPool = bossPool,
        hardMode = difficulty == Difficulty.DIFFICULTY_HARD or difficulty == Difficulty.DIFFICULTY_GREEDIER,
        mode = mode,
        persistentGameData = persistentGameData,
        localStageId = localStageId,
        stageID = stageId,
        isVoid = stage == LevelStage.STAGE7,
        gameStateFlags = gameStateFlags,
        challenge = game.m_challenge,
        dailyChallenge = game.m_dailyChallenge,
        superMinibossChance = superMinibossChance,
        isChapter6 = stage == LevelStage.STAGE6,
        isDarkRoom = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_ORIGINAL,
        isChest = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_WOTL,
        isChristmas = game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.CHRISTMAS,
        curseOfLabyrinth = curseOfLabyrinth,
        curseOfGiant = curseOfGiant,
        forcedMegaSatan = challengeParams.m_isMegaSatan and stage == LevelStage.STAGE6,
        hasMotherBossFight = (stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_1 and curseOfLabyrinth)) and isAltPath,
        hasForgottenGrave = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_ORIGINAL,
        canSurpriseSecret = stage >= LevelStage.STAGE3_1,
        canSurpriseShop = stage >= LevelStage.STAGE2_2,
        hasBossChallenge = level.m_hasBossChallenge,
        devilsCrownEffect = hasDevilsCrown,
        forgottenUnlocked = forgottenUnlocked,
        shopLvl1 = shopLvl1,
        shopLvl2 = shopLvl2,
        shopLvl3 = shopLvl3,
        shopLvl4 = shopLvl4,
        planetariumNecessaryCondition = planetariumsUnlocked,
        superSecretRoomCount = superSecretRoomCount,
        onForgottenQuest = hasFirstBrokenShovel,
        voodooHead = hasVoodooHead,
        cainBirthright = hasCainBirthright,
        planetariumChance = planetariumChance,
        goldenHorseShoeMultiplier = goldenHorseShoeMultiplier,
        hasPayToWin = hasPayToWin,
        sacrificeRecoveryCondition = anyoneHasFullHeartsSoulHearts or anyoneIsLazarus,
        anyoneIsTaintedKeeper = anyoneIsTaintedKeeper,
        hasMirrorDimension = hasMirrorDimension,
        hasAbandonedMineshaft = QuestUtils.HasAbandonedMineshaft(generationContext, level) and hasFirstKnifePiece,
        hasPhotoDoor = QuestUtils.HasPhotoDoor(generationContext, level) and strangeDoor,
        superSecretAllowed = challengeAllowsSuperSecret,
        shopAllowed = shopAvailable and challengeAllowsShop and game.m_victoryRun_currentLap < 3,
        treasureAllowed = treasureAllowed,
        treasureRoomCount = treasureRoomCount,
        obligatoryTreasureRoom = hasMirrorDimension and challengeParams.m_isSecretPath,
        planetariumAllowed = challengeAllowsPlanetarium and challengeAllowsTreasure,
        diceAllowed = preChapter6 and challengeAllowsDice,
        sacrificeAllowed = preChapter6 and challengeAllowsSacrifice,
        libraryAllowed = preChapter6 and challengeAllowsLibrary,
        libraryRecoveryCondition = (gameStateFlags & GameStateFlag.STATE_BOOK_PICKED_UP) ~= 0,
        curseAllowed = preChapter6 and challengeAllowsCurse,
        curseRoomCount = hasVoodooHead and 2 or 1,
        minibossUltraPrideAllowed = effectiveStage >= LevelStage.STAGE2_1,
        minibossAllowed = preChapter6 and challengeAllowsMiniboss,
        challengeAllowed = preChapter6 and challengeAllowsChallenge,
        chestAllowed = preChapter6 and challengeAllowsChest and not hasCainBirthright,
        arcadeAllowed = preChapter6 and challengeAllowsArcade,
        isaacsAllowed = preChapter4 and challengeAllowsIssacs,
        barrenAllowed = preChapter4 and challengeAllowsBarren and LevelUtils.CanSpawnTrapDoor(generationContext, level),
        secretAllowed = secretAllowed,
        secretRoomCount = secretRoomCount,
        ultraSecretAllowed = challengeAllowsUltraSecret,
        diceRecoveryCondition = numKeys >= 2,
        chestRecoveryCondition = numKeys >= 2,
        chestNecessaryCondition = numKeys >= 2 and isValidArcadeStage,
        arcadeNecessaryCondition = numCoins >= 5 and isValidArcadeStage,
        greedSurpriseChance = greedSurpriseChance,
        minibossRecoveryCondition = effectiveStage == LevelStage.STAGE1_1,
        challengeRecoveryCondition = effectiveStage >= LevelStage.STAGE2_1,
        challengeNecessaryCondition = anyoneHasFullHeartsSoulHearts and effectiveStage > LevelStage.STAGE1_1,
        isaacsRecoveryCondition = anyoneIsAtLowHealth,
    }
end

---@param result LevelGenerationContext.GenerateDungeon
---@param level LevelComponent
---@return LevelGenerationContext.GenerateDungeon
local function BuildGenerateDungeonContext(result, level)
end

--#region Module

Module.BuildGenerateDungeonContext = BuildGenerateDungeonContext
Module.BuildPlaceRoomsContext = BuildPlaceRoomsContext

--#endregion

return Module