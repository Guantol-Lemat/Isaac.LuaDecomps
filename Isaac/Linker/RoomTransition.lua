---@class Interface.RoomTransition
local Interface = require("Isaac.Interface.RoomTransition")

--#region Stub

local Stub = {}

---@param roomTransition Component.RoomTransition
---@return boolean
function Stub.IsTeleportAnimation(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.destructor(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.CreateSurfaces(roomTransition) end

---@param roomTransition Component.RoomTransition
---@return boolean
function Stub.IsActive(roomTransition) end

---@param roomTransition Component.RoomTransition
---@param RoomIndex GridRooms | integer
---@param dir Direction | integer
---@param anim RoomTransitionAnim | integer
---@param Player Component.Entity.Player
---@param Dimension Dimension | integer
function Stub.Start(roomTransition, RoomIndex, dir, anim, Player, Dimension) end

---@param roomTransition Component.RoomTransition
function Stub.AddMazeEffect(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.Reset(roomTransition) end

---@param roomTransition Component.RoomTransition
---@param bossId1 BossType | integer
---@param bossId2 BossType | integer
function Stub.StartBossIntro(roomTransition, bossId1, bossId2) end

---@param roomTransition Component.RoomTransition
function Stub.change_room(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.ProcessInput(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.Update(roomTransition) end

---@param roomTransition Component.RoomTransition
---@return boolean
function Stub.IsRendering(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.Interpolate(roomTransition) end

---@param roomTransition Component.RoomTransition
---@return boolean
function Stub.IsRenderingBossIntro(roomTransition) end

---@param roomTransition Component.RoomTransition
---@return number
function Stub.GetAlpha(roomTransition) end

---@param roomTransition Component.RoomTransition
---@return Color
function Stub.GetFadeColor(roomTransition) end

---@param roomTransition Component.RoomTransition
function Stub.Render(roomTransition) end

--#endregion

Interface.IsTeleportAnimation = Stub.IsTeleportAnimation
Interface.destructor = Stub.destructor
Interface.CreateSurfaces = Stub.CreateSurfaces
Interface.IsActive = Stub.IsActive
Interface.Start = Stub.Start
Interface.AddMazeEffect = Stub.AddMazeEffect
Interface.Reset = Stub.Reset
Interface.StartBossIntro = Stub.StartBossIntro
Interface.change_room = Stub.change_room
Interface.ProcessInput = Stub.ProcessInput
Interface.Update = Stub.Update
Interface.IsRendering = Stub.IsRendering
Interface.Interpolate = Stub.Interpolate
Interface.IsRenderingBossIntro = Stub.IsRenderingBossIntro
Interface.GetAlpha = Stub.GetAlpha
Interface.GetFadeColor = Stub.GetFadeColor
Interface.Render = Stub.Render