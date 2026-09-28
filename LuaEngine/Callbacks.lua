--#region Dependencies



--#endregion

local function PreActionHookB()
end

local function PreActionHookF()
end

local function GetShaderParams()
end

local function ExecuteConCommand()
end

---@param isContinued boolean
local function PostGameStart(isContinued)
end

local function PostGameEnd()
end

local function PreGameExit()
end

local function PostUpdate()
end

local function PostRender()
end

local function PostLevelLoad()
end

local function PostCurseEval()
end

local function PostRoomLoad()
end

local function PreRoomEntitySpawn()
end

---@param rng RNG
---@param position Vector
---@return boolean
local function PreSpawnCleanAward(rng, position)
end

local function PreGetCollectible()
end

local function PostGetCollectible()
end

local function GetTrinket()
end

local function GetCard()
end

local function GetPill()
end

---@param player Component.Entity.Player
---@param cacheFlag CacheFlag | integer
local function PostEvaluateItems(player, cacheFlag)
end

local function GetPillEffect()
end

---@param collectibleType CollectibleType | integer
---@param rng RNG
---@param player Component.Entity.Player
---@param useFlags UseFlag | integer
---@param activeSlot ActiveSlot
---@param customVarData integer
---@return boolean
local function PreUseItem(collectibleType, rng, player, useFlags, activeSlot, customVarData)
end

---@param collectibleType CollectibleType | integer
---@param rng RNG
---@param player Component.Entity.Player
---@param useFlags UseFlag | integer
---@param activeSlot ActiveSlot
---@param customVarData integer
---@return boolean discharged
---@return boolean remove
---@return boolean showAnim
local function PostUseItem(collectibleType, rng, player, useFlags, activeSlot, customVarData)
end

---@param cardType Card | integer
---@param player Component.Entity.Player
---@param useFlags UseFlag | integer
local function PostUseCard(cardType, player, useFlags)
end

---@param pillEffect PillEffect | integer
---@param player Component.Entity.Player
---@param useFlags UseFlag | integer
local function PostUsePillEffect(pillEffect, player, useFlags)
end

local function PostFireTear()
end

local function PreEntitySpawn()
end

local function PreEntityTakeDamage()
end

local function PostEntityKill()
end

local function PostEntityRemove()
end

---@param player Component.Entity.Player
local function PostPlayerInit(player)
end

---@param player Component.Entity.Player
local function PostPlayerUpdate(player)
end

---@param player Component.Entity.Player
---@param offset Vector
local function PostPlayerRender(player, offset)
end

local function PrePlayerCollision()
end

---@param player Component.Entity.Player
local function PostPlayerEffectUpdate(player)
end

local function PostTearInit()
end

local function PostTearUpdate()
end

local function PostTearRender()
end

local function PreTearCollision()
end

---@param familiar Component.Entity.Familiar
local function PostFamiliarInit(familiar)
end

---@param familiar Component.Entity.Familiar
local function PostFamiliarUpdate(familiar)
end

local function PostFamiliarRender()
end

local function PreFamiliarCollision()
end

local function PostBombInit()
end

local function PostBombUpdate()
end

local function PostBombRender()
end

local function PreBombCollision()
end

---@param pickup Component.Entity.Pickup
local function PostPickupInit(pickup)
end

local function PostPickupUpdate()
end

local function PostPickupRender()
end

local function PrePickupCollision()
end

---@param pickup Component.Entity.Pickup
---@param variant integer
---@param subtype integer
---@return integer, integer
local function PostPickupSelection(pickup, variant, subtype)
end

local function PostLaserInit()
end

local function PostLaserUpdate()
end

local function PostLaserRender()
end

local function PostKnifeInit()
end

---@param knife Component.Entity.Knife
local function PostKnifeUpdate(knife)
end

local function PostKnifeRender()
end

local function PreKnifeCollision()
end

local function PostProjectileInit()
end

local function PostProjectileUpdate()
end

local function PostProjectileRender()
end

local function PreProjectileCollision()
end

---@param npc Component.Entity.Npc
local function PostNPCInit(npc)
end

local function PreNPCUpdate()
end

