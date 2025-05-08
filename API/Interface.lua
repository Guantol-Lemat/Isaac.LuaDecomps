---@class Decomp.IGlobalAPI
---@field Environment Decomp.IEnvironment
---@field Game Decomp.IGame
---@field Level Decomp.ILevel
---@field Room Decomp.IRoom
---@field RoomDescriptor Decomp.IRoomDescriptor
---@field ItemPool Decomp.IItemPool
---@field BossPool Decomp.IBossPool
---@field DailyChallenge Decomp.IDailyChallenge
---@field ChallengeParams Decomp.IChallengeParams
---@field Seeds Decomp.ISeeds
---@field ItemConfig Decomp.IItemConfig
---@field SFXManager Decomp.ISFXManager
---@field MusicManager Decomp.IMusicManager
---@field PlayerManager Decomp.IPlayerManager
---@field PersistentGameData Decomp.IPersistentGameData
---@field Entity Decomp.IEntity
---@field EntityPlayer Decomp.IEntityPlayer
---@field EntityPickup Decomp.IEntityPickup
---@field TemporaryEffects Decomp.ITemporaryEffects
---@field Backdrop Decomp.IBackdrop
---@field RoomTransition Decomp.IRoomTransition
---@field DeathmatchManager Decomp.IDeathmatchManager
---@field CppContainer Decomp.ICppContainer

---@class Decomp.EnvironmentObject
---@class Decomp.GameObject
---@class Decomp.LevelObject
---@class Decomp.RoomObject
---@class Decomp.RoomDescObject
---@class Decomp.ItemPoolObject
---@class Decomp.BossPoolObject
---@class Decomp.ChallengeParamObject
---@class Decomp.DailyChallengeObject
---@class Decomp.SeedsObject
---@class Decomp.PlayerManagerObject
---@class Decomp.PersistentGameDataObject
---@class Decomp.ItemConfigObject
---@class Decomp.RoomConfigObject
---@class Decomp.EntityObject
---@class Decomp.EntityPlayerObject : Decomp.EntityObject
---@class Decomp.EntityTearObject : Decomp.EntityObject
---@class Decomp.EntityPickupObject : Decomp.EntityObject
---@class Decomp.EntityProjectileObject : Decomp.EntityObject
---@class Decomp.GridEntityObject
---@class Decomp.TemporaryEffectsObject
---@class Decomp.BackdropObject
---@class Decomp.RoomTransitionObject
---@class Decomp.DeathmatchManagerObject
---@class Decomp.MusicManagerObject
---@generic T
---@class Decomp.CppContainerObject<T>

---@class Decomp.EnvironmentObject
---@field _API Decomp.IGlobalAPI

---Entity virtual methods
---@class Decomp.EntityObject
---@field Update fun(self: Decomp.EntityObject)

---GridEntity virtual methods
---@class Decomp.GridEntityObject
---@field Destroy fun(self: Decomp.GridEntityObject, immediate: boolean): boolean

---@class Decomp.IEnvironment
---@field GetGame fun(env: Decomp.EnvironmentObject): Decomp.GameObject
---@field GetLevel fun(env: Decomp.EnvironmentObject): Decomp.LevelObject
---@field GetRoom fun(env: Decomp.EnvironmentObject): Decomp.RoomObject
---@field GetCurrentRoomDesc fun(env: Decomp.EnvironmentObject): Decomp.RoomDescObject
---@field GetPlayerManager fun(env: Decomp.EnvironmentObject): Decomp.PlayerManagerObject
---@field GetPlayer fun(env: Decomp.EnvironmentObject, index: integer?): Decomp.EntityPlayerObject
---@field GetSeeds fun(env: Decomp.EnvironmentObject): Decomp.SeedsObject
---@field GetItemPool fun(env: Decomp.EnvironmentObject): Decomp.ItemPoolObject
---@field GetBossPool fun(env: Decomp.EnvironmentObject): Decomp.BossPoolObject
---@field GetItemConfig fun(env: Decomp.EnvironmentObject): Decomp.ItemConfigObject
---@field GetPersistentGameData fun(env: Decomp.EnvironmentObject): Decomp.PersistentGameDataObject
---@field GetMusicManager fun(env: Decomp.EnvironmentObject): Decomp.MusicManagerObject
---@field LogMessage fun(logType: integer, message: string, ...)
---@field RunCallback fun(env: Decomp.EnvironmentObject, callback: ModCallbacks, ...): any

