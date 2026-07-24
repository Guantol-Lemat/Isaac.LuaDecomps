---@class Interface.Backdrop
local Interface = require("Isaac.Interface.Backdrop")

--#region Stub

local Stub = {}

---@param backdrop Component.Backdrop
---@return Component.Backdrop.Entry
function Stub.GetCurrentBackdropEntry(backdrop) end

---@param backdrop Component.Backdrop
---@param param_1 BackdropType | integer
---@return Component.Backdrop.Entry
function Stub.GetEntry(backdrop, param_1) end

---@param backdrop Component.Backdrop
---@return Component.Backdrop
function Stub.Constructor(backdrop) end

---@param backdrop Component.Backdrop
function Stub.destructor(backdrop) end

---@param backdrop Component.Backdrop
---@param filepath string
---@return integer
function Stub.LoadConfig(backdrop, filepath) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
function Stub.pre_render_controls(backdrop, ctx) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@return integer
function Stub.pick_floor_id(backdrop, ctx) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@return integer
function Stub.pick_wall_id(backdrop, ctx) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
function Stub.pre_render_floor(backdrop, ctx) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param param_1 Component.Image
---@param param_2 Component.Image
---@param param_3 Component.Image
---@param param_4 integer
---@param param_5 RNG
function Stub.pre_render_floor_2(backdrop, ctx, param_1, param_2, param_3, param_4, param_5) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
function Stub.pre_render_walls(backdrop, ctx) end

---@param ctx Context.Common
---@param buffer Vector
---@param pos Vector
---@return Vector
function Stub.wall_details_translate_pos(ctx, buffer, pos) end

---@param ctx Context.Common
---@param buffer Vector
---@param quad Engine.Graphics.DestinationQuad
---@return Vector
function Stub.wall_details_quad_to_vector(ctx, buffer, quad) end

---@param buffer Vector
---@param param_2_00 integer
---@param param_3 boolean
---@param param_4 boolean
---@return Vector
function Stub.wall_details_direction(buffer, param_2_00, param_3, param_4) end

---@param ctx Context.Common
---@param anm2 Sprite
---@param vector Vector
---@param exponentPosX_qqq boolean
---@param exponentPosY_qqq boolean
function Stub.mines_detail_light_spawner(ctx, anm2, vector, exponentPosX_qqq, exponentPosY_qqq) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param wallId integer
---@param param_2 integer
---@param param_3 integer
---@param param_4 integer
---@param quad Engine.Graphics.DestinationQuad
---@param param_6 boolean
---@param param_7 boolean
function Stub.spawn_wall_details(backdrop, ctx, wallId, param_2, param_3, param_4, quad, param_6, param_7) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param rng RNG
---@param pos Vector
---@param flipX boolean
---@param flipY boolean
---@param param_5 boolean
---@param param_6 boolean
---@param param_7 number
function Stub.render_detail(backdrop, ctx, rng, pos, flipX, flipY, param_5, param_6, param_7) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param Backdrop BackdropType | integer
---@param LoadGraphics boolean
function Stub.Init(backdrop, ctx, Backdrop, LoadGraphics) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
function Stub.LoadGraphics(backdrop, ctx) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param param_1 Vector
---@param param_2 Vector
function Stub.render_black_outside_rect(backdrop, ctx, param_1, param_2) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param pos Vector
---@param color Color
function Stub.RenderFloor(backdrop, ctx, pos, color) end

---@param backdrop Component.Backdrop
---@param pos Vector
---@param color Color
function Stub.RenderFloor2(backdrop, pos, color) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param pos Vector
---@param color Color
function Stub.RenderWalls(backdrop, ctx, pos, color) end

---@param backdrop Component.Backdrop
---@param ctx Context.Common
---@param param_1 Vector
function Stub.render_water(backdrop, ctx, param_1) end

---@param backdrop Component.Backdrop
---@param source Engine.Graphics.SourceQuad
---@param dest Engine.Graphics.DestinationQuad
function Stub.render_water_quad(backdrop, source, dest) end

--#endregion

Interface.GetCurrentBackdropEntry = Stub.GetCurrentBackdropEntry
Interface.GetEntry = Stub.GetEntry
Interface.Constructor = Stub.Constructor
Interface.destructor = Stub.destructor
Interface.LoadConfig = Stub.LoadConfig
Interface.pre_render_controls = Stub.pre_render_controls
Interface.pick_floor_id = Stub.pick_floor_id
Interface.pick_wall_id = Stub.pick_wall_id
Interface.pre_render_floor = Stub.pre_render_floor
Interface.pre_render_floor_2 = Stub.pre_render_floor_2
Interface.pre_render_walls = Stub.pre_render_walls
Interface.wall_details_translate_pos = Stub.wall_details_translate_pos
Interface.wall_details_quad_to_vector = Stub.wall_details_quad_to_vector
Interface.wall_details_direction = Stub.wall_details_direction
Interface.mines_detail_light_spawner = Stub.mines_detail_light_spawner
Interface.spawn_wall_details = Stub.spawn_wall_details
Interface.render_detail = Stub.render_detail
Interface.Init = Stub.Init
Interface.LoadGraphics = Stub.LoadGraphics
Interface.render_black_outside_rect = Stub.render_black_outside_rect
Interface.RenderFloor = Stub.RenderFloor
Interface.RenderFloor2 = Stub.RenderFloor2
Interface.RenderWalls = Stub.RenderWalls
Interface.render_water = Stub.render_water
Interface.render_water_quad = Stub.render_water_quad