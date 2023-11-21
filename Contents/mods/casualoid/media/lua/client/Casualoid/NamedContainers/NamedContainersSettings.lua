local CasualoidSettings = require "Casualoid/CasualoidSettings"
local NamedContainersUIData = {}

function NamedContainersUIData.getSettings()
  ---@class NamedContainersSettings
  ---@field sizeLoot number
  ---@field sizeCharacter number
  local namedContainersSettings = CasualoidSettings:get().namedContainers

  namedContainersSettings.sizeLoot = namedContainersSettings.sizeLoot or 125
  namedContainersSettings.sizeCharacter = namedContainersSettings.sizeCharacter or 100

  return namedContainersSettings
end

---@param inventoryPage ISInventoryPage
---@param newSize number
function NamedContainersUIData.saveSize(inventoryPage, newSize)
  -- save the data
  local namedContainersUIdata = NamedContainersUIData.getSettings()
  if inventoryPage.onCharacter then
    namedContainersUIdata.sizeCharacter = newSize
  else
    namedContainersUIdata.sizeLoot = newSize
  end

  CasualoidSettings:save()
end

---@param inventoryPage ISInventoryPage
function NamedContainersUIData.getSavedSize(inventoryPage)
  local modData = NamedContainersUIData.getSettings()
  if inventoryPage.onCharacter then
    return modData.sizeCharacter
  end

  return modData.sizeLoot
end

return NamedContainersUIData
