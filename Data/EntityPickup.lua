---@class Decomp.Data.Pickup
---@field m_IsBlind boolean
---@field m_PayToPlay boolean
---@field m_FlipSaveState Decomp.Data.Pickup?

---@class Decomp.Data.Pickup.API
local PickupData = {}
Decomp.Data.Pickup = PickupData

---@return Decomp.Data.Pickup data
local function init_pickup_data()
    ---@type Decomp.Data.Pickup
    local data = {
        m_IsBlind = false,
        m_PayToPlay = false,
        m_FlipSaveState = nil,
    }

    return data
end

---@param data Decomp.Data.Pickup
---@param storedData Decomp.Data.Pickup
local function store_pickup_data(data, storedData)
    storedData.m_IsBlind = data.m_IsBlind
    if data.m_FlipSaveState then
        storedData.m_FlipSaveState = init_pickup_data()
        store_pickup_data(storedData.m_FlipSaveState, data.m_FlipSaveState)
    end
end

---@param player EntityPickup
---@return Decomp.Data.Pickup data
function PickupData.GetData(player)
    local data = player:GetData() -- It is highly suggested to replace this with your own data getter, GetData is only used here for demonstration purposes
    if not data.PickupData then
        data.PickupData = init_pickup_data()
    end

    return data.PickupData
end