--#region Dependencies

local TableUtils = require("General.Table")
local MathUtils = require("General.Math")
local VectorUtils = require("General.Math.VectorUtils")
local IsaacUtils = require("Isaac.Utils")
local Callbacks = require("LuaEngine.Callbacks")
local EntityUtils = require("Entity.Utils")
local EntityCast = require("Entity.TypeCast")
local EntityUpdate = require("Entity.Common.Update")
local EntityIdentity = require("Entity.Identity")
local KnifeUtils = require("Entity.Knife.Utils")
local KnifeMovement = require("Mechanics.Knife.Movement")
local KnifeAttack = require("Mechanics.Knife.Attack")
local TearParams = require("Mechanics.Tear.Params")
local TearAttack = require("Mechanics.Tear.Attack")
local LaserUtils = require("Entity.Laser.Utils")
local HomingLaser = require("Mechanics.Laser.HomingLaser")
local WeaponParams = require("Mechanics.Player.WeaponParams")
local PlayerInventory = require("Mechanics.Player.Inventory")
local GridUtils = require("GridEntity.Utils")
local SpawnLogic = require("Game.Spawn")
local StrangeAttractor = require("Mechanics.Game.StrangeAttractor")
local HitListUtils = require("Entity.System.HitList.Utils")
local RoomGrid = require("Game.Room.Grid")
local RoomBounds = require("Game.Room.Bounds")
local CellSpace = require("Game.Room.EntityManager.CellSpace")

local VectorZero = VectorUtils.VectorZero
local eKnifeSubType = EntityIdentity.eKnifeSubType
--#endregion

local REQUIRED_WEAPON = {
    [KnifeVariant.BONE_CLUB] = WeaponType.WEAPON_BONE,
    [KnifeVariant.SPIRIT_SWORD] = WeaponType.WEAPON_SPIRIT_SWORD
}

local NO_WEAPON_REQUIREMENT_KNIVES = TableUtils.CreateDictionary({
    KnifeVariant.BAG_OF_CRAFTING, 8, KnifeVariant.NOTCHED_AXE,
})

local SWORD_IDLE_ANIMATIONS = {
    [Direction.LEFT + 1] = "IdleLeft",
    [Direction.UP + 1] = "IdleUp",
    [Direction.RIGHT + 1] = "IdleRight",
    [Direction.DOWN + 1] = "IdleDown",
}

local SWORD_CHARGED_ANIMATIONS = {
    [Direction.LEFT + 1] = "ChargedLeft",
    [Direction.UP + 1] = "ChargedUp",
    [Direction.RIGHT + 1] = "ChargedRight",
    [Direction.DOWN + 1] = "ChargedDown",
}

local MULTIDIMENSIONAL_COLOR = {
    Color(-1.0, -1.0, -1.0, 1.0, 1.0, 1.0, 1.0),
    Color(-0.33, -0.33, -0.33, 1.0, 0.66, 0.66, 0.66),
    Color(0.33, 0.33, 0.33, 1.0, 0.33, 0.33, 0.33),
    Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0),
    Color(0.33, 0.33, 0.33, 1.0, 0.33, 0.33, 0.33),
    Color(-0.33, -0.33, -0.33, 1.0, 0.66, 0.66, 0.66),
}

---@param requiredWeapon WeaponType | integer
---@param isClub boolean
---@param isSword boolean
local function update_closure_pack(requiredWeapon, isClub, isSword)
    return table.pack(requiredWeapon, isClub, isSword)
end

---@param closure table
---@return WeaponType | integer requiredWeapon
---@return boolean isClub
---@return boolean isSword
local function update_closure_unpack(closure)
---@diagnostic disable-next-line: unused-function, redundant-return-value
    return table.unpack(closure)
end

