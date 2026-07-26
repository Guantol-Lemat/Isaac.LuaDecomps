---@class Decomp.Collectible.BrokenModem
local BrokenModem = {}
Decomp.Item.Collectible.BrokenModem = BrokenModem

require("Lib.PlayerManager")

local Lib = Decomp.Lib

---@param projectile EntityProjectile
function BrokenModem.TryGlitchProjectile(projectile) -- EntityProjectile::Update
    if not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BROKEN_MODEM) then
        return
    end

    local totalLuck = Lib.PlayerManager.GetLuck()
    local chance = math.max(67 - totalLuck, 50)

    if Random() % chance ~= 0 or projectile:IsDead() then
        return
    end

    -- Set Inaccessible Vector equal to Position
    projectile:AddEntityFlags(EntityFlag.FLAG_FREEZE)
    projectile.Velocity = Vector(0, 0)
end