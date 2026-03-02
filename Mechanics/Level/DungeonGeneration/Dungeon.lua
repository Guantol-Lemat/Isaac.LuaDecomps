--#region Dependencies

local Log = require("General.Log")
local TableUtils = require("General.Table")
local Enums = require("General.Enums")
local RNGUtils = require("General.RNG")
local GameUtils = require("Game.Utils")
local LevelUtils = require("Game.Level.Utils")
local StageUtils = require("Game.Level.StageUtils")
local CurseUtils = require("Mechanics.Level.Curse.Utils")
local QuestUtils = require("Mechanics.Game.Quest.Utils")
local LevelRules = require("Level.Rules")
local RoomDescriptorUtils = require("Room.RoomDescriptor.Utils")
local RoomConfigUtils = require("Config.Room.Utils")
local RoomConfigRules = require("Config.Room.Rules")
local BossPoolUtils = require("Game.Pools.BossPool.Utils")
local BossPoolPick = require("Game.Pools.BossPool.PickLogic")
local PersistentDataUtils = require("Admin.PersistentData.Utils")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local LevelGeneratorModule = require("Game.Level.LevelGenerator.Component")
local LevelGeneratorUtils = require("Game.Level.LevelGenerator.Utils")
local GenerationUtils = require("Mechanics.Level.DungeonGeneration.Utils")
local GenerationLogic = require("Mechanics.Level.DungeonGeneration.Generator")
local QuestGenerationLogic = require("Game.Level.Generation.QuestDungeon")
local LevelGenerationContext = require("Level.Generation.Context")

local eSpecialDailyRuns = Enums.eSpecialDailyRuns
--#endregion

local Module = {}

---@type Set<BossType>
local VOID_BOSS_BLACKLIST = TableUtils.CreateDictionary({
    BossType.MONSTRO, BossType.LARRY_JR, BossType.CHUB, BossType.GURDY,
    BossType.MOM, BossType.FAMINE, BossType.PESTILENCE, BossType.DUKE_OF_FLIES,
    BossType.PEEP, BossType.GEMINI, BossType.FISTULA, BossType.STEVEN,
    BossType.CHAD, BossType.FALLEN, BossType.HOLLOW, BossType.CARRION_QUEEN,
    BossType.GURDY_JR, BossType.HUSK, BossType.BLIGHTED_OVUM, BossType.WIDOW,
    BossType.WRETCHED, BossType.PIN, BossType.HAUNT, BossType.DINGLE,
    BossType.MEGA_MAW, BossType.MEGA_FATTY, BossType.DARK_ONE, BossType.POLYCEPHALUS,
    BossType.MEGA_SATAN, BossType.GURGLINGS, BossType.STAIN, BossType.LITTLE_HORN,
    BossType.RAG_MAN, BossType.ULTRA_GREED, BossType.HUSH, BossType.DANGLE,
    BossType.TURDLINGS, BossType.RAG_MEGA, BossType.BIG_HORN
})

---@type BossType[]
local VOID_BOSSES = {}
for i = 0, BossType.DELIRIUM - 1, 1 do
    if not VOID_BOSS_BLACKLIST[i] then
        table.insert(VOID_BOSSES, i)
    end
end

local MINIBOSSES = {
    {RoomSubType.MINIBOSS_WRATH, RoomSubType.MINIBOSS_SUPER_WRATH, GameStateFlag.STATE_WRATH_SPAWNED},
    {RoomSubType.MINIBOSS_GLUTTONY, RoomSubType.MINIBOSS_SUPER_GLUTTONY, GameStateFlag.STATE_GLUTTONY_SPAWNED},
    {RoomSubType.MINIBOSS_LUST, RoomSubType.MINIBOSS_SUPER_LUST, GameStateFlag.STATE_LUST_SPAWNED},
    {RoomSubType.MINIBOSS_SLOTH, RoomSubType.MINIBOSS_SUPER_SLOTH, GameStateFlag.STATE_SLOTH_SPAWNED},
    {RoomSubType.MINIBOSS_ENVY, RoomSubType.MINIBOSS_SUPER_ENVY, GameStateFlag.STATE_ENVY_SPAWNED},
    {RoomSubType.MINIBOSS_PRIDE, RoomSubType.MINIBOSS_SUPER_PRIDE, GameStateFlag.STATE_PRIDE_SPAWNED},
}

---@return BossType[]
local function get_void_bosses()
    local list = {}
    for i = 1, #VOID_BOSSES, 1 do
        table.insert(list, VOID_BOSSES[i])
    end

    return list
end

---@param level LevelComponent
---@return Set<integer>
local function build_secret_room_index_blacklist(level)
end

---@param level LevelComponent
---@return Set<integer>
local function build_ultrasecret_room_index_blacklist(level)
end

---@param level LevelComponent
---@return Set<integer>
local function build_specialnormal_room_index_blacklist(level)
end

