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

local function getParentModData(container)
  local modData = container:getParent():getModData()
  modData.originalCapacity = modData.originalCapacity or container:getCapacity()
  modData.newCapacity = modData.newCapacity or 0
  return modData
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
    self.srcContainer:setCapacity(self.srcContainer:getCapacity() - weightUpgrade)
  end

  if self.destContainer:getSourceGrid() then
    local modData = getParentModData(self.destContainer)
    self.destContainer:setCapacity(modData.originalCapacity + weightUpgrade)
    modData.newCapacity = self.destContainer:getCapacity()
  end

  return result
end

-- Ensures the new weight is properly applied when a container is unloaded in MP
local function onLoadGridSquare(square)
  if not square then
    return
  end

  local squareObjects = square:getObjects();
  for i = 0, squareObjects:size() - 1 do
    local object = squareObjects:get(i)
    for j = 1, object:getContainerCount() do
      local container = object:getContainerByIndex(j - 1)
      local modData = getParentModData(container)
      if modData.newCapacity > 0 then
        CasualoidPrint('modData.newCapacity:', modData.newCapacity)
        container:setCapacity(modData.newCapacity)
      end
    end
  end
end

Events.LoadGridsquare.Add(onLoadGridSquare);
