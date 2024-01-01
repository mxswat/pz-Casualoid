local ContainerUpgradesModData = require "Casualoid/ContainerUpgrades/ContainerUpgradesModData"
local MxDebug  = require("MxUtilities/MxDebug ")
local getCapacityUpgrade = require("Casualoid/ContainerUpgrades/getCapacityUpgrade")

---@param object IsoObject
---@param upgradeItem InventoryItem
local function applyUpgradeToObjectContainer(object, upgradeItem)
  local modData = ContainerUpgradesModData:get(object)

  local capacityUpgrade = getCapacityUpgrade(upgradeItem)

  modData.capacityUpgrade =
      Math.min(modData.capacityUpgrade + capacityUpgrade, SandboxVars.Casualoid.ContainerUpgradeMaxCapacity)

  MxDebug:printTable(modData)
end


return applyUpgradeToObjectContainer
