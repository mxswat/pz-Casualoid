---@param upgradeItem InventoryItem
local function getCapacityUpgrade(upgradeItem)
  local capacityUpgrades = {
    ["Casualoid.WoodenContainerUpgrade"] = SandboxVars.Casualoid.WoodenContainerUpgradeCapacity,
    ["Casualoid.MetalContainerUpgrade"] = SandboxVars.Casualoid.MetalContainerUpgradeCapacity,
  }

  return capacityUpgrades[upgradeItem:getFullType()]
end

return getCapacityUpgrade