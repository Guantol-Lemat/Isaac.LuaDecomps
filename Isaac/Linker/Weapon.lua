---@class Interface.Weapon
local Interface = require("Isaac.Interface.Weapon")

--#region Stub

local Stub = {}

---@param weapon Component.Weapon
---@param param_1 CollectibleType | integer
---@return string
function Stub.GetItemAnimFrame(weapon, param_1) end

---@return number
function Stub.GetMaxCharge() end

---@param weapon Component.Weapon
---@return Component.Entity
function Stub.GetMainEntity(weapon) end

---@return Component.Weapon
function Stub.constructor(weapon) end

---@param weapon Component.Weapon
---@param param_1 boolean
function Stub.Free(weapon, param_1) end

---@param weapon Component.Weapon
function Stub.Destructor(weapon) end

---@param weapon Component.Weapon
function Stub.ClearReferences(weapon) end

---@param weapon Component.Weapon
---@return Component.Entity.Player?
function Stub.GetPlayer(weapon) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@return boolean
function Stub.IsAxisAligned(weapon, ctx) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_2 Vector
---@return Vector
function Stub.GetLastBufferedDirection(weapon, ctx, param_2) end

---@param weapon Component.Weapon
function Stub.Reset(weapon) end

---@param weapon Component.Weapon
---@param weaponType integer
---@param param_2 Component.Entity
function Stub.Init(weapon, weaponType, param_2) end

---@param weapon Component.Weapon
---@param param_1 boolean
function Stub.Update(weapon, param_1) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 boolean
---@param param_3 boolean
function Stub.Fire(weapon, ctx, param_1, param_2, param_3) end

---@param weapon Component.Weapon
---@return Vector
function Stub.GetPosition(weapon) end

---@param weapon Component.Weapon
---@return number
function Stub.GetLuck(weapon) end

---@param weapon Component.Weapon
---@return number
function Stub.GetShotSpeed(weapon) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@return number
function Stub.GetTearDamage(weapon, ctx) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@return BitSet128
function Stub.GetTearFlags(weapon, ctx) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@return Color
function Stub.GetTearColor(weapon, ctx) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@return Color
function Stub.GetLaserColor(weapon, ctx) end

---@param weapon Component.Weapon
---@return number
function Stub.GetTimeScale(weapon) end

---@param weapon Component.Weapon
---@param __return_storage_ptr__ number
---@return number
function Stub.GetChargeBarAmount(weapon, __return_storage_ptr__) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@return Component.Weapon.MultiShotParams
function Stub.GetMultiShotParams(weapon, ctx) end

---@param ret Component.PosVel
---@param idx integer
---@param WeaponType WeaponType | integer
---@param ShotDirection Component.XY
---@param ShotSpeed number
---@param Params Component.Weapon.MultiShotParams
---@return Component.PosVel
function Stub.GetMultiShotPositionVelocity(ret, idx, WeaponType, ShotDirection, ShotSpeed, Params) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@param itemAnim ItemAnim | integer
---@param Direction Vector
---@param pos number
function Stub.PlayItemAnim(weapon, ctx, CollectibleType, itemAnim, Direction, pos) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@param param_2 integer
---@param param_3 Vector
---@param param_4 number
function Stub.SetItemAnimFrame(weapon, ctx, CollectibleType, param_2, param_3, param_4) end

---@param weapon Component.Weapon
---@param param_1 CollectibleType | integer
---@return Component.Entity.Player
function Stub.ClearAllItemAnim(weapon, param_1) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_1 CollectibleType | integer
function Stub.ClearItemAnim(weapon, ctx, param_1) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@return boolean
function Stub.IsItemAnimFinished(weapon, ctx, CollectibleType) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param CollectibleType CollectibleType | integer
---@param itemAnim ItemAnim | integer
---@param direction Vector
---@param pos number
function Stub.PlayItemBodySubAnim(weapon, ctx, CollectibleType, itemAnim, direction, pos) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_1 CollectibleType | integer
---@return boolean
function Stub.IsItemBodySubAnimFinished(weapon, ctx, param_1) end