---@param closure table
---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@param pivotRadius number
local function update_base_normal(closure, myContext, knife, pivotRadius)
    local requiredWeapon, isClub, isSword = update_closure_unpack(closure)
    local game = myContext.game

    local variant = knife.m_variant
    local player = KnifeUtils.GetPlayer(knife)
    local primaryKnife = KnifeUtils.GetPrimaryKnife(knife)

    -- check required weapon
    if not NO_WEAPON_REQUIREMENT_KNIVES[primaryKnife.m_variant] then
        local primaryParent = primaryKnife.m_parent.ref
        local primaryPlayer = nil

        -- get primary player
        if primaryParent then
            local parentType = primaryParent.m_type
            if parentType == EntityType.ENTITY_PLAYER then
                primaryPlayer = EntityCast.StaticToPlayer(primaryParent)
            elseif parentType == EntityType.ENTITY_FAMILIAR then
                local familiar = EntityCast.StaticToFamiliar(primaryParent)
                primaryPlayer = familiar.m_player
            end
        end

        if not primaryPlayer or primaryPlayer.m_enabledWeapons[requiredWeapon + 1] then
            return true -- remove
        end
    end

    local isPrimaryKnife = primaryKnife == knife
    local interpolationUpdate = knife.m_interpolated
    local sprite = knife.m_sprite

    if not isPrimaryKnife then
        -- play animation from primary on "init"
        if isClub or isSword and EntityUtils.GetFrameCount(myContext, knife) < 2 then
            local animation = primaryKnife.m_sprite:GetAnimation()
            sprite:Play(animation, false)
        end

        -- inherit data
        knife.m_rotation = primaryKnife.m_rotation
        knife.m_effectiveRotation = primaryKnife.m_effectiveRotation + knife.m_rotationOffset - primaryKnife.m_rotationOffset
        knife.m_charge = primaryKnife.m_charge

        -- shoot knife
        if not knife.m_isFlying and primaryKnife.m_isFlying then
            knife.m_hydroBounce_height = primaryKnife.m_hydroBounce_height
            knife.m_hydroBounce_gravitySpeed = primaryKnife.m_hydroBounce_gravitySpeed
            knife.m_0x424 = primaryKnife.m_0x424
            KnifeAttack.DoShootEffects(myContext, knife)
        end
    end

    local updatedSwing = false

    -- sword spin logic
    if isSword then
        if not sprite:IsEventTriggered("SwingEnd") or interpolationUpdate then
            -- activate spin attack on non primary knife
            if not isPrimaryKnife and (primaryKnife.m_spinAttack_isActive and not knife.m_spinAttack_isActive) then
                KnifeAttack.SpinAttack(myContext, knife, knife.m_spinAttack_remainingMultiShot, 0)
                updatedSwing = true
            end
            goto END_OF_SWORD_SPIN_LOGIC
        end

        local spinAttack = knife.m_spinAttack_isActive
        if not spinAttack and (knife.m_flags & EntityFlag.FLAG_SPAWN_STICKY_SPIDERS) ~= 0 then
            goto END_OF_SWORD_SPIN_LOGIC
        end

        --- shoot sword beam
        knife.m_flags = knife.m_flags & ~EntityFlag.FLAG_SPAWN_STICKY_SPIDERS
        local shotVelocity = Vector.FromAngle(knife.m_effectiveRotation) * 10.0

        if player then
            local inheritance = WeaponParams.GetTearMovementInheritance(myContext, player, shotVelocity, false)
            shotVelocity = (shotVelocity + inheritance) * player.m_shotSpeed
        end

        if spinAttack then
            shotVelocity = shotVelocity * 2
        end

        local tearVariant = variant == KnifeVariant.TECH_SWORD and TearVariant.TECH_SWORD_BEAM or TearVariant.SWORD_BEAM
        local ent = SpawnLogic.Spawn(myContext, game, EntityType.ENTITY_TEAR, tearVariant, 0, IsaacUtils.Random(), knife.m_position, shotVelocity, knife.m_spawnerEntity.ref)
        local beam = EntityCast.StaticToTear(ent)

        -- init beam data
        if player then
            beam.m_fallingAcceleration = player.m_tearFallingAcceleration
            beam.m_fallingSpeed = IsaacUtils.RandomFloat() * 0.2 - player.m_tearFallingSpeed
            TearParams.SetHeight(myContext, beam, player.m_tearHeight)
        end

        EntityUtils.SetEntityReference(beam.m_parent, knife.m_spawnerEntity.ref)
        local beamTearFlags = knife.m_tearFlags & ~TearFlags.TEAR_FETUS
        TearParams.SetTearFlags(beam, beamTearFlags)
        beam.m_unkBool = true
        beam:SetColor(myContext, knife.m_color, -1, -1, false, true)
        local collisionDamage = knife.m_spinAttack_isActive and knife.m_collisionDamage * 4.0 + 4.0 or knife.m_collisionDamage * 2.0
        beam:SetCollisionDamage(myContext, collisionDamage)
        TearParams.SetScale({seeds = game.m_seeds}, beam, knife.m_sprite.Scale.X)

        beam:Update(myContext)

        -- resolve multiShot spin attack
        local remainingMultiShot = knife.m_spinAttack_remainingMultiShot
        if spinAttack and remainingMultiShot > 1 then
            local swing = knife.m_swingEntity.ref
            if swing then
                swing:Remove(myContext)
            end

            remainingMultiShot = remainingMultiShot - 1
            knife.m_spinAttack_remainingMultiShot = remainingMultiShot
            KnifeAttack.SpinAttack(myContext, knife, remainingMultiShot, 2)
            updatedSwing = true
        end

        ::END_OF_SWORD_SPIN_LOGIC::
    end

    -- update swing
    if primaryKnife.m_isSwinging and not primaryKnife.m_isFlying and not updatedSwing then
        KnifeAttack.UpdateBoneSwing(myContext, knife)
        updatedSwing = true
    end

    -- update swing on non swinging sword
    if isSword and not primaryKnife.m_isSwinging then
        if primaryKnife.m_meleeSwingInputHeld_qqq then
            -- play appropriate animation
            local direction = Vector.FromAngle(knife.m_effectiveRotation)
            local movementDirection = EntityUtils.GetMovementDirection(direction)
            local animationSet = knife.m_swordCharged and SWORD_CHARGED_ANIMATIONS or SWORD_IDLE_ANIMATIONS
            knife.m_sprite:Play(animationSet[movementDirection + 1], false)
        end

        if not updatedSwing then
            KnifeAttack.UpdateBoneSwing(myContext, knife)
        end
    end

    ---@type EntityComponent
    local primaryParent = primaryKnife.m_parent.ref
    local holderAngle = 0.0

    if not primaryKnife.m_isFlying then
        -- update held knife

        if not isPrimaryKnife then
            -- sync flying status
            knife.m_isFlying = false
        else
            -- update effective rotation
            local frame = EntityUtils.GetFrameCount(myContext, knife)
            if frame < 2 or math.abs(knife.m_effectiveRotation - knife.m_rotation) <= 0.1 then
                knife.m_effectiveRotation = knife.m_rotation + knife.m_rotationOffset
            else
                local interpolationFactor = 0.3
                if player and PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_TRACTOR_BEAM, false) then
                    interpolationFactor = 1.0
                end

                knife.m_effectiveRotation = MathUtils.InterpolateAngle(knife.m_effectiveRotation, knife.m_rotation + knife.m_rotationOffset, interpolationFactor)
            end
        end

        VectorUtils.Assign(knife.m_targetPosition, VectorZero)
        EntityUtils.SetEntityReference(knife.m_target, nil)

        if not isPrimaryKnife and knife.m_distanceRelated_qqq >= 0.0 then
            knife:Remove(myContext)
        end
        knife.m_distanceRelated_qqq = -1.0

        if knife.m_splitDistance >= 0.0 then
            knife.m_visible = true
        end
        knife.m_splitDistance = -1.0

        local direction = Vector.FromAngle(knife.m_effectiveRotation)
        local holderPosition = primaryParent.m_position
        knife.m_position =  direction * pivotRadius + holderPosition
        VectorUtils.Assign(knife.m_holderPosition, holderPosition)
        knife.m_0x424 = knife.m_positionOffset.Y
        holderAngle = (knife.m_position - holderPosition):GetAngleDegrees()
    else
        -- TODO: Update isFlying
    end

    -- update sprite
    if isSword then
        if knife.m_isFlying then
            sprite.Rotation = MathUtils.NormalizeAngle(holderAngle - 90.0)
        end
    elseif isClub then
        if not knife.m_isFlying then
            local spriteRotation = (knife.m_position - primaryParent.m_position):GetAngleDegrees()
            sprite.Rotation = MathUtils.NormalizeAngle(spriteRotation - 90.0)
            sprite:GetCurrentAnimationData()
            ---@type NullFrame?
            local nullFrame = nil -- GetNullFrame at layerId 0 (you currently can only get it by layer name not layer id)
            if nullFrame then
                local spriteDirection = Vector.FromAngle(sprite.Rotation)
                knife.m_knifeDepthOffset = nullFrame:GetPos():Dot(spriteDirection)
            end
        end
    else
        local spriteRotation = MathUtils.NormalizeAngle(holderAngle - 90.0)
        sprite.Rotation = spriteRotation
        sprite:GetLayer(0):SetFlipX(spriteRotation > 0.0)
    end

    knife.m_hitboxRotation = holderAngle

    -- mysterious liquid flag
    if knife.m_isFlying and knife.m_visible and (knife.m_tearFlags & TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP) ~= 0 and EntityUtils.IsFrame(myContext, knife, 2, 0) and IsaacUtils.RandomInt(2) == 0 then
        -- spawn player creep green
        local room = game.m_level.m_room
        local creepPosition = RoomBounds.GetClampedPosition(room, knife.m_position, 15.0, 15.0, 15.0, 15.0)
        local ent = SpawnLogic.Spawn(myContext, game, EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, IsaacUtils.Random(), creepPosition, VectorZero, knife.m_spawnerEntity.ref)
        local creep = EntityCast.StaticToEffect(ent)

        creep.m_timeout = 30
        creep.m_lifeSpan = 30
        creep.m_sprite.Scale = Vector(0.4, 0.4)
        creep:Update(myContext)
    end

    if not isPrimaryKnife and (variant == KnifeVariant.BAG_OF_CRAFTING or variant == 8) and not primaryKnife.m_isFlying and not primaryKnife.m_meleeSwingInputHeld_qqq and not primaryKnife.m_isSwinging then
        knife:Remove(myContext)
    end
