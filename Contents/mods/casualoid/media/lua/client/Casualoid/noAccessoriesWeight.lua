local function noAccessoriesWeight()
  local allItems = getAllItems()
  local allItemsSize = allItems:size()
  for i = allItemsSize - 1, 0, -1 do
    local item = allItems:get(i)
    if item:isCosmetic() then
      item:DoParam("Weight = 0")
    end
  end
end

return noAccessoriesWeight