---@param myContext Context.Common
---@param level LevelComponent
---@param levelGenerator LevelGeneratorComponent
---@param minDifficulty integer
---@param maxDifficulty integer
---@return boolean
local function place_rooms(myContext, level, levelGenerator, minDifficulty, maxDifficulty)
    local isaac = myContext.manager
    local game = myContext.game

    local persistentGameData = isaac.m_persistentGameData
    local roomConfig = game.m_roomConfig
    local bossPool = game.m_bossPool
    local playerManager = game.m_playerManager

    local gameStateFlags = game.m_gameStateFlags
    local stage = level.m_stage
    local stageType = level.m_stageType
    local rng = level.m_generationRNG
    local mode = GameUtils.IsGreedMode(game) and 1 or 0
    local challengeParams = GameUtils.GetChallengeParams(myContext, game)
    local roomFilter = challengeParams.m_roomFilter
    local curse = CurseUtils.GetCurses(myContext, level)
    local curseOfLabyrinth = (curse & LevelCurse.CURSE_OF_LABYRINTH) ~= 0

    local localStageId = StageUtils.GetStageID(myContext, level)
    local stageId = RoomConfigUtils.GetStageId(stage, stageType, mode)
    local preChapter4 = stage < LevelStage.STAGE4_1
    local preChapter6 = stage < LevelStage.STAGE6
    local isAltPath = LevelUtils.IsAltPath(level)
    local effectiveStage = isAltPath and stage + 1 or stage

    local minibossNotPlaced = true
    local surpriseShopListIdx = -1
    local surpriseSecretListIdx = -1
    local questRoomCount = 0

    -- Place Boss (Can FAIL)
    do
        local forcedMegaSatan = challengeParams.m_isMegaSatan and stage == LevelStage.STAGE6
        if forcedMegaSatan then
            local megaSatanRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_MEGA_SATAN_IDX, Dimension.CURRENT)
            ---@cast megaSatanRoom RoomDescriptorComponent
            level.m_lastBossListIdx = megaSatanRoom.m_listIdx

            goto END_OF_BLOCK
        end

        local boss = BossPoolPick.GetBossId(myContext, bossPool, stage, stageType)
        local roomData = RoomConfigRules.GetRandomBossRoom(myContext, boss, rng:Next())
        if not roomData then
            Log.LogMessage(0, string.format("[warn] could not find matching boss room (boss id: %d) for the current stage\n", boss))
            return false -- FAILURE
        end

        local room = GenerationLogic.GetNewBossRoom(levelGenerator, roomData.m_shape, roomData.m_doors, false)
        if not room then
            return false -- FAILURE
        end

        level.m_lastBossListIdx = level.m_roomCount
        level.m_deliriumListIdx = level.m_roomCount

        LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())

        if stage == LevelStage.STAGE7 then
            local numBosses = 5 + rng:RandomInt(4)
            local voidBosses = get_void_bosses()
            RNGUtils.Shuffle(voidBosses, rng)

            for i = 1, numBosses, 1 do
                roomData = RoomConfigRules.GetRandomBossRoom(myContext, voidBosses[i], rng:Next())
                if not roomData then
                    Log.LogMessage(0, string.format("[warn] could not find matching boss room (boss id: %d) for the current stage\n", boss))
                    return false -- FAILURE
                end

                room = GenerationLogic.GetNewBossRoom(levelGenerator, roomData.m_shape, roomData.m_doors, true)
                if not room then
                    if i < 5 then
                        return false -- FAILURE
                    end
                    break
                end

                level.m_lastBossListIdx = level.m_roomCount
                LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
            end
        end

        if curseOfLabyrinth then
            local previousSeed = rng:GetSeed()
            boss = BossPoolPick.GetBossId(myContext, bossPool, stage + 1, stageType)
            roomData = RoomConfigRules.GetRandomBossRoom(myContext, boss, rng:Next())
            if not roomData then
                Log.LogMessage(0, string.format("[warn] could not find matching boss room (boss id: %d) for the current stage\n", boss))
                return false -- FAILURE
            end

            room = GenerationLogic.GetNewBossRoom(levelGenerator, roomData.m_shape, roomData.m_doors, false)
            level.m_lastBossListIdx = level.m_roomCount
            if not room then
                return false -- FAILURE
            end

            LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
            rng:SetSeed(previousSeed, 35)
        end

        -- this only blocks the positions adjacent to the last created boss room
        LevelGeneratorUtils.BlockOccupiedAndNeighbors(levelGenerator, room)

        ::END_OF_BLOCK::
    end

    -- Place Super Secret (Can FAIL)
    local superSecretAllowed = not roomFilter[RoomType.ROOM_SUPERSECRET]
    if superSecretAllowed then
        local superSecretRNG = RNG(rng:Next(), 9)
        local superSecretRoomCount = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_LUNA) and 2 or 1

        for i = 1, superSecretRoomCount, 1 do
            local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, superSecretRNG:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SUPERSECRET, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
            ---@cast roomData RoomDataComponent
            local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

            if not room then
                if i == 1 then
                    return false -- FAILURE
                end
                break
            end

            LevelRules.PlaceRoom(myContext, level, room, roomData, superSecretRNG:GetSeed())
        end
    end

    local secretSeed = rng:Next()

    -- Place Shop (Can FAIL)
    local shopAvailable
    do
        if preChapter4 then
            shopAvailable = true
            goto END_OF_BLOCK
        end

        if stage <= LevelStage.STAGE4_2 then
            shopAvailable = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_SILVER_DOLLAR)
            goto END_OF_BLOCK
        end

        if stage == LevelStage.STAGE5 then
            if stageType == StageType.STAGETYPE_ORIGINAL then
                shopAvailable = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_WICKED_CROWN)
            elseif stageType == StageType.STAGETYPE_WOTL then
                shopAvailable = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_HOLY_CROWN)
            end

            goto END_OF_BLOCK
        end

        shopAvailable = false
        ::END_OF_BLOCK::
    end

    local shopAllowed = shopAvailable and not roomFilter[RoomType.ROOM_SHOP] and game.m_victoryRun_currentLap < 3
    if shopAllowed then
        local shopLvl1 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV1)
        local shopLvl2 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV2)
        local shopLvl3 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV3)
        local shopLvl4 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV4)

        local oddUpgrades = 0
        if shopLvl1 then
            oddUpgrades = oddUpgrades + 1
        end
        if shopLvl3 then
            oddUpgrades = oddUpgrades + 1
        end

        local evenUpgrades = 0
        if shopLvl2 then
            evenUpgrades = evenUpgrades + 1
        end
        if shopLvl4 then
            evenUpgrades = evenUpgrades + 1
        end

        local shopRNG = RNG(rng:Next(), 19)
        local shopLvl = shopRNG:RandomInt(oddUpgrades + 1) + shopRNG:RandomInt(evenUpgrades + 1)

        if shopRNG:RandomInt(2) == 0 or not GameUtils.IsHardMode(game) then
            shopLvl = oddUpgrades + evenUpgrades
        end

        local roomSubtype = shopLvl
        local random = shopRNG:RandomInt(256)
        if random == 0 then
            roomSubtype = RoomSubType.SHOP_RARE_BAD
        elseif random == 1 and shopLvl > 1 then
            roomSubtype = RoomSubType.SHOP_RARE_GOOD
        end

        if PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_KEEPER_B) then
            roomSubtype = roomSubtype + 100
        end

        local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, roomSubtype, mode)
        ---@cast roomData RoomDataComponent
        local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)
        if not room then
            return false -- FAILURE
        end

        surpriseShopListIdx = level.m_roomCount
        LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
    end

    -- Place Treasure (Can FAIL)
    local treasureAvailable
    do
        if preChapter4 then
            treasureAvailable = true
            goto END_OF_BLOCK
        end

        if stage <= LevelStage.STAGE4_2 then
            treasureAvailable = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_BLOODY_CROWN)
            goto END_OF_BLOCK
        end

        if stage == LevelStage.STAGE5 then
            if stageType == StageType.STAGETYPE_ORIGINAL then
                treasureAvailable = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_WICKED_CROWN)
            elseif stageType == StageType.STAGETYPE_WOTL then
                treasureAvailable = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_HOLY_CROWN)
            end

            goto END_OF_BLOCK
        end

        treasureAvailable = false
        ::END_OF_BLOCK::
    end

    do
        local treasureAllowed = treasureAvailable and not roomFilter[RoomType.ROOM_TREASURE]
        if not treasureAllowed then
            local obligatoryTreasureRoom = QuestUtils.HasMirrorDimension(myContext, level) and challengeParams.m_isSecretPath
            if obligatoryTreasureRoom then
                local roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, rng:Next(), true, stageId, StbType.SPECIAL_ROOMS, RoomType.ROOM_TREASURE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, 0, mode)
                ---@cast roomData RoomDataComponent
                local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)
                if not room then
                    return false -- FAILURE
                end

                LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
            end

            goto END_OF_BLOCK
        end

        local oldSeed = rng:GetSeed()
        local treasureRoomCount = curseOfLabyrinth and 2 or 1
        local goldenHorseShoeMultiplier = PlayerManagerUtils.GetTrinketMultiplier(myContext, playerManager, TrinketType.TRINKET_GOLDEN_HORSE_SHOE)
        local hasPayToWin = PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_PAY_TO_WIN)

        for i = 1, treasureRoomCount, 1 do
            local roomSubtype = nil
            local highChanceOptionsRoom = 100 // math.min(goldenHorseShoeMultiplier, 1)
            if rng:RandomInt(100) == 0 or (rng:RandomInt(highChanceOptionsRoom) < 15 and (goldenHorseShoeMultiplier > 0 or game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.CHRISTMAS)) then
                roomSubtype = hasPayToWin and RoomSubType.TREASURE_PAY_TO_PLAY_OPTIONS or RoomSubType.TREASURE_OPTIONS
            else
                roomSubtype = hasPayToWin and RoomSubType.TREASURE_PAY_TO_PLAY or RoomSubType.TREASURE_NORMAL
            end

            local roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, rng:Next(), true, stageId, StbType.SPECIAL_ROOMS, RoomType.ROOM_TREASURE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, roomSubtype, mode)
            ---@cast roomData RoomDataComponent
            local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)
            if not room then
                return false -- FAILURE
            end

            LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())

            -- Make it so extra rooms do not affect further rooms
            if i == 1 then
                oldSeed = rng:GetSeed()
            end
        end

        rng:SetSeed(oldSeed, 35)
        ::END_OF_BLOCK::
    end

    -- Place Planetarium
    do
        local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_PLANETARIUM, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
        ---@cast roomData RoomDataComponent
        local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

        if not room then
            goto END_OF_BLOCK
        end

        local function can_place()
            local allowed = (not roomFilter[RoomType.ROOM_PLANETARIUM] and not roomFilter[RoomType.ROOM_TREASURE])
            if not allowed then
                return false
            end

            if rng:RandomFloat() >= GenerationUtils.GetPlanetariumChance(myContext, level) then
                return false
            end

            local necessaryCondition = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.PLANETARIUMS)
            if not necessaryCondition then
                return false
            end

            return true
        end

        if can_place() then
            LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
        else
            LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
        end

        ::END_OF_BLOCK::
    end

    if stage < LevelStage.STAGE6 then
        -- Place Sacrifice or Dice
        do
            local roomData = nil
            local diceRecoveryCondition = PlayerManagerUtils.GetNumKeys(playerManager)
            local diceAllowed = not roomFilter[RoomType.ROOM_DICE]
            if (rng:RandomInt(50) == 0 or (rng:RandomInt(5) == 0 and PlayerManagerUtils.GetNumKeys(playerManager))) and diceAllowed then
                roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
            else
                roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SACRIFICE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
            end
            ---@cast roomData RoomDataComponent
            local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

            local function can_place()
                local allowed = not roomFilter[RoomType.ROOM_SACRIFICE]
                if not allowed then
                    return false
                end

                local BASE_CHANCE = 7
                local RECOVERY_CHANCE = 4

                if rng:RandomInt(BASE_CHANCE) ~= 0 then
                    if rng:RandomInt(RECOVERY_CHANCE) ~= 0 then
                        return false
                    end

                    local recoveryCondition = PlayerManagerUtils.HasFullHeartsSoulHearts(playerManager, false) or
                        (PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_LAZARUS) or PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_LAZARUS2))

                    if not recoveryCondition then
                        return false
                    end
                end

                local necessaryCondition = true
                if not necessaryCondition then
                    return false
                end

                return true
            end

            local canPlace = can_place()
            if room then
                if canPlace then
                    LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
                else
                    LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
                end
            end
        end

        -- Place Library
        do
            local roomData = nil
            local shopLvl1 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV1)
            local shopLvl2 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV2)
            local shopLvl3 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV3)
            local shopLvl4 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV4)

            local shopLvl = shopLvl4 and 4 or shopLvl3 and 3 or shopLvl2 and 2 or shopLvl1 and 1 or 0
            local roomSubtype = rng:RandomInt(shopLvl + 1)

            roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_LIBRARY, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, roomSubtype, mode)
            ---@cast roomData RoomDataComponent
            local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

            local function can_place()
                local allowed = not roomFilter[RoomType.ROOM_LIBRARY]
                if not allowed then
                    return false
                end

                local BASE_CHANCE = 20
                local RECOVERY_CHANCE = 4

                if rng:RandomInt(BASE_CHANCE) ~= 0 then
                    if rng:RandomInt(RECOVERY_CHANCE) ~= 0 then
                        return false
                    end

                    local recoveryCondition = (gameStateFlags & GameStateFlag.STATE_BOOK_PICKED_UP) ~= 0
                    if not recoveryCondition then
                        return false
                    end
                end

                local necessaryCondition = true
                if not necessaryCondition then
                    return false
                end

                return true
            end

            local canPlace = can_place()
            if room then
                if canPlace then
                    LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
                else
                    LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
                end
            end
        end

        -- Place Curse
        do
            local myRNG = RNG(rng:Next(), 66)
            local voodooHead = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_VOODOO_HEAD)
            local roomSubtype = voodooHead and RoomSubType.CURSE_VOODOO_HEAD or RoomSubType.CURSE_NORMAL
            local roomCount = voodooHead and 2 or 1

            local function can_place()
                local allowed = not roomFilter[RoomType.ROOM_CURSE]
                if not allowed then
                    return false
                end

                local BASE_CHANCE = 2
                local RECOVERY_CHANCE = 1

                if myRNG:RandomInt(BASE_CHANCE) ~= 0 then
                    if myRNG:RandomInt(RECOVERY_CHANCE) ~= 0 then
                        return false
                    end

                    local recoveryCondition = true
                    if not recoveryCondition then
                        return false
                    end
                end

                local necessaryCondition = true
                if not necessaryCondition then
                    return false
                end

                return true
            end

            for _ = 1, roomCount, 1 do
                local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, myRNG:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_CURSE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, roomSubtype, mode)
                ---@cast roomData RoomDataComponent
                local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)
                local canPlace = can_place()

                if room then
                    if canPlace then
                        LevelRules.PlaceRoom(myContext, level, room, roomData, myRNG:GetSeed())
                    else
                        LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
                    end
                end
            end
        end

        -- Place Miniboss
        do
            local minibossFlag = -1
            local miniboss = -1
            local minibossDifficulty = stage >= LevelStage.STAGE4_1 and 10 or 1
            local minibossUltraPrideAllowed = effectiveStage >= LevelStage.STAGE2_1

            if minibossUltraPrideAllowed and rng:RandomInt(10) == 0 and (gameStateFlags & GameStateFlag.STATE_ULTRAPRIDE_SPAWNED) == 0 then
                miniboss = RoomSubType.MINIBOSS_ULTRA_PRIDE
                minibossFlag = GameStateFlag.STATE_ULTRAPRIDE_SPAWNED
                rng:Next() -- emulate the seed you would have gotten from normal pool selection
            else
                local superMinibossChance = 80
                if PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.WOMB) then
                    superMinibossChance = 30
                end

                if PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.EVERYTHING_IS_TERRIBLE) then
                    superMinibossChance = 10
                end

                if persistentGameData.m_eventCounters[EventCounter.BLUE_BABY_KILLS] + persistentGameData.m_eventCounters[EventCounter.LAMB_KILLS] ~= 0 then
                    superMinibossChance = 5
                end

                local superMiniBoss = rng:RandomInt(superMinibossChance) == 0
                local pool = {}

                for i = 1, MINIBOSSES, 1 do
                    if (gameStateFlags & MINIBOSSES[i][3]) == 0 then
                        table.insert(pool, i)
                    end
                end

                local poolNum = #pool
                if poolNum ~= 0 then
                    local id = pool[rng:RandomInt(poolNum) + 1]
                    local typeKey = superMiniBoss and 2 or 1
                    miniboss = MINIBOSSES[id][typeKey]
                    minibossFlag = MINIBOSSES[id][3]
                end
            end

            local room = nil
            local roomData = nil

            if miniboss > -1 then
                roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_MINIBOSS, RoomShape.NUM_ROOMSHAPES, 0, -1, minibossDifficulty, minibossDifficulty, 0, miniboss, mode)
                if not roomData then
                    roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_MINIBOSS, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, miniboss, mode)
                end

                if roomData then
                    room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)
                end
            end

            local function can_place()
                local allowed = not roomFilter[RoomType.ROOM_MINIBOSS]
                if not allowed then
                    return false
                end

                local BASE_CHANCE = 4
                local RECOVERY_CHANCE = 3

                if rng:RandomInt(BASE_CHANCE) ~= 0 then
                    if rng:RandomInt(RECOVERY_CHANCE) ~= 0 then
                        return false
                    end

                    local recoveryCondition = effectiveStage == LevelStage.STAGE1_1
                    if not recoveryCondition then
                        return false
                    end
                end

                local necessaryCondition = true
                if not necessaryCondition then
                    return false
                end

                return true
            end

            local canPlace = can_place()
            if room then
                ---@cast roomData RoomDataComponent
                if canPlace then
                    LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
                    gameStateFlags = gameStateFlags | minibossFlag
                    game.m_gameStateFlags = gameStateFlags
                    minibossNotPlaced = false
                else
                    LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
                end
            end
        end

        -- Place Challenge
        do
            local roomSubtype = level.m_hasBossChallenge and RoomSubType.CHALLENGE_BOSS or RoomSubType.CHALLENGE_NORMAL
            local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_CHALLENGE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, roomSubtype, mode)
            ---@cast roomData RoomDataComponent
            local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

            local function can_place()
                local allowed = not roomFilter[RoomType.ROOM_CHALLENGE]
                if not allowed then
                    return false
                end

                local BASE_CHANCE = 2

                if rng:RandomInt(BASE_CHANCE) ~= 0 then
                    local recoveryCondition = effectiveStage >= LevelStage.STAGE2_1
                    if not recoveryCondition then
                        return false
                    end
                end

                local necessaryCondition = PlayerManagerUtils.HasFullHeartsSoulHearts(playerManager, false) and effectiveStage > LevelStage.STAGE1_1
                if not necessaryCondition then
                    return false
                end

                return true
            end

            local canPlace = can_place()
            if room then
                if canPlace then
                    LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
                else
                    LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
                end
            end
        end

        -- Place Arcade or Chest
        do
            local cainBirthright = PlayerManagerUtils.AnyoneHasBirthright(myContext, playerManager, PlayerType.PLAYER_CAIN)
            local chestAllowed = not roomFilter[RoomType.ROOM_CHEST] and not cainBirthright
            local chestRecoveryCondition = PlayerManagerUtils.GetNumKeys(playerManager) >= 2
            local isChest = false
            local roomData = nil

            if (rng:RandomInt(10) == 0 or (rng:RandomInt(4) == 0 and chestRecoveryCondition)) and chestAllowed then
                roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_CHEST, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
                isChest = true
            else
                local roomSubtype = cainBirthright and RoomSubType.ARCADE_CAIN or RoomSubType.ARCADE_NORMAL
                roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ARCADE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, roomSubtype, mode)
                if not roomData and roomSubtype == RoomSubType.ARCADE_CAIN then
                    roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ARCADE, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, RoomSubType.ARCADE_NORMAL, mode)
                end
            end

            ---@cast roomData RoomDataComponent
            local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

            local function can_place()
                local evenStage = effectiveStage == LevelStage.STAGE1_2 or effectiveStage == LevelStage.STAGE2_2 or effectiveStage == LevelStage.STAGE3_2 or effectiveStage == LevelStage.STAGE4_2
                local isValidArcadeStage = evenStage or (cainBirthright or effectiveStage < LevelStage.STAGE6)

                local allowed
                local necessaryCondition

                if isChest then
                    allowed = chestAllowed
                    necessaryCondition = PlayerManagerUtils.GetNumKeys(playerManager) >= 2 and isValidArcadeStage
                else
                    allowed = not roomFilter[RoomType.ROOM_ARCADE]
                    necessaryCondition = PlayerManagerUtils.GetNumCoins(playerManager) >= 5 and isValidArcadeStage
                end

                return allowed and necessaryCondition
            end

            local canPlace = can_place()
            if room then
                if canPlace then
                    LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
                else
                    LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
                end
            end
        end
    end

    -- Place Bedroom
    if stage < LevelStage.STAGE4_1 then
        local barrenAllowed = not roomFilter[RoomType.ROOM_BARREN] and StageUtils.CanSpawnTrapDoor(myContext, level)
        local isaacsAllowed = not roomFilter[RoomType.ROOM_ISAACS]

        local bedroomType = RoomType.ROOM_BARREN
        if (rng:RandomInt(2) == 0 or not barrenAllowed) and isaacsAllowed then
            bedroomType = RoomType.ROOM_ISAACS
        end

        local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, bedroomType, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
        ---@cast roomData RoomDataComponent
        local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

        local function can_place()
            local allowed = not roomFilter[RoomType.ROOM_MINIBOSS]
            if not allowed then
                return false
            end

            local BASE_CHANCE = 50
            local RECOVERY_CHANCE = 5

            if rng:RandomInt(BASE_CHANCE) ~= 0 then
                if rng:RandomInt(RECOVERY_CHANCE) ~= 0 then
                    return false
                end

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

                local recoveryCondition = anyoneIsAtLowHealth
                if not recoveryCondition then
                    return false
                end
            end

            local necessaryCondition = true
            if not necessaryCondition then
                return false
            end

            return true
        end

        local canPlace = can_place()
        if room then
            if canPlace then
                LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
            else
                LevelGeneratorUtils.AddEndRoom(levelGenerator, room)
            end
        end
    end

    -- Evaluate Quest Requirements (Can FAIL)
    if QuestUtils.HasMirrorDimension(myContext, level) then
        questRoomCount = 1

        local roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, stageId, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, 0, 0, 0, RoomSubType.DOWNPOUR_MIRROR, mode)
        ---@cast roomData RoomDataComponent
        local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

        if not room then
            return false -- FAILURE
        end

        LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
    elseif QuestUtils.HasAbandonedMineshaft(myContext, level) then
        questRoomCount = 2

        local mineshaftRNG = RNG(rng:GetSeed(), 34)
        local roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, mineshaftRNG:Next(), true, stageId, StbType.MINES, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, 0, 0, 0, RoomSubType.DOWNPOUR_MIRROR, mode)
        ---@cast roomData RoomDataComponent
        local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

        if not room then
            return false -- FAILURE
        end

        LevelRules.PlaceRoom(myContext, level, room, roomData, mineshaftRNG:GetSeed())
    elseif QuestUtils.HasPhotoDoor(myContext, level) then
        questRoomCount = 1
    end

    -- Place Secret Room
    local secretAllowed = not roomFilter[RoomType.ROOM_SECRET]
    if secretAllowed then
        local secretRNG = RNG(secretSeed, 1)
        local secretRoomCount = 1

        if PlayerManagerUtils.AnyoneHasTrinket(myContext, playerManager, TrinketType.TRINKET_FRAGMENTED_CARD) then
            secretRoomCount = secretRoomCount + 1
        end

        if PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_LUNA) then
            secretRoomCount = secretRoomCount + 1
        end

        for i = 1, secretRoomCount, 1 do
            local roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, secretRNG:GetSeed(), true, stageId, StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
            ---@cast roomData RoomDataComponent
            local blacklist = build_secret_room_index_blacklist(level)
            local room = GenerationLogic.GetNewSecretRoom(levelGenerator, blacklist)

            if room then
                surpriseSecretListIdx = level.m_roomCount
                LevelRules.PlaceRoom(myContext, level, room, roomData, secretRNG:GetSeed())
            end

            secretRNG:Next()
        end
    end

    -- Place Forgotten Grave (Can FAIL)
    local hasForgottenGrave = stage == LevelStage.STAGE6 and stageType == StageType.STAGETYPE_ORIGINAL
    if hasForgottenGrave then
        local roomData = nil
        if PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.FORGOTTEN) then
            roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 3, 9, 1, 10, 0, -1, mode)
        else
            roomData = RoomConfigUtils.GetRoom(roomConfig, StbType.SPECIAL_ROOMS, RoomType.ROOM_DEFAULT, 3, mode)
        end
        ---@cast roomData RoomDataComponent
        local room = LevelGeneratorUtils.GetNewEndRoom(levelGenerator, roomData.m_shape, roomData.m_doors)

        if not room then
            return false -- FAILURE
        end

        LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
    end

    -- Place Ultra Secret Room
    local ultraSecretAllowed = not roomFilter[RoomType.ROOM_ULTRASECRET]
    if ultraSecretAllowed then
        local ultraSecretRNG = RNG(secretSeed, 71)
        local roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, ultraSecretRNG:GetSeed(), true, stageId, StbType.SPECIAL_ROOMS, RoomType.ROOM_ULTRASECRET, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
        if roomData then
            local blacklist = build_ultrasecret_room_index_blacklist(level)
            local room = GenerationLogic.GetNewUltraSecretRoom(levelGenerator, blacklist)

            if room then
                LevelRules.PlaceRoom(myContext, level, room, roomData, ultraSecretRNG:GetSeed())
                level.m_roomList[level.m_roomCount].m_group = 99
            end
        end
    end

    -- Place Default Rooms
    local startingRoomIdx = level.m_startingRoomIdx
    ---@type Pair<RoomDescriptorComponent, LevelGeneratorRoomComponent>[]
    local placedRooms = {}

    local remainingRooms = LevelGeneratorUtils.GetRemainingRooms(levelGenerator)
    for i = 1, #remainingRooms, 1 do
        local roomMinDifficulty = minDifficulty
        if (minDifficulty > 1 and rng:GetSeed() % 8 == 0) then
            roomMinDifficulty = 1
        end

        local room = remainingRooms[i]
        local roomGridIdx = LevelUtils.ToRoomIdx(room.m_position)
        local roomData = nil

        local isStartingRoom = startingRoomIdx == roomGridIdx and room.m_distanceFromStart == 0
        if isStartingRoom then
            local requestedStageId = StbType.SPECIAL_ROOMS
            local variant = 2

            if stage == LevelStage.STAGE6 then
                if stageType == StageType.STAGETYPE_ORIGINAL then
                    requestedStageId = StbType.DARK_ROOM
                    variant = 0
                elseif stageType == StageType.STAGETYPE_WOTL then
                    requestedStageId = StbType.CHEST
                    variant = 0
                end
            end

            roomData = RoomConfigUtils.GetRoom(roomConfig, requestedStageId, RoomType.ROOM_DEFAULT, variant, mode)
        else
            local minVariant = stage == LevelStage.STAGE6 and 1 or 0 -- 0 is the starting room in chapter 6 so avoid it
            roomData = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, stageId, RoomType.ROOM_DEFAULT, room.m_shape, minVariant, -1, roomMinDifficulty, maxDifficulty, room.m_requiredDoors, 0, mode)
        end

        if not roomData then
            local doorsString = RoomConfigUtils.DoorsToString(room.m_requiredDoors)
            Log.LogMessage(0, string.format("[warn] LevelGenerator could not find a required room (type=ROOM_DEFAULT, shape=%d, difficulty=%d-%d, doors=%s.\n", room.m_shape, roomMinDifficulty, maxDifficulty, doorsString))
            return false -- FAILURE
        end

        LevelRules.PlaceRoom(myContext, level, room, roomData, rng:GetSeed())
        local placedRoom = level.m_roomList[level.m_roomCount]
        table.insert(placedRooms, {placedRoom, room})
    end

    local nonRemainingRoomsCount = #levelGenerator.m_rooms - #remainingRooms
    for i = 1, nonRemainingRoomsCount, 1 do
        rng:Next()
    end

    -- Place quest rooms
    if questRoomCount > 0 then
        local questRoomsRNG = RNG(rng:GetSeed(), 41)
        RNGUtils.Shuffle(placedRooms, questRoomsRNG)

        local defaultStageID = stageId
        if stageId == StbType.DROSS then
            defaultStageID = StbType.DOWNPOUR
        elseif stageId == StbType.ASHPIT then
            defaultStageID = StbType.MINES
        elseif stageId == StbType.NECROPOLIS or stageId == StbType.DANK_DEPTHS then
            defaultStageID = StbType.DEPTHS
        end

        local blacklist = build_specialnormal_room_index_blacklist(level)
        local numPlacedRooms = #placedRooms
        local tries = #placedRooms + questRoomCount
        local i = 1
        local minVariant = stage == LevelStage.STAGE6 and 1 or 0 -- 0 is the starting room in chapter 6 so avoid it

        while (i <= tries and questRoomCount > 0) do
            local room = nil
            local roomDesc = nil
            local noPlacedRooms = i > numPlacedRooms

            if noPlacedRooms then
                room = GenerationLogic.CreateRandomEndRoom(levelGenerator, blacklist)
                if not room then
                    return false -- FAILURE
                end
            else
                roomDesc = placedRooms[i][1]
                room = placedRooms[i][2]
            end

            local roomMinDifficulty = minDifficulty
            if (minDifficulty > 1 and questRoomsRNG:GetSeed() % 8 == 0) then
                roomMinDifficulty = 1
            end

            local roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, questRoomsRNG:Next(), true, stageId, defaultStageID, RoomType.ROOM_DEFAULT, room.m_shape, minVariant, -1, roomMinDifficulty, maxDifficulty, room.m_requiredDoors, 1, mode)
            if not roomData then
                roomData = RoomConfigRules.GetRandomRoomFromOptionalStage(myContext, roomConfig, questRoomsRNG:Next(), true, stageId, defaultStageID, RoomType.ROOM_DEFAULT, room.m_shape, minVariant, -1, 1, 10, room.m_requiredDoors, 1, mode)
            end

            if roomData then
                -- newly created room
                if not roomDesc then
                    LevelRules.PlaceRoom(myContext, level, room, roomData, questRoomsRNG:Next())
                else
                    roomDesc.m_data = roomData
                    roomDesc.m_allowedDoors = roomData.m_doors
                end

                questRoomCount = questRoomCount - 1
            end

            i = i + 1
        end

        if questRoomCount > 0 then
            return false -- FAILURE
        end
    end

    -- Variable Reset, since we succeeded
    game.m_gameStateFlags = gameStateFlags | (GameStateFlag.STATE_DONATION_SLOT_BLOWN | GameStateFlag.STATE_SHOPKEEPER_KILLED)
    game.m_donationModGreed = 0

    -- SurpriseMiniboss Evaluation
    do
        local greedAvailable = (gameStateFlags & (GameStateFlag.STATE_GREED_SPAWNED | GameStateFlag.STATE_SUPERGREED_SPAWNED)) == 0
        greedAvailable = greedAvailable and minibossNotPlaced

        local anger = 1.0
        if (PlayerManagerUtils.GetNumCoins(playerManager) >= 20) then
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

        if rng:RandomFloat() < greedSurpriseChance and greedAvailable and surpriseSecretListIdx >= 0 and stage >= LevelStage.STAGE3_1 then
            local surpriseRNG = RNG(rng:GetSeed(), 12)
            greedAvailable = surpriseRNG:RandomInt(1000) == 0

            local surpriseSecretRoom = level.m_roomList[surpriseSecretListIdx]
            surpriseSecretRoom.m_flags = surpriseSecretRoom.m_flags | RoomDescriptor.FLAG_SURPRISE_MINIBOSS
        end

        if rng:RandomFloat() < greedSurpriseChance and greedAvailable and surpriseShopListIdx >= 0 and stage >= LevelStage.STAGE2_2 then
            local surpriseRNG = RNG(rng:GetSeed(), 12)
            surpriseRNG:Next()

            local surpriseShopRoom = level.m_roomList[surpriseShopListIdx]
            surpriseShopRoom.m_flags = surpriseShopRoom.m_flags | RoomDescriptor.FLAG_SURPRISE_MINIBOSS
        end
    end

    -- Place OffGridRooms
    local errorRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_ERROR_IDX, Dimension.CURRENT)
    ---@cast errorRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(errorRoom, rng)
    errorRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)

    local blackMarketRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_BLACK_MARKET_IDX, Dimension.CURRENT)
    ---@cast blackMarketRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(blackMarketRoom, rng)
    blackMarketRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_BLACK_MARKET, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)

    local dungeonRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_DUNGEON_IDX, Dimension.CURRENT)
    ---@cast dungeonRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(dungeonRoom, rng)
    dungeonRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_DUNGEON, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)

    local bossRushRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_BOSSRUSH_IDX, Dimension.CURRENT)
    ---@cast bossRushRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(bossRushRoom, rng)

    local onForgottenQuest = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1)
    if onForgottenQuest then
        rng:Next()
        bossRushRoom.m_data = RoomConfigUtils.GetRoom(roomConfig, StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSSRUSH, 0, mode)
    else
        bossRushRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSSRUSH, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, -1, mode)
    end

    local megaSatanRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_MEGA_SATAN_IDX, Dimension.CURRENT)
    ---@cast megaSatanRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(megaSatanRoom, rng)
    megaSatanRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSS, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, BossType.MEGA_SATAN, mode)

    local portalIdx = GridRooms.ROOM_BLUE_WOOM_IDX
    if stageId == StbType.BLUE_WOMB then
        portalIdx = GridRooms.ROOM_THE_VOID_IDX
    end

    local portalRoom = LevelUtils.GetRoomByIdx(level, portalIdx, Dimension.CURRENT)
    ---@cast portalRoom RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(portalRoom, rng)
    portalRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, StbType.BLUE_WOMB, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, 0, 0, 0, 1, mode)

    local shopLvl2 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV2)
    local shopLvl3 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV3)
    local shopLvl4 = PersistentDataUtils.Unlocked(myContext, persistentGameData, Achievement.STORE_UPGRADE_LV4)

    local evenUpgrades = 1
    if shopLvl2 then
        evenUpgrades = evenUpgrades + 1
    end
    if shopLvl4 then
        evenUpgrades = evenUpgrades + 1
    end

    local oddUpgrades = 1
    if shopLvl3 then
        oddUpgrades = oddUpgrades + 1
    end

    local secretShopRNG = RNG(rng:Next(), 19)
    local secretShopLevel = secretShopRNG:RandomInt(oddUpgrades) + secretShopRNG:RandomInt(evenUpgrades)
    local secretShop = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_SECRET_SHOP_IDX, Dimension.CURRENT)
    ---@cast secretShop RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(secretShop, secretShopRNG)
    secretShop.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, secretShopRNG:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SHOP, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, secretShopLevel, mode)

    local angelShopRNG = RNG(rng:Next(), 20)
    local angelShop = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_ANGEL_SHOP_IDX, Dimension.CURRENT)
    ---@cast angelShop RoomDescriptorComponent
    RoomDescriptorUtils.InitSeeds(angelShop, angelShopRNG)
    angelShop.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, angelShopRNG:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ANGEL, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, RoomSubType.ANGEL_STAIRWAY, mode)

    local hasMotherBossFight = (stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_1 and curseOfLabyrinth)) and isAltPath
    if hasMotherBossFight then
        rng:Next()
        local motherRoom = LevelUtils.GetRoomByIdx(level, GridRooms.ROOM_SECRET_EXIT_IDX, Dimension.CURRENT)
        ---@cast motherRoom RoomDescriptorComponent
        RoomDescriptorUtils.InitSeeds(motherRoom, rng)
        motherRoom.m_data = RoomConfigRules.GetRandomRoom(myContext, roomConfig, rng:Next(), true, stageId, RoomType.ROOM_BOSS, RoomShape.NUM_ROOMSHAPES, 0, -1, 1, 10, 0, BossType.MOTHER, mode)
    end

    return true