end

---@param closure table
---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@return boolean? Remove
local function update_base_ludovico(closure, myContext, knife)
end

---@param closure table
---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@return boolean? Remove
local function update_base(closure, myContext, knife)
    local _, isClub, isSword = update_closure_unpack(closure)

    -- get pivotRadius
    local pivotRadius = isSword and 0.1 or isClub and 4.0 or 30.0
    ---@type EntityComponent
    local parent = knife.m_parent.ref

    local tear = EntityCast.ToTear(parent)
    if tear and not isClub and not isSword then
        pivotRadius = tear.m_fScale * 20.0
    end

    local player = KnifeUtils.GetPlayer(knife)
    local variant = knife.m_variant

    -- update notched axe belial color
    if variant == KnifeVariant.NOTCHED_AXE then
        local r, g, b = 0.0, 0.0, 0.0
        if player and PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, false) then
            local frameCount = myContext.game.m_frameCount
            -- desynced sine oscillation
            r = math.sin(frameCount + 0.5) * 0.17 + 0.17 -- [0.0, 0.34]
            g = math.sin(frameCount + 0.25) * 0.1 + 0.1 -- [0.0, 0.2]
            b = math.sin(frameCount) * 0.25 + 0.25 -- [0.0, 0.5]
        end

        local layerState = knife.m_sprite:GetLayer(0)
        if layerState then
            local color = layerState:GetColor()
            color:SetOffset(r, g, b)
            layerState:SetColor(color)
        end
    end

    if (knife.m_tearFlags & TearFlags.TEAR_LUDOVICO) ~= 0 then
        update_base_ludovico(closure, myContext, knife)
    else
        local remove = update_base_normal(closure, myContext, knife, pivotRadius)
        if remove then
            return remove
        end
    end

    -- hydrobounce flag
    if knife.m_isFlying and (knife.m_tearFlags & TearFlags.TEAR_HYDROBOUNCE) ~= 0 then
        local hydroHeight = knife.m_hydroBounce_height
        local gravitySpeed = knife.m_hydroBounce_gravitySpeed

        -- hydrobounce physics
        if hydroHeight < 0.0 or gravitySpeed < 0.0 then
            hydroHeight = hydroHeight + gravitySpeed
            knife.m_hydroBounce_height = hydroHeight

            if knife.m_knifeVelocity <= 0.0 then
                gravitySpeed = math.max(gravitySpeed, hydroHeight * -0.1)
            else
                gravitySpeed = gravitySpeed + 1.5
            end
            knife.m_hydroBounce_gravitySpeed = gravitySpeed

            -- reached ground
            if hydroHeight >= 0.0 then
                -- prepare next bounce
                hydroHeight = 0.0
                knife.m_hydroBounce_height = 0.0

                if knife.m_knifeVelocity <= 0.0 or gravitySpeed <= 0.5 then
                    gravitySpeed = 0.0 -- stop bouncing
                else
                    gravitySpeed = gravitySpeed * -0.8
                end
                knife.m_hydroBounce_gravitySpeed = gravitySpeed

                -- tear splash
                local game = myContext.game
                local ripple = SpawnLogic.Spawn(myContext, game, EntityType.ENTITY_EFFECT, EffectVariant.RIPPLE_POOF, 0, IsaacUtils.Random(), knife.m_position, VectorZero, nil)

                local rippleSprite = ripple.m_sprite
                rippleSprite.Scale = Vector(0.75, 0.75)
                ripple:SetColor(myContext, rippleSprite.Color, -1, -1, false, true)
                ripple:Update(myContext)

                IsaacUtils.PlaySound(myContext, SoundEffect.SOUND_TEARIMPACTS, 0.5, 2, false, 1.0)

                TearAttack.TearSplashDamage(myContext, knife.m_position, 30.0, knife.m_collisionDamage, knife, knife.m_tearFlags)
            end
        end

        knife.m_positionOffset.Y = hydroHeight + knife.m_0x424
        -- update sprite
        if not isClub or not isSword then
            local sprite = knife.m_sprite
            local spriteRotation = sprite.Rotation

            local gravityRotation = MathUtils.RadiansToDegrees(math.atan(-gravitySpeed, knife.m_knifeVelocity))
            local verticalAmount = math.sin(MathUtils.DegreesToRadians(spriteRotation))
            sprite.Rotation = spriteRotation + gravityRotation * verticalAmount

            if knife.m_knifeVelocity < 0.0 then
                local layer = sprite:GetLayer(0)
                assert(layer, "Layer 0 does not exist!")
                local flipX = layer:GetFlipX() == false
                layer:SetFlipX(flipX)
            end
        end
    end

    local interpolationUpdate = knife.m_interpolated
    if not interpolationUpdate then
        -- lasers update logic

        if not knife.m_isFlying or knife.m_isDead then -- remove lasers
            -- tech x laser fade out logic
            local techXLaser = EntityCast.StaticToLaser(knife.m_techXLaser.ref)
            if techXLaser then
                local timeout = techXLaser.m_timeout
                if timeout > 8 then
                    techXLaser.m_timeout = 8
                else
                    -- fade out
                    local color = techXLaser.m_sprite.Color
                    color.A = color.A * timeout * 1/8
                    techXLaser.m_radius = techXLaser.m_radius + 4.0
                end
            end
        elseif player and PlayerInventory.HasCollectible(myContext, player, CollectibleType.COLLECTIBLE_TECHNOLOGY, false) then
            -- update technology laser
            local createdThisUpdate = false
            local technologyLaser = EntityCast.StaticToLaser(knife.m_technologyLaser.ref)

            if not technologyLaser then
                -- create laser
                local positionOffset = player.m_positionOffset + Vector(0.0, -8.0)
                technologyLaser = LaserUtils.ShootAngle(myContext, LaserVariant.THICK_RED, player.m_position, 0.0, -1, positionOffset, player, false)

                local laserTearFlags = knife.m_tearFlags & ~(TearFlags.TEAR_WIGGLE | TearFlags.TEAR_ORBIT | TearFlags.TEAR_BIG_SPIRAL | TearFlags.TEAR_SPIRAL | TearFlags.TEAR_SQUARE)
                technologyLaser.m_tearFlags = laserTearFlags
                technologyLaser:SetColor(myContext, player.m_laserColor, -1, -1, false, true)
                technologyLaser:SetCollisionDamage(myContext, knife.m_charge * knife.m_collisionDamage)
                technologyLaser.m_mass = 0.0
                EntityUtils.SetEntityReference(knife.m_technologyLaser, technologyLaser)
                createdThisUpdate = true
            end

            local laserSegmentVector = knife.m_position - technologyLaser.m_position
            LaserUtils.SetAngle(technologyLaser, laserSegmentVector:GetAngleDegrees())
            technologyLaser.m_maxDistance = laserSegmentVector:Length()
            technologyLaser.m_depthOffset = laserSegmentVector.Y < -0.5 and -10.0 or 3000.0

            if createdThisUpdate then
                technologyLaser:Update(myContext)
            end
        end

        if not knife.m_isFlying or knife.m_isDead then -- don't know why they performed the check twice
            local technologyLaser = knife.m_technologyLaser.ref
            if technologyLaser then
                technologyLaser:Remove(myContext)
            end
        end
    end
