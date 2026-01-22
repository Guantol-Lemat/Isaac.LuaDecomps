--#region Dependencies

local NetManagerUtils = require("Isaac.NetManager.Utils")
local EntityManagerUtils = require("Game.Room.EntityManager.Utils")
local EntityUtils = require("Entity.Common.Utils")
local HudUtils = require("Game.HUD.Utils")
local Screen = require("Isaac.Screen")

--#endregion

---@class EntityManagerLogic
local Module = {}

---@class EntityManagerContext.Update
---@field manager IsaacManager
---@field game GameComponent
---@field netManager NetManagerComponent

---@param entity EntityComponent
---@param isTransition boolean
---@return boolean
local function should_update_entity(entity, isTransition)
    local flags = entity.m_flags
    if (flags & (EntityFlag.FLAG_RENDER_FLOOR | EntityFlag.FLAG_NO_REMOVE_ON_TEX_RENDER)) == EntityFlag.FLAG_RENDER_FLOOR then
        return false
    end

    if isTransition and (flags & EntityFlag.FLAG_TRANSITION_UPDATE == 0) then
        return false
    end

    return true
end

---@class EntityManagerLogic.detail.EnemyMetadata
---@field aliveEnemyCount integer
---@field aliveBossCount integer
---@field maxBossBarHealth integer
---@field bossBarHealth integer
---@field damageTakenThisFrame number

---@param context EntityManagerContext.Update
---@param entity EntityComponent
---@param isTransition boolean
---@param enemyMetadata EntityManagerLogic.detail.EnemyMetadata
local function update_entity(context, entity, isTransition, enemyMetadata)
    if not entity.m_exists then
        return
    end

    local preTotalDamageTaken = 0.0

    if EntityUtils.IsEnemy(entity) then
        local npc = EntityUtils.ToNPC(entity)
        assert(npc ~= nil, "NPC is not and EntityNPC!")
        preTotalDamageTaken = npc.m_totalDamageTaken
    end

    if should_update_entity(entity, isTransition) then
        -- TODO: Entity:Update()
        if not entity.m_exists then
            return
        end
    end

    -- continue to process alive enemies
    if not entity:CanShutDoors() or entity.m_type == EntityType.ENTITY_DARK_ESAU then
        return
    end

    enemyMetadata.aliveEnemyCount = enemyMetadata.aliveEnemyCount + 1

    if entity:IsBoss() and entity.m_flags & (EntityFlag.FLAG_BOSSDEATH_TRIGGERED | EntityFlag.FLAG_DONT_COUNT_BOSS_HP) == 0 then
        enemyMetadata.aliveBossCount = enemyMetadata.aliveBossCount + 1
        if EntityUtils.GetFrameCount({frameCount = context.game.m_frameCount}, entity) > 0 then
            enemyMetadata.bossBarHealth = enemyMetadata.bossBarHealth + math.max(entity.m_health, 0.0)
            enemyMetadata.maxBossBarHealth = enemyMetadata.maxBossBarHealth + entity.m_maxHealth
        end
    end

    if not EntityUtils.IsEnemy(entity) or entity.m_flags & EntityFlag.FLAG_FRIENDLY ~= 0 then
        return
    end

    -- if not main pin
    if entity.m_type == EntityType.ENTITY_PIN and EntityUtils.DoesEntityShareStatus(entity) and EntityUtils.GetLastParent(entity) ~= entity then
        return
    end

    local npc = EntityUtils.ToNPC(entity)
    assert(npc ~= nil, "NPC is not and EntityNPC!")

    local postTotalDamageTaken = math.min(npc.m_totalDamageTaken, npc.m_maxHealth)
    local damageTaken = math.max(postTotalDamageTaken - preTotalDamageTaken, 0.0)

    enemyMetadata.damageTakenThisFrame = enemyMetadata.damageTakenThisFrame + damageTaken
end

local function render_backdrop_entities(entityManager)
    local renderList = entityManager.m_renderEL

    local shouldRenderFloor = false
    local shouldRenderWall = false

    for i = 1, #renderList, 1 do
        local entity = renderList[i]
        if not entity.m_exists then
            goto continue
        end

        if entity.m_flags & EntityFlag.FLAG_RENDER_FLOOR ~= 0 then
            shouldRenderFloor = true
        end
        if entity.m_flags & EntityFlag.FLAG_RENDER_WALL ~= 0 then
            shouldRenderWall = true
        end

        if shouldRenderFloor and shouldRenderWall then
            break
        end
        ::continue::
    end

    if not shouldRenderFloor and not shouldRenderWall then
        return
    end

    local renderOffset = Screen.GetRenderPosition(Vector(-20.0, 60.0), true)

    -- TODO: Render Call Render
end

