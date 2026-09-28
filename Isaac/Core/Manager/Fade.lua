--#region Dependencies

local Engine = require("Engine.Global")
local G = require("Isaac.Global")
local C = require("Isaac.Constants")

local IManager = require("Isaac.Interface.Manager")

--#endregion

local function GameLoad_RenderFadeIn(value)
    Engine.GraphicsManager:SetBlendMode_Type(BlendType.NORMAL)

    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local color = KColor(0.0, 0.0, 0.0, value)
    Engine.ShapeRenderer:FillQuad(dest, color)
    IManager.RenderLoadImage(G.Manager, value)
end

local function MenuReturn_RenderFadeOut(value)
    local dest = DestinationQuad.NewFromRectangle(C.VECTOR_ZERO, G.WIDTH, G.HEIGHT)
    local color = KColor(0.0, 0.0, 0.0, value)
    Engine.ShapeRenderer:FillQuad(dest, color)
    return
end

---@class Manager.Fade
local Module = {}

--#region Module

Module.GameLoad_RenderFadeIn = GameLoad_RenderFadeIn
Module.MenuReturn_RenderFadeOut = MenuReturn_RenderFadeOut

--#endregion

return Module