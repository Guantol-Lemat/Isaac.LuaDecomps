---@class Interface.ScoreSheet
local Interface = require("Isaac.Interface.ScoreSheet")

--#region Stub

local Stub = {}

---@param scoreSheet Component.ScoreSheet
---@return Component.ScoreSheet
function Stub.constructor(scoreSheet) end

---@param param_1 RoomShape | integer
---@return integer
function Stub.GetRoomClearValue(param_1) end

---@param scoreSheet Component.ScoreSheet
---@param ctx Context.Common
---@param RoomType RoomType | integer
---@param RoomShape RoomShape | integer
---@param clearCount integer
function Stub.AddClearedRoom(scoreSheet, ctx, RoomType, RoomShape, clearCount) end

---@param scoreSheet Component.ScoreSheet
---@param ctx Context.Common
---@param var PickupVariant | integer
---@param subtype integer
---@param pos Vector
function Stub.AddPickup(scoreSheet, ctx, var, subtype, pos) end

---@param scoreSheet Component.ScoreSheet
---@param ctx Context.Common
---@param entity Component.Entity.Npc
function Stub.AddKilledEnemy(scoreSheet, ctx, entity) end

---@param scoreSheet Component.ScoreSheet
---@param ctx Context.Common
function Stub.Calculate(scoreSheet, ctx) end

--#endregion

Interface.constructor = Stub.constructor
Interface.GetRoomClearValue = Stub.GetRoomClearValue
Interface.AddClearedRoom = Stub.AddClearedRoom
Interface.AddPickup = Stub.AddPickup
Interface.AddKilledEnemy = Stub.AddKilledEnemy
Interface.Calculate = Stub.Calculate