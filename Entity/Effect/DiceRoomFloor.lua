---@class Datamines.Entity.Effect.DiceRoomFloor
local DiceRoomFloor = {}

local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_Seeds = g_Game:GetSeeds()

DiceRoomFloor.TYPE = EntityType.ENTITY_EFFECT
DiceRoomFloor.VARIANT = EffectVariant.DICE_FLOOR

---@param player EntityPlayer
---@return EntityPlayer mainPlayer
local function EntityPlayer_GetMainPlayer(player)
    local twin = player:GetOtherTwin()
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and twin ~= nil then
        return twin
    end

    return player
end

---@param level Level
---@return boolean isAltPath
local function Level_IsAltPath(level)
    local stageType = level:GetStageType()
    return stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
end

---@param level Level
---@return integer effectiveStage
local function Level_GetEffectiveStage(level)
    local stage = level:GetStage()
    if Level_IsAltPath(level) then
        return stage + 1
    end

    return stage
end

--#region Dice Effects

---@param entity EntityEffect
---@param player EntityPlayer
local function dice_effect_1(entity, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D4, UseFlag.USE_NOANIM | UseFlag.USE_REMOVEACTIVE)
end

---@param entity EntityEffect
---@param player EntityPlayer
local function dice_effect_2(entity, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D20, UseFlag.USE_NOANIM)
end

---@param entity EntityEffect
---@param player EntityPlayer
local function dice_effect_3(entity, player)
    dice_effect_2(entity, player)
    g_Game:RerollLevelPickups(entity.InitSeed)
end

---@param entity EntityEffect
---@param player EntityPlayer
local function dice_effect_4(entity, player)
    g_Game:RerollLevelCollectibles()
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM)
end

---@param entity EntityEffect
---@param player EntityPlayer
local function dice_effect_5(entity, player)
    local stage = Level_GetEffectiveStage(g_Level)
    g_Seeds:ForgetStageSeed(stage)
    g_Game:StartStageTransition(true, 0, nil) --- This is a broken function in regular repentance
end

---@param entity EntityEffect
---@param player EntityPlayer
local function dice_effect_6(entity, player)
    dice_effect_3(entity, player)
    dice_effect_4(entity, player)

    for i = 0, g_Game:GetNumPlayers(), 1 do
        local playerIt = Isaac.GetPlayer(i)
        if playerIt.Variant == 0 then
            dice_effect_1(entity, playerIt)
        end
    end
end

---@type fun(entity: EntityEffect, player: EntityPlayer)[]
local s_DiceEffects = {
    [0] = dice_effect_1,
    [1] = dice_effect_2,
    [2] = dice_effect_3,
    [3] = dice_effect_4,
    [4] = dice_effect_5,
    [5] = dice_effect_6
}

--#endregion

--#region Update

---@param entity EntityEffect
---@return boolean shouldEvaluate
local function should_evaluate_dice_room_floor(entity)
    return not g_Game:GetRoom():IsSacrificeDone() and entity.FrameCount > 15
end

---@param player EntityPlayer
---@return boolean canTrigger
local function can_player_trigger_dice_effect(player)
    return player.Variant == 0 and player.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE
end

---@param entity EntityEffect
---@param player EntityPlayer
---@return boolean inRange
local function is_player_in_dice_floor_range(entity, player)
    local diff = player.Position - entity.Position
    return math.abs(diff.X) < 75.0 and math.abs(diff.Y) < 75.0
end

---@param entity EntityEffect
---@param player EntityPlayer
local function trigger_dice_effect(entity, player)
    g_Game:GetRoom():SetSacrificeDone(true)
    g_Game:Darken(1.0, 60)
    g_Game:ShakeScreen(50)

    local diceEffect = s_DiceEffects[entity.SubType]
    if diceEffect then
        diceEffect(entity, EntityPlayer_GetMainPlayer(player))
    end
end

---@param entity EntityEffect
---@param player EntityPlayer
---@return boolean triggered
local function try_trigger_dice_effect(entity, player)
    if not can_player_trigger_dice_effect(player) then
        return false
    end

    if not is_player_in_dice_floor_range(entity, player) then
        return false
    end

    trigger_dice_effect(entity, player)
    return true
end

---@param entity EntityEffect
function DiceRoomFloor.Update(entity)
    if not should_evaluate_dice_room_floor(entity) then
        return
    end

    for i = 0, g_Game:GetNumPlayers(), 1 do
        if try_trigger_dice_effect(entity, Isaac.GetPlayer(i)) then
            break
        end
    end
end

--#endregion

---@param rng RNG
---@return integer subType
function DiceRoomFloor.GetRandomSubType(rng)
    return rng:RandomInt(6)
end

return DiceRoomFloor