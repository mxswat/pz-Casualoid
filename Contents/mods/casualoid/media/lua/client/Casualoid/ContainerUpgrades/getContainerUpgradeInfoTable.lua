local ContainerUpgradesModData = require "Casualoid/ContainerUpgrades/ContainerUpgradesModData"
local getSpriteBaseCapacity    = require "Casualoid/ContainerUpgrades/getSpriteBaseCapacity"
local getCapacityUpgrade       = require "Casualoid/ContainerUpgrades/getCapacityUpgrade"

---@param moveProps ISMoveableSpriteProps
---@param upgradeItem InventoryItem
local function getContainerUpgradeInfoTable(moveProps, upgradeItem)
  local baseCapacity = getSpriteBaseCapacity(moveProps.sprite)

  -- local containerType = moveProps.object:getContainerByIndex(0):getType()

  local capacityUpgrade = ContainerUpgradesModData:get(moveProps.object)

  local newCapacityUpgrade = getCapacityUpgrade(upgradeItem)

  local currentCapacity = baseCapacity + capacityUpgrade.capacityUpgrade
  local upgradedCapacity = currentCapacity + newCapacityUpgrade
  local maxCapacity = SandboxVars.Casualoid.ContainerUpgradeMaxCapacity

  local data = {
    currentCapacity = currentCapacity,
    upgradedCapacity = upgradedCapacity,
    maxCapacity = maxCapacity,
  }

  local maxCapacityColor = upgradedCapacity > maxCapacity and ' <RGB:1,0,0> ' or ' <RGB:1,1,1> '

  local info = {
    { moveProps.name },
    -- { 'Container Name:',   getTextOrNull("IGUI_ContainerTitle_" .. containerType) },
    { '' },
    { 'Base Capacity:',                           baseCapacity },
    { ' <RGB:1,1,0> Current Capacity:',           currentCapacity },
    { ' <RGB:0,1,0> Upgraded Capacity:',          upgradedCapacity },
    { maxCapacityColor .. 'Max Upgraded Capacity:', maxCapacity },
  }

  return info, data
end

return getContainerUpgradeInfoTable