---@param context EntityManagerContext.Update
---@param entityManager EntityManagerComponent
---@param isTransition boolean
local function Update(context, entityManager, isTransition)
    local game = context.game
    local netManager = context.netManager
    local isNetPlay = NetManagerUtils.IsNetPlay(netManager)

    if isNetPlay then
        -- TODO: NetPlay related checksums
    end

    EntityManagerUtils.ClearResults(entityManager)

    local enemyData = {
        aliveEnemyCount = 0,
        aliveBossCount = 0,
        maxBossBarHealth = 0,
        bossBarHealth = 0,
    }

    local entityRemoved = false
    local entityBaited = false

    local updateList = entityManager.m_updateEL
    local entities = updateList.data
    local lastEntity = entities[updateList.size] -- update until this entity, do not update newly spawned entities

    assert(updateList.size ~= 0, "EntityList: e_update is empty!")

    -- Pre Update
    do
        local i = 1
        local entity
        repeat
            entity = entities[i]
            do
                if not entity.m_exists then
                    goto continue
                end

                if not should_update_entity(entity, isTransition) then
                    goto continue
                end

                -- TODO: Entity:PreUpdate()
                ::continue::
            end
            i = i + 1
        until entity == lastEntity or i > updateList.size
    end

    do
        local i = 1
        local entity
        -- Update
        repeat
            entity = entities[i]
            update_entity(context, entity, isTransition, enemyData)

            if not entity.m_exists then
                entityRemoved = true
            end

            if entity.m_flags & EntityFlag.FLAG_BAITED ~= 0 then
                entityBaited = true
            end

            if isNetPlay then
                -- TODO: Checksum Entity
            end
            i = i + 1
        until entity == lastEntity or i > updateList.size
    end

    local playerManager = game.m_playerManager
    local possessors = playerManager.m_possessors

    for i = 1, #possessors, 1 do
        local possessor = possessors[i]
        -- TODO: Entity:Update()
    end

    local manager = context.manager
    if not manager.m_options.m_enableInterpolation then
        local players = playerManager.m_players
        for i = 1, #players, 1 do
            -- TODO: Interpolation Update and GridCollision
        end

        for i = 1, #possessors, 1 do
            -- TODO: Interpolation Update
        end
    end

    entityManager.m_aliveEnemyCount = enemyData.aliveEnemyCount + entityManager.m_addedEnemies
    entityManager.m_addedEnemies = 0
    entityManager.m_aliveBossCount = enemyData.aliveBossCount + entityManager.m_addedBosses
    entityManager.m_addedBosses = 0
    entityManager.m_enemyDamageInflicted = enemyData.damageTakenThisFrame

    entityManager.m_entityBaited = entityBaited
    local hudHealth
    if enemyData.aliveBossCount <= 0 then
        hudHealth = -1.0
        entityManager.m_maxBossBarHealth = 0.0
    else
        local maxHealth = math.max(enemyData.maxBossBarHealth, entityManager.m_maxBossBarHealth)
        entityManager.m_maxBossBarHealth = maxHealth
        hudHealth = enemyData.bossBarHealth / maxHealth
    end

    HudUtils.SetBossHealth(game.m_hud, hudHealth)
    local renderList = entityManager.m_renderEL

    if renderList.size ~= 0 then
        render_backdrop_entities(entityManager)
    end

    -- Commit remove
    if entityRemoved then
        for i = updateList.size, 1, -1 do
            local entity = updateList.data[i]
            if not entity.m_exists then
                -- TODO: EL::Remove
            end
        end

        for i = renderList.size, 1, -1 do
            local entity = renderList.data[i]
            if not entity.m_exists then
                -- TODO: EL::Remove
            end
        end

        local wispCache = entityManager.m_wispCache
        for i = wispCache.size, 1, -1 do
            local wisp = wispCache.data[i]
            if not wisp.m_exists then
                -- TODO: EL::Remove
            end
        end

        local mainLists = entityManager.m_mainEL
        for i = mainLists.size, 1, -1 do
            local entity = mainLists.data[i]
            if not entity.m_exists then
                entity:ClearReferences()
                entity.m_valid = false
                -- TODO: EL::Remove
            end
        end

        local persistentLists = entityManager.m_persistentEL
        for i = persistentLists.size, 1, -1 do
            local entity = persistentLists.data[i]
            if not entity.m_exists then
                entity:ClearReferences()
                local wasValid = entity.m_valid
                entity.m_valid = false

                if wasValid and entity.m_type == EntityType.ENTITY_PLAYER then
                    entity:Free()
                end
                -- TODO: EL::Remove
            end
        end
    end

    if not isTransition then
        -- TODO: collide
    end

    -- TODO: render sort

    if isNetPlay then
        -- TODO: Checksum related
    end
end

Module.Update = Update

--#endregion

return Module