end

---@param myContext Context.Common
---@param level LevelComponent
---@param extraRNG RNG
local function GenerateDungeon(myContext, level, extraRNG)
    local isaac = myContext.manager
    local game = myContext.game
    local rng = level.m_generationRNG
    local stage = level.m_stage
    local stageType = level.m_stageType

    local playerManager = game.m_playerManager
    local roomConfig = game.m_roomConfig
    local bossPool = game.m_bossPool
    local persistentData = isaac.m_persistentGameData
    local difficulty = game.m_difficulty
    local curses = CurseUtils.GetCurses(myContext, level)
    local mode = GameUtils.GetMode(game)
    local challenge = game.m_challenge

    local altPath = LevelUtils.IsAltPath(level)
    local hasMirrorDimension = QuestUtils.HasMirrorDimension(myContext, level)
    local hasAbandonedMineshaft = QuestUtils.HasAbandonedMineshaft(myContext, level)
    local hasPhotoDoor = QuestUtils.HasPhotoDoor(myContext, level) and PersistentDataUtils.Unlocked(myContext, persistentData, Achievement.STRANGE_DOOR)
    local curseOfLabyrinth = (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0
    local curseOfLost = (curses & LevelCurse.CURSE_OF_THE_LOST) ~= 0
    local curseOfGiant = (curses & LevelCurse.CURSE_OF_GIANT) ~= 0
    local voodooHead = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_VOODOO_HEAD)

    --#region Room Count

    local roomCount = (stage * 10) // 3 + 5 + rng:RandomInt(2)
    roomCount = math.min(roomCount, 20)

    if altPath and (hasMirrorDimension or hasAbandonedMineshaft) then
        roomCount = roomCount - 3
    end

    if curseOfLabyrinth then
        roomCount = math.floor(roomCount * 1.8)
        roomCount = math.min(roomCount, 45)
    elseif curseOfLost then
        roomCount = roomCount + 4
    end

    if challenge == Challenge.CHALLENGE_XXXXXXXXL then
        roomCount = rng:RandomInt(5) + 40
    end

    if stage == LevelStage.STAGE7 then
        roomCount = rng:RandomInt(5) + 50
    end

    local hardModeRooms = extraRNG:RandomInt(2) + 2
    if difficulty == Difficulty.DIFFICULTY_HARD then
        roomCount = roomCount + hardModeRooms
    end

    if curseOfGiant then
        roomCount = (roomCount * 3) // 5
        roomCount = math.max(roomCount, 4)
    end

    --#endregion

    --#region Dead Ends

    local extraDeadEnds = stage == LevelStage.STAGE1_1 and 0 or 1
    local deadEnds = 5 + extraDeadEnds

    if curseOfLabyrinth then
        deadEnds = deadEnds + 1
    end

    if stage == LevelStage.STAGE7 then
        deadEnds = deadEnds + 2
    end

    if voodooHead then
        deadEnds = deadEnds + 1
    end

    if hasMirrorDimension or hasAbandonedMineshaft then
        deadEnds = deadEnds + 1
    end

    --#endregion

    local levelGen = LevelGeneratorModule.NewLevelGenerator(rng:Next())

    --#region GetDifficulty + GetRooms

    local minDifficulty
    local maxDifficulty
    local rooms
    local hardMode = difficulty == Difficulty.DIFFICULTY_HARD

    if curseOfLabyrinth or stage > LevelStage.STAGE4_2 then
        minDifficulty = hardMode and 5 or 1
        maxDifficulty = hardMode and 15 or 10
    else
        local evenStage = stage % 2 == 0
        if evenStage then
            minDifficulty = hardMode and 10 or 5
            maxDifficulty = hardMode and 15 or 10
        else
            minDifficulty = hardMode and 5 or 1
            maxDifficulty = hardMode and 10 or 5
        end
    end

    local stageId = RoomConfigUtils.GetStageId(stage, stageType, mode)

    if stage == LevelStage.STAGE7 then
        minDifficulty = 5
        maxDifficulty = 15
        rooms = RoomConfigUtils.GetVoidRooms(roomConfig, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, minDifficulty, maxDifficulty, 0, -1, mode)
    else
        rooms = RoomConfigUtils.GetRooms(roomConfig, stageId, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, minDifficulty, maxDifficulty, 0, -1, mode)
    end

    -- not enough rooms
    if #rooms < 20 then
        minDifficulty = 1
        maxDifficulty = 15

        if stage == LevelStage.STAGE7 then
            rooms = RoomConfigUtils.GetVoidRooms(roomConfig, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, minDifficulty, maxDifficulty, 0, -1, mode)
        else
            rooms = RoomConfigUtils.GetRooms(roomConfig, stageId, RoomType.ROOM_DEFAULT, RoomShape.NUM_ROOMSHAPES, 0, -1, minDifficulty, maxDifficulty, 0, -1, mode)
        end
    end

    --#endregion

    --#region Allowed Shape

    local numShapes = {}
    for i = 1, RoomShape.NUM_ROOMSHAPES, 1 do
        numShapes[i] = 0
    end

    for i = 1, #rooms, 1 do
        local room = rooms[i]
        numShapes[room.m_shape + 1] = numShapes[room.m_shape + 1] + 1
    end

    local allowedShapes = 0
    for shape = 1, RoomShape.NUM_ROOMSHAPES, 1 do
        allowedShapes = allowedShapes | (1 << shape)
    end

    local GIANT_BANNED_SHAPES = ~((1 << RoomShape.ROOMSHAPE_1x1) | (1 << RoomShape.ROOMSHAPE_IH) | (1 << RoomShape.ROOMSHAPE_IV))
    if curseOfGiant then
        allowedShapes = allowedShapes & GIANT_BANNED_SHAPES
    end

    --#endregion

    local placeRoomsContext = LevelGenerationContext.BuildPlaceRoomsContext(level, myContext)

    local tries = 0
    while true do
        BossPoolUtils.ResetLevelBlacklist(bossPool)

        -- does not, in fact, give up
        if tries > 99 then
            Log.LogMessage(3, "failed to generate level too often, giving up\n")
        end
        Log.LogMessage(0, "generate...\n")

        tries = tries + 1

        LevelGeneratorUtils.ResetBlockedPosition(levelGen)
        if hasPhotoDoor then
            LevelGeneratorUtils.BlockPosition(levelGen, {x = 6, y = 5})
        end

        local isXL = curseOfLabyrinth or challenge == Challenge.CHALLENGE_XXXXXXXXL
        local startPosition = {x = 6, y = 6}
        local startRoom = LevelGeneratorModule.NewRoom(startPosition, RoomShape.ROOMSHAPE_1x1)

        GenerationLogic.Generate(levelGen, roomCount, stage == LevelStage.STAGE6, isXL, stage == LevelStage.STAGE7, allowedShapes, deadEnds, startRoom)
        if levelGen.m_isUsable then
            Log.LogMessage(0, "generated level is not usable\n")
            goto continue -- FAILURE
        end

        local generatedDeadEnds = #levelGen.m_deadEndQueue
        if generatedDeadEnds < deadEnds then
            Log.LogMessage(0, string.format("not enough dead ends (%d/%d)\n", generatedDeadEnds, deadEnds))
            if tries >= 10 and tries % 5 == 0 and roomCount < 64 then
                roomCount = roomCount + 1
            end
            goto continue -- FAILURE
        end

        Log.LogMessage(0, "placing rooms...\n")
        LevelUtils.reset_dimension_lookup(level)
        level.m_roomCount = 0

        local success = place_rooms(placeRoomsContext, level, levelGen, minDifficulty, maxDifficulty)
        if success then
            break -- SUCCESS
        end

        LevelUtils.reset_room_list(level)
        ::continue:: -- FAILURE
    end

    if hasMirrorDimension then
        QuestGenerationLogic.GenerateMirrorWorld(myContext, level)
    elseif hasAbandonedMineshaft then
        QuestGenerationLogic.GenerateMinesDungeon(myContext, level)
    end

    BossPoolUtils.CommitLevelBlacklist(bossPool)
    Log.LogMessage(0, string.format("Map Generated in %d Loops\n", tries))
end

--#region Module

Module.GenerateDungeon = GenerateDungeon

--#endregion

return Module