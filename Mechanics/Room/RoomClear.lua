--#region Dependencies

local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils")
local RoomUtils = require("Game.Room.Utils")
local LuaCallbacks = require("LuaEngine.Callbacks")
local GameUtils = require("Game.Utils")
local SpawnLogic = require("Game.Spawn")
local PlayerManagerUtils = require("Game.PlayerManager.Utils")
local GameEnd = require("Game.End")
local PersistentGameDataUtils = require("Isaac.PersistentGameData.Utils")
local Progress = require("Isaac.PersistentGameData.Progress")
local LevelUtils = require("Game.Level.Utils")
local EntityUtils = require("Entity.Utils")
local PlayerUtils = require("Entity.Player.Utils")
local PickupInit = require("Entity.Pickup.Init")
local PickupUtils = require("Entity.Pickup.Utils")
local GenericPromptUtils = require("Game.GenericPrompt.Utils")
local QuestUtils = require("Mechanics.Game.Quest.Utils")
local ExtraBossRoom = require("Mechanics.Level.ExtraBossRoom")
local CurseUtils = require("Mechanics.Level.Curse.Utils")
local CollectiblePool = require("Game.Pools.ItemPool.CollectiblePool")
local CoopExtraItem = require("Mechanics.Pickup.CoopExtraItem.Logic")

local VectorZero = VectorUtils.VectorZero
--#endregion

---@class RoomContext.SpawnClearAward : Context.Common, GameContext.Spawn, RoomContext.SpawnGridEntity, PersistentDataContext.RecordPlayerCompletion, LevelContext.GetExtraBossRoomStage, LevelContext.Curses
---@field manager IsaacManager
---@field persistentGameData PersistentDataComponent
---@field achievementOverlay AchievementOverlayComponent
---@field game GameComponent
---@field level LevelComponent
---@field playerManager PlayerManagerComponent
---@field itemPool ItemPoolComponent

--- This is similar to Room::GetCenterPos but not quite.
---@param room RoomComponent
---@param shape RoomShape | integer
---@return Vector
local function get_award_position(room, shape)
    local gridIdx
    if shape == RoomShape.ROOMSHAPE_LBL then
        gridIdx = 132
    elseif shape == RoomShape.ROOMSHAPE_LBR then
        gridIdx = 119
    elseif shape == RoomShape.ROOMSHAPE_LTL then
        gridIdx = 328
    elseif shape == RoomShape.ROOMSHAPE_LTR then
        gridIdx = 315
    else
        local tileX = room.m_gridWidth // 2
        local tileY = room.m_gridHeight // 2
        gridIdx = RoomUtils.GetGridIndexByTile(room, Vector(tileX, tileY))
    end

    return RoomUtils.GetGridPosition(room, gridIdx)
end

---@param room RoomComponent
---@param position Vector
---@return Vector
local function fix_award_position(room, position)
    -- TODO
end

---@param room RoomComponent
---@param gridIdx integer
---@return integer
local function fix_trapdoor_pos(room, gridIdx)
end

---@param room RoomComponent
---@param gridIdx integer
---@return integer
local function fix_heaven_light_pos(room, gridIdx)

end