---@class Decomp.IGame
---@field GetLevel fun(game: Decomp.GameObject): Decomp.LevelObject
---@field GetRoom fun(game: Decomp.GameObject): Decomp.RoomObject
---@field GetCurrentRoomDesc fun(game: Decomp.GameObject): Decomp.RoomDescObject
---@field GetDifficulty fun(game: Decomp.GameObject): Difficulty
---@field GetChallenge fun(game: Decomp.GameObject): Challenge
---@field GetDailyChallenge fun(game: Decomp.GameObject): Decomp.DailyChallengeObject
---@field GetChallengeParams fun(game: Decomp.GameObject): Decomp.ChallengeParamObject
---@field GetItemPool fun(game: Decomp.GameObject): Decomp.ItemPoolObject
---@field GetBossPool fun(game: Decomp.GameObject): Decomp.BossPoolObject
---@field GetSeeds fun(game: Decomp.GameObject): Decomp.SeedsObject
---@field GetPlayerManager fun(game: Decomp.GameObject): Decomp.PlayerManagerObject
---@field GetRoomTransition fun(game: Decomp.GameObject): Decomp.RoomTransitionObject
---@field GetDeathmatchManager fun(game: Decomp.GameObject): Decomp.DeathmatchManagerObject
---@field GetDevilRoomDeals fun(game: Decomp.GameObject): integer
---@field Spawn fun(game: Decomp.GameObject, type: EntityType | integer, variant: integer, position: Vector, velocity: Vector, spawner: Decomp.EntityObject?, subType: integer, seed: integer): Decomp.EntityObject
---@field IsHardMode fun(game: Decomp.GameObject): boolean
---@field IsGreedMode fun(game: Decomp.GameObject): boolean
---@field IsRestoringGlowingHourglass fun(game: Decomp.GameObject): boolean

---@class Decomp.ILevel
---@field GetStage fun(level: Decomp.LevelObject): LevelStage
---@field GetStageType fun(level: Decomp.LevelObject): StageType
---@field GetAbsoluteStage fun(level: Decomp.LevelObject): LevelStage
---@field GetCurses fun(level: Decomp.LevelObject): integer
---@field GetRoom fun(level: Decomp.LevelObject): Decomp.RoomObject
---@field GetCurrentRoomIndex fun(level: Decomp.LevelObject): GridRooms | integer
---@field GetDimension fun(level: Decomp.LevelObject): Dimension
---@field GetRoomByIdx fun(level: Decomp.LevelObject, roomIdx: GridRooms | integer, dimension: Dimension): Decomp.RoomDescObject
---@field GetStateFlag fun(level: Decomp.LevelObject, flag: LevelStateFlag): boolean
---@field GetStageID fun(level: Decomp.LevelObject): StbType
---@field IsAltPath fun(level: Decomp.LevelObject): boolean
---@field HasMirrorDimension fun(level: Decomp.LevelObject): boolean
---@field HasAbandonedMineshaft fun(level: Decomp.LevelObject): boolean
---@field IsAscent fun(level: Decomp.LevelObject): boolean
---@field IsBackwardsPath fun(level: Decomp.LevelObject): boolean
---@field IsCorpseEntrance fun(level: Decomp.LevelObject): boolean
---@field IsStageAvailable fun(level: Decomp.LevelObject, stage: LevelStage, stageType: StageType): boolean
---@field IsNextStageAvailable fun(level: Decomp.LevelObject): boolean

