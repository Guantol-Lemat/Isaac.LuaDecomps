---@class Decomp.IGlobalAPI
---@field Manager Decomp.IManager
---@field Game Decomp.IGame
---@field Level Decomp.ILevel
---@field Room Decomp.IRoom
---@field RoomDescriptor Decomp.IRoomDescriptor
---@field ItemPool Decomp.IItemPool
---@field Seeds Decomp.ISeeds
---@field ItemConfig Decomp.IItemConfig
---@field SFXManager Decomp.ISFXManager
---@field MusicManager Decomp.IMusicManager
---@field PlayerManager Decomp.IPlayerManager
---@field PersistentGameData Decomp.IPersistentGameData
---@field Entity Decomp.IEntity
---@field EntityPlayer Decomp.IEntityPlayer
---@field TemporaryEffects Decomp.ITemporaryEffects
---@field Backdrop Decomp.IBackdrop
---@field RoomTransition Decomp.IRoomTransition
---@field DeathmatchManager Decomp.IDeathmatchManager
---@field CppContainer Decomp.ICppContainer

---@class Decomp.IEnvironment
---@class Decomp.IGameObject
---@class Decomp.ILevelObject
---@class Decomp.IRoomObject
---@class Decomp.IRoomDescObject
---@class Decomp.IItemPoolObject
---@class Decomp.ISeedsObject
---@class Decomp.IPlayerManagerObject
---@class Decomp.IPersistentGameDataObject
---@class Decomp.IItemConfigObject
---@class Decomp.IRoomConfigObject
---@class Decomp.IEntityObject
---@class Decomp.IEntityPlayerObject : Decomp.IEntityObject
---@class Decomp.IEntityTearObject : Decomp.IEntityObject
---@class Decomp.IEntityProjectileObject : Decomp.IEntityObject
---@class Decomp.ITemporaryEffectsObject
---@class Decomp.IBackdropObject
---@class Decomp.IRoomTransitionObject
---@class Decomp.IDeathmatchManagerObject
---@class Decomp.IMusicManagerObject
---@generic T
---@class Decomp.ICppContainerObject<T>

---Entity virtual methods
---@class Decomp.IEntityObject
---@field Update fun(self: Decomp.IEntityObject)

---@class Decomp.IManager
---@field GetGame fun(env: Decomp.IEnvironment): Decomp.IGameObject
---@field GetItemConfig fun(env: Decomp.IEnvironment): Decomp.IItemConfigObject
---@field GetPersistentGameData fun(env: Decomp.IEnvironment): Decomp.IPersistentGameDataObject
---@field GetMusicManager fun(env: Decomp.IEnvironment): Decomp.IMusicManagerObject
---@field LogMessage fun(logType: integer, message: string, ...)
---@field RunCallback fun(env: Decomp.IEnvironment, callback: ModCallbacks): any

---@class Decomp.IGame
---@field GetLevel fun(game: Decomp.IGameObject): Decomp.ILevelObject
---@field GetRoom fun(game: Decomp.IGameObject): Decomp.IRoomObject
---@field GetCurrentRoomDesc fun(game: Decomp.IGameObject): Decomp.IRoomDescObject
---@field GetDifficulty fun(game: Decomp.IGameObject): Difficulty
---@field GetChallenge fun(game: Decomp.IGameObject): Challenge
---@field GetItemPool fun(game: Decomp.IGameObject): Decomp.IItemPoolObject
---@field GetSeeds fun(game: Decomp.IGameObject): Decomp.ISeedsObject
---@field GetPlayerManager fun(game: Decomp.IGameObject): Decomp.IPlayerManagerObject
---@field GetRoomTransition fun(game: Decomp.IGameObject): Decomp.IRoomTransitionObject
---@field GetDeathmatchManager fun(game: Decomp.IGameObject): Decomp.IDeathmatchManagerObject
---@field IsGreedMode fun(game: Decomp.IGameObject): boolean
---@field IsRestoringGlowingHourglass fun(game: Decomp.IGameObject): boolean

---@class Decomp.ILevel
---@field GetStage fun(level: Decomp.ILevelObject): LevelStage
---@field GetStageType fun(level: Decomp.ILevelObject): StageType
---@field GetDimension fun(level: Decomp.ILevelObject): Dimension
---@field IsAltPath fun(level: Decomp.ILevelObject): boolean
---@field HasAbandonedMineshaft fun(level: Decomp.ILevelObject): boolean
---@field IsBackwardsPath fun(level: Decomp.ILevelObject): boolean
---@field GetRoomByIdx fun(level: Decomp.ILevelObject, roomIdx: GridRooms | integer, dimension: Dimension): Decomp.IRoomDescObject
---@field GetStateFlag fun(level: Decomp.ILevelObject, flag: LevelStateFlag): boolean
---@field GetStageID fun(level: Decomp.ILevelObject): StbType

