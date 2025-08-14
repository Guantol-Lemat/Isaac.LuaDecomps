---@class Decomp.Admin
---@field context Context
---@field Systems Decomp.Systems

---@class Context
---@field GetGame fun(self: Context): GameComponent
---@field GetLevel fun(self: Context): LevelComponent
---@field GetRoom fun(self: Context): RoomComponent
---@field GetSeeds fun(self: Context): SeedsComponent
---@field GetOptions fun(self: Context): OptionsComponent
---@field GetInput fun(self: Context): InputComponent
---@field GetScreen fun(self: Context): ScreenComponent
---@field GetStageTransition fun(self: Context): StageTransitionComponent
---@field GetDeathmatchManager fun(self: Context): DeathmatchManagerComponent

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