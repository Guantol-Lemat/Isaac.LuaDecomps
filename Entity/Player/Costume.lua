--#region Dependencies

local Enums = require("General.Enums")
local Log = require("General.Log")
local ItemConfigUtils = require("Isaac.ItemConfig.Utils")
local EntityConfigUtils = require("Config.EntityConfig.Utils")
local PlayerFactory = require("Entity.Player.Component")
local PlayerInventory = require("Mechanics.Player.Inventory")
local TemporaryEffectsUtils = require("Game.TemporaryEffects.Utils")
local ModManager = require("Isaac.ModManager.Module")
local FileManager = require("Engine.FileManager.Utils")

local eSpecialDailyRuns = Enums.eSpecialDailyRuns
--#endregion

local COSTUME_MODIFIERS = {
    [1] = {CollectibleType.COLLECTIBLE_BRIMSTONE, 2, NullItemID.ID_BRIMSTONE2},
    [2] = {CollectibleType.COLLECTIBLE_GUPPYS_EYE, 2, NullItemID.ID_DOUBLE_GUPPYS_EYE},
    [3] = {CollectibleType.COLLECTIBLE_GLASS_EYE, 2, NullItemID.ID_DOUBLE_GLASS_EYE},
}

local SKIN_COLOR_SUFFIX = {
    [SkinColor.SKIN_WHITE + 1] = "_white",
    [SkinColor.SKIN_BLACK + 1] = "_black",
    [SkinColor.SKIN_BLUE + 1] = "_blue",
    [SkinColor.SKIN_RED + 1] = "_red",
    [SkinColor.SKIN_GREEN + 1] = "_green",
    [SkinColor.SKIN_GREY + 1] = "_grey"
}

local s_rebuildingCostumeMap = false

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param item ItemConfigItemComponent
---@param itemStateOnly boolean
local function AddCostume(myContext, player, item, itemStateOnly) end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param item ItemConfigItemComponent
local function RemoveCostume(myContext, player, item) end

