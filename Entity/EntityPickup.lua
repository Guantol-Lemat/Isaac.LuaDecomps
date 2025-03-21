---@class Decomp.Class.EntityPickup
local Class_EntityPickup = {}
Decomp.Class.EntityPickup = Class_EntityPickup

require("General.Enums")
require("Data.EntityPickup")
require("Entity.Pickup.TypeSelection")

local Enums = Decomp.Enums
local Lib = Decomp.Lib
local Data = Decomp.Data
local Pickup = Decomp.Entity.Pickup

local g_Game = Game()

--#region RandomVelocity

---@param velocity Vector
---@param velType Decomp.Enum.ePickVelType
---@return Vector modifiedVelocity
local function apply_vel_modifiers(velocity, velType)
    if velType == Enums.ePickVelType.BEGGAR then
        velocity.Y = velocity.Y * 0.2 + 3.0
        return velocity
    end

    if g_Game:GetRoom():GetType() == RoomType.ROOM_CHALLENGE then
        return velocity * 0.4
    end

    return velocity
end

---@param velType Decomp.Enum.ePickVelType
---@param rng RNG?
---@return Vector velocity
local function get_random_pickup_velocity(velType, rng)
    if not rng then
        rng = RNG()
        rng:SetSeed(Random(), 18)
    else
        rng:Next()
    end

    local velocity = rng:PhantomVector()
    velocity = velocity * 5.0

    return apply_vel_modifiers(velocity, velType)
end

---@param position Vector
---@param velocity Vector
---@return boolean valid
local function validate_pickup_velocity(position, velocity)
    local landingPosition = velocity * 7.0 + position
    return g_Game:GetRoom():CheckLine(position, landingPosition, LineCheckMode.RAYCAST, 0, false, false)
end

---@param position Vector
---@param rng RNG?
---@param velType Decomp.Enum.ePickVelType?
function Class_EntityPickup.GetRandomPickupVelocity(position, rng, velType)
    local result = Vector(0, 0)
    if not velType then
        velType = Enums.ePickVelType.DEFAULT
    end

    for i = 1, 10, 1 do
        result = get_random_pickup_velocity(velType, rng)
        if validate_pickup_velocity(position, result) then
            break
        end
    end

    return result
end

--#endregion

--#region Init

---@param pickup EntityPickup
local function initialize_pickup_data(pickup)
    local pickupData = Data.Pickup.GetData(pickup)

    -- Unfinished
    pickup.Price = 0
    pickup.ShopItemId = 0
    pickup.Timeout = -1
    pickup.Wait = 0
    pickup.Touched = false
    pickupData.m_IsBlind = false
    pickupData.m_PayToPlay = false

    pickupData.m_FlipSaveState = nil

    pickup.State = 0
    pickup.AutoUpdatePrice = true
end

---@param pickup EntityPickup
---@param type integer
---@param variant integer
---@param subType integer
---@param seed integer
function Class_EntityPickup.Init(pickup, type, variant, subType, seed)
    initialize_pickup_data(pickup)
    local rng = RNG(); rng:SetSeed(seed, 35)

    local selectVariant, selectSubType = Class_EntityPickup.SelectPickupType(seed, variant, subType, true, false)
    if not selectVariant or not selectSubType then
        g_Game:Spawn(EntityType.ENTITY_FLY, 0, pickup.Position, Vector(0, 0), nil, 0, pickup:GetDropRNG():Next())
        return
    end

    variant = selectVariant
    subType = selectSubType

    -- TODO
end

--#endregion

--#region SelectPickupType

local s_IgnoreModifiers = false

---@param seed integer
---@param variant PickupVariant | integer
---@param subType integer
---@param advanceRNG boolean
---@param shopItem boolean
---@return integer? newVariant
---@return integer? newSubType
function Class_EntityPickup.SelectPickupType(seed, variant, subType, advanceRNG, shopItem)
    return Pickup.TypeSelection.SelectPickupType(seed, variant, subType, advanceRNG, shopItem, s_IgnoreModifiers)
end

--#endregion