---@param npc Component.Entity.Npc
local function PostNPCUpdate(npc)
end

local function PostNPCRender()
end

local function PostNPCDeath()
end

local function PreNPCCollision()
end

local function PostEffectInit()
end

local function PostEffectUpdate()
end

local function PostEffectRender()
end

---@class LuaCallbacks
local Module = {}

--#region Module

Module.PostNPCUpdate = PostNPCUpdate
Module.PostUpdate = PostUpdate
Module.PostRender = PostRender
Module.PostUseItem = PostUseItem
Module.PostPlayerEffectUpdate = PostPlayerEffectUpdate
Module.PostUseCard = PostUseCard
Module.PostFamiliarUpdate = PostFamiliarUpdate
Module.PostFamiliarInit = PostFamiliarInit
Module.PostEvaluateItems = PostEvaluateItems
Module.PostPlayerInit = PostPlayerInit
Module.PostUsePillEffect = PostUsePillEffect
Module.PreEntityTakeDamage = PreEntityTakeDamage
Module.PostCurseEval = PostCurseEval
Module.PreActionHookB = PreActionHookB
Module.PreActionHookF = PreActionHookF
-- MC_LEVEL_GENERATOR has no caller
Module.PostGameStart = PostGameStart
Module.PostGameEnd = PostGameEnd
Module.PreGameExit = PreGameExit
Module.PostLevelLoad = PostLevelLoad
Module.PostRoomLoad = PostRoomLoad
Module.GetCard = GetCard
Module.GetShaderParams = GetShaderParams
Module.ExecuteConCommand = ExecuteConCommand
Module.PreUseItem = PreUseItem
Module.PreEntitySpawn = PreEntitySpawn
Module.PostFamiliarRender = PostFamiliarRender
Module.PreFamiliarCollision = PreFamiliarCollision
Module.PostNPCInit = PostNPCInit
Module.PostNPCRender = PostNPCRender
Module.PostNPCDeath = PostNPCDeath
Module.PreNPCCollision = PreNPCCollision
Module.PostPlayerUpdate = PostPlayerUpdate
Module.PostPlayerRender = PostPlayerRender
Module.PrePlayerCollision = PrePlayerCollision
Module.PostPickupInit = PostPickupInit
Module.PostPickupUpdate = PostPickupUpdate
Module.PostPickupRender = PostPickupRender
Module.PostPickupSelection = PostPickupSelection
Module.PrePickupCollision = PrePickupCollision
Module.PostTearInit = PostTearInit
Module.PostTearUpdate = PostTearUpdate
Module.PostTearRender = PostTearRender
Module.PreTearCollision = PreTearCollision
Module.PostProjectileInit = PostProjectileInit
Module.PostProjectileUpdate = PostProjectileUpdate
Module.PostProjectileRender = PostProjectileRender
Module.PreProjectileCollision = PreProjectileCollision
Module.PostLaserInit = PostLaserInit
Module.PostLaserUpdate = PostLaserUpdate
Module.PostLaserRender = PostLaserRender
Module.PostKnifeInit = PostKnifeInit
Module.PostKnifeUpdate = PostKnifeUpdate
Module.PostKnifeRender = PostKnifeRender
Module.PreKnifeCollision = PreKnifeCollision
Module.PostEffectInit = PostEffectInit
Module.PostEffectUpdate = PostEffectUpdate
Module.PostEffectRender = PostEffectRender
Module.PostBombInit = PostBombInit
Module.PostBombUpdate = PostBombUpdate
Module.PostBombRender = PostBombRender
Module.PreBombCollision = PreBombCollision
Module.PostFireTear = PostFireTear
Module.PreGetCollectible = PreGetCollectible
Module.PostGetCollectible = PostGetCollectible
Module.GetPill = GetPill
Module.GetPillEffect = GetPillEffect
Module.GetTrinket = GetTrinket
Module.PostEntityRemove = PostEntityRemove
Module.PostEntityKill = PostEntityKill
Module.PreNPCUpdate = PreNPCUpdate
Module.PreSpawnCleanAward = PreSpawnCleanAward
Module.PreRoomEntitySpawn = PreRoomEntitySpawn

--#endregion

return Module