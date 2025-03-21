---@class Decomp.Room.SuperSecret
local SuperSecretRoom = {}
Decomp.Room.SuperSecret = SuperSecretRoom

require("Lib.EntityPickup")

local Lib = Decomp.Lib

local g_Game = Game()
local g_Level = g_Game:GetLevel()

local s_VariantToHeartType = {
    [0] = HeartSubType.HEART_FULL,
    [1] = HeartSubType.HEART_ETERNAL,
    [16] = HeartSubType.HEART_ETERNAL,
    [6] = HeartSubType.HEART_BLACK,
    [13] = HeartSubType.HEART_BLACK,
    [12] = HeartSubType.HEART_SOUL,
    [23] = HeartSubType.HEART_BONE,
}

local s_VariantToHeartType_Greed = {
    [0] = HeartSubType.HEART_FULL,
    [4] = HeartSubType.HEART_SOUL,
    [5] = HeartSubType.HEART_BLACK,
    [24] = HeartSubType.HEART_ETERNAL,
    [25] = HeartSubType.HEART_HALF
}

---@return HeartSubType? heartType
function SuperSecretRoom.GetHeartType()
    local roomDesc = g_Level:GetCurrentRoomDesc()
    local roomVariant = roomDesc.Data.Variant

    local switchTable = g_Game:IsGreedMode() and s_VariantToHeartType_Greed or s_VariantToHeartType
    ---@type HeartSubType?
    local heartSubType = switchTable[roomVariant]

    if heartSubType and not Lib.EntityPickup.IsAvailable(PickupVariant.PICKUP_HEART, heartSubType) then
        heartSubType = nil
    end

    return heartSubType
end