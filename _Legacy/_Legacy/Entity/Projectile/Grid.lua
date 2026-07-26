---@class Decomp.Entity.Projectile.Grid
local ProjectileGrid = {}
Decomp.Entity.Projectile.Grid = ProjectileGrid

local AllBits = ~0
local VariantMask = ~(AllBits << 16)

---@param projectile EntityProjectile
local function OnDeath(projectile)
    projectile:GetColor():Reset()

    local gridDesc = GridDesc_new
    gridDesc.m_Type = projectile.SubType >> 16
    gridDesc.m_Variant = projectile.SubType & VariantMask
    gridDesc.m_SpawnSeed = projectile.InitSeed
    gridDesc.m_State = projectile.HitPoints
    gridDesc.m_VarData = projectile:HasEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER) and 1 or 0

    GridEntity_GridEntityProjectileBreakEffects(projectile.Position, gridDesc, projectile)
end