--#region Dependencies

local EngineGlobal = require("Engine.Global")
local IImageManager = require("Engine.Interface.ImageManager")
local Enums = require("General.Enums")
local GameEffects = require("Isaac.Interface.Custom.GameEffects")
local IsaacUtils = require("Isaac.Utils.Common")

--#endregion

local eVertexAttributes = Enums.eVertexAttributes

---@param proceduralItemManager Component.ProceduralItemManager
---@param ctx Context.Common
local function Reset(proceduralItemManager, ctx)
    if not proceduralItemManager.m_itemSurface then
        local color = KColor(0.0, 0.0, 0.0, 0.0)
        local surface = IImageManager.CreateProceduralImage(EngineGlobal.ImageManager, 1024, 1024, "Procedural Item Surface", color)
        surface:SetVertexFormat(eVertexAttributes.COLOR_OFFSET)
        proceduralItemManager.m_itemSurface = surface
    end

    if not proceduralItemManager.m_collectionItemSurface then
        local color = KColor(0.0, 0.0, 0.0, 0.0)
        local surface = IImageManager.CreateProceduralImage(EngineGlobal.ImageManager, 512, 512, "Procedural Item Collection Surface", color)
        surface:SetVertexFormat(eVertexAttributes.COLOR_OFFSET)
        proceduralItemManager.m_collectionItemSurface = surface
    end

    proceduralItemManager.m_items = {}

    local activeItemPool = {}
    local collectibles = ctx.manager.m_itemConfig.m_collectibleList
    for i = 1, #collectibles, 1 do
        local item = collectibles[i]
        local allowed = item
            and item.m_itemType == ItemType.ITEM_ACTIVE
            and not GameEffects.BanActiveFromProceduralPool(item)

        if allowed then
            table.insert(activeItemPool, item)
        end
    end
    proceduralItemManager.m_activeItemPool = activeItemPool

    proceduralItemManager.m_entityTriggerBlacklist = {}

    local graphics = EngineGlobal.GraphicsManager
    IsaacUtils.PushRenderTarget()

    -- clear image content
    graphics:SetRenderTargetTexture(proceduralItemManager.m_itemSurface, false)
    graphics:Clear()
    graphics:SetRenderTargetTexture(proceduralItemManager.m_collectionItemSurface, false)
    graphics:Clear()

    IsaacUtils.PopRenderTarget()

    GameEffects.GFuel_CreateGFuelItem(ctx.game, ctx, proceduralItemManager)
end

---@class Gameplay.ProceduralItem.Init
local Module = {}

--#region Module

Module.Reset = Reset

--#endregion

return Module