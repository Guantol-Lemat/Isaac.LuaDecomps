---@class Decomp.Class.EntityPickup
local Class_EntityPickup = {}
Decomp.Class.EntityPickup = Class_EntityPickup

require("General.Enums")

local g_Game = Game()
local Enums = Decomp.Enums

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