---@param weapon Component.Weapon
---@param time integer
function Stub.SetBlinkTime(weapon, time) end

---@param weapon Component.Weapon
---@param time integer
function Stub.SetHeadLockTime(weapon, time) end

---@param weapon Component.Weapon
---@param param_1 integer
function Stub.SetHeadDirection(weapon, param_1) end

---@param weapon Component.Weapon
---@return integer
function Stub.GetTearSpawnDisplacement(weapon) end

---@param weapon Component.Weapon
---@param param_1 integer
function Stub.SetTearSpawnDisplacement(weapon, param_1) end

---@param weapon Component.Weapon
---@return unknown
function Stub.GetPeeBurstCooldown(weapon) end

---@param weapon Component.Weapon
---@return unknown
function Stub.GetMaxPeeBurstCooldown(weapon) end

---@param weapon Component.Weapon
---@return unknown
function Stub.GetEpiphoraCharge(weapon) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_2 Vector
---@return Vector
function Stub.get_tear_movement_inheritance(weapon, ctx, param_2) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param OffsetId integer
---@param Direction Vector
---@return Vector
function Stub.get_laser_offset(weapon, ctx, OffsetId, Direction) end

---@param weapon Component.Weapon
---@return boolean
function Stub.has_wizard_effect(weapon) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param position Vector
---@param velocity Vector
---@param flags integer
---@param source Component.Entity
---@param damageMultiplier number
---@param offsetMultiplier number
---@return Component.Entity.Tear
function Stub.FireTear(weapon, ctx, position, velocity, flags, source, damageMultiplier, offsetMultiplier) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 Vector
---@return Component.Entity.Bomb
function Stub.FireBomb(weapon, ctx, param_1, param_2) end

---@param ctx Context.Common
---@param parent Component.Entity
---@param Position Vector
---@param Velocity Vector
---@param DamageMultiplier number
---@param characterType_qqq boolean
---@return Component.Entity.Laser
function Stub.FireBrimstone(ctx, parent, Position, Velocity, DamageMultiplier, characterType_qqq) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param Direction Vector
---@param DamageMultipler number
---@param b boolean
---@return Component.Entity.Laser
function Stub.FireBrimstone_Wrapper(weapon, ctx, Direction, DamageMultipler, b) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param Position Vector
---@param OffsetId integer
---@param Direction Vector
---@param LeftEye boolean
---@param OneHit boolean
---@param DamageScale number
---@return Component.Entity.Laser
function Stub.FireTechLaser(weapon, ctx, Position, OffsetId, Direction, LeftEye, OneHit, DamageScale) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_2 Vector
---@param param_3 Vector
---@param param_4 number
---@param param_5 number
---@return Component.Entity.Laser
function Stub.FireTechXLaser(weapon, ctx, param_2, param_3, param_4, param_5) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_2 Component.Entity
---@param param_3 integer
---@param param_4 number
---@param param_5 boolean
---@return Component.Entity.Knife
function Stub.FireKnife(weapon, ctx, param_2, param_3, param_4, param_5) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param parent Component.Entity
---@param variant integer
---@param param_3 boolean
---@return Component.Entity.Knife
function Stub.FireBoneClub(weapon, ctx, parent, variant, param_3) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param pos Vector
---@param vel Vector
---@param offset Vector
---@return Component.Entity.Effect
function Stub.FireBrimstoneBall(weapon, ctx, pos, vel, offset) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_1 Component.Entity
---@param param_2 integer
---@param param_3 number
---@param param_4 boolean
---@param param_5 boolean
---@param param_6 integer
---@param param_7 Component.Entity
---@return Component.Entity.Knife
function Stub.FireSword(weapon, ctx, param_1, param_2, param_3, param_4, param_5, param_6, param_7) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param pos Vector
---@param velocity_qqq Vector
---@param flags_qqq integer
---@param owner Component.Entity
---@param DamageScale number
---@return Component.Entity.Tear
function Stub.FireFetus(weapon, ctx, pos, velocity_qqq, flags_qqq, owner, DamageScale) end