---@param myContext Context.Manager
---@param path string
---@param skinColor SkinColor | integer
---@param playerType PlayerType | integer
---@return string
---@return boolean uniqueSkinColor
---@return boolean uniquePlayerType
local function translate_costume_sprite_path(myContext, path, skinColor, playerType)
    local isaac = myContext.manager
    local uniqueSkinColor = false
    local uniquePlayerType = false

    if playerType ~= -1 then
        -- build unique playerType path and check if it exists
        local playerConfig = EntityConfigUtils.GetPlayer(isaac.m_entityConfig, playerType)
        local costumeSuffixName = playerConfig and playerConfig.m_costumeSuffixName or ""

        if costumeSuffixName ~= "" then
            -- find position of the last costumes/
            local pos = path:match(".*()costumes[/\\]")

            if pos then
                pos = pos + 8 -- place pos at the /
                local parentPath = path:sub(1, pos - 1)
                local relativePath = path:sub(pos)

                parentPath = parentPath .. "_" .. costumeSuffixName
                local fullPath = parentPath .. relativePath

                fullPath = ModManager.TryRedirectPath(isaac.m_modManager, fullPath)
                if FileManager.Exists(fullPath) then
                    path = fullPath
                    uniquePlayerType = true
                end
            end
        end
    end

    if skinColor ~= SkinColor.SKIN_PINK then
        -- build unique skinColor path and check if it exists
        local suffix = SKIN_COLOR_SUFFIX[skinColor + 1] or SKIN_COLOR_SUFFIX[SkinColor.SKIN_WHITE + 1]

        -- find last occurrence of '.'
        local pos = path:match(".*()[.]")
        if pos then
            local filePath = path:sub(1, pos - 1)
            local fileExtension = path:sub(pos)

            filePath = filePath .. suffix
            local fullPath = filePath .. fileExtension

            fullPath = ModManager.TryRedirectPath(isaac.m_modManager, fullPath)
            if FileManager.Exists(fullPath) then
                path = fullPath
                uniqueSkinColor = true
            end
        end
    end

    return path, uniqueSkinColor, uniquePlayerType
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
local function rebuild_costume_map(myContext, player)
    if (player.m_variant == PlayerVariant.CO_OP_BABY or player.m_isCoopGhost) or s_rebuildingCostumeMap then
        return
    end

    local itemConfig = myContext.manager.m_itemConfig

    ---@type NullItemID
    local jupiterBody = NullItemID.ID_JUPITER_BODY
    ---@type NullItemID
    local currentJupiterBody = NullItemID.ID_NULL
    local hasMegaMush = false
    local hasSamsonBerserk = false
    local hasBerserk = false
    local hasJupiter = false

    -- Get active costumes flags
    local costumeSprites = player.m_costumeSpriteDesc
    local canFly = player.m_canFly
    for i = 1, #costumeSprites, 1 do
        local costumeSprite = costumeSprites[i]
        local item = costumeSprite.m_itemConfig

        if item then
            if ItemConfigUtils.IsCollectible(item) then
                ---@type CollectibleType
                local id = item.m_id
                if id == CollectibleType.COLLECTIBLE_JUPITER then
                    hasJupiter = true
                elseif id == CollectibleType.COLLECTIBLE_PONY then
                    jupiterBody = NullItemID.ID_JUPITER_BODY_PONY
                elseif id == CollectibleType.COLLECTIBLE_WHITE_PONY then
                    jupiterBody = NullItemID.ID_JUPITER_BODY_WHITEPONY
                elseif id == CollectibleType.COLLECTIBLE_MEGA_MUSH then
                    hasMegaMush = true
                elseif id == CollectibleType.COLLECTIBLE_BERSERK then
                    hasBerserk = true
                end
            elseif item.m_itemType == ItemType.ITEM_NULL then
                ---@type NullItemID
                local id = item.m_id
                if NullItemID.ID_JUPITER_BODY <= id and id <= NullItemID.ID_JUPITER_BODY_WHITEPONY then
                    currentJupiterBody = id
                end

                if id == NullItemID.ID_BERSERK_SAMSON then
                    hasSamsonBerserk = true
                end
            end
        end

        local isAngelJupiter = canFly and costumeSprite.m_isFlying and (not item or
            (NullItemID.ID_JUPITER_BODY <= item.m_id and item.m_id <= NullItemID.ID_JUPITER_BODY_WHITEPONY)) -- pretty sure this is a bug as they don't check if it's a null item

        if isAngelJupiter then
            jupiterBody = NullItemID.ID_JUPITER_BODY_ANGEL
        end
    end

    if not hasJupiter then
        jupiterBody = NullItemID.ID_NULL
    end

    -- sync jupiterBody
    if jupiterBody ~= currentJupiterBody then
        for i = #costumeSprites, 1, -1 do
            local item = costumeSprites[i].m_itemConfig
            if not item or item.m_itemType ~= ItemType.ITEM_NULL then
                goto continue
            end

            local id = item.m_id
            if (NullItemID.ID_JUPITER_BODY <= id and id <= NullItemID.ID_JUPITER_BODY_WHITEPONY) then
                table.remove(costumeSprites, i)
            end
            ::continue::
        end

        if jupiterBody ~= NullItemID.ID_NULL then
            local costume = ItemConfigUtils.GetNullItem(itemConfig, jupiterBody)
            ---@cast costume ItemConfigItemComponent
            AddCostume(myContext, player, costume, false)
        end
    end

    local playerType = player.m_playerType
    local samsonBerserk = hasSamsonBerserk and playerType == PlayerType.PLAYER_SAMSON_B
    -- sync samson berserk
    if samsonBerserk ~= hasBerserk then
        local costume = ItemConfigUtils.GetNullItem(itemConfig, NullItemID.ID_BERSERK_SAMSON)
        ---@cast costume ItemConfigItemComponent
        if samsonBerserk then
            AddCostume(myContext, player, costume, false)
        else
            RemoveCostume(myContext, player, costume)
        end
    end

    local entityConfig = myContext.manager.m_entityConfig
    local playerConfig = EntityConfigUtils.GetPlayer(entityConfig, playerType)
    local headColor = playerConfig.m_skinColor
    local bodyColor = playerConfig.m_skinColor
    local headColorPriority = -1
    local bodyColorPriority = -1

    -- reset costume map
    local costumeMap = player.m_costumeMap
    for i = 0, 14, 1 do
        local mapEntry = costumeMap[i + 1]
        mapEntry.index = -1
        mapEntry.layerID = -1
        mapEntry.priority = -1
        mapEntry.isBodyLayer = not (i == 0 or (i > 3 and i ~= 11))
    end

    local it = 1
    local itEnd = #costumeSprites
    -- map costume sprites
    while it < itEnd do
        do
            local bodyIndex = it
            local headIndex = it
            local costumeSprite = costumeSprites[it]
            local item = costumeSprite.m_itemConfig
            local canApplyCostume = not player.m_hasCurseMistEffect or
                (item and item.m_itemType == ItemType.ITEM_NULL and item.m_id == playerConfig.m_costumeID)

            if not canApplyCostume then
                canApplyCostume = (ItemConfigUtils.IsCollectible(item) and item.m_id == CollectibleType.COLLECTIBLE_TRANSCENDENCE) and
                    TemporaryEffectsUtils.HasCollectibleEffect(player.m_temporaryEffects, CollectibleType.COLLECTIBLE_TRANSCENDENCE)
            end

            if canApplyCostume then
                canApplyCostume = not player.m_isCoopGhost and
                    (not hasMegaMush or (item and item.m_itemType == ItemType.ITEM_ACTIVE and item.m_id == CollectibleType.COLLECTIBLE_MEGA_MUSH)) and -- only apply MEGA MUSH costume when the player has mega mush
                    (not ((item and ItemConfigUtils.IsCollectible(item) and item.m_id == CollectibleType.COLLECTIBLE_ANEMIC)) or
                    (player.m_playerType ~= PlayerType.PLAYER_LAZARUS or player.m_playerType ~= PlayerType.PLAYER_LAZARUS2)) -- Don't apply anemic if lazarus
            end

            if not canApplyCostume then
                goto continue
            end

            local lastAppliedIsBodyLayer = false
            local appliedLayers = 0
            for t = 0, 14, 1 do
                local layer = player.m_sprite:GetLayer(t)
                local layerName = layer and layer:GetName() or ""
                local costumeLayer = costumeSprite.m_sprite:GetLayer(layerName)

                if not costumeLayer then
                    goto CONTINUE_LAYER_ITERATOR
                end

                local currentCostume = costumeMap[t + 1]
                local applicable = currentCostume.priority <= costumeSprite.m_priority and
                    (not currentCostume.isBodyLayer or (not player.m_canFly or costumeSprite.m_isFlying)) -- if body layer and player is flying the costume must be flying

                if applicable then
                    local isBodyLayer = currentCostume.isBodyLayer
                    local increaseIndex = appliedLayers ~= 0 and bodyIndex == headIndex and
                        t ~= 0 and lastAppliedIsBodyLayer ~= isBodyLayer

                    -- If the costume has both a head and body layer then there should be
                    -- two sprite descriptors next to each other, one for each.
                    if increaseIndex then
                        if isBodyLayer then
                            bodyIndex = bodyIndex + 1
                        else
                            headIndex = headIndex + 1
                        end
                    end

                    lastAppliedIsBodyLayer = isBodyLayer
                    appliedLayers = appliedLayers + 1

                    local index = isBodyLayer and bodyIndex or headIndex
                    currentCostume.index = index
                    currentCostume.layerID = costumeLayer:GetLayerID()
                    currentCostume.priority = costumeSprite.m_priority
                end

                -- overwrite skin color
                if costumeSprite.m_overwriteColor then
                    if t == 4 then
                        local higherPriority = headColorPriority < costumeSprite.m_priority
                        local overrideColor = higherPriority or applicable
                        if higherPriority then
                            headColorPriority = costumeSprite.m_priority
                        end
                        if overrideColor then
                            headColor = costumeSprite.m_defaultSkinColor
                        end
                    elseif t == 1 then
                        local higherPriority = headColorPriority < costumeSprite.m_priority
                        local overrideColor = higherPriority or applicable
                        if higherPriority then
                            headColorPriority = costumeSprite.m_priority
                        end
                        if overrideColor then
                            headColor = costumeSprite.m_defaultSkinColor
                        end
                    end
                end
                ::CONTINUE_LAYER_ITERATOR::
            end

            -- item skin color overwrite
            if costumeSprite.m_overwriteColor and item then
                local costume = item.m_costume
                if costume.m_forceHeadColor and headColorPriority < costume.m_priority then
                    headColor = costumeSprite.m_defaultSkinColor
                    headColorPriority = costume.m_priority
                end

                if costume.m_forceBodyColor and bodyColorPriority < costume.m_priority then
                    bodyColor = costumeSprite.m_defaultSkinColor
                    bodyColorPriority = costume.m_priority
                end
            end

            -- if the costume has a head and body layer then we already
            -- applied the next costumeSprite, skip it.
            it = math.max(bodyIndex, headIndex)
            ::continue::
        end
        it = it + 1
    end

    local shadowSkin = playerType == PlayerType.PLAYER_BLACKJUDAS or playerType == PlayerType.PLAYER_JUDAS_B
    -- init costume data
    for i = 0, 14, 1 do
        local mappedCostume = costumeMap[i + 1]
        local costumeIndex = mappedCostume.index
        if costumeIndex < 0 then
            goto continue
        end

        local costume = costumeSprites[costumeIndex + 1]
        local needsToUpdateSkin = (costume.m_hasSkinAlt and
            ((costume.m_skinColor ~= headColor and not mappedCostume.isBodyLayer) or
            (costume.m_skinColor ~= bodyColor and mappedCostume.isBodyLayer))) or
            costume.m_playerType ~= player.m_playerType

        if not needsToUpdateSkin then
            goto continue
        end

        local sprite = costume.m_sprite
        local animation = sprite:GetAnimation()
        local isPlaying = sprite:IsPlaying()
        local frame = sprite:GetFrame() -- technically incorrect (this returns a floored frame)

        local skinColor = headColor
        if (costume.m_skinColor ~= bodyColor and mappedCostume.isBodyLayer) then
            skinColor = bodyColor
        end

        local item = costume.m_itemConfig
        local edenHair = item.m_itemType == ItemType.ITEM_NULL and (item.m_id == NullItemID.ID_EDEN or item.m_id == NullItemID.ID_EDEN_B)

        if not edenHair then
            local altSkinColor = costume.m_hasSkinAlt and costume.m_defaultSkinColor ~= skinColor
            local targetSkinColor = altSkinColor and skinColor or SkinColor.SKIN_PINK

            -- init layer data (spritesheet and color)
            local layers = sprite:GetAllLayers()
            local altFound = false
            for t = 1, #layers, 1 do
                local layer = layers[i]
                local defaultPath = layer:GetDefaultSpritesheetPath()
                local path, uniqueSkinColor, uniquePlayerType = translate_costume_sprite_path(myContext, defaultPath, targetSkinColor, player.m_playerType)
                sprite:ReplaceSpritesheet(t - 1, path, false)

                -- black judas color modifier
                if not uniquePlayerType and shadowSkin then
                    layer:SetColor(Color(0.0, 0.0, 0.0, 1.0, 0.0314, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
                else
                    layer:SetColor(Color.Default)
                end

                if uniqueSkinColor and uniquePlayerType then
                    altFound = true
                end
            end

            if altSkinColor and not altFound then
                Log.LogMessage(0, string.format("Costume %s supports skin color alts but no alt spritesheet could be found! (skin color %d)\n", costume.m_sprite:GetFilename(), skinColor))
            end
        end

        costume.m_skinColor = skinColor
        costume.m_playerType = playerType
        sprite:LoadGraphics()

        -- restore previous state
        if isPlaying then
            sprite:Play(animation, false)
        else
            sprite:SetFrame(animation, frame)
        end
        ::continue::
    end

    -- sync player skin color
    if player.m_headColor ~= headColor or player.m_bodyColor ~= bodyColor then
        local hotPotatoUniqueSprite = myContext.game.m_challenge == Challenge.CHALLENGE_HOT_POTATO and playerType == PlayerType.PLAYER_THEFORGOTTEN_B
        local sprite = player.m_sprite

        if hotPotatoUniqueSprite then
            for i = 0, 14, 1 do
                sprite:ReplaceSpritesheet(i, "gfx/characters/costumes/character_016b_theforgotten_bomb.png", false)
            end
        elseif playerConfig.m_skinPath ~= "" then
            local headPath = ""
            local bodyPath = ""

            if player.m_headColor ~= headColor then
                headPath = translate_costume_sprite_path(myContext, playerConfig.m_skinPath, headColor, -1)
            end
            if player.m_bodyColor ~= bodyColor then
                bodyPath = translate_costume_sprite_path(myContext, playerConfig.m_skinPath, bodyColor, -1)
            end

            for i = 0, 14, 1 do
                local isBodyLayer = not (i == 0 or (i > 3 and i ~= 11))
                local path = isBodyLayer and bodyPath or headPath

                if path ~= "" then
                    sprite:ReplaceSpritesheet(i, path, false)
                end
            end
        end

        sprite:LoadGraphics()
        player.m_headColor = headColor
        player.m_bodyColor = bodyColor
    end

    for i = 0, 14, 1 do
        local costume = costumeMap[i + 1]
        local costumeIndex = costume.index
        if costumeIndex < 0 then
            goto continue
        end

        local costumeDesc = costumeSprites[costumeIndex + 1]
        local defaultAnimation = costume.isBodyLayer and "WalkDown" or "HeadDown"
        local sprite = costumeDesc.m_sprite

        sprite:SetFrame(defaultAnimation, 0)
        if sprite:GetAnimationData("SubAnim") then
            sprite:PlayOverlay("SubAnim", false)
        end
        ::continue::
    end

    s_rebuildingCostumeMap = false
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param item ItemConfigItemComponent
---@param itemStateOnly boolean
AddCostume = function (myContext, player, item, itemStateOnly)
    if player.m_variant == PlayerVariant.CO_OP_BABY or player.m_isCoopGhost then
        return
    end

    local modifier = 0
    if item.m_itemType == ItemType.ITEM_PASSIVE then
        local id = item.m_id
        if id == CollectibleType.COLLECTIBLE_BRIMSTONE then
            modifier = 1
        elseif id == CollectibleType.COLLECTIBLE_GUPPYS_EYE then
            modifier = 2
        elseif id == NullItemID.ID_DOUBLE_GLASS_EYE then
            modifier = 3
        end
    end

    if modifier > 0 then
        local collectibleType, num, costume = table.unpack(COSTUME_MODIFIERS[modifier])
        if PlayerInventory.NumCollectibleHeld(myContext, player, collectibleType, false) >= num then
            local newCostume = ItemConfigUtils.GetNullItem(myContext.manager.m_itemConfig, costume)
            ---@cast newCostume ItemConfigItemComponent
            item = newCostume -- will crash if the null item doesn't exist.
        end
    end

    if item.m_costume.m_anm2Path == "" then
        return
    end

    local id = item.m_id

    local affectsBackwardPlayer = player.m_valid and (item.m_tags & ItemConfig.TAG_LAZ_SHARED) ~= 0
    local backupPlayer = player.m_backupPlayer.ref
    ---@cast backupPlayer EntityPlayerComponent?
    if affectsBackwardPlayer and backupPlayer then
        AddCostume(myContext, backupPlayer, item, itemStateOnly)
    end

    local game = myContext.game
    local applyCostume = game.m_challenge ~= Challenge.CHALLENGE_GUARDIAN or
        (ItemConfigUtils.IsCollectible(item) and item.m_id == CollectibleType.COLLECTIBLE_HOLY_GRAIL)

    if not applyCostume then
        return
    end

    local alreadyAdded = false
    local costumeSpriteDesc = player.m_costumeSpriteDesc

    for i = #costumeSpriteDesc, 1, -1 do
        if costumeSpriteDesc[i].m_itemConfig == item then
            alreadyAdded = true
            table.remove(costumeSpriteDesc, i)
        end
    end

    if alreadyAdded then
        local displayName = ItemConfigUtils.GetDisplayName(item)
        Log.LogMessage(0, string.format("Adding costume for %d (%s) which was added before and never removed.\n", item.m_id, displayName))
    end

    local costumeDesc = PlayerFactory.CostumeSpriteDesc.Create(item)
    table.insert(costumeSpriteDesc, costumeDesc)

    local costume = item.m_costume
    costumeDesc.m_priority = costume.m_priority
    costumeDesc.m_isFlying = costume.m_isFlying
    costumeDesc.m_hasOverlay = costume.m_hasOverlay
    costumeDesc.m_defaultSkinColor = costume.m_skinColor
    costumeDesc.m_skinColor = costume.m_skinColor
    costumeDesc.m_hasSkinAlt = costume.m_hasSkinAlt
    costumeDesc.m_overwriteColor = costume.m_overwriteColor
    costumeDesc.m_itemStateOnly = itemStateOnly

    local halloweenSackHead = game.m_dailyChallenge.m_specialDailyChallenge == eSpecialDailyRuns.HALLOWEEN and
        ItemConfigUtils.IsCollectible(item) and id == CollectibleType.COLLECTIBLE_SACK_HEAD

    if halloweenSackHead then
        costumeDesc.m_priority = costumeDesc.m_priority + 3
    end

    local sprite = costumeDesc.m_sprite
    sprite:Load(costume.m_anm2Path, false)

    local edenHair = item.m_itemType == ItemType.ITEM_NULL and (id == NullItemID.ID_EDEN or id == NullItemID.ID_EDEN_B)
    if edenHair then
        local entityConfig = myContext.manager.m_entityConfig
        local edenHairSheet = EntityConfigUtils.GetRandomEdenHairSheet(entityConfig, player.m_initSeed)
        sprite:ReplaceSpritesheet(0, edenHairSheet, false)
    end

    sprite:LoadGraphics()

    local hasBodyLayer = false
    local hasHeadLayer = false
    local costumeMap = player.m_costumeMap
    for i = 0, 14, 1 do
        local layer = player.m_sprite:GetLayer(i)
        local layerName = layer and layer:GetName() or ""
        local costumeLayer = sprite:GetLayer(layerName)

        local playerCostumeEntry = costumeMap[i + 1]
        if costumeLayer then
            if playerCostumeEntry.isBodyLayer then
                hasBodyLayer = true
            else
                hasHeadLayer = true
            end
        end
    end

    if not hasBodyLayer and not hasHeadLayer then
        local displayName = ItemConfigUtils.GetDisplayName(item)
        Log.LogMessage(0, string.format("[warn] Costume for item %d (%s) has no layers!\n", id, displayName))
    elseif hasBodyLayer and hasHeadLayer then
        -- we need two costume sprites since head and body layers are not synced animation wise.
        local copy = PlayerFactory.CostumeSpriteDesc.Copy(costumeDesc)
        table.insert(costumeSpriteDesc, copy)
    end

    rebuild_costume_map(myContext, player)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
---@param item ItemConfigItemComponent
RemoveCostume = function(myContext, player, item)
end

---@param player EntityPlayerComponent
local function ClearCostumes(player)
end

---@param myContext Context.Common
---@param player EntityPlayerComponent
local function InitPlayerSkin(myContext, player)
end

local Module = {}

--#region Module

Module.AddCostume = AddCostume
Module.RemoveCostume = RemoveCostume
Module.ClearCostumes = ClearCostumes
Module.InitPlayerSkin = InitPlayerSkin

--#endregion

return Module