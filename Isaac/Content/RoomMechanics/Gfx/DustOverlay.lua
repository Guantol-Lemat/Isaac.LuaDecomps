--#region Dependencies

local G = require("Isaac.Global")
local C = require("Isaac.Constants")

local ColorUtils = require("General.VanillaAPI.Color")
local ILevel = require("Isaac.Interface.Level")

--#endregion

---@return boolean
local function UseGraphics()
    return ILevel.GetStageID(G.Game.m_level) == StbType.ASHPIT
end

---@param graphics Engine.GraphicsManager
---@param room Component.Room
---@param surface Engine.Image
local function Render(graphics, room, surface)
    local restoreBlend = graphics:GetBlendMode()
    graphics:SetBlendMode_Type(BlendType.ADDITIVE)

    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local buffer = surface:Render_DestQuadFlatColor(dest, C.COLOR_WHITE)

    ColorUtils.FillVertices(C.COLOR_MOD_DEFAULT, buffer, surface)
    graphics:SetBlendMode(restoreBlend)
end

---@class Content.Room.DustOverlayGfx
local Module = {}

--#region Module

Module.UseGraphics = UseGraphics
Module.Render = Render

--#endregion

return Module