---@param weapon Component.Weapon
---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 integer
function Stub.TriggerTearFired(weapon, ctx, param_1, param_2) end

---@param weapon Component.Weapon
function Stub.TriggerNewRoom(weapon) end

---@param weapon Component.Weapon
---@return boolean
function Stub.SupportsTractorBeam(weapon) end

--#endregion

Interface.GetItemAnimFrame = Stub.GetItemAnimFrame
Interface.GetMaxCharge = Stub.GetMaxCharge
Interface.GetMainEntity = Stub.GetMainEntity
Interface.constructor = Stub.constructor
Interface.Free = Stub.Free
Interface.Destructor = Stub.Destructor
Interface.ClearReferences = Stub.ClearReferences
Interface.GetPlayer = Stub.GetPlayer
Interface.IsAxisAligned = Stub.IsAxisAligned
Interface.GetLastBufferedDirection = Stub.GetLastBufferedDirection
Interface.Reset = Stub.Reset
Interface.Init = Stub.Init
Interface.Update = Stub.Update
Interface.Fire = Stub.Fire
Interface.GetPosition = Stub.GetPosition
Interface.GetLuck = Stub.GetLuck
Interface.GetShotSpeed = Stub.GetShotSpeed
Interface.GetTearDamage = Stub.GetTearDamage
Interface.GetTearFlags = Stub.GetTearFlags
Interface.GetTearColor = Stub.GetTearColor
Interface.GetLaserColor = Stub.GetLaserColor
Interface.GetTimeScale = Stub.GetTimeScale
Interface.GetChargeBarAmount = Stub.GetChargeBarAmount
Interface.GetMultiShotParams = Stub.GetMultiShotParams
Interface.GetMultiShotPositionVelocity = Stub.GetMultiShotPositionVelocity
Interface.PlayItemAnim = Stub.PlayItemAnim
Interface.SetItemAnimFrame = Stub.SetItemAnimFrame
Interface.ClearAllItemAnim = Stub.ClearAllItemAnim
Interface.ClearItemAnim = Stub.ClearItemAnim
Interface.IsItemAnimFinished = Stub.IsItemAnimFinished
Interface.PlayItemBodySubAnim = Stub.PlayItemBodySubAnim
Interface.IsItemBodySubAnimFinished = Stub.IsItemBodySubAnimFinished
Interface.SetBlinkTime = Stub.SetBlinkTime
Interface.SetHeadLockTime = Stub.SetHeadLockTime
Interface.SetHeadDirection = Stub.SetHeadDirection
Interface.GetTearSpawnDisplacement = Stub.GetTearSpawnDisplacement
Interface.SetTearSpawnDisplacement = Stub.SetTearSpawnDisplacement
Interface.GetPeeBurstCooldown = Stub.GetPeeBurstCooldown
Interface.GetMaxPeeBurstCooldown = Stub.GetMaxPeeBurstCooldown
Interface.GetEpiphoraCharge = Stub.GetEpiphoraCharge
Interface.get_tear_movement_inheritance = Stub.get_tear_movement_inheritance
Interface.get_laser_offset = Stub.get_laser_offset
Interface.has_wizard_effect = Stub.has_wizard_effect
Interface.FireTear = Stub.FireTear
Interface.FireBomb = Stub.FireBomb
Interface.FireBrimstone = Stub.FireBrimstone
Interface.FireBrimstone_Wrapper = Stub.FireBrimstone_Wrapper
Interface.FireTechLaser = Stub.FireTechLaser
Interface.FireTechXLaser = Stub.FireTechXLaser
Interface.FireKnife = Stub.FireKnife
Interface.FireBoneClub = Stub.FireBoneClub
Interface.FireBrimstoneBall = Stub.FireBrimstoneBall
Interface.FireSword = Stub.FireSword
Interface.FireFetus = Stub.FireFetus
Interface.TriggerTearFired = Stub.TriggerTearFired
Interface.TriggerNewRoom = Stub.TriggerNewRoom
Interface.SupportsTractorBeam = Stub.SupportsTractorBeam