---@param myContext RoomContext.SpawnClearAward
---@param room RoomComponent
---@param rng RNG
local function trigger_unique_boss_award(myContext, room, rng)
    local persistentGameData = myContext.persistentGameData
    local itemPool = myContext.itemPool
    local playerManager = myContext.playerManager
    local isBossRush = room.m_type == RoomType.ROOM_BOSSRUSH

    local bossCollectibleId = 0
    local bossId = room.m_bossId

    if bossId == BossType.CONQUEST and CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_WHITE_PONY, true) then
        bossCollectibleId = CollectibleType.COLLECTIBLE_WHITE_PONY
    elseif bossId == BossType.HEADLESS_HORSEMAN and CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_PONY, true) then
        bossCollectibleId = CollectibleType.COLLECTIBLE_PONY
    elseif bossId == BossType.CHAD and CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_LITTLE_CHAD, true) then
        bossCollectibleId = CollectibleType.COLLECTIBLE_LITTLE_CHAD
        Progress.TryUnlock(persistentGameData, Achievement.LITTLE_CHAD)
    elseif bossId == BossType.GISH and CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_LITTLE_GISH, true) then
        bossCollectibleId = CollectibleType.COLLECTIBLE_LITTLE_GISH
        Progress.TryUnlock(persistentGameData, Achievement.LITTLE_GISH)
    elseif bossId == BossType.STEVEN and (CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_STEVEN, true) or CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_LITTLE_STEVEN, true)) then
        Progress.TryUnlock(persistentGameData, Achievement.LITTLE_STEVEN)
        if CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_LITTLE_STEVEN, true) and rng:RandomInt(6) ~= 0 then
            bossCollectibleId = CollectibleType.COLLECTIBLE_LITTLE_STEVEN
        else
            bossCollectibleId = CollectibleType.COLLECTIBLE_STEVEN
        end
    elseif (BossType.FAMINE <= bossId and bossId <= BossType.DEATH) or bossId == BossType.CONQUEST or bossId == BossType.HEADLESS_HORSEMAN then
        Progress.TryUnlock(persistentGameData, Achievement.BOOK_OF_REVELATIONS)
        if rng:RandomInt(2) ~= 0 then
            bossCollectibleId = CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES
        else
            bossCollectibleId = CollectibleType.COLLECTIBLE_CUBE_OF_MEAT
        end

        if PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_CUBE_OF_MEAT) then
            bossCollectibleId = CollectibleType.COLLECTIBLE_CUBE_OF_MEAT
        elseif PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES) then
            bossCollectibleId = CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES
        end
    elseif isBossRush and PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1) then
        bossCollectibleId = CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_2
    elseif bossId == BossType.BABY_PLUM and room.m_babyPlum_mercyTimer == -1 and CollectiblePool.CanSpawnCollectible(itemPool, CollectibleType.COLLECTIBLE_PLUM_FLUTE, true) then
        room.m_babyPlum_mercyTimer = 0
        Progress.TryUnlock(persistentGameData, Achievement.PLUM_FLUTE)
        bossCollectibleId = CollectibleType.COLLECTIBLE_PLUM_FLUTE
    end

    if bossCollectibleId ~= 0 then
        CollectiblePool.RemoveCollectible(itemPool, bossCollectibleId, false, false)
    else
        bossCollectibleId = RoomUtils.GetSeededCollectible(myContext, rng:Next(), false)
    end

    return bossCollectibleId
end

