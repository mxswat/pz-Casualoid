local getSpriteBaseCapacity = require "Casualoid/ContainerUpgrades/getSpriteBaseCapacity"

--- @class ContainerUpgradesModData
--- @field capacityUpgrade number

local modDataKey = 'ContainerUpgrades'
local ContainerUpgradesModData = {}

---@param object IsoObject
---@return ContainerUpgradesModData
function ContainerUpgradesModData:get(object)
  object:getModData()[modDataKey] = object:getModData()[modDataKey] or self:getDefault(object)

  return object:getModData()[modDataKey]
end

---@param object IsoObject
---@return ContainerUpgradesModData
function ContainerUpgradesModData:getDefault(object)
  return {
    capacityUpgrade = 0,
  }
end

return ContainerUpgradesModData
