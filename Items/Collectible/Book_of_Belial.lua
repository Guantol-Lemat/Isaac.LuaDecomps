---@class Decomp.Collectible.BookOfBelial
local BookOfBelial = {}

BookOfBelial.COLLECTIBLE_ID = CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL

local Lib = {
    Math = require("Lib.Math")
}

local g_Game = Game()
local g_SFXManager = SFXManager()

--#region Passive

---@param player EntityPlayer
---@return SoundEffect | integer sound
local function get_belial_sound(player)
    local temporaryEffects = player:GetEffects()
    if temporaryEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) and temporaryEffects:HasNullEffect(NullItemID.ID_JUDAS_BIRTHRIGHT) then
        return SoundEffect.SOUND_DEVIL_CARD
    end

    return SoundEffect.SOUND_CANDLE_LIGHT
end

---@return Color newColor
local function get_belial_poof_color()
    local color = Color()
    color:SetTint(0.2, 0.2, 0.2, 0.6)
    color:SetColorize(1.0, 1.0, 1.0, 1.0)
    color:SetOffset(0.0, 0.0, 0.0)

    return color
end

---@param player EntityPlayer
---@param charge integer
local function animate_belial_poof(player, charge)
    if charge < 4 then
        local effect = g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, player.Position, Vector(0, 0), nil, 0, Random())
        effect.Color = get_belial_poof_color()
        effect:Update()
    else
        player:MakeGroundPoof(player.Position, get_belial_poof_color(), 1.0)
    end
end

---@param count integer
---@return Vector velocity
local function get_belial_flame_speed(count)
    local randomFloat = Random() * (1 / 2^32) -- the same as rng:RandomFloat but without initializing an RNG object
    local baseVelocity = Vector(0.0, randomFloat * -6.0 - 10.0)
    baseVelocity = baseVelocity * (count * 0.7 * 0.25 + 0.3)

    randomFloat = Random() * (1 / 2^32)
    local angle = randomFloat * 10.0 - 5.0

    local speedModifier = Lib.Math.MapToRange(count, {0.0, 12.0}, {0.6, 2.0}, true)
    return baseVelocity:Rotated(angle) * speedModifier
end

---@param flameEffect EntityEffect
local function post_process_belial_flame(flameEffect)
    local sprite = flameEffect:GetSprite()
    local layer = sprite:GetLayer(0)
    if not layer then
        return
    end
    layer:GetBlendMode():SetMode(BlendType.ADDITIVE)

    local color = layer:GetColor()
    color:Reset()
    color:SetTint(5.0, 0.5, 0.2, 1.0)
    layer:SetColor(color)

    local randomFloat = Random() * (1 / 2^32)
    flameEffect.Rotation = randomFloat * 10.0 + 2.0

    local randomInt = Random() % 10 + 10 -- RandomInt(10) + 10
    flameEffect.Timeout = randomInt
    flameEffect.LifeSpan = randomInt

    randomFloat = Random() * (1 / 2^32)
    local scale = randomFloat * 0.4 + 0.2
    sprite.Scale = Vector(1, 1) * scale * flameEffect.SpriteScale

    flameEffect.RenderZOffset = -600
end

---@param player EntityPlayer
local function animate_belial_flames(player)
    for i = 1, 5, 1 do
        local velocity = get_belial_flame_speed(i - 1)
        local startPosition = (velocity * 2) + player.Position

        local flame = g_Game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, startPosition, velocity, player, 0, Random())
        local flameEffect = flame:ToEffect()
        if not flameEffect then
            flame:Remove() -- something went wrong for this to not be an effect
            goto continue
        end

        post_process_belial_flame(flameEffect)
        ::continue::
    end
end

---@param player EntityPlayer
---@param charge integer
local function animate_belial(player, charge)
    animate_belial_poof(player, charge)
    animate_belial_flames(player)
end

---@param player EntityPlayer
---@param charge integer
function BookOfBelial.PostTriggerBookOfBelial(player, charge)
    g_SFXManager:Play(get_belial_sound(player), 1.0, 2, false, 1.0, 0)

    local temporaryEffects = player:GetEffects()
    temporaryEffects:AddNullEffect(NullItemID.ID_JUDAS_BIRTHRIGHT, true, 1)

    animate_belial(player, charge)
end

--#endregion

return BookOfBelial