---@class Decomp.IRoom
---@field GetRoomType fun(room: Decomp.RoomObject): RoomType | integer
---@field GetRoomDescriptor fun(room: Decomp.RoomObject): Decomp.RoomDescObject
---@field GetRoomGridIdx fun(room: Decomp.RoomObject): GridRooms | integer
---@field GetRoomConfigStage fun(room: Decomp.RoomObject): StbType | integer
---@field GetTemporaryEffects fun(room: Decomp.RoomObject): Decomp.TemporaryEffectsObject
---@field GetSeededCollectible fun(room: Decomp.RoomObject, seed: integer, advanceRNG: boolean): CollectibleType | integer
---@field GetRoomEntities fun(room: Decomp.RoomObject): Decomp.CppContainerObject<Decomp.EntityObject>
---@field GetGridEntity fun(room: Decomp.RoomObject, gridIdx: integer): Decomp.GridEntityObject?
---@field GetTintedRockIdx fun(room: Decomp.RoomObject): integer
---@field GetDoorSlotPosition fun(room: Decomp.RoomObject, doorSlot: DoorSlot): Vector
---@field GetWidth fun(room: Decomp.RoomObject): integer
---@field GetHeight fun(room: Decomp.RoomObject): integer
---@field GetGridPosition fun(room: Decomp.RoomObject, gridIdx: integer): Vector
---@field GetGridIndex fun(room: Decomp.RoomObject, position: Vector): integer
---@field SetWaterCurrent fun(room: Decomp.RoomObject, value: Vector)
---@field Init fun(room: Decomp.RoomObject, roomData: RoomConfigRoom, roomDesc: Decomp.RoomDescObject)
---@field HasRoomConfigFlag fun(room: Decomp.RoomObject, flag: integer)
---@field TrySpawnBlueWombDoor fun(room: Decomp.RoomObject, firstTime: boolean, ignoreTime: boolean, force: boolean): boolean
---@field TrySpawnBossRushDoor fun(room: Decomp.RoomObject, ignoreTime: boolean, force: boolean): boolean
---@field TrySpawnDevilRoomDoor fun(room: Decomp.RoomObject, animate: boolean, force: boolean): boolean
---@field TrySpawnMegaSatanRoomDoor fun(room: Decomp.RoomObject, force: boolean): boolean
---@field TrySpawnSecretExit fun(room: Decomp.RoomObject, animate: boolean, force: boolean): boolean
---@field TrySpawnSecretShop fun(room: Decomp.RoomObject, force: boolean): boolean
---@field TrySpawnTheVoidDoor fun(room: Decomp.RoomObject, force: boolean): boolean
---@field UpdateRedKey fun(room: Decomp.RoomObject)
---@field IsBeastRoom fun(room: Decomp.RoomObject): boolean
---@field IsDoorSlotAllowed fun(room: Decomp.RoomObject, doorSlot: DoorSlot): boolean
---@field is_persistent_room_entity fun(room: Decomp.RoomObject, type: EntityType | integer, variant: integer): boolean
---@field ShouldSaveEntity fun(room: Decomp.RoomObject, type: EntityType | integer, variant: integer, subType: integer, spawnerType: EntityType | integer, roomCleared: boolean): boolean

---@class Decomp.IRoomDescriptor
---@field GetGridIdx fun(roomDesc: Decomp.RoomDescObject): GridRooms | integer
---@field GetRoomData fun(roomDesc: Decomp.RoomDescObject): RoomConfigRoom
---@field SetRoomData fun(roomDesc: Decomp.RoomDescObject, data: RoomConfigRoom)
---@field GetEffectiveRoomData fun(roomDesc: Decomp.RoomDescObject): RoomConfigRoom
---@field GetDecorationSeed fun(roomDesc: Decomp.RoomDescObject): integer
---@field GetSpawnSeed fun(roomDesc: Decomp.RoomDescObject): integer
---@field GetAwardSeed fun(roomDesc: Decomp.RoomDescObject): integer
---@field SetAwardSeed fun(roomDesc: Decomp.RoomDescObject, seed: integer)
---@field GetVisitedCount fun(roomDesc: Decomp.RoomDescObject): integer
---@field SetVisitedCount fun(roomDesc: Decomp.RoomDescObject, visitedCount: integer)
---@field GetRestrictedGridIndexes fun(roomDesc: Decomp.RoomDescObject): integer[]
---@field AddFlags fun(roomDesc: Decomp.RoomDescObject, flags: integer)
---@field ClearFlags fun(roomDesc: Decomp.RoomDescObject, flags: integer)
---@field HasFlags fun(roomDesc: Decomp.RoomDescObject, flags: integer): boolean
---@field AddRestrictedGridIndex fun(roomDesc: Decomp.RoomDescObject, index: integer)

