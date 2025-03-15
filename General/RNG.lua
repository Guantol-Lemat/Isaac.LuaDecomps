local Class = {}
---@class Decomp.Class.RNG
Class.RNG = {}

--#region Vector

---@param seed integer?
---@return Vector vector
local function random_vector(seed)
    if not seed then
        seed = Random()
    end

    local rng = RNG()
    rng:SetSeed(seed, 18)
    local randomFloat = rng:RandomFloat()

    local randomAngle = 2 * randomFloat * math.pi
    return Vector(math.cos(randomAngle), math.sin(randomAngle))
end

---@param rng RNG
---@return Vector vector
function Class.RNG.RandomVector(rng)
    local vector = random_vector(rng:GetSeed())
    rng:Next();
    return vector;
end

---@param rng RNG
---@return Vector vector
function Class.RNG.PhantomVector(rng)
    return random_vector(rng:GetSeed())
end

--#endregion