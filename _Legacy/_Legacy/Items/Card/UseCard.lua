local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_PersistentGameData = Isaac.GetPersistentGameData()

local function has_flags(bitset, flags)
    return (bitset & flags) ~= 0
end

local function has_all_flags(bitset, flags)
    return (bitset & flags) == flags
end

--#region Tarot Cards

---@param player EntityPlayer
---@param useFlag integer
---@return boolean? earlyReturn
local function use_card_fool(player, useFlag)
    if has_flags(useFlag, UseFlag.USE_CARBATTERY) then
        return true
    end

    g_Level.LeaveDoor = DoorSlot.NO_DOOR_SLOT
    g_Game:StartRoomTransition(g_Level:GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, Dimension.NORMAL)
    return false
end

---@param player EntityPlayer
---@param useFlag integer
---@return boolean? earlyReturn
local function use_card_magician(player, useFlag)
    if has_flags(useFlag, UseFlag.USE_CARBATTERY) then
        return true
    end

    if has_flags(player.TearFlags, TearFlags.TEAR_HOMING) then
        g_PersistentGameData:TryUnlock(Achievement.BABY_BENDER)
    end

    local effects = player:GetEffects()
    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, false, 1)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
        effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false, 1)
    end

    return false
end

--#endregion

--#region Soul Stones

---@param room Room
---@param player EntityPlayer
---@param rng RNG
---@param i integer
local function spawn_soul_keeper_coin(room, player, rng, i)
    local seed = rng:Next()
    local position = room:FindFreePickupSpawnPosition(player.Position, 40.0, false, false)
    ---@type EntityPickup -- Game just assumes the entity was spawned and is a pickup
    local coin = g_Game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, position, Vector(0, 0), player, 0, seed):ToPickup()
    coin:SetDropDelay(i - 1)
    coin:Update()
end

---@param player EntityPlayer
---@param useFlag integer
---@return boolean? earlyReturn
local function use_soul_keeper(player, useFlag)
    local room = g_Game:GetRoom()
    local rng = player:GetCardRNG(Card.CARD_SOUL_KEEPER)

    local coinCount = rng:RandomInt(25) + 1
    for i = 1, coinCount, 1 do
        spawn_soul_keeper_coin(room, player, rng, i)
    end
end

--#endregion

---@type table<Card | integer, fun(player: EntityPlayer, useFlags: integer): boolean?>
local s_CardUseLogic = {
    [Card.CARD_FOOL] = use_card_fool,
    [Card.CARD_MAGICIAN] = use_card_magician,
    [Card.CARD_SOUL_KEEPER] = use_soul_keeper,
}