---@class Decomp.IItemPool
---@field GetCollectible fun(itemPool: Decomp.ItemPoolObject, poolType: ItemPoolType | integer, decrease: boolean, seed: integer, defaultItem: CollectibleType | integer, flags: GetCollectibleFlag | integer): CollectibleType | integer
---@field GetTrinket fun(itemPool: Decomp.ItemPoolObject, dontAdvanceRNG: boolean): TrinketType | integer
---@field GetCard fun(itemPool: Decomp.ItemPoolObject, seed: integer, playing: boolean, rune: boolean, onlyRunes: boolean): Card | integer
---@field GetCardEx fun(itemPool: Decomp.ItemPoolObject, seed: integer, specialChance: integer, runeChance: integer, suitChance: integer, allowNonCards: boolean): Card | integer
---@field GetPill fun(itemPool: Decomp.ItemPoolObject, seed: integer): PillColor | integer
---@field ResetRoomBlacklist fun(itemPool: Decomp.ItemPoolObject)

---@class Decomp.IBossPool
---@field GetRemovedBosses fun(bossPool: Decomp.BossPoolObject): table<BossType, boolean>

---@class Decomp.IDailyChallenge
---@field GetSpecialRunID fun(dailyChallenge: Decomp.DailyChallengeObject): integer

---@class Decomp.IChallengeParams
---@field IsAltPath fun(challengeParams: Decomp.ChallengeParamObject): boolean
---@field GetEndStage fun(challengeParams: Decomp.ChallengeParamObject): StageType

---@class Decomp.ISeeds
---@field HasSeedEffect fun(seeds: Decomp.SeedsObject, seed: SeedEffect): boolean

---@class Decomp.IItemConfig
---@field GetCollectible fun(itemConfig: Decomp.ItemConfigObject, collectible: CollectibleType | integer): ItemConfigItem?
---@field GetTrinket fun(itemConfig: Decomp.ItemConfigObject, trinket: TrinketType | integer): ItemConfigItem?
---@field GetCard fun(itemConfig: Decomp.ItemConfigObject, card: Card | integer): ItemConfigCard?
---@field GetPillEffect fun(itemConfig: Decomp.ItemConfigObject, pill: PillEffect | integer): ItemConfigPillEffect?

---@class Decomp.IPlayerManager
---@field GetPlayer fun(playerManager: Decomp.PlayerManagerObject, index: integer): Decomp.EntityPlayerObject
---@field GetNumPlayers fun(playerManager: Decomp.PlayerManagerObject): integer
---@field GetNumCollectibles fun(playerManager: Decomp.PlayerManagerObject, collectible: CollectibleType | integer): integer
---@field GetTrinketMultiplier fun(playerManager: Decomp.PlayerManagerObject, trinket: TrinketType | integer): integer
---@field AnyoneIsPlayerType fun(playerManager: Decomp.PlayerManagerObject, playerType: PlayerType | integer): boolean
---@field AnyoneHasCollectible fun(playerManager: Decomp.PlayerManagerObject, collectible: CollectibleType | integer): boolean
---@field AnyoneHasTrinket fun(playerManager: Decomp.PlayerManagerObject, trinket: TrinketType | integer): boolean
---@field AnyPlayerTypeHasBirthright fun(playerManager: Decomp.PlayerManagerObject, playerType: PlayerType | integer): boolean
---@field GetRandomCollectibleOwner fun(playerManager: Decomp.PlayerManagerObject, collectible: CollectibleType | integer, seed: integer): Decomp.EntityPlayerObject?
---@field TriggerNewRoom fun(playerManager: Decomp.PlayerManagerObject)

