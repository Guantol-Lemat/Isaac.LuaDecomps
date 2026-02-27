--#region Dependencies



--#endregion

---@class ItemConfigUtils
local Module = {}

---@param myContext Context.Game
---@param itemConfig ItemConfigComponent
---@param collectibleId CollectibleType | integer
---@return ItemConfigItemComponent?
local function GetCollectible(myContext, itemConfig, collectibleId)
    if collectibleId < CollectibleType.COLLECTIBLE_NULL then
        local proceduralItemManager = myContext.game.m_proceduralItemManager
        local item = proceduralItemManager.m_items[(~collectibleId) + 1]

        if not item then
            return nil
        end

        return item.m_config
    end

    return itemConfig.m_collectibleList[collectibleId + 1]
end

---@param itemConfig ItemConfigComponent
---@param nullItemId NullItemID | integer
---@return ItemConfigItemComponent?
local function GetNullItem(itemConfig, nullItemId)
    return itemConfig.m_nullItemList[nullItemId + 1]
end

---@param itemConfig ItemConfigComponent
---@param collectibleId CollectibleType | integer
---@param tags integer
---@return boolean
local function IsTaggedCollectible(itemConfig, collectibleId, tags)
end

--#region Module

Module.GetCollectible = GetCollectible
Module.GetNullItem = GetNullItem
Module.IsTaggedCollectible = IsTaggedCollectible

--#endregion

return Module