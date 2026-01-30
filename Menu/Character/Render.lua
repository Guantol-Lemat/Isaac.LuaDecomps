--#region Dependencies

local MyComponent = require("Menu.Character.Component")
local VectorUtils = require("General.Math.VectorUtils")

local eMyState = MyComponent.eMenuCharacterState
local VectorZero = VectorUtils.VectorZero

--#endregion

---@param menuCharacter MenuCharacterComponent
---@param renderOffset Vector
---@param wheelPos Vector
---@param wheelScale Vector
local function render_character_wheel(menuCharacter, renderOffset, wheelPos, wheelScale)
end

---@param menuCharacter MenuCharacterComponent
---@param renderOffset Vector
---@param skipCharacterWheel boolean
local function render_character_menu(menuCharacter, renderOffset, skipCharacterWheel)
end

---@param myContext Context.Menu
---@param menuCharacter MenuCharacterComponent
local function Render(myContext, menuCharacter)
    local menu = myContext.menuManager
    local renderOffset = menu.m_viewPosition + menuCharacter.m_position

    local background = menuCharacter.m_characterMenuBGSprite

    menuCharacter.m_seedEntrySprite:Render(renderOffset + Vector(480.0, 0.0), VectorZero, VectorZero)
    background:RenderLayer(0, renderOffset, VectorZero, VectorZero)
    menuCharacter.m_taintedMenuBGDecoSprite:Render(renderOffset, VectorZero, VectorZero)
    background:RenderLayer(1, renderOffset, VectorZero, VectorZero)
    background:RenderLayer(4, renderOffset, VectorZero, VectorZero)

    if menuCharacter.m_state == eMyState.PAGE_SWAP or background:GetAnimation() ~= "Idle" then
        -- layer 3 contains pageSwapMenuRenderSurface
        background:RenderLayer(3, renderOffset, VectorZero, VectorZero)
        local frame = background:GetLayerFrameData(3)
        if frame and frame:IsVisible() then
            local wheelScale = frame:GetScale()
            local wheelPos = frame:GetPos() - frame:GetPivot() * wheelScale
            render_character_wheel(menuCharacter, renderOffset, wheelPos, wheelScale)
        end
    else
        render_character_menu(menuCharacter, renderOffset, false)
    end

    background:RenderLayer(2, renderOffset, VectorZero, VectorZero)
    if menuCharacter.m_pageSwapWidgetSprite.Color.A > 0.0 then
        -- TODO: Render page swap widget
    end

    -- TODO: Rest of render
end

local Module = {}

--#region Module

Module.Render = Render

--#endregion

return Module