---@class Decomp.IPersistentGameData
---@field Unlocked fun(persistentGameData: Decomp.PersistentGameDataObject, achievement: Achievement | integer): boolean

---@class Decomp.IEntity
---@field ToPickup fun(entity: Decomp.EntityObject): Decomp.EntityPickupObject?
---@field GetType fun(entity: Decomp.EntityObject): EntityType | integer
---@field GetVariant fun(entity: Decomp.EntityObject): integer
---@field GetSubType fun(entity: Decomp.EntityObject): integer
---@field GetParent fun(entity: Decomp.EntityObject): Decomp.EntityObject?
---@field GetPositionOffset fun(entity: Decomp.EntityObject): Vector
---@field SetEntityCollisionClass fun(entity: Decomp.EntityObject, class: EntityCollisionClass)
---@field SetGridCollisionClass fun(entity: Decomp.EntityObject, class: GridCollisionClass)
---@field SetSpawnGridIndex fun(entity: Decomp.EntityObject, gridIdx: integer)

---@class Decomp.IEntityPlayer
---@field GetPlayerType fun(player: Decomp.EntityPlayerObject): PlayerType | integer
---@field GetLuck fun(player: Decomp.EntityPlayerObject): number
---@field IsCoopGhost fun(player: Decomp.EntityPlayerObject): boolean
---@field GetHealthType fun(player: Decomp.EntityPlayerObject): HealthType
---@field GetEffectiveMaxHearts fun(player: Decomp.EntityPlayerObject): integer
---@field GetSoulHearts fun(player: Decomp.EntityPlayerObject): integer
---@field IsHologram fun(player: Decomp.EntityPlayerObject): boolean
---@field HasInstantDeathCurse fun(player: Decomp.EntityPlayerObject): boolean

---@class Decomp.IEntityPickup
---@field SetWait fun(pickup: Decomp.EntityPickupObject, value: integer)
---@field SetCycleNum fun(pickup: Decomp.EntityPickupObject, value: integer)
---@field SetOptionsPickupIndex fun(pickup: Decomp.EntityPickupObject, value: integer)
---@field InitFlipState fun(pickup: Decomp.EntityPickupObject)

---@class Decomp.ITemporaryEffects
---@field HasCollectibleEffect fun(effects: Decomp.TemporaryEffectsObject, collectible: CollectibleType | integer): boolean

---@class Decomp.IBackdrop
---@field GetType fun(backdrop: Decomp.BackdropObject): BackdropType

---@class Decomp.IRoomTransition
---@field GetTransitionMode fun(roomTransition: Decomp.RoomTransitionObject): integer
---@field IsActive fun(roomTransition: Decomp.RoomTransitionObject): boolean
---@field HasFlags fun(roomTransition: Decomp.RoomTransitionObject, flags: integer): boolean

---@class Decomp.IDeathmatchManager
---@field IsInDeathmatch fun(deathmatch: Decomp.DeathmatchManagerObject)

---@class Decomp.IMusicManager
---@field SetVolume fun(musicManager: Decomp.MusicManagerObject, volume: number)
---@field SetPitch fun(musicManager: Decomp.MusicManagerObject, pitch: number)
---@field ResetPitch fun(musicManager: Decomp.MusicManagerObject)

---@generic T
---@class Decomp.ICppContainer<T>
local CppContainer = {}

---@generic T
---@param container Decomp.CppContainerObject<T>
---@param index integer
---@return T
function CppContainer.Get(container, index)
    return container[index]
end

---@generic T
---@param container Decomp.CppContainerObject<T>
---@return integer
function CppContainer.GetSize(container)
    return #container
end

---@generic T
---@param container Decomp.CppContainerObject<T>
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