---@param myContext RoomContext.SpawnClearAward
---@param room RoomComponent
---@param rng RNG
---@param awardPosition Vector
---@param stage LevelStage | integer
---@param isLastBoss boolean
local function handle_boss_completion(myContext, room, rng, awardPosition, stage, isLastBoss)
    local game = myContext.game
    local level = myContext.level
    local playerManager = myContext.playerManager
    local persistentGameData = myContext.persistentGameData
    local roomType = room.m_type

    local trapdoorGridIdx = RoomUtils.GetGridIdx(room, awardPosition + Vector(0.0, -80.0))
    local singleBossCollectiblePosition = awardPosition + Vector(0.0, 80.0)
    local cantrippedCollectiblePosition = VectorUtils.Copy(singleBossCollectiblePosition)
    local leftCollectiblePosition = awardPosition + Vector(-40.0, 80.0)
    local rightCollectiblePosition = awardPosition + Vector(40.0, 80.0)

    local makeBossShopItem = false
    local shopItemId = -1 -- choose automatically
    if PlayerManagerUtils.AnyoneIsPlayerType(playerManager, PlayerType.PLAYER_KEEPER_B) then
        makeBossShopItem = true
    elseif (level.m_levelStateFlags & LevelStateFlag.STATE_SATANIC_BIBLE_USED) ~= 0 and roomType == RoomType.ROOM_BOSS then
        shopItemId = -2 -- choose automatically + force devil deal behavior
        makeBossShopItem = true
    end

    local isDarkRoomAvailable = LevelUtils.IsStageAvailable(myContext, LevelStage.STAGE5, StageType.STAGETYPE_ORIGINAL)
    local isChestAvailable = LevelUtils.IsStageAvailable(myContext, LevelStage.STAGE5, StageType.STAGETYPE_WOTL)
    local isVoidAvailable = LevelUtils.IsStageAvailable(myContext, LevelStage.STAGE7, StageType.STAGETYPE_ORIGINAL)

    local challengeParams = GameUtils.GetChallengeParams(game)
    local challengeEndNotReached = (not challengeParams.m_altersEndStage and true) or stage < challengeParams.m_endStage

    local achievementOverlay = myContext.achievementOverlay
    local itemPool = myContext.itemPool

    --#region Helper Functions

    ---@param position Vector
    local function spawn_big_chest_exit(position)
        achievementOverlay.disablePopups = true
        local seed = rng:Next()
        SpawnLogic.Spawn(myContext, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 0, seed, position, VectorZero, nil)
    end

    ---@param position Vector
    local function spawn_trophy(position)
        local seed = IsaacUtils.Random()
        SpawnLogic.Spawn(myContext, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY, 0, seed, position, VectorZero, nil)
    end

    ---@param position Vector
    ---@param challengeEnd boolean
    local function spawn_epilogue_end(position, challengeEnd)
        fix_award_position(room, position)
        if challengeEnd then
            spawn_trophy(position)
        else
            spawn_big_chest_exit(position)
        end
    end

    ---@param position Vector
    local function spawn_void_portal(position)
        position = RoomUtils.FindFreePickupSpawnPosition(room, position, 80.0, true, false)
        local gridIdx = RoomUtils.GetGridIdx(room, position)
        fix_trapdoor_pos(room, gridIdx)
        SpawnLogic.SpawnGridEntity(myContext, gridIdx, GridEntityType.GRID_TRAPDOOR, 0, IsaacUtils.Random(), 1)
    end

    ---@param collectibleId CollectibleType | integer
    ---@param position Vector
    ---@return EntityPickupComponent
    local function spawn_collectible(collectibleId, position)
        position = fix_award_position(room, position)

        local ent = SpawnLogic.Spawn(myContext, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleId, rng:Next(), position, VectorZero, nil)
        local collectible = EntityUtils.ToPickup(ent)
        assert(collectible, "Pickup is not an EntityPickup!")
        if makeBossShopItem then
            PickupInit.MakeShopItem(collectible, shopItemId)
        end
        CoopExtraItem.MakePickupCoopExtra(collectible)

        return collectible
    end

    ---@param position Vector
    ---@return EntityPickupComponent
    local function spawn_void_collectible(position)
        local randomPool = rng:RandomInt(17)
        if randomPool == 16 then
            randomPool = ItemPoolType.POOL_BOMB_BUM
        end

        local collectibleId = CollectiblePool.GetCollectible(myContext, itemPool, randomPool, rng:Next(), 0, CollectibleType.COLLECTIBLE_NULL)
        CollectiblePool.RemoveCollectible(itemPool, collectibleId, false, false)
        fix_award_position(room, position)

        local ent = SpawnLogic.Spawn(myContext, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleId, rng:Next(), position, VectorZero, nil)
        local collectible = EntityUtils.ToPickup(ent)
        assert(collectible, "Pickup is not an EntityPickup!")
        CoopExtraItem.MakePickupCoopExtra(collectible)

        return collectible
    end

    ---@param collectibleId CollectibleType | integer
    ---@param position Vector
    ---@return EntityPickupComponent
    local function spawn_photograph(collectibleId, position)
        fix_award_position(room, position)
        local ent = SpawnLogic.Spawn(myContext, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleId, rng:Next(), position, VectorZero, nil)
        CollectiblePool.RemoveCollectible(itemPool, collectibleId, false, false)

        local collectible = EntityUtils.ToPickup(ent)
        assert(collectible, "Pickup is not an EntityPickup!")
        collectible.m_cycle_cycleNum = 0
        CoopExtraItem.MakePickupCoopExtra(collectible)

        return collectible
    end

    --#endregion Helper Functions

    --#region Boss Completion Handlers

    local function default_boss_completion()
        if isLastBoss then
            -- Spawn trapdoor to next stage or trophy to end challenge
            if challengeEndNotReached then
                if not LevelUtils.TrapDoorHindersChallenge(game.m_challenge, challengeParams, level, stage) then
                    trapdoorGridIdx = fix_trapdoor_pos(room, trapdoorGridIdx)
                    local seed = IsaacUtils.Random()
                    SpawnLogic.SpawnGridEntity(myContext, trapdoorGridIdx, GridEntityType.GRID_TRAPDOOR, 0, seed, 0)
                end
            else
                awardPosition = fix_award_position(room, awardPosition)
                spawn_trophy(awardPosition)
            end
        end

        local bossCollectibleId = trigger_unique_boss_award(myContext, room, rng)

        if game.m_challenge == Challenge.CHALLENGE_CANTRIPPED then
            PickupInit.StartIgnoreModifiers()
            local cantrippedCollectible = spawn_collectible(CollectibleType.COLLECTIBLE_STARTER_DECK, cantrippedCollectiblePosition)
            PickupInit.EndIgnoreModifiers()
        else
            local options = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_THERES_OPTIONS)
            local position = options and leftCollectiblePosition or singleBossCollectiblePosition
            position = VectorUtils.Copy(position)
            local firstCollectible = spawn_collectible(bossCollectibleId, position)

            if options then
                local collectibleId = RoomUtils.GetSeededCollectible(myContext, rng:Next(), false)
                CollectiblePool.RemoveCollectible(itemPool, collectibleId, false, false)
                local secondCollectible = spawn_collectible(collectibleId, rightCollectiblePosition)
                local optionsIdx = PickupUtils.SetNewOptionsPickupIndex(firstCollectible)
                secondCollectible.m_optionsPickupIndex = optionsIdx
            end
        end
    end

    local function void_boss_completion()
        local options = PlayerManagerUtils.AnyoneHasCollectible(myContext, playerManager, CollectibleType.COLLECTIBLE_THERES_OPTIONS)

        local position = options and leftCollectiblePosition or singleBossCollectiblePosition
        position = VectorUtils.Copy(position)
        local firstCollectible = spawn_void_collectible(position)

        if options then
            local secondCollectible = spawn_void_collectible(rightCollectiblePosition)
            local optionsIdx = PickupUtils.SetNewOptionsPickupIndex(firstCollectible)
            secondCollectible.m_optionsPickupIndex = optionsIdx
        end
    end

    local function boss_rush_completion()
        Progress.RecordPlayerCompletion(myContext, CompletionType.BOSS_RUSH)
        Progress.IncreaseEventCounter(persistentGameData, EventCounter.BOSSRUSHS_CLEARED, 1)
        game.m_gameStateFlags = game.m_gameStateFlags | GameStateFlag.STATE_BOSSRUSH_DONE
        default_boss_completion()
    end

    local function chapter3_completion()
        Progress.TryUnlock(persistentGameData, Achievement.WOMB)
        Progress.TryUnlock(persistentGameData, Achievement.HORSEMEN)
        Progress.TryUnlock(persistentGameData, Achievement.CUBE_OF_MEAT)

        local chapter4PassageUnlocked = Progress.Unlocked(myContext, persistentGameData, Achievement.WOMB)
        local challengeForcesChapter4 = challengeParams.m_altersEndStage and (challengeParams.m_endStage > stage or challengeParams.m_isMegaSatan)

        if not (chapter4PassageUnlocked or challengeForcesChapter4) then
            GameEnd.End(game, Ending.EPILOGUE)
            return
        end

        if not challengeEndNotReached then
            spawn_trophy(awardPosition)
        else
            trapdoorGridIdx = fix_trapdoor_pos(room, trapdoorGridIdx)
            SpawnLogic.SpawnGridEntity(myContext, trapdoorGridIdx, GridEntityType.GRID_TRAPDOOR, 0, IsaacUtils.Random(), 0)
        end

        local collectiblePosition = Vector(320.0, 360.0)
        local polaroidAvailable = isChestAvailable and Progress.Unlocked(myContext, persistentGameData, Achievement.POLAROID)
        local negativeAvailable = isDarkRoomAvailable and Progress.Unlocked(myContext, persistentGameData, Achievement.NEGATIVE)

        if polaroidAvailable and negativeAvailable then
            -- Spawn Both
            local firstCollectible = spawn_photograph(CollectibleType.COLLECTIBLE_POLAROID, leftCollectiblePosition)
            local secondCollectible = spawn_photograph(CollectibleType.COLLECTIBLE_NEGATIVE, rightCollectiblePosition)
            local optionsIdx = PickupUtils.SetNewOptionsPickupIndex(firstCollectible)
            secondCollectible.m_optionsPickupIndex = optionsIdx
        elseif polaroidAvailable or negativeAvailable then
            -- Spawn One
            local collectibleId = polaroidAvailable and CollectibleType.COLLECTIBLE_POLAROID or CollectibleType.COLLECTIBLE_NEGATIVE
            spawn_photograph(collectibleId, collectiblePosition)
        else
            -- Spawn One Random
            local collectibleId = RoomUtils.GetSeededCollectible(myContext, rng:Next(), false)
            spawn_collectible(collectibleId, collectiblePosition)
        end

        -- Try spawn void portal
        if not challengeEndNotReached and isVoidAvailable then
            local highestDamage = 0
            local totalCollectibleCount = 0

            local players = playerManager.m_players
            for i = 1, #players, 1 do
                local player = players[i]
                if player.m_variant ~= PlayerVariant.PLAYER then
                    goto continue
                end

                local count = PlayerUtils.GetCollectibleCount(player)
                totalCollectibleCount = totalCollectibleCount + count
                highestDamage = math.max(player.m_damage, highestDamage)
                ::continue::
            end

            if rng:RandomInt(20) == 0 and (totalCollectibleCount > 19 or highestDamage > 100.0) then
                spawn_void_portal(awardPosition)
            end
        end
    end

    ---@param isBlueWomb boolean
    local function chapter4_completion(isBlueWomb)
        local chapter5PassageUnlocked = (isBlueWomb and Progress.GetEventCounter(persistentGameData, EventCounter.HUSH_KILLS) ~= 0) or Progress.Unlocked(myContext, persistentGameData, Achievement.IT_LIVES)
        local challengeForcesChapter5 = challengeParams.m_altersEndStage and (challengeParams.m_endStage > stage or challengeParams.m_isMegaSatan)

        -- Spawn chapter5 passage
        if not (chapter5PassageUnlocked or challengeForcesChapter5) or challengeEndNotReached then
            spawn_epilogue_end(awardPosition, not challengeEndNotReached)
        else
            if isDarkRoomAvailable then
                local passagePos = RoomUtils.GetCenterPos(room)
                passagePos.X = passagePos.X - 40.0
                passagePos.Y = 280.0 -- Hardcoded
                local passageIdx = RoomUtils.GetGridIdx(room, passagePos)
                passageIdx = fix_trapdoor_pos(room, passageIdx)
                SpawnLogic.SpawnGridEntity(myContext, passageIdx, GridEntityType.GRID_TRAPDOOR, 0, IsaacUtils.Random(), 0)
            end

            if isChestAvailable then
                local passagePos = RoomUtils.GetCenterPos(room)
                passagePos.X = passagePos.X + 40.0
                passagePos.Y = 280.0 -- Hardcoded
                local passageIdx = RoomUtils.GetGridIdx(room, passagePos)
                passageIdx = fix_heaven_light_pos(room, passageIdx)
                passagePos = RoomUtils.GetGridPosition(room, passageIdx)
                SpawnLogic.Spawn(myContext, EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, IsaacUtils.Random(), passagePos, VectorZero, nil)
            end
        end

        if isBlueWomb then
            Progress.RecordPlayerCompletion(myContext, CompletionType.HUSH)
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.HUSH_KILLS, 1)
            Progress.TryUnlock(persistentGameData, Achievement.VOID_FLOOR)
            game.m_gameStateFlags = game.m_gameStateFlags | GameStateFlag.STATE_BLUEWOMB_DONE
        else
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.MOM_KILLS, 1)
            Progress.RecordPlayerCompletion(myContext, CompletionType.MOMS_HEART)

            if rng:RandomInt(10) == 0 and challengeEndNotReached and isVoidAvailable then
                spawn_void_portal(awardPosition)
            end
        end
    end

    ---@param isEvilPath boolean
    local function chapter5_Completion(isEvilPath)
        if isEvilPath then
            Progress.RecordPlayerCompletion(myContext, CompletionType.SATAN)
            Progress.TryUnlock(persistentGameData, Achievement.JUDAS)
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.SATAN_KILLS, 1)
        else
            Progress.RecordPlayerCompletion(myContext, CompletionType.ISAAC)
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.ISAAC_KILLS, 1)
        end

        spawn_epilogue_end(awardPosition, not challengeEndNotReached)
        if rng:RandomInt(100) <= 14 and challengeEndNotReached and isVoidAvailable then
            spawn_void_portal(awardPosition)
        end
    end

    ---@param isEvilPath boolean
    local function chapter6_completion(isEvilPath)
        if isEvilPath then
            Progress.RecordPlayerCompletion(myContext, CompletionType.LAMB)
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.LAMB_KILLS, 1)
            Progress.TryUnlock(persistentGameData, Achievement.THE_GATE_IS_OPEN)

            if game.m_timeCounter < 36000 then -- 10 minutes
                Progress.TryUnlock(persistentGameData, Achievement.ACE_OF_DIAMONDS)
            end

            if (game.m_gameStateFlags & GameStateFlag.STATE_HEART_BOMB_COIN_PICKED) == 0 then
                Progress.TryUnlock(persistentGameData, Achievement.ACE_OF_SPADES)
            end

            local victoryLap = game.m_victoryRun_currentLap
            if victoryLap > 0 then
                local achievementUnlocksDisallowed = GameUtils.AchievementUnlocksDisallowed(myContext, game)
                PersistentGameDataUtils.SetReadOnly(persistentGameData, achievementUnlocksDisallowed)

                Progress.TryUnlock(persistentGameData, Achievement.GULP_PILL)
                if victoryLap > 1 then
                    Progress.TryUnlock(persistentGameData, Achievement.BUTTER)
                end
                if victoryLap > 2 then
                    Progress.TryUnlock(persistentGameData, Achievement.RERUNS)
                end

                PersistentGameDataUtils.SetReadOnly(persistentGameData, true)
            end

            if not GameUtils.InChallenge(game) and not GameUtils.IsGreedMode(game) then
                GenericPromptUtils.Show(game.m_victoryRun_prompt)
            end
        else
            Progress.RecordPlayerCompletion(myContext, CompletionType.BLUE_BABY)
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.BLUE_BABY_KILLS, 1)
        end

        spawn_epilogue_end(awardPosition, not challengeEndNotReached)
        if rng:RandomInt(5) == 0 and challengeEndNotReached and isVoidAvailable then
            spawn_void_portal(awardPosition)
        end
    end

    local function mega_satan_completion()
        Progress.IncreaseEventCounter(persistentGameData, EventCounter.MEGA_SATAN_KILLS, 1)
        Progress.AddBoss(persistentGameData, BossType.MEGA_SATAN)
        if not challengeParams.m_isMegaSatan then
            if rng:RandomInt(2) == 0 and challengeEndNotReached and isVoidAvailable then
                spawn_big_chest_exit(awardPosition)
                spawn_void_portal(awardPosition)
            else
                GameEnd.End(game, Ending.MEGA_SATAN)
            end
        else
            awardPosition = fix_award_position(room, awardPosition)
            spawn_trophy(awardPosition)
        end
    end

    local function chapter7_completion()
        Progress.RecordPlayerCompletion(myContext, CompletionType.DELIRIUM)
        Progress.TryUnlock(persistentGameData, Achievement.DELIRIOUS)
        Progress.TryUnlock(persistentGameData, Achievement.LIL_DELIRIUM)
        Progress.IncreaseEventCounter(persistentGameData, EventCounter.DELIRIUM_KILLS, 1)
        spawn_epilogue_end(awardPosition, not challengeEndNotReached)
    end

    --#endregion

    if roomType == RoomType.ROOM_BOSSRUSH then
        boss_rush_completion()
        return
    end

    -- Alt path unique bosses
    if level.m_roomIdx == GridRooms.ROOM_SECRET_EXIT_IDX and roomType == RoomType.ROOM_BOSS then
        if stage == LevelStage.STAGE3_2 then -- Mom's Heart
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.MOM_KILLS, 1)
            Progress.RecordPlayerCompletion(myContext, CompletionType.MOMS_HEART)
        elseif stage == LevelStage.STAGE4_2 then -- Mother
            Progress.RecordPlayerCompletion(myContext, CompletionType.MOTHER)
            Progress.IncreaseEventCounter(persistentGameData, EventCounter.MOTHER_KILLS, 1)
            spawn_epilogue_end(awardPosition, challengeParams.m_altersEndStage)
        end

        return
    end

    if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION and stage < LevelStage.STAGE4_2 then
        default_boss_completion()
        return
    end

    if room.m_bossId == BossType.MEGA_SATAN then
        mega_satan_completion()
        return
    end

    if stage == LevelStage.STAGE3_2 and isLastBoss then
        chapter3_completion()
        return
    end

    if (stage == LevelStage.STAGE4_2 and isLastBoss) or stage == LevelStage.STAGE4_3 then
        chapter4_completion(stage == LevelStage.STAGE4_3)
        return
    end

    if stage == LevelStage.STAGE5 then
        chapter5_Completion(level.m_stageType == StageType.STAGETYPE_ORIGINAL)
        return
    end

    if stage == LevelStage.STAGE6 then
        chapter6_completion(level.m_stageType == StageType.STAGETYPE_ORIGINAL)
        return
    end

    if stage == LevelStage.STAGE7 then
        if room.m_bossId == BossType.DELIRIUM then
            chapter7_completion()
            return
        end

        void_boss_completion()
        return
    end

    if stage > LevelStage.STAGE7 then
        return
    end

    default_boss_completion()
