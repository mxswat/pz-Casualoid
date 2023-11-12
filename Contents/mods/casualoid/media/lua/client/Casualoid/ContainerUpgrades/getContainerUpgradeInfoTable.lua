local ContainerUpgradesModData = require "Casualoid/ContainerUpgrades/ContainerUpgradesModData"
local getSpriteBaseCapacity    = require "Casualoid/ContainerUpgrades/getSpriteBaseCapacity"
local getCapacityUpgrade       = require "Casualoid/ContainerUpgrades/getCapacityUpgrade"

---@param moveProps ISMoveableSpriteProps
---@param upgradeItem InventoryItem
---@return string[][]
local function getContainerUpgradeInfoTable(moveProps, upgradeItem)
  local capacity = getSpriteBaseCapacity(moveProps.sprite)

  -- local containerType = moveProps.object:getContainerByIndex(0):getType()

  local capacityUpgrade = ContainerUpgradesModData:get(moveProps.object)

  local newCapacityUpgrade = getCapacityUpgrade(upgradeItem)

  local info = {
    { moveProps.name },
    -- { 'Container Name:',   getTextOrNull("IGUI_ContainerTitle_" .. containerType) },
    { '' },
    { 'Base Capacity:',     capacity },
    { ' <RGB:1,1,0> Current Capacity:',  capacity + capacityUpgrade.capacityUpgrade },
    { '' },
    { ' <RGB:0,1,0> Upgraded Capacity:', capacity + capacityUpgrade.capacityUpgrade + newCapacityUpgrade },
  }

  return info
end

return getContainerUpgradeInfoTable
