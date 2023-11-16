local NamedContainersUIData = {}

function NamedContainersUIData.getModData()
  ---@class NamedContainersUIModata
  ---@field sizeLoot number
  ---@field sizeCharacter number
  local modData = ModData.getOrCreate('NamedContainersUIData')

  modData.sizeLoot = modData.sizeLoot or 100
  modData.sizeCharacter = modData.sizeCharacter or 100

  return modData
end

---@param inventoryPage ISInventoryPage
---@param newSize number
function NamedContainersUIData.saveSize(inventoryPage, newSize)
  -- save the data
  local namedContainersUIdata = NamedContainersUIData.getModData()
  if inventoryPage.onCharacter then
    namedContainersUIdata.sizeCharacter = newSize
    return
  end
  namedContainersUIdata.sizeLoot = newSize
end

---@param inventoryPage ISInventoryPage
function NamedContainersUIData.getSavedSize(inventoryPage)
  local modData = NamedContainersUIData.getModData()
  if inventoryPage.onCharacter then
    return modData.sizeCharacter
  end

  return modData.sizeLoot
end

return NamedContainersUIData