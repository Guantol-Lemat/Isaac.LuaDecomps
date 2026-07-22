--#region Dependencies

local SpriteUtils = require("General.Sprite")
local MenuOptions = require("Isaac.Interface.Menu_Options")
local GenericPrompt = require("Isaac.Interface.GenericPrompt")

--#endregion

---@param pauseScreen Component.PauseScreen
---@param ctx Context.Common
local function Reset(pauseScreen, ctx)
    pauseScreen.m_state = 0
    pauseScreen.m_selection_qqq = 1
    pauseScreen.m_unkCountdown = 0
    pauseScreen.m_frameCount = 0
    SpriteUtils.ResetOverlayAnimation(pauseScreen.m_anm2_1)
    MenuOptions.Reset(pauseScreen.m_menuOptions, ctx)
    GenericPrompt.Initialize(pauseScreen.m_genericPrompt, ctx, true)
end

---@class UI.PauseScreen.Misc
local Module = {}

--#region Module

Module.Reset = Reset

--#endregion

return Module