end

---@param closure table
---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@return boolean? Remove
local function update_projectile(closure, myContext, knife)
    local requiredWeapon, isClub, isSword = update_closure_unpack(closure)
    
end

---@param closure table
---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@return boolean? Remove
local function update_3(closure, myContext, knife)
    local requiredWeapon, isClub, isSword = update_closure_unpack(closure)
    
end

---@param closure table
---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@return boolean? Remove
local function update_club_hitbox(closure, myContext, knife)
    local requiredWeapon, isClub, isSword = update_closure_unpack(closure)
end

local switch_update = {
    [eKnifeSubType.BASE] = update_base,
    [eKnifeSubType.PROJECTILE] = update_projectile,
    [eKnifeSubType.SUBTYPE_3] = update_3,
    [eKnifeSubType.CLUB_HITBOX] = update_club_hitbox,
}

---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@param knifeData table
local function update_hit_list_clear(myContext, knife, knifeData)
    local isClub, isSword = table.unpack(knifeData, 2)
    if isSword then
        return
    end

    local interval
    if isClub then
        if knife.m_variant ~= 2 then
            return
        end

        interval = (knife.m_tearFlags & TearFlags.TEAR_WAIT) ~= 0 and 10 or 5
    else
        interval = 3
    end

    if EntityUtils.IsFrame(myContext, knife, interval, 0) then
        HitListUtils.Clear(knife.m_hitList)
    end
