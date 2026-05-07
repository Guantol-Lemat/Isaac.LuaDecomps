---@class Interface.Entity_Projectile
local Interface = require("Isaac.Interface.Entity_Projectile")

--#region Stub

local Stub = {}

---@param projectile Component.Entity.Projectile
---@return integer
function Stub.GetProjectileFlags(projectile) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetHeight(projectile) end

---@param projectile Component.Entity.Projectile
---@param Offset number
function Stub.SetDepthOffset(projectile, Offset) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetDepthOffset(projectile) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetFallingAccel(projectile) end

---@param projectile Component.Entity.Projectile
---@param Speed number
function Stub.SetFallingSpeed(projectile, Speed) end

---@param projectile Component.Entity.Projectile
---@param Acceleration number
function Stub.SetFallingAccel(projectile, Acceleration) end

---@param projectile Component.Entity.Projectile
---@param Offset integer
function Stub.SetWiggleFrameOffset(projectile, Offset) end

---@param projectile Component.Entity.Projectile
---@param Flags1 integer
---@param Flags2 integer
function Stub.SetProjectileFlags(projectile, Flags1, Flags2) end

---@param projectile Component.Entity.Projectile
---@param Height number
function Stub.SetHeight(projectile, Height) end

---@param projectile Component.Entity.Projectile
---@param Scale number
function Stub.SetScale(projectile, Scale) end

---@param projectile Component.Entity.Projectile
---@param Height number
function Stub.AddHeight(projectile, Height) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetFallingSpeed(projectile) end

---@param projectile Component.Entity.Projectile
---@param Speed number
function Stub.AddFallingSpeed(projectile, Speed) end

---@param projectile Component.Entity.Projectile
---@param Acceleration number
function Stub.AddFallingAccel(projectile, Acceleration) end

---@param projectile Component.Entity.Projectile
---@param Flags integer
function Stub.AddProjectileFlags(projectile, Flags) end

---@param projectile Component.Entity.Projectile
---@param Strength number
function Stub.SetCurvingStrength(projectile, Strength) end

---@param projectile Component.Entity.Projectile
---@param Acceleration number
function Stub.SetAcceleration(projectile, Acceleration) end

---@param projectile Component.Entity.Projectile
---@param flags integer
function Stub.SetChangeFlags(projectile, flags) end

---@param projectile Component.Entity.Projectile
---@param Velocity number
function Stub.SetChangeVelocity(projectile, Velocity) end

---@param projectile Component.Entity.Projectile
---@param Timeout integer
function Stub.SetChangeTimeout(projectile, Timeout) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetCurvingStrength(projectile) end

---@param projectile Component.Entity.Projectile
---@return integer
function Stub.GetWiggleFrameOffset(projectile) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetScale(projectile) end

---@param projectile Component.Entity.Projectile
---@param Strength number
function Stub.SetHomingStrength(projectile, Strength) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetDamage(projectile) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetHomingStrength(projectile) end

---@param projectile Component.Entity.Projectile
---@param projectile Component.Entity.Projectile
---@return Component.Entity.Projectile
function Stub.Constructor(projectile, projectile) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@param param_1 integer
function Stub.destructor(ctx, projectile, param_1) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@param param_1 Component.Entity
function Stub.destructor_2(ctx, projectile, param_1) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@param type integer
---@param var integer
---@param subtype integer
---@param seed integer
function Stub.Init(ctx, projectile, type, var, subtype, seed) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@return number
function Stub.get_time_scale(ctx, projectile) end

---@param projectile Component.Entity.Projectile
---@return boolean
function Stub.CanShutDoors(projectile) end

---@param projectile Component.Entity.Projectile
function Stub.DieFromShielded(projectile) end

---@param projectile Component.Entity.Projectile
---@param unused Component.Entity
---@param velocity Vector
function Stub.Reflect(projectile, unused, velocity) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
function Stub.Update(ctx, projectile) end

