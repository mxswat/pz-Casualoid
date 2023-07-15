local getUpgradeItem = function(inputItems)
  for i = 0, (inputItems:size() - 1) do
    local item = inputItems:get(i);
    if item:getType() == 'StorageUpgrade' then
      return item
    end
  end

  return nil
end

function ImproveStorageUpgrade(inputItems, resultItem, player)
  local inputItem = getUpgradeItem(inputItems)

  if not inputItem then
    return
  end

  local newWeight = math.ceil(inputItem:getActualWeight() * 2.1)

  resultItem:setActualWeight(newWeight + 0.01);
  resultItem:setWeight(newWeight + 0.01);
  resultItem:setName("Storage Upgrade " .. newWeight * -1 .. "kg");
  resultItem:setCustomName(true);
end

function CanCraftStorageUpgrade()
  if SandboxVars.Casualoid.CanCraftStorageUpgrade == false then return false end
	return true
end