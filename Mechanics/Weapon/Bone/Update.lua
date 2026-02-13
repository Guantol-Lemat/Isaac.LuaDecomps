--#region Dependencies

local IsaacUtils = require("Isaac.Utils")
local VectorUtils = require("General.Math.VectorUtils")
local WeaponUtils = require("Game.Weapon.Utils")
local WeaponUpdate = require("Mechanics.Weapon.Update")
local WeaponAttack = require("Mechanics.Weapon.Attacks")
local EntityUtils = require("Entity.Utils")
local PlayerInventory = require("Mechanics.Player.Inventory")
local WeaponParams = require("Mechanics.Player.WeaponParams")
local HeldEntity = require("Mechanics.Player.HeldEntity")
local TearParams = require("Mechanics.Tear.Params")
local KnifeAttack = require("Mechanics.Knife.Attack")
local TemporaryEffectsUtils = require("Game.TemporaryEffects.Utils")
local CellSpace = require("Game.Room.EntityManager.CellSpace")
local SpawnLogic = require("Game.Spawn")

--#endregion

local function update_bone_attributes()
end

---@param myContext Context.Common
---@param weapon WeaponBoneComponent
---@param shootingInput Vector
---@param isShooting boolean
---@param interpolationUpdate boolean
local function Fire(myContext, weapon, shootingInput, isShooting, interpolationUpdate)

end

local Module = {}

--#region Module

Module.Fire = Fire

--#endregion

return Module