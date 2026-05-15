---@class Interface.GridEntityRock
local Interface = {}

--#region Stub

local Stub = {}

---@param gridRock Component.GridEntity.Rock
---@return string
function Stub.GetRubbleAnim(gridRock) end

---@param gridRock Component.GridEntity.Rock
---@param param_1 boolean
function Stub.Free(gridRock, param_1) end

---@param ctx Context.Common
---@param backdrop BackdropType | integer
---@return integer
function Stub.GetAltRockType(ctx, backdrop) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
function Stub.update_collision(ctx, gridRock) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
function Stub.Update(ctx, gridRock) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
---@param Immediate boolean
function Stub.Destroy(ctx, gridRock, Immediate) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
---@param param_1 Vector
function Stub.Render(ctx, gridRock, param_1) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
---@param Offset_qqq Vector
function Stub.RenderTop(ctx, gridRock, Offset_qqq) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
function Stub.InitSubclass(ctx, gridRock) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
function Stub.PostInit(ctx, gridRock) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
---@param Frame integer
function Stub.SetBigRockFrame(ctx, gridRock, Frame) end

---@param gridRock Component.GridEntity.Rock
---@return integer
function Stub.GetBigRockFrame(gridRock) end

---@param gridRock Component.GridEntity.Rock
function Stub.UpdateAnimFrame(gridRock) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
function Stub.UpdateNeighbors(ctx, gridRock) end

---@param ctx Context.Common
---@param GridEntityType GridEntityType | integer
function Stub.RegisterRockDestroyed(ctx, GridEntityType) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
function Stub.TrySpawnWorms(ctx, gridRock) end

---@param ctx Context.Common
---@param GridEntityType GridEntityType | integer
---@param BackdropType BackdropType | integer
function Stub.PlayBreakSound(ctx, GridEntityType, BackdropType) end

---@param ctx Context.Common
---@param gridRock Component.GridEntity.Rock
---@return boolean
function Stub.TrySpawnLadder(ctx, gridRock) end

---@param ctx Context.Common
---@param Position Vector
---@param GridEntityType GridEntityType | integer
---@param GridEntityVariant integer
---@param Seed integer
---@param falseIfFromDestroy boolean
---@param BackdropType BackdropType | integer
function Stub.SpawnDrops(ctx, Position, GridEntityType, GridEntityVariant, Seed, falseIfFromDestroy, BackdropType) end

---@param gridRock Component.GridEntity.Rock
---@return Component.WaterClipInfo
function Stub.GetWaterClipInfo(gridRock) end

---@param ctx Context.Common
---@param param_1 integer
function Stub.TriggerChainRocks(ctx, param_1) end

--endregion

Interface.GetRubbleAnim = Stub.GetRubbleAnim
Interface.Free = Stub.Free
Interface.GetAltRockType = Stub.GetAltRockType
Interface.update_collision = Stub.update_collision
Interface.Update = Stub.Update
Interface.Destroy = Stub.Destroy
Interface.Render = Stub.Render
Interface.RenderTop = Stub.RenderTop
Interface.InitSubclass = Stub.InitSubclass
Interface.PostInit = Stub.PostInit
Interface.SetBigRockFrame = Stub.SetBigRockFrame
Interface.GetBigRockFrame = Stub.GetBigRockFrame
Interface.UpdateAnimFrame = Stub.UpdateAnimFrame
Interface.UpdateNeighbors = Stub.UpdateNeighbors
Interface.RegisterRockDestroyed = Stub.RegisterRockDestroyed
Interface.TrySpawnWorms = Stub.TrySpawnWorms
Interface.PlayBreakSound = Stub.PlayBreakSound
Interface.TrySpawnLadder = Stub.TrySpawnLadder
Interface.SpawnDrops = Stub.SpawnDrops
Interface.GetWaterClipInfo = Stub.GetWaterClipInfo
Interface.TriggerChainRocks = Stub.TriggerChainRocks