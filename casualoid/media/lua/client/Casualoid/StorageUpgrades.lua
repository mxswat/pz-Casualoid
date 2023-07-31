local function getBaseWeight()
  return SandboxVars.Casualoid.StorageUpgradeBaseWeight
end

local function getImprovementMultiplier()
  return SandboxVars.Casualoid.StorageImprovementMultiplier
end

function OnCanPerform_CanCraftStorageUpgrade()
  return SandboxVars.Casualoid.CanCraftStorageUpgrade == true
end

local function getItemUpgradeData(item)
  local modData = item:getModData();
  local result = {
    weightUpgrade = modData.weightUpgrade or getBaseWeight(),
    weightUpgradeCount = modData.weightUpgradeCount or 0
  }
  return result
end

local function setItemUpgradeData(item, weightUpgrade, weightUpgradeCount)
  local modData = item:getModData();
  modData.weightUpgrade = weightUpgrade
  modData.weightUpgradeCount = weightUpgradeCount
end

local getUpgradeItem = function(inputItems)
  for i = 0, (inputItems:size() - 1) do
    local item = inputItems:get(i);
    if item:getType() == 'StorageUpgrade' then
      return item
    end
  end

  return nil
end

function OnCreate_CreateStorageUpgrade(inputItems, resultItem, player)
  resultItem:setName("Storage Upgrade " .. getBaseWeight() .. "kg");
  resultItem:setCustomName(true);
end

function OnCreate_ImproveStorageUpgrade(inputItems, resultItem, player)
  local inputItem = getUpgradeItem(inputItems)

  if not inputItem then
    return
  end

  -- TODO: Implement upgrade count limit?

  local upgradeData = getItemUpgradeData(inputItem)
  local newWeight = math.ceil(upgradeData.weightUpgrade * getImprovementMultiplier())

  setItemUpgradeData(resultItem, newWeight, upgradeData.weightUpgradeCount + 1)

  resultItem:setName("Storage Upgrade " .. newWeight .. "kg");
  resultItem:setCustomName(true);
end

-- Add recipe requirement sandbox option?
-- https://discord.com/channels/136501320340209664/232196827577974784/1093160430966415491
-- recipe:getSource():get(0):setCount(amount)
-- Bigger example here: https://discord.com/channels/136501320340209664/232196827577974784/1012771329533022339

-- Limit one upgrade per container
local old_ISInventoryTransferAction_isValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
  local result = old_ISInventoryTransferAction_isValid(self)
  if self.destContainer:getSourceGrid() and self.destContainer:contains("Casualoid.StorageUpgrade") then
    return false
  end

  return result
end

local onRefreshInventoryWindowContainers = function(self, state)
  local inventory = self.inventoryPane.inventory
  if state ~= "begin" or not inventory or not inventory:getParent() or not inventory:getSourceGrid() then
    return
  end

  -- 50 is the default value coming from ItemContainer.java => public int Capacity = 50;
  local containerCapacity = tonumber(inventory:getParent():getSprite():getProperties():Val("ContainerCapacity") or 50)

  local upgradeItem = inventory:FindAndReturn("Casualoid.StorageUpgrade")
  if not upgradeItem then
    inventory:setCapacity(containerCapacity)
  else
    local upgradeData = getItemUpgradeData(upgradeItem)
    inventory:setCapacity(containerCapacity + upgradeData.weightUpgrade)
  end
end

Events.OnRefreshInventoryWindowContainers.Add(onRefreshInventoryWindowContainers)
