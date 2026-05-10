---@class Interface.Entity_Knife
local Interface = require("Isaac.Interface.Entity_Knife")

--#region Stub

local Stub = {}

---@param knife Component.Entity.Knife
---@return number
function Stub.GetRotation(knife) end

---@param knife Component.Entity.Knife
---@return number
function Stub.GetKnifeVelocity(knife) end

---@param knife Component.Entity.Knife
---@param Rotation number
function Stub.SetRotation(knife, Rotation) end

---@param knife Component.Entity.Knife
---@param ll integer
---@param lh integer
---@param hl integer
---@param hh integer
function Stub.SetTearFlags(knife, ll, lh, hl, hh) end

---@param knife Component.Entity.Knife
---@return boolean
function Stub.IsFlying(knife) end

---@param knife Component.Entity.Knife
---@param Speed number
function Stub.SetPathFollowSpeed(knife, Speed) end

---@param knife Component.Entity.Knife
---@return boolean
function Stub.GetPrismApplied(knife) end

---@param knife Component.Entity.Knife
---@param Offset number
function Stub.SetRotationOffset(knife, Offset) end

---@param knife Component.Entity.Knife
---@return boolean
function Stub.IsSwinging(knife) end

---@param knife Component.Entity.Knife
---@return boolean
function Stub.GetIsMeleeSwingInputHeld_qqq(knife)
end

---@param knife Component.Entity.Knife
---@param swingCount integer
function Stub.PrepareSwing(knife, swingCount) end

---@param knife Component.Entity.Knife
---@return number
function Stub.GetCharge(knife) end

---@param knife Component.Entity.Knife
---@param charge number
function Stub.SetCharge(knife, charge) end

---@param knife Component.Entity.Knife
---@param charged boolean
function Stub.SetSwordCharged(knife, charged) end

---@param knife Component.Entity.Knife
---@param param_1 unknown
function Stub.GetTearFlags(knife, param_1) end

---@param knife Component.Entity.Knife
---@return number
function Stub.GetKnifeDistance(knife) end

---@param knife Component.Entity.Knife
---@return number
function Stub.GetRotationOffset(knife) end

---@param knife Component.Entity.Knife
function Stub.LUA_GetRenderZ(knife) end

---@param knife Component.Entity.Knife
---@return KnifeVariant | integer
function Stub.GetBaseType(knife) end

