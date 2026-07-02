--#region Dependencies

local IEntityNpc = require("Isaac.Interface.Entity_NPC")
local IPlayerManager = require("Isaac.Interface.PlayerManager")
local IPersistentGameData = require("Isaac.Interface.PersistentGameData")
local IGame = require("Isaac.Interface.Game")
local ILevel = require("Isaac.Interface.Level")
local IRoom = require("Isaac.Interface.Room")
local Log = require("General.Log")
local EntityIdentity = require("Isaac.Enums.EntityIdentity")

--#endregion

local eMomBossColor = EntityIdentity.eMomBossColor
local eMomsHeartBossColor = EntityIdentity.eMomsHeartBossColor

---@param ctx Context.Common
---@param npc Component.Entity.Npc
local function ChampionSetup(ctx, npc)
    local game = ctx.game
    local level = game.m_level
    local room = level.m_room
    local playerManager = game.m_playerManager
    local entityConfig = npc.m_config

    local rng = RNG(npc.m_initSeed, 1)

    local chance = 0.05

    if IPlayerManager.AnyoneHasCollectible(ctx, playerManager, CollectibleType.COLLECTIBLE_CHAMPION_BELT) then
        chance = 0.2
    end

    if level.m_stage == LevelStage.STAGE7 then
        chance = 0.75
    end

    local purpleHeartMultiplier = IPlayerManager.GetTrinketMultiplier(ctx, playerManager, TrinketType.TRINKET_PURPLE_HEART)
    if purpleHeartMultiplier then
        chance = chance * (purpleHeartMultiplier * 2)
    end

    local room_isInitialized = room.m_isInitialized
    if room_isInitialized then
        chance = chance * 0.2
    end

    if IGame.HasSeedEffect(game, SeedEffect.SEED_ALL_CHAMPIONS) then
        chance = 1.0
    end

    if not npc.m_isBoss then
        -- npc state
        local canBeChampion = entityConfig.canBeChampion and not npc.m_champion_isChampion

        -- world state
        canBeChampion = canBeChampion and
            not room_isInitialized and
            not IRoom.HasRoomConfigFlag(room, 4) and
            not (npc.m_type == EntityType.ENTITY_CLICKETY_CLACK and room.m_type == RoomType.ROOM_BOSS)

        -- chance check
        canBeChampion = canBeChampion and
            (rng:RandomFloat() < chance or
            game.m_challenge == Challenge.CHALLENGE_ULTRA_HARD or
            (game.m_victoryRun_currentLap > 0 and rng:RandomFloat() < 0.25))

        if canBeChampion then
            npc.m_champion_isChampion = true
        end
    else
        local numBossColors = #entityConfig.bossColors
        if npc.m_type == EntityType.ENTITY_BIG_HORN and npc.m_spawnerEntity.ref then
            numBossColors = 0
        else
            local persistentGameData = ctx.manager.m_persistentGameData
            -- defeated satan
            if IPersistentGameData.Unlocked(persistentGameData, ctx, Achievement.JUDAS) then
                local bossColor_chance = 0.1

                if IPersistentGameData.Unlocked(persistentGameData, ctx, Achievement.EVERYTHING_IS_TERRIBLE) then
                    bossColor_chance = 0.3
                end

                if game.m_difficulty == Difficulty.DIFFICULTY_GREEDIER then
                    bossColor_chance = 0.6
                end

                local bossColor_purpleHeartMultiplier = IPlayerManager.GetTrinketMultiplier(ctx, playerManager, TrinketType.TRINKET_PURPLE_HEART)
                if bossColor_purpleHeartMultiplier then
                    bossColor_chance = bossColor_chance * (bossColor_purpleHeartMultiplier * 2)
                end

                if game.m_challenge == Challenge.CHALLENGE_ULTRA_HARD or game.m_victoryRun_currentLap > 0 then
                    bossColor_chance = 1.0
                end

                local boss_rng = RNG(IRoom.GetSpawnSeed(room), 5)
                if boss_rng:RandomFloat() < bossColor_chance then
                    npc.m_subtype = boss_rng:RandomInt(numBossColors) + 1
                end

                -- ban red mom boss color in guardian challenge
                if entityConfig.id == EntityType.ENTITY_MOM and npc.m_subtype == eMomBossColor.RED and game.m_challenge == Challenge.CHALLENGE_GUARDIAN then
                    npc.m_subtype = eMomBossColor.NORMAL
                end
            end
        end

        -- force mausoleum mom boss
        if ILevel.IsAltPath(level) then
            local entityId = entityConfig.id
            if entityId == EntityType.ENTITY_MOM then
                npc.m_subtype = eMomBossColor.MAUSOLEUM
            elseif entityId == EntityType.ENTITY_MOMS_HEART then
                npc.m_subtype = eMomsHeartBossColor.MAUSOLEUM
            end
        end

        local bossColor = npc.m_subtype - 1
        if bossColor ~= -1 and bossColor < numBossColors then
            local colorConfig = entityConfig.bossColors[bossColor + 1]
            npc.m_bossColorIdx = bossColor

            if not (0 <= bossColor and bossColor < numBossColors) then
                Log.LogMessage(0, string.format("Invalid boss color idx: %d\n", bossColor))
                npc.m_bossColorIdx = -1
            else
                npc.m_sprite.Scale = npc.m_sprite.Scale * colorConfig.m_scaleMulti
                npc.m_maxHealth = npc.m_maxHealth * colorConfig.m_hpMulti
            end

            npc:ResetColor()
            IEntityNpc.load_graphics(ctx, npc, true)
            npc.m_sprite:SetFrame(npc.m_sprite:GetDefaultAnimationName(), 0.0)
        end
    end

    if not npc.m_champion_isChampion then
        return
    end

    local seed = rng:Next()
    IEntityNpc.MakeChampion(ctx, npc, seed, npc.m_champion_id, true)
end

---@class Gameplay.ChampionSetup
local Module = {}

--#region Module

Module.ChampionSetup = ChampionSetup

--#endregion

return Module