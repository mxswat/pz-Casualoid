local getSpriteBaseCapacity = require "Casualoid/ContainerUpgrades/getSpriteBaseCapacity"

---@param moveProps ISMoveableSpriteProps
---@return string[][]
local function getContainerUpgradeInfoTable(moveProps)
  local capacity = getSpriteBaseCapacity(moveProps.sprite)

  local containerType = moveProps.object:getContainerByIndex(0):getType()

  local info = {
    { 'Object Name:',      moveProps.name },
    { 'Container Name:',   getTextOrNull("IGUI_ContainerTitle_" .. containerType) },
    { '' },
    { 'Base Capacity:',    capacity },
    { 'Current Capacity:', 999 },
  }

  return info
end

return getContainerUpgradeInfoTable