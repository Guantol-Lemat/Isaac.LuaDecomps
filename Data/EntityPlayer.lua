---@class Decomp.Data.Player
---@field m_PillEffectUses integer[]
---@field m_CandyHeartStatUps number[]
---@field m_SoulLocketStatUps number[]
---@field m_BagOfCraftingHeldTimer integer
---@field m_UnkFireDelayCacheCooldown integer
---@field m_UnkWord number
---@field m_LiquidPoopFrameCount integer
---@field m_HallowedGroundCountdown integer
---@field m_EpiphoraCharge integer
---@field m_PeeBurstCooldown integer
---@field m_MaxPeeBurtsCooldown integer
---@field m_BloodyGustHits integer

---@class Decomp.Data.Player.API
local PlayerData = {}
Decomp.Data.Player = PlayerData

---@return Decomp.Data.Player data
local function init_player_data()
    ---@type Decomp.Data.Player
    local data = {
        m_PillEffectUses = {},
        m_CandyHeartStatUps = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        m_SoulLocketStatUps = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        m_BagOfCraftingHeldTimer = 0,
        m_UnkFireDelayCacheCooldown = 0,
        m_UnkWord = 0.0,
        m_LiquidPoopFrameCount = 0,
        m_HallowedGroundCountdown = 0,
        m_EpiphoraCharge = 0,
        m_PeeBurstCooldown = 0,
        m_MaxPeeBurtsCooldown = 0,
        m_BloodyGustHits = 0,
    }

    for i = 0, PillEffect.NUM_PILL_EFFECTS - 1, 1 do
        data.m_PillEffectUses[i] = 0
    end

    return data
end

---@param data Decomp.Data.Player
---@param storedData Decomp.Data.Player
local function store_player_data(data, storedData)
    storedData.m_PillEffectUses = data.m_PillEffectUses
    storedData.m_CandyHeartStatUps = data.m_CandyHeartStatUps
    storedData.m_SoulLocketStatUps = data.m_SoulLocketStatUps
end

---@param player EntityPlayer
---@return Decomp.Data.Player data
function PlayerData.GetData(player)
    local data = player:GetData() -- It is highly suggested to replace this with your own data getter, GetData is only used here for demonstration purposes
    if not data.PlayerData then
        data.PlayerData = init_player_data()
    end

    return data.PlayerData
end