end

---@param myContext Context.Common
---@param knife EntityKnifeComponent
---@param player EntityPlayerComponent?
local function damage_grid(myContext, knife, player)
    local room = myContext.game.m_level.m_room
    local gridIdx = RoomGrid.GetGridIdx(room, knife.m_position)

    if gridIdx < 0 then
        return
    end

    local gridEntity = RoomGrid.GetGridEntity(room, gridIdx)
    if not gridEntity then
        return
    end

    local collisionClass = gridEntity.m_collisionClass
    if collisionClass == GridCollisionClass.COLLISION_PIT or collisionClass == GridCollisionClass.COLLISION_NONE and IsaacUtils.RandomInt(4) ~= 0 then
        RoomGrid.DamageGrid(room, gridIdx)
        return
    end

    local tearFlags = knife.m_tearFlags
    if player then
        local tearHitParams = WeaponParams.GetTearHitParams(myContext, player, WeaponType.WEAPON_KNIFE, 1.0, 0, knife.m_spawnerEntity.ref)
        tearFlags = tearFlags | tearHitParams.tearFlags
    end

    if (tearFlags & (TearFlags.TEAR_ACID | TearFlags.TEAR_ROCK)) == 0 or not gridEntity:CanTakeDamageFromTearEffects() then
        RoomGrid.DamageGrid(room, gridIdx)
        return
    end

    local destroyed = gridEntity:Destroy(myContext, false)
    if not destroyed then
        RoomGrid.DamageGrid(room, gridIdx)
        return
    end

    -- try make bridge
    local direction = Vector.FromAngle(knife.m_rotation + 90.0)
    direction = VectorUtils.GetAxisAlignedUnitVector(direction)

    if VectorUtils.Equals(direction, VectorZero) then
        return
    end

    local pitPosition = direction * 40.0 + GridUtils.GetPosition({room = room}, gridEntity)
    local pitGridIdx = RoomGrid.GetGridIdx(room, pitPosition)
    local pit = RoomGrid.GetGridEntity(room, pitGridIdx)

    RoomGrid.TryMakeBridge(room, pit, gridEntity)
