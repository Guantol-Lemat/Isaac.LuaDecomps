---@class Decomp.Player.TaintedCain
local TaintedCain = {}
Decomp.Player.TaintedCain = TaintedCain

local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_SFXManager = SFXManager()
local g_ItemConfig = Isaac.GetItemConfig()

---@param pickup EntityPickup
---@return boolean shouldSalvage
local function should_salvage(pickup)
    local collectibleConfig = g_ItemConfig:GetCollectible(pickup.SubType)

    return not collectibleConfig:HasTags(ItemConfig.TAG_QUEST) and g_Game.Challenge ~= Challenge.CHALLENGE_CANTRIPPED and
        g_Level:GetDimension() ~= Dimension.DEATH_CERTIFICATE and g_Level:GetCurrentRoomIndex() ~= GridRooms.ROOM_GENESIS_IDX
end

---@param player EntityPlayer
---@param pickup EntityPickup
---@return boolean overwriteLogic
function TaintedCain.HandleAddQueueItem(player, pickup) -- Called on Pickup-Player Collision when the Add to item queue logic is being executed after it has been determined that the collectible can be added
    if not should_salvage(pickup) then
        return false
    end

    player:SalvageCollectible(pickup.SubType, pickup.Position, pickup:GetDropRNG(), ItemPoolType.POOL_NULL)
    pickup:TryRemoveCollectible()
    g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, pickup.Position + Vector(0, 10.0), Vector(0, 0), nil, 0, Random())
    pickup.Timeout = 2
    g_SFXManager:Play(SoundEffect.SOUND_THUMBS_DOWN, 1.0, 2, false, 1.0)
    player:FlushQueueItem()

    return true
end