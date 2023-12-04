local ContainerUpgradesModData = require "Casualoid/ContainerUpgrades/ContainerUpgradesModData"
---comment
---@param self ISInventoryPage
---@param state string
local function onRefreshInventoryWindowContainers(self, state)
  -- Casualoid.print('onRefreshInventoryWindowContainers')
  if state ~= "buttonsAdded" then
    return
  end

  for k, button in ipairs(self.backpacks) do
    ---@type ItemContainer
    local inventory = button.inventory
    local object = inventory:getParent()
    if instanceof(object, "IsoObject") and not instanceof(object, "BaseVehicle") then
      local moddata = ContainerUpgradesModData:get(object)
      local newCapacity = moddata.capacityUpgrade + moddata.baseCapacity
      button.capacity = newCapacity
      inventory:setCapacity(newCapacity)
    end
  end
end

return onRefreshInventoryWindowContainers
