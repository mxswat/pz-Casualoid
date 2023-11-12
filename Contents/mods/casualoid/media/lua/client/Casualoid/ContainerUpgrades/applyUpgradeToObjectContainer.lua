local ContainerUpgradesModData = require "Casualoid/ContainerUpgrades/ContainerUpgradesModData"
local Debug = require("Casualoid/Debug")
local getCapacityUpgrade = require("Casualoid/ContainerUpgrades/getCapacityUpgrade")

---@param object IsoObject
---@param upgradeItem InventoryItem
local function applyUpgradeToObjectContainer(object, upgradeItem)
  local modData = ContainerUpgradesModData:get(object)

  local capacityUpgrade = getCapacityUpgrade(upgradeItem)

  modData.capacityUpgrade = modData.capacityUpgrade + capacityUpgrade

  Debug:printTable(modData)
end


return applyUpgradeToObjectContainer
