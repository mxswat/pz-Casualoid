---@param upgradeItem InventoryItem
local function getCapacityUpgrade(upgradeItem)
  local capacityUpgrades = {
    ["Casualoid.WoodenContainerUpgrade"] = 20,
    ["Casualoid.MetalContainerUpgrade"] = 20,
  }

  return capacityUpgrades[upgradeItem:getFullType()]
end

return getCapacityUpgrade