---@class Decomp.IRoom
---@field GetRoomType fun(room: Decomp.IRoomObject): RoomType | integer
---@field GetRoomDescriptor fun(room: Decomp.IRoomObject): Decomp.IRoomDescObject
---@field GetRoomGridIdx fun(room: Decomp.IRoomObject): GridRooms | integer
---@field GetTemporaryEffects fun(room: Decomp.IRoomObject): Decomp.ITemporaryEffectsObject
---@field GetSeededCollectible fun(room: Decomp.IRoomObject, seed: integer, advanceRNG: boolean): CollectibleType | integer
---@field GetRoomEntities fun(room: Decomp.IRoomObject): Decomp.ICppContainerObject<Decomp.IEntityObject>
---@field Init fun(room: Decomp.IRoomObject, roomData: RoomConfigRoom, roomDesc: Decomp.IRoomDescObject)
---@field TrySpawnBlueWombDoor fun(room: Decomp.IRoomObject, firstTime: boolean, ignoreTime: boolean, force: boolean): boolean
---@field TrySpawnBossRushDoor fun(room: Decomp.IRoomObject, ignoreTime: boolean, force: boolean): boolean
---@field TrySpawnDevilRoomDoor fun(room: Decomp.IRoomObject, animate: boolean, force: boolean): boolean
---@field TrySpawnMegaSatanRoomDoor fun(room: Decomp.IRoomObject, force: boolean): boolean
---@field TrySpawnSecretExit fun(room: Decomp.IRoomObject, animate: boolean, force: boolean): boolean
---@field TrySpawnSecretShop fun(room: Decomp.IRoomObject, force: boolean): boolean
---@field TrySpawnTheVoidDoor fun(room: Decomp.IRoomObject, force: boolean): boolean
---@field UpdateRedKey fun(room: Decomp.IRoomObject)
---@field IsBeastRoom fun(room: Decomp.IRoomObject): boolean

---@class Decomp.IRoomDescriptor
---@field GetGridIdx fun(roomDesc: Decomp.IRoomDescObject): GridRooms | integer
---@field GetRoomData fun(roomDesc: Decomp.IRoomDescObject): RoomConfigRoom
---@field SetRoomData fun(roomDesc: Decomp.IRoomDescObject, data: RoomConfigRoom)
---@field GetEffectiveRoomData fun(roomDesc: Decomp.IRoomDescObject): RoomConfigRoom
---@field GetDecorationSeed fun(roomDesc: Decomp.IRoomDescObject): integer
---@field GetSpawnSeed fun(roomDesc: Decomp.IRoomDescObject): integer
---@field GetAwardSeed fun(roomDesc: Decomp.IRoomDescObject): integer
---@field SetAwardSeed fun(roomDesc: Decomp.IRoomDescObject, seed: integer)
---@field GetVisitedCount fun(roomDesc: Decomp.IRoomDescObject): integer
---@field SetVisitedCount fun(roomDesc: Decomp.IRoomDescObject, visitedCount: integer)
---@field AddFlags fun(roomDesc: Decomp.IRoomDescObject, flags: integer)
---@field ClearFlags fun(roomDesc: Decomp.IRoomDescObject, flags: integer)
---@field HasFlags fun(roomDesc: Decomp.IRoomDescObject, flags: integer): boolean

---@class Decomp.IItemPool
---@field GetCollectible fun(itemPool: Decomp.IItemPoolObject, poolType: ItemPoolType | integer, decrease: boolean, seed: integer, defaultItem: CollectibleType | integer, flags: GetCollectibleFlag | integer): CollectibleType | integer
---@field GetTrinket fun(itemPool: Decomp.IItemPoolObject, dontAdvanceRNG: boolean): TrinketType | integer
---@field GetCard fun(itemPool: Decomp.IItemPoolObject, seed: integer, playing: boolean, rune: boolean, onlyRunes: boolean): Card | integer
---@field GetCardEx fun(itemPool: Decomp.IItemPoolObject, seed: integer, specialChance: integer, runeChance: integer, suitChance: integer, allowNonCards: boolean): Card | integer
---@field GetPill fun(itemPool: Decomp.IItemPoolObject, seed: integer): PillColor | integer
---@field ResetRoomBlacklist fun(itemPool: Decomp.IItemPoolObject)

---@class Decomp.ISeeds
---@field HasSeedEffect fun(seeds: Decomp.ISeedsObject, seed: SeedEffect): boolean

