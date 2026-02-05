--#region Dependencies



--#endregion

---@param familiar EntityFamiliarComponent
---@param pickup PickupVariant
---@param progressRate number
---@param guaranteeThreshold number
local function try_award_pickup(familiar, pickup, progressRate, guaranteeThreshold)
    if pickup == 0 or progressRate <= 0.0 then
        return
    end

    if familiar.m_player.m_playerType == PlayerType.PLAYER_BETHANY_B then
        progressRate = progressRate * 0.75
    end

    -- if progressRate is greater or equal than guaranteeThreshold, always award
    if progressRate < guaranteeThreshold then
        local clearCount = familiar.m_roomClearCount % 512
        if math.floor((clearCount + 1) * progressRate) <= math.floor(clearCount * progressRate) then
            return
        end
    end

    -- Reward pickup
end

---@param familiar EntityFamiliarComponent
local function TriggerRoomClear(familiar)
    if not familiar.m_exists then
        return
    end

    local player = familiar.m_player
    if not player or not player.m_exists then
        return
    end

    familiar.m_roomClearCount = familiar.m_roomClearCount + 1

    local awardPickup = 0
    local awardPickupProgressRate = 0.0
    local awardPickupGuaranteeThreshold = 1.0

    -- TODO: Familiar Specific logic

    try_award_pickup(familiar, awardPickup, awardPickupProgressRate, awardPickupGuaranteeThreshold)
end

local Module = {}

--#region Module



--#endregion

return Module