---@param ctx Context.Common
---@param timer Component.Entity.Effect
function Stub.something(ctx, timer) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@param collider Component.Entity
---@param low boolean
function Stub.handle_collision(ctx, projectile, collider, low) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
function Stub.Interpolate(ctx, projectile) end

---@param ctx Context.Common
---@param projectile Component.Entity.Projectile
---@param offset Vector
function Stub.Render(ctx, projectile, offset) end

---@param projectile Component.Entity.Projectile
---@param damage number
function Stub.SetDamage(projectile, damage) end

---@param projectile Component.Entity.Projectile
---@param Flags integer
function Stub.AddChangeFlags(projectile, Flags) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetAcceleration(projectile) end

---@param projectile Component.Entity.Projectile
---@return integer
function Stub.GetChangeFlags(projectile) end

---@param projectile Component.Entity.Projectile
---@return number
function Stub.GetChangeVelocity(projectile) end

---@param projectile Component.Entity.Projectile
---@return integer
function Stub.GetChangeTimeout(projectile) end

---@param projectile Component.Entity.Projectile
---@param Scale number
function Stub.AddScale(projectile, Scale) end

--endregion

Interface.GetProjectileFlags = Stub.GetProjectileFlags
Interface.GetHeight = Stub.GetHeight
Interface.SetDepthOffset = Stub.SetDepthOffset
Interface.GetDepthOffset = Stub.GetDepthOffset
Interface.GetFallingAccel = Stub.GetFallingAccel
Interface.SetFallingSpeed = Stub.SetFallingSpeed
Interface.SetFallingAccel = Stub.SetFallingAccel
Interface.SetWiggleFrameOffset = Stub.SetWiggleFrameOffset
Interface.SetProjectileFlags = Stub.SetProjectileFlags
Interface.SetHeight = Stub.SetHeight
Interface.SetScale = Stub.SetScale
Interface.AddHeight = Stub.AddHeight
Interface.GetFallingSpeed = Stub.GetFallingSpeed
Interface.AddFallingSpeed = Stub.AddFallingSpeed
Interface.AddFallingAccel = Stub.AddFallingAccel
Interface.AddProjectileFlags = Stub.AddProjectileFlags
Interface.SetCurvingStrength = Stub.SetCurvingStrength
Interface.SetAcceleration = Stub.SetAcceleration
Interface.SetChangeFlags = Stub.SetChangeFlags
Interface.SetChangeVelocity = Stub.SetChangeVelocity
Interface.SetChangeTimeout = Stub.SetChangeTimeout
Interface.GetCurvingStrength = Stub.GetCurvingStrength
Interface.GetWiggleFrameOffset = Stub.GetWiggleFrameOffset
Interface.GetScale = Stub.GetScale
Interface.SetHomingStrength = Stub.SetHomingStrength
Interface.GetDamage = Stub.GetDamage
Interface.GetHomingStrength = Stub.GetHomingStrength
Interface.Constructor = Stub.Constructor
Interface.destructor = Stub.destructor
Interface.destructor_2 = Stub.destructor_2
Interface.Init = Stub.Init
Interface.get_time_scale = Stub.get_time_scale
Interface.CanShutDoors = Stub.CanShutDoors
Interface.DieFromShielded = Stub.DieFromShielded
Interface.Reflect = Stub.Reflect
Interface.Update = Stub.Update
Interface.something = Stub.something
Interface.handle_collision = Stub.handle_collision
Interface.Interpolate = Stub.Interpolate
Interface.Render = Stub.Render
Interface.SetDamage = Stub.SetDamage
Interface.AddChangeFlags = Stub.AddChangeFlags
Interface.GetAcceleration = Stub.GetAcceleration
Interface.GetChangeFlags = Stub.GetChangeFlags
Interface.GetChangeVelocity = Stub.GetChangeVelocity
Interface.GetChangeTimeout = Stub.GetChangeTimeout
Interface.AddScale = Stub.AddScale