---@param knife Component.Entity.Knife
---@return Component.Entity
function Stub.constructor(knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param param_1 integer
function Stub.destructor(ctx, knife, param_1) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param param_1 Component.Entity
function Stub.destructor_2(ctx, knife, param_1) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param type integer
---@param variant integer
---@param subtype integer
---@param initSeed integer
function Stub.Init(ctx, knife, type, variant, subtype, initSeed) end

---@param knife Component.Entity.Knife
function Stub.ClearReferences(knife) end

---@param knife Component.Entity.Knife
---@return Component.HitList
function Stub.get_hit_entities(knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param Direction Vector
---@param Source Component.Entity
---@param Offset number
function Stub.InitHomingPath(ctx, knife, Direction, Source, Offset) end

---@param knife Component.Entity.Knife
---@param param_1 Component.Entity.Knife
function Stub.CopyProperties(knife, param_1) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@return boolean
function Stub.ApplyMultidimensional(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@return boolean
function Stub.ApplyPrism(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@return boolean
function Stub.IsEnchantedNotchedAxe(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
function Stub.Update(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param offset Vector
function Stub.Render(ctx, knife, offset) end

---@param knife Component.Entity.Knife
---@return integer
function Stub.GetRenderZ(knife) end

---@param knife Component.Entity.Knife
---@return Component.Entity.Player
function Stub.GetPlayer(knife) end

---@param knife Component.Entity.Knife
---@return Component.Entity
function Stub.GetPrimaryKnife(knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param Collider Component.Entity.Npc
---@param Low boolean
---@return boolean
function Stub.handle_collision(ctx, knife, Collider, Low) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param Charge number
---@param Range number
function Stub.Shoot(ctx, knife, Charge, Range) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
function Stub.do_shoot_effects(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param param_1 number
function Stub.HomeIn(ctx, knife, param_1) end

---@param knife Component.Entity.Knife
---@param param_1 number
function Stub.Wiggle(knife, param_1) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
function Stub.ScreenWrap(ctx, knife) end

---@param knife Component.Entity.Knife
function Stub.Interpolate(knife) end

---@param knife Component.Entity.Knife
function Stub.Reset(knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
function Stub.Swing(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param attackCount integer
---@param startAnimFrame integer
function Stub.SpinAttack(ctx, knife, attackCount, startAnimFrame) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param discharge integer
---@return boolean
function Stub.trigger_notched_axe_hit(ctx, knife, discharge) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
function Stub.update_bone_swing(ctx, knife) end

---@param ctx Context.Common
---@param knife Component.Entity.Knife
---@param param_1 Vector
---@param param_2 Component.Entity
---@param param_3 Vector
---@param param_4 number
---@param param_5 number
---@param param_6 integer
---@param param_7 integer
---@param param_8 boolean
function Stub.trigger_collision(ctx, knife, param_1, param_2, param_3, param_4, param_5, param_6, param_7, param_8) end

--endregion

Interface.GetRotation = Stub.GetRotation
Interface.GetKnifeVelocity = Stub.GetKnifeVelocity
Interface.SetRotation = Stub.SetRotation
Interface.SetTearFlags = Stub.SetTearFlags
Interface.IsFlying = Stub.IsFlying
Interface.SetPathFollowSpeed = Stub.SetPathFollowSpeed
Interface.GetPrismApplied = Stub.GetPrismApplied
Interface.SetRotationOffset = Stub.SetRotationOffset
Interface.IsSwinging = Stub.IsSwinging
Interface.GetIsMeleeSwingInputHeld_qqq = Stub.GetIsMeleeSwingInputHeld_qqq
Interface.PrepareSwing = Stub.PrepareSwing
Interface.GetCharge = Stub.GetCharge
Interface.SetCharge = Stub.SetCharge
Interface.SetSwordCharged = Stub.SetSwordCharged
Interface.GetTearFlags = Stub.GetTearFlags
Interface.GetKnifeDistance = Stub.GetKnifeDistance
Interface.GetRotationOffset = Stub.GetRotationOffset
Interface.GetBaseType = Stub.GetBaseType
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.destructor_2 = Stub.destructor_2
Interface.Init = Stub.Init
Interface.ClearReferences = Stub.ClearReferences
Interface.get_hit_entities = Stub.get_hit_entities
Interface.InitHomingPath = Stub.InitHomingPath
Interface.CopyProperties = Stub.CopyProperties
Interface.ApplyMultidimensional = Stub.ApplyMultidimensional
Interface.ApplyPrism = Stub.ApplyPrism
Interface.IsEnchantedNotchedAxe = Stub.IsEnchantedNotchedAxe
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.GetRenderZ = Stub.GetRenderZ
Interface.GetPlayer = Stub.GetPlayer
Interface.GetPrimaryKnife = Stub.GetPrimaryKnife
Interface.handle_collision = Stub.handle_collision
Interface.Shoot = Stub.Shoot
Interface.do_shoot_effects = Stub.do_shoot_effects
Interface.HomeIn = Stub.HomeIn
Interface.Wiggle = Stub.Wiggle
Interface.ScreenWrap = Stub.ScreenWrap
Interface.Interpolate = Stub.Interpolate
Interface.Reset = Stub.Reset
Interface.Swing = Stub.Swing
Interface.SpinAttack = Stub.SpinAttack
Interface.trigger_notched_axe_hit = Stub.trigger_notched_axe_hit
Interface.update_bone_swing = Stub.update_bone_swing
Interface.trigger_collision = Stub.trigger_collision