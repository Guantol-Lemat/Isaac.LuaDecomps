---@class Interface.Entity_Bomb
local Interface = require("Isaac.Interface.Entity_Bomb")

--#region Stub

local Stub = {}

---@param bomb Component.Entity.Bomb
---@return boolean
function Stub.GetIsFetus(bomb) end

---@param bomb Component.Entity.Bomb
---@param Multi number
function Stub.SetRadiusMultiplier(bomb, Multi) end

---@param bomb Component.Entity.Bomb
---@param param_1 integer
function Stub.SetExplosionCountdown(bomb, param_1) end

---@param bomb Component.Entity.Bomb
---@param param_2 number
function Stub.SetRocketAngle(bomb, param_2) end

---@param bomb Component.Entity.Bomb
---@return BitSet128
function Stub.GetTearFlags(bomb) end

---@param bomb Component.Entity.Bomb
---@param Value boolean
function Stub.SetIsFetus(bomb, Value) end

---@param bomb Component.Entity.Bomb
---@return number
function Stub.GetRadiusMultiplier(bomb) end

---@param bomb Component.Entity.Bomb
---@return boolean
function Stub.unk_getter(bomb) end

---@param bomb Component.Entity.Bomb
---@param param_1 unknown
function Stub.IsPrismTouched(bomb, param_1) end

---@param bomb Component.Entity.Bomb
---@return number
function Stub.GetRocketAngle(bomb) end

---@param bomb Component.Entity.Bomb
---@return number
function Stub.GetRocketSpeed(bomb) end

---@param bomb Component.Entity.Bomb
---@param param_2 number
function Stub.SetRocketSpeed(bomb, param_2) end

---@param bomb Component.Entity.Bomb
---@return Component.Entity
function Stub.constructor(bomb) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
---@param param_1 integer
function Stub.destructor(ctx, bomb, param_1) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
function Stub.destructor_2(ctx, bomb) end

---@param bomb Component.Entity.Bomb
---@return boolean
function Stub.IsRocket(bomb) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
---@param type EntityType | integer
---@param variant BombVariant | integer
---@param subtype integer
---@param seed integer
function Stub.Init(ctx, bomb, type, variant, subtype, seed) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
function Stub.Update(ctx, bomb) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
---@param offset Vector
function Stub.Render(ctx, bomb, offset) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
---@param collider Component.Entity
---@param low boolean
---@return boolean
function Stub.handle_collision(ctx, bomb, collider, low) end

---@param bomb Component.Entity.Bomb
---@param flags BitSet128
function Stub.SetTearFlags(bomb, flags) end

---@param bomb Component.Entity.Bomb
---@param param_2 number
function Stub.SetScale(bomb, param_2) end

---@param bomb Component.Entity.Bomb
function Stub.AnimatePitfallIn(bomb) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
function Stub.update_dirt_color(ctx, bomb) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
---@param param_1 string
---@param param_2 integer
function Stub.translate_gfx_path(ctx, bomb, param_1, param_2) end

---@param ctx Context.Common
---@param bomb Component.Entity.Bomb
function Stub.load_costumes(ctx, bomb) end

--endregion

Interface.GetIsFetus = Stub.GetIsFetus
Interface.SetRadiusMultiplier = Stub.SetRadiusMultiplier
Interface.SetExplosionCountdown = Stub.SetExplosionCountdown
Interface.SetRocketAngle = Stub.SetRocketAngle
Interface.GetTearFlags = Stub.GetTearFlags
Interface.SetIsFetus = Stub.SetIsFetus
Interface.GetRadiusMultiplier = Stub.GetRadiusMultiplier
Interface.unk_getter = Stub.unk_getter
Interface.IsPrismTouched = Stub.IsPrismTouched
Interface.GetRocketAngle = Stub.GetRocketAngle
Interface.GetRocketSpeed = Stub.GetRocketSpeed
Interface.SetRocketSpeed = Stub.SetRocketSpeed
Interface.constructor = Stub.constructor
Interface.destructor = Stub.destructor
Interface.destructor_2 = Stub.destructor_2
Interface.IsRocket = Stub.IsRocket
Interface.Init = Stub.Init
Interface.Update = Stub.Update
Interface.Render = Stub.Render
Interface.handle_collision = Stub.handle_collision
Interface.SetTearFlags = Stub.SetTearFlags
Interface.SetScale = Stub.SetScale
Interface.AnimatePitfallIn = Stub.AnimatePitfallIn
Interface.update_dirt_color = Stub.update_dirt_color
Interface.translate_gfx_path = Stub.translate_gfx_path
Interface.load_costumes = Stub.load_costumes