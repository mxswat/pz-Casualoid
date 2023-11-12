local getSpriteBaseCapacity = require "Casualoid/ContainerUpgrades/getSpriteBaseCapacity"

--- @class CUModData
--- @field capacityUpgrade number

local modDataKey = 'ContainerUpgrades'
local ContainerUpgradesModData = {}

---@param object IsoObject
---@return CUModData
function ContainerUpgradesModData:getUpgradeModData(object)
  object:getModData()[modDataKey] = object:getModData()[modDataKey] or self:getUpgradeDefaultModData(object)

  return object:getModData()[modDataKey]
end

---@param object IsoObject
---@return CUModData
function ContainerUpgradesModData:getUpgradeDefaultModData(object)
  return {
    capacityUpgrade = getSpriteBaseCapacity(object:getSprite()),
  }
end

return ContainerUpgradesModData
