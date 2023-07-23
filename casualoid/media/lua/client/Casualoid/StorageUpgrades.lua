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

local old_ISInventoryTransferAction_transferItem = ISInventoryTransferAction.transferItem
function ISInventoryTransferAction:transferItem(item)
  local result = old_ISInventoryTransferAction_transferItem(self, item)

  if not item or item:getType() ~= 'StorageUpgrade' then
    return result
  end

  local weightUpgrade = getItemUpgradeData(item).weightUpgrade

  -- use "getSourceGrid" to check if it's a tile
  if self.srcContainer:getSourceGrid() then
    -- local modData = self.srcContainer:getParent():getModData()
    self.srcContainer:setCapacity(self.srcContainer:getCapacity() - weightUpgrade)
  end

  if self.destContainer:getSourceGrid() then
    self.destContainer:setCapacity(self.destContainer:getCapacity() + weightUpgrade)
  end

  return result
end