end

---@param myContext Context.Common
---@param knife EntityKnifeComponent
local function Update(myContext, knife)
    local interpolationUpdate = knife.m_interpolated
    if interpolationUpdate then
        knife.m_friction = knife.m_friction * 0.7
    end

    local baseType = KnifeUtils.GetBaseType(knife)
    local requiredWeapon = REQUIRED_WEAPON[baseType] or WeaponType.WEAPON_KNIFE
    local isClub = baseType == KnifeVariant.BONE_CLUB
    local isSword = baseType == KnifeVariant.SPIRIT_SWORD

    local player = KnifeUtils.GetPlayer(knife)
    local parent = knife.m_parent.ref

    local closure = update_closure_pack(requiredWeapon, isClub, isSword)

    if not parent then
        knife:Remove(myContext)
    else
        ---@type eKnifeSubType
        local subtype = knife.m_subtype
        local update = switch_update[subtype]
        if update then
            local remove = update(closure, myContext, knife)
            if remove then
                knife:Remove(myContext)
                return
            end
        end
    end

    local flags = knife.m_tearFlags

    -- multidimensional update
    if not interpolationUpdate and knife.m_multidimensional_applied then
        local frame = EntityUtils.GetFrameCount(myContext, knife) % 6
        local multidimensionalColor = MULTIDIMENSIONAL_COLOR[frame + 1]
        knife.m_sprite.Color = knife.m_color * multidimensionalColor
    end

    -- attractor update
    if not interpolationUpdate and (flags & TearFlags.TEAR_ATTRACTOR) ~= 0 then
        local force = 1.0
        if knife.m_subtype == KnifeSubType.CLUB_HITBOX then
            force = 20.0
        elseif knife.m_isFlying then
            force = MathUtils.MapToRange(knife.m_distance, {0.0, 100.0}, {1.0, 30.0}, true)
        end

        StrangeAttractor.UpdateStrangeAttractor(myContext.game, knife.m_position, force, 250.0, nil)
    end

    -- hitbox update
    if (isClub or isSword) and knife.m_isFlying then
        knife.m_size = knife.m_config.collisionRadius * knife.m_sprite.Scale.X
    end
    update_hit_list_clear(myContext, knife, closure)

    -- callback
    Callbacks.PostKnifeUpdate(knife)

    -- try grid damage
    if not interpolationUpdate and ((not isClub and not isSword) or knife.m_isFlying) and knife.m_visible then
        damage_grid(myContext, knife, player)
    end

    if not interpolationUpdate then
        EntityUpdate.Update(myContext, knife)
    end
end

local Module = {}

--#region Module

Module.Update = Update

--#endregion

return Module