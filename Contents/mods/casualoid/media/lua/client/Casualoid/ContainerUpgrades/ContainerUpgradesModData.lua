local getSpriteBaseCapacity = require "Casualoid/ContainerUpgrades/getSpriteBaseCapacity"
local Utils                 = require "MxUtilities/Utils"

--- @class ContainerUpgradesModData
--- @field capacityUpgrade number
--- @field baseCapacity number

local modDataKey = 'ContainerUpgrades'
local ContainerUpgradesModData = {}

---@param object IsoObject
---@return ContainerUpgradesModData
function ContainerUpgradesModData:get(object)
  return Utils:getModDataWithDefault(object:getModData(), modDataKey, self:getDefault(object))
end

---@param object IsoObject
---@return ContainerUpgradesModData
function ContainerUpgradesModData:getDefault(object)
  local baseCapacity = getSpriteBaseCapacity(object:getSprite())

  return {
    capacityUpgrade = 0,
    baseCapacity = baseCapacity
  }
end

return ContainerUpgradesModData
