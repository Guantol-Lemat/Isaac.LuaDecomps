---@class Decomp.Admin
---@field context Decomp.Context
---@field Systems Decomp.Systems

---@class Decomp.Context
---@field GetGame fun(self: Decomp.Context): Decomp.GameObject
---@field GetLevel fun(self: Decomp.Context): Decomp.LevelObject

---@class Decomp.Systems
---@field Level Decomp.System.Level
---@field Entity Decomp.System.Entity
---@field EntityTear Decomp.System.EntityTear

---@class Decomp.System.Level
---@field API Decomp.ILevel

---@class Decomp.System.Entity
---@field API Decomp.IEntity

---@class Decomp.System.EntityTear
---@field API Decomp.IEntityTear