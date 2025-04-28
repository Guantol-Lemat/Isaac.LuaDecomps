---@class Decomp.Class.EntityPickup
local Class_EntityPickup = {}
Decomp.Class.EntityPickup = Class_EntityPickup

local super = require("Entity.Entity")

local Lib = {
    Math = require("Lib.Math"),
    Table = require("Lib.Table"),
    Pickup = require("Lib.EntityPickup")
}

require("General.Enums")
require("Data.EntityPickup")
require("Entity.Pickup.TypeSelection")

local Enums = Decomp.Enums
local Data = Decomp.Data
local Pickup = Decomp.Entity.Pickup

local g_Game = Game()

---@class Decomp.Object.EntityPickup : Decomp.Class.EntityPickup.Data, Decomp.Class.EntityPickup.API

---@class Decomp.Class.EntityPickup.Data : Decomp.Class.Entity.Data
---@field object EntityPickup
---@field m_VariantRelated integer
---@field m_UnkInt integer
---@field m_SourcePool ItemPoolType
---@field m_FlipSaveState Decomp.Class.EntityPickup.SaveState?

---@class Decomp.Class.EntityPickup.SaveState : Decomp.Class.Entity.SaveState
---@field m_Charge integer
---@field m_Price integer
---@field m_AutoUpdatePrice boolean
---@field m_ShopItemId integer
---@field m_Touched boolean
---@field m_UnkInt integer
---@field m_OptionsPickupIndex integer
---@field m_Timeout integer
---@field m_IsBlind boolean
---@field m_AlternatePedestal PedestalType
---@field m_ActiveVarData integer
---@field m_SourcePool ItemPoolType
---@field m_SpriteScale number
---@field m_CycleCollectible CollectibleType[]
---@field m_FlipSaveState Decomp.Class.EntityPickup.SaveState?

local s_StationaryPickups = Lib.Table.CreateDictionary({
    PickupVariant.PICKUP_COLLECTIBLE, PickupVariant.PICKUP_BED, PickupVariant.PICKUP_BIGCHEST,
    PickupVariant.PICKUP_TROPHY, PickupVariant.PICKUP_MOMSCHEST, PickupVariant.PICKUP_MEGACHEST,
})

---@param variant integer
---@return boolean
local function should_pickup_be_stationary(variant)
    return not not s_StationaryPickups[variant]
end

--#region Data

---@param entityData Decomp.Class.EntityPickup.Data
local function get_chest_subtype(entityData)
    local entity = entityData.object
    if entity.Variant == PickupVariant.PICKUP_ETERNALCHEST and entityData.m_VariantRelated > 0 then
        return 1
    end

    return entity.SubType
end

---@param entityData Decomp.Class.EntityPickup.Data
---@return boolean
local function should_save(entityData)
    local entity = entityData.object

    if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType == 0 then
        return false
    end

    if Lib.Pickup.IsChest(entity.Variant) and get_chest_subtype(entityData) == 0 then
        return false
    end

    if entity.Variant == PickupVariant.PICKUP_HAUNTEDCHEST and entity:HasEntityFlags(EntityFlag.FLAG_THROWN | EntityFlag.FLAG_HELD) then
        return false
    end

    if entity.Timeout > -1 then
        return false
    end

    return super.should_save(entityData)
end

---@param entityData Decomp.Class.EntityPickup.Data
---@param saveState Decomp.Class.EntityPickup.SaveState
local function store_state(entityData, saveState)
    super.store_state(entityData, saveState)
    local entity = entityData.object

    if should_pickup_be_stationary(entity.Variant) and not Lib.Math.IsVectorEqual(entity.TargetPosition, Lib.Math.VectorZero) then
        saveState.m_Position = entity.TargetPosition
    end

    if Lib.Pickup.IsChest(entity.Variant) then
        saveState.m_SubType = get_chest_subtype(entityData)
    end

    saveState.m_Charge = entity.Charge
    saveState.m_Price = entity.Price
    saveState.m_AutoUpdatePrice = entity.AutoUpdatePrice
    saveState.m_ShopItemId = entity.ShopItemId
    saveState.m_Touched = entity.Touched
    saveState.m_UnkInt = entityData.m_UnkInt
    saveState.m_OptionsPickupIndex = entity.OptionsPickupIndex
    saveState.m_Timeout = entity.Timeout
    saveState.m_IsBlind = entity:IsBlind(true)
    saveState.m_AlternatePedestal = entity:GetAlternatePedestal()
    saveState.m_ActiveVarData = entity:GetVarData()
    saveState.m_SourcePool = entityData.m_SourcePool
    saveState.m_SpriteScale = entity:GetSprite().Scale.X

    saveState.m_CycleCollectible = {}
    for index, value in ipairs(entity:GetCollectibleCycle()) do
        saveState.m_CycleCollectible[index] = value
    end

    if entityData.m_FlipSaveState then
        ---@diagnostic disable-next-line: missing-fields
        saveState.m_FlipSaveState = {}
        entityData.m_FlipSaveState:copy_state(saveState.m_FlipSaveState)
    end
end

--#endregion

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

---@param pickup EntityPickup
function Class_EntityPickup.InitFlipState(pickup)
    -- TODO
end