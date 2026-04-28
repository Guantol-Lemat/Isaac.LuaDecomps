--#region Dependencies



--#endregion

---@class Component.NPC.ProjectileParams
---@field m_gridCollision boolean : 0x0
---@field m_heightModifier number : 0x4
---@field m_fallingSpeedModifier number : 0x8
---@field m_fallingAccelModifier number : 0xc
---@field m_velocityMulti number : 0x10
---@field m_scale number : 0x14
---@field m_circleAngle number : 0x18
---@field m_homingStrength number : 0x1c
---@field m_curvingStrength number : 0x20
---@field m_acceleration number : 0x24
---@field m_spread number : 0x28
---@field m_color Color : 0x2c
---@field m_bulletFlags integer : 0x58
---@field m_positionOffset Vector : 0x60
---@field m_targetPosition Vector : 0x68
---@field m_fireDirectionLimit Vector : 0x70
---@field m_dotProductLimit number : 0x78
---@field m_wiggleFrameOffset integer : 0x7c
---@field m_changeFlags integer : 0x80
---@field m_changeVelocity number : 0x88
---@field m_changeTimeout integer : 0x8c
---@field m_depthOffset number : 0x90
---@field m_variant integer : 0x94
---@field m_unk_fallingS_A_modifier boolean : 0x98
---@field m_damage number : 0x9c
---@field m_interpFunction function : 0xa0


---@return Component.NPC.ProjectileParams
local function NewProjectileParams()
end

---@param ctx Context.Common
---@param npc EntityNPCComponent
---@param pos Vector
---@param velocity Vector
---@param mode ProjectileMode | integer
---@param params Component.NPC.ProjectileParams
local function FireProjectile(ctx, npc, pos, velocity, mode, params)
end

---@class Mechanics.NPC.FireProjectile
local Module = {}

--#region Module

Module.NewProjectileParams = NewProjectileParams
Module.FireProjectiles = FireProjectile

--#endregion

return Module