end

---@param myContext RoomContext.SpawnClearAward
---@param room RoomComponent
---@param rng RNG
---@param awardPosition Vector
local function spawn_boss_room_clear_award(myContext, room, rng, awardPosition)
    local game = myContext.game
    local level = myContext.level
    local playerManager = myContext.playerManager
    local persistentGameData = myContext.persistentGameData

    local stage
    local isLastBoss
    do
        stage = level.m_stage
        local roomIdx = level.m_roomIdx
        if roomIdx == GridRooms.ROOM_EXTRA_BOSS_IDX then
            local _, bossStage, _ = ExtraBossRoom.GetExtraBossRoomStage(myContext, stage, level.m_stageType)
            stage = bossStage
        else
            local curses = CurseUtils.GetCurses(myContext, level)
            if (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 or game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
                stage = stage + 1
            end
        end

        isLastBoss = RoomUtils.IsCurrentRoomLastBoss({level = level})
        if game.m_challenge == Challenge.CHALLENGE_RED_REDEMPTION then
            local currenRoomDesc = LevelUtils.GetRoomByIdx(level, roomIdx, Dimension.CURRENT)
            isLastBoss = currenRoomDesc.m_data.m_type == RoomType.ROOM_BOSS
        end
    end

    -- Handle Completion
    if isLastBoss and PlayerManagerUtils.IsCoopPlay(playerManager) then
        PlayerManagerUtils.ReviveCoopPlayers(playerManager)
    end

    handle_boss_completion(myContext, room, rng, awardPosition, stage, isLastBoss)

    -- Handle Stage Completion (yes any boss room completion counts as clearing the floor)
    Progress.AddStageCompleted(persistentGameData, stage)

    if stage == LevelStage.STAGE1_2 then
        Progress.TryUnlock(persistentGameData, Achievement.MONSTROS_LUNG)
    elseif stage == LevelStage.STAGE2_2 then
        Progress.TryUnlock(persistentGameData, Achievement.LIL_CHUBBY)
    elseif stage == LevelStage.STAGE6 then
        Progress.TryUnlock(persistentGameData, Achievement.ANGELS)
    end

    local switch_NoHitChapters = {
        [LevelStage.STAGE1_2] = {2, {Achievement.BASEMENT_BOY, Achievement.SPRINKLER}},
        [LevelStage.STAGE2_2] = {2, {Achievement.SPELUNKER_BOY, Achievement.TELEKINESIS}},
        [LevelStage.STAGE3_2] = {2, {Achievement.DARK_BOY, Achievement.LEPROSY}},
        [LevelStage.STAGE4_2] = {2, {Achievement.MAMAS_BOY, Achievement.POP}},
        [LevelStage.STAGE6] = {1, {Achievement.DEAD_BOY}}
    }

    local noHitChapterData = switch_NoHitChapters[stage]
    if noHitChapterData then
        local chapterLength, achievements = table.unpack(noHitChapterData, 1, 2)
        if game.m_lastLevelWithDamage <= stage - chapterLength then
            for i = 1, #achievements, 1 do
                Progress.TryUnlock(persistentGameData, achievements[i])
            end
        end
    end
end

---@param myContext RoomContext.SpawnClearAward
---@param room RoomComponent
---@param rng RNG
---@param awardPosition Vector
local function spawn_clear_award(myContext, room, rng, awardPosition)
    local game = myContext.game
    local level = myContext.level
    local persistentGameData = myContext.persistentGameData
    local roomType = room.m_type

    if GameUtils.IsGreedMode(game) then
        -- TODO: Greed Mode rewards
        return
    end

    if RoomUtils.IsBeastDungeon(room) then
        -- Beast Completion
        Progress.IncreaseEventCounter(persistentGameData, EventCounter.MOM_KILLS, 1)
        Progress.RecordPlayerCompletion(myContext, CompletionType.BEAST)
        Progress.IncreaseEventCounter(persistentGameData, EventCounter.BEAST_KILLS, 1)
        GameEnd.End(game, Ending.BEAST)
        return
    end

    if roomType == RoomType.ROOM_DUNGEON or QuestUtils.IsAbandonedMineshaft(myContext, level) then
        return
    end

    if roomType == RoomType.ROOM_BOSS and roomType == RoomType.ROOM_BOSSRUSH then
        spawn_boss_room_clear_award(myContext, room, rng, awardPosition)
        return
    end

    -- TODO: Spawn Normal clear award
end

---@param myContext RoomContext.SpawnClearAward
---@param room RoomComponent
local function SpawnClearAward(myContext, room)
    local roomDescriptor = room.m_roomDescriptor

    local rng = RNG(roomDescriptor.m_awardSeed, 35)
    local awardPosition = get_award_position(room, roomDescriptor.m_data.m_shape)

    -- the callback does not modify rng or position
    local skip = LuaCallbacks.SpawnClearAward(rng, awardPosition)
    if skip then
        return
    end

    spawn_clear_award(myContext, room, rng, awardPosition)
    roomDescriptor.m_awardSeed = rng:GetSeed()
end

local Module = {}

--#region Module

Module.SpawnClearAward = SpawnClearAward

--#endregion

return Module