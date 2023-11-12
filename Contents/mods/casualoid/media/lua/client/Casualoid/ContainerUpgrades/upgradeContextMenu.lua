local Debug = require("Casualoid/Debug")

local getContainerUpgradeInfoTable = require("Casualoid/ContainerUpgrades/getContainerUpgradeInfoTable")

local containerUpgradeIcon = getTexture("media/textures/Item_ContainerUpgrade.png")

---@class UpgradeContainerContextMenu
UpgradeContainerContextMenu = {
  hasWoodenUpgrade = false, ---@type boolean
  hasMetalUpgrade = false ---@type boolean
}

---@param context ISContextMenu
---@return table, ISContextMenu
function UpgradeContainerContextMenu:createUpgradeSubMenu(context)
  local menuOption = context:addOption(getText("ContextMenu_UpgradeContainer"), nil)
  menuOption.iconTexture = containerUpgradeIcon
  local subMenuContext = ISContextMenu:getNew(context)
  context:addSubMenu(menuOption, subMenuContext)
  return menuOption, subMenuContext
end

---@param worldObjects table
---@return table<string, ISMoveableSpriteProps>
function UpgradeContainerContextMenu:extractValidMoveProps(worldObjects)
  local validObjects = {}

  for _, object in ipairs(worldObjects) do
    local square = object:getSquare()

    if square then
      local moveProps = ISMoveableSpriteProps.fromObject(object)

      if moveProps and object:getContainerCount() > 0 then
        moveProps.hasWoodenUpgrade = self.hasWoodenUpgrade
        moveProps.hasMetalUpgrade = self.hasMetalUpgrade
        validObjects[tostring(object)] = moveProps
      end
    end
  end

  return validObjects
end

---@param subMenu table
---@param moveProps ISMoveableSpriteProps
---@return ISToolTip
function UpgradeContainerContextMenu:createUpgradeToolTip(subMenu, moveProps)
  local color = getCore():getGoodHighlitedColor()
  local tooltipFont = ISToolTip.GetFont()

  local toolTip = ISToolTip:new()
  toolTip:initialise()
  toolTip:setVisible(false)
  toolTip.description = "Upgrade container"
  toolTip.object = moveProps.object
  toolTip:setTexture(moveProps.object:getSprite():getName())
  toolTip.description = ""

  local infoTable = getContainerUpgradeInfoTable(moveProps)

  local column2 = 0
  for _, t1 in ipairs(infoTable) do
    if #t1 == 2 then
      local textWid = getTextManager():MeasureStringX(tooltipFont, t1[1])
      column2 = math.max(column2, textWid + 10)
    end
  end

  for _, t1 in ipairs(infoTable) do
    toolTip.description = string.format("%s %s", toolTip.description, t1[1])
    if #t1 == 2 then
      toolTip.description = string.format("%s <SETX:%d> <INDENT:%d> %s", toolTip.description, column2, column2, t1[2])
    end
    toolTip.description = toolTip.description .. " <LINE> <INDENT:0> "
  end

  -- Highlight the object on the tile while the tooltip is showing
  subMenu.showTooltip = function(_subMenu, _option)
    ISContextMenu.showTooltip(_subMenu, _option)
    if _subMenu.toolTip.object ~= nil then
      _subMenu.toolTip.object:setHighlightColor(color)
      _subMenu.toolTip.object:setHighlighted(true, false)
    end
  end

  -- Stop highlighting the object when the tooltip is not showing
  subMenu.hideToolTip = function(_subMenu)
    if _subMenu.toolTip and _subMenu.toolTip.object then
      _subMenu.toolTip.object:setHighlighted(false)
    end
    ISContextMenu.hideToolTip(_subMenu)
  end

  return toolTip
end

---@param subMenuContext table
---@param moveProps ISMoveableSpriteProps
---@return table, ISContextMenu
function UpgradeContainerContextMenu:createUpgradeObjectMenuOption(subMenuContext, moveProps)
  local object = moveProps.object
  local objName = moveProps.name or "Unknown Object (Unnamed)"
  local objectOption = subMenuContext:addOption(Translator.getMoveableDisplayName(objName), object)

  local upgradeObjectMenuContext = ISContextMenu:getNew(subMenuContext)
  upgradeObjectMenuContext:addSubMenu(objectOption, upgradeObjectMenuContext)

  return objectOption, upgradeObjectMenuContext
end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
function UpgradeContainerContextMenu:renderContextMenu(playerIndex, context, worldObjects)
  local player = getSpecificPlayer(playerIndex)

  self.hasWoodenUpgrade = not not player:getInventory():FindAndReturn("Casualoid.WoodenContainerUpgrade")
  self.hasMetalUpgrade = not not player:getInventory():FindAndReturn("Casualoid.MetalContainerUpgrade")

  if not self.hasWoodenUpgrade and not self.hasMetalUpgrade then
    local option = self:createUpgradeSubMenu(context)
    option.notAvailable = true

    local tooltip = ISInventoryPaneContextMenu.addToolTip()
    tooltip.description = getText("ContextMenu_MissingUpgradeContainerItem")
    option.toolTip = tooltip
    return
  end

  local validProps = self:extractValidMoveProps(worldObjects)

  Debug:print('validObjects:', Debug:printTable(validProps))

  if table.isempty(validProps) then
    return
  end

  local upgradeMenuOption, upgradeMenuContext = self:createUpgradeSubMenu(context)

  for _, moveProps in pairs(validProps) do
    local upgradeObjectOption, upgradeObjectMenuContext = self:createUpgradeObjectMenuOption(upgradeMenuContext, moveProps)

    if self.hasWoodenUpgrade then
      local woodenOption = upgradeObjectMenuContext:addOption("Wooden Upgrade", nil, nil);
      woodenOption.toolTip = self:createUpgradeToolTip(upgradeMenuContext, moveProps)
    end

    if self.hasMetalUpgrade then
      local metalOption = upgradeObjectMenuContext:addOption("Metal Upgrade", nil, nil);
      metalOption.toolTip = self:createUpgradeToolTip(upgradeMenuContext, moveProps)
    end
  end
end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
function UpgradeContainerContextMenu.onFillWorldObjectContextMenu(playerIndex, context, worldObjects)
  UpgradeContainerContextMenu:renderContextMenu(playerIndex, context, worldObjects)
end

return UpgradeContainerContextMenu