---@class Decomp.IItemConfig
---@field GetCollectible fun(itemConfig: Decomp.IItemConfigObject, collectible: CollectibleType | integer): ItemConfigItem?
---@field GetTrinket fun(itemConfig: Decomp.IItemConfigObject, trinket: TrinketType | integer): ItemConfigItem?
---@field GetCard fun(itemConfig: Decomp.IItemConfigObject, card: Card | integer): ItemConfigCard?
---@field GetPillEffect fun(itemConfig: Decomp.IItemConfigObject, pill: PillEffect | integer): ItemConfigPillEffect?

---@class Decomp.IPlayerManager
---@field GetPlayer fun(playerManager: Decomp.IPlayerManagerObject, index: integer): Decomp.IEntityPlayerObject
---@field GetNumPlayers fun(playerManager: Decomp.IPlayerManagerObject): integer
---@field GetNumCollectibles fun(playerManager: Decomp.IPlayerManagerObject, collectible: CollectibleType | integer): integer
---@field GetTrinketMultiplier fun(playerManager: Decomp.IPlayerManagerObject, trinket: TrinketType | integer): integer
---@field AnyoneIsPlayerType fun(playerManager: Decomp.IPlayerManagerObject, playerType: PlayerType | integer): boolean
---@field AnyoneHasCollectible fun(playerManager: Decomp.IPlayerManagerObject, collectible: CollectibleType | integer): boolean
---@field AnyoneHasTrinket fun(playerManager: Decomp.IPlayerManagerObject, trinket: TrinketType | integer): boolean
---@field AnyPlayerTypeHasBirthright fun(playerManager: Decomp.IPlayerManagerObject, playerType: PlayerType | integer): boolean
---@field TriggerNewRoom fun(playerManager: Decomp.IPlayerManagerObject)

---@class Decomp.IPersistentGameData
---@field Unlocked fun(persistentGameData: Decomp.IPersistentGameDataObject, achievement: Achievement | integer): boolean

---@class Decomp.IEntity
---@field GetVariant fun(entity: Decomp.IEntityObject): integer
---@field GetParent fun(entity: Decomp.IEntityObject): Decomp.IEntityObject?
---@field GetPositionOffset fun(entity: Decomp.IEntityObject): Vector
---@field SetEntityCollisionClass fun(entity: Decomp.IEntityObject, class: EntityCollisionClass)
---@field SetGridCollisionClass fun(entity: Decomp.IEntityObject, class: GridCollisionClass)

---@class Decomp.IEntityPlayer
---@field IsCoopGhost fun(player: Decomp.IEntityPlayerObject): boolean
---@field GetHealthType fun(player: Decomp.IEntityPlayerObject): HealthType
---@field GetEffectiveMaxHearts fun(player: Decomp.IEntityPlayerObject): integer
---@field GetSoulHearts fun(player: Decomp.IEntityPlayerObject): integer
---@field IsHologram fun(player: Decomp.IEntityPlayerObject): boolean
---@field HasInstantDeathCurse fun(player: Decomp.IEntityPlayerObject): boolean

---@class Decomp.ITemporaryEffects
---@field HasCollectibleEffect fun(effects: Decomp.ITemporaryEffectsObject, collectible: CollectibleType | integer): boolean

---@class Decomp.IBackdrop
---@field GetType fun(backdrop: Decomp.IBackdropObject): BackdropType

---@class Decomp.IRoomTransition
---@field GetTransitionMode fun(roomTransition: Decomp.IRoomTransitionObject): integer
---@field IsActive fun(roomTransition: Decomp.IRoomTransitionObject): boolean
---@field HasFlags fun(roomTransition: Decomp.IRoomTransitionObject, flags: integer): boolean

---@class Decomp.IDeathmatchManager
---@field IsInDeathmatch fun(deathmatch: Decomp.IDeathmatchManagerObject)

---@class Decomp.IMusicManager
---@field SetVolume fun(musicManager: Decomp.IMusicManagerObject, volume: number)
---@field SetPitch fun(musicManager: Decomp.IMusicManagerObject, pitch: number)
---@field ResetPitch fun(musicManager: Decomp.IMusicManagerObject)

---@generic T
---@class Decomp.ICppContainer<T>
local CppContainer = {}

---@generic T
---@param container Decomp.ICppContainerObject<T>
---@param index integer
---@return T
function CppContainer.Get(container, index)
    return container[index]
end

---@generic T
---@param container Decomp.ICppContainerObject<T>
---@return integer
function CppContainer.GetSize(container)
    return #container
end

---@generic T
---@param container Decomp.ICppContainerObject<T>
---@return fun(): integer, T
function CppContainer.iterator(container)
    local i = 0
    return function()
        i = i + 1
        if i <= #container then
            return i, container[i]
        end
    end
end