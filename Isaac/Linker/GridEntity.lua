---@class Interface.GridEntity
local Interface = require("Isaac.Interface.GridEntity")

--#region Stub

local Stub = {}

---@param gridEntity Component.GridEntity
---@return Sprite
function Stub.GetSprite(gridEntity) end

---@param gridEntity Component.GridEntity
---@return unknown
function Stub.GetCollisionClass(gridEntity) end

---@param gridEntity Component.GridEntity
---@return integer
function Stub.GetGridIndex(gridEntity) end

---@param gridEntity Component.GridEntity
---@param State integer
function Stub.SetState(gridEntity, State) end

---@param gridEntity Component.GridEntity
---@return integer
function Stub.GetVarData(gridEntity) end

---@param gridEntity Component.GridEntity
---@param Type integer
function Stub.SetType(gridEntity, Type) end

---@param gridEntity Component.GridEntity
---@return boolean
function Stub.Destroy(gridEntity) end

---@param gridEntity Component.GridEntity
---@return Component.GridEntity
function Stub.Constructor(gridEntity) end

---@param gridEntity Component.GridEntity
---@param param_1 boolean
---@return unknown
function Stub.Free(gridEntity, param_1) end

---@param gridEntity Component.GridEntity
function Stub.Destructor_qqq(gridEntity) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@param Seed integer
function Stub.Init(ctx, gridEntity, Seed) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@return Vector
function Stub.GetPosition(ctx, gridEntity) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@return Vector
function Stub.GetRenderPosition(ctx, gridEntity) end

---@return Component.WaterClipInfo
function Stub.GetWaterClipInfo() end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@param collider Component.Entity
---@param DamageAmount number
---@param PlayerDamageAmount integer
---@param DamageFlagsL DamageFlags | integer
---@param DamageFlagsH DamageFlags | integer
---@param IgnoreGridCollisionClass boolean
function Stub.hurt_func(ctx, gridEntity, collider, DamageAmount, PlayerDamageAmount, DamageFlagsL, DamageFlagsH, IgnoreGridCollisionClass) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@param Distance number
---@param PlayerDistance number
---@param DamageAmount number
---@param PlayerDamageAmount integer
---@param DamageFlagsL DamageFlags | integer
---@param DamageFlagsH DamageFlags | integer
---@param IgnoreGridCollisionClass boolean
function Stub.hurt_surroundings(ctx, gridEntity, Distance, PlayerDistance, DamageAmount, PlayerDamageAmount, DamageFlagsL, DamageFlagsH, IgnoreGridCollisionClass) end

---@param gridEntity Component.GridEntity
function Stub.BeginBatches(gridEntity) end

---@param gridEntity Component.GridEntity
function Stub.EndBatches(gridEntity) end

---@param gridEntity Component.GridEntity
---@return boolean
function Stub.IsBreakableRock(gridEntity) end

---@param ent EntityGridCollisionClass | integer
---@param grid EntityGridCollisionClass | integer
---@return boolean
function Stub.GridCollisionClassCollidesWithGridType(ent, grid) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@return boolean
function Stub.IsEasyCrushableOrWalkable(ctx, gridEntity) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@return boolean
function Stub.IsDangerousCrushableOrWalkable(ctx, gridEntity) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@return boolean
function Stub.IsCrushableOrWalkable(ctx, gridEntity) end

---@param gridEntityType integer
---@return boolean
function Stub.IsHighPriority(gridEntityType) end

---@param ctx Context.Common
---@param id SoundEffect | integer
---@param volume number
---@param frameDelay integer
---@param unused_qqq unknown
---@param pitch number
function Stub.PlaySound(ctx, id, volume, frameDelay, unused_qqq, pitch) end

---@param ctx Context.Common
---@param Position Vector
---@param Desc Component.GridEntityDesc
---@param Source Component.Entity
---@param BackdropType BackdropType | integer
function Stub.GridEntityProjectileBreakEffects(ctx, Position, Desc, Source, BackdropType) end

---@param gridEntity Component.GridEntity
---@param Value integer
function Stub.SetVarData(gridEntity, Value) end

---@param ctx Context.Common
---@param gridEntity Component.GridEntity
---@param param_1 Vector
function Stub.Render(ctx, gridEntity, param_1) end

---@param gridEntity Component.GridEntity
---@param Variant integer
function Stub.SetVariant(gridEntity, Variant) end

---@param gridEntity Component.GridEntity
---@return Component.GridEntityDesc
function Stub.GetSaveState(gridEntity) end

---@param gridEntity Component.GridEntity
---@return RNG
function Stub.GetRNG(gridEntity) end

---@param gridEntity Component.GridEntity
---@param Damage integer
---@return boolean
function Stub.Hurt(gridEntity, Damage) end

---@param gridEntity Component.GridEntity
function Stub.PostInit(gridEntity) end

---@param gridEntity Component.GridEntity
function Stub.Update(gridEntity) end

--endregion

Interface.GetSprite = Stub.GetSprite
Interface.GetCollisionClass = Stub.GetCollisionClass
Interface.GetGridIndex = Stub.GetGridIndex
Interface.SetState = Stub.SetState
Interface.GetVarData = Stub.GetVarData
Interface.SetType = Stub.SetType
Interface.Destroy = Stub.Destroy
Interface.Constructor = Stub.Constructor
Interface.Free = Stub.Free
Interface.Destructor_qqq = Stub.Destructor_qqq
Interface.Init = Stub.Init
Interface.GetPosition = Stub.GetPosition
Interface.GetRenderPosition = Stub.GetRenderPosition
Interface.GetWaterClipInfo = Stub.GetWaterClipInfo
Interface.hurt_func = Stub.hurt_func
Interface.hurt_surroundings = Stub.hurt_surroundings
Interface.BeginBatches = Stub.BeginBatches
Interface.EndBatches = Stub.EndBatches
Interface.IsBreakableRock = Stub.IsBreakableRock
Interface.GridCollisionClassCollidesWithGridType = Stub.GridCollisionClassCollidesWithGridType
Interface.IsEasyCrushableOrWalkable = Stub.IsEasyCrushableOrWalkable
Interface.IsDangerousCrushableOrWalkable = Stub.IsDangerousCrushableOrWalkable
Interface.IsCrushableOrWalkable = Stub.IsCrushableOrWalkable
Interface.IsHighPriority = Stub.IsHighPriority
Interface.PlaySound = Stub.PlaySound
Interface.GridEntityProjectileBreakEffects = Stub.GridEntityProjectileBreakEffects
Interface.SetVarData = Stub.SetVarData
Interface.Render = Stub.Render
Interface.SetVariant = Stub.SetVariant
Interface.GetSaveState = Stub.GetSaveState
Interface.GetRNG = Stub.GetRNG
Interface.Hurt = Stub.Hurt
Interface.PostInit = Stub.PostInit
Interface.Update = Stub.Update