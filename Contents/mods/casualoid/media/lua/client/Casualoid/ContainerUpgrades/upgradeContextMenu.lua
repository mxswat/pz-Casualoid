local Debug                         = require("Casualoid/Debug")
local HookableToolTip               = require("MxUtilities/HookableTooltip")
local applyUpgradeToObjectContainer = require("Casualoid/ContainerUpgrades/applyUpgradeToObjectContainer")
local getContainerUpgradeInfoTable  = require("Casualoid/ContainerUpgrades/getContainerUpgradeInfoTable")
local UpgradeContainerAction        = require("Casualoid/ContainerUpgrades/UpgradeContainerAction")

local containerUpgradeIcon          = getTexture("media/textures/Item_ContainerUpgrade.png")

---@class UpgradeContainerContextMenu
UpgradeContainerContextMenu         = {
  woodenUpgrade = nil, ---@type InventoryItem|nil
  metalUpgrade = nil ---@type InventoryItem|nil
}

---@param moveProps ISMoveableSpriteProps
---@param useDefaultRender? boolean
function UpgradeContainerContextMenu:createHightlightToolTip(moveProps, useDefaultRender)
  local color = getCore():getGoodHighlitedColor()

  local function onRenderTooltip()
    moveProps.object:setHighlightColor(color)
    moveProps.object:setHighlighted(true, false)
    return useDefaultRender
  end

  local function onRemoveTooltip()
    moveProps.object:setHighlighted(false)
  end

  return HookableToolTip:new(onRenderTooltip, onRemoveTooltip)
end

---@param context ISContextMenu
---@return table, ISContextMenu
function UpgradeContainerContextMenu:createUpgradeContainerMenu(context)
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
        moveProps.hasWoodenUpgrade = self.woodenUpgrade
        moveProps.hasMetalUpgrade = self.metalUpgrade
        validObjects[tostring(object)] = moveProps
      end
    end
  end

  return validObjects
end

---@param moveProps ISMoveableSpriteProps
---@param upgradeItem InventoryItem
---@return ISToolTip,boolean
function UpgradeContainerContextMenu:createUpgradeToolTip(moveProps, upgradeItem)
  if not upgradeItem then
    local tooltip = ISInventoryPaneContextMenu.addToolTip()
    tooltip.description = getText("ContextMenu_MissingUpgradeContainerItem")
    return tooltip, true
  end

  local tooltipFont = ISToolTip.GetFont()

  local toolTip = self:createHightlightToolTip(moveProps, true)
  toolTip:initialise()
  toolTip:setVisible(false)
  toolTip:setTexture(moveProps.object:getSprite():getName())

  local infoTable = getContainerUpgradeInfoTable(moveProps, upgradeItem)

  local column2 = 0
  for _, t1 in ipairs(infoTable) do
    if #t1 == 2 then
      -- removes Text Between Angle Brackets, including the spaces
      local sanitized = t1[1]:gsub("%s*<%s*.-%s*>%s*", "")
      local textWid = getTextManager():MeasureStringX(tooltipFont, sanitized)
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

  return toolTip, false
end

---@param subMenuContext table
---@param moveProps ISMoveableSpriteProps
---@return table, ISContextMenu
function UpgradeContainerContextMenu:createUpgradableObjectMenu(subMenuContext, moveProps)
  local object = moveProps.object
  local objName = moveProps.name or "Unknown Object (Unnamed)"
  local objectOption = subMenuContext:addOption(Translator.getMoveableDisplayName(objName), nil, nil)

  local toolTip = self:createHightlightToolTip(moveProps)
  toolTip:initialise()
  toolTip:setVisible(false)

  objectOption.toolTip = toolTip

  local upgradeObjectMenuContext = ISContextMenu:getNew(subMenuContext)
  upgradeObjectMenuContext:addSubMenu(objectOption, upgradeObjectMenuContext)

  return objectOption, upgradeObjectMenuContext
end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
function UpgradeContainerContextMenu:renderContextMenu(playerIndex, context, worldObjects)
  local player = getSpecificPlayer(playerIndex)

  self.woodenUpgrade = player:getInventory():FindAndReturn("Casualoid.WoodenContainerUpgrade")
  self.metalUpgrade = player:getInventory():FindAndReturn("Casualoid.MetalContainerUpgrade")

  local validProps = self:extractValidMoveProps(worldObjects)

  Debug:print('validObjects:', Debug:printTable(validProps))

  if table.isempty(validProps) then
    return
  end

  local upgradeMenuOption, upgradeMenuContext = self:createUpgradeContainerMenu(context)

  for _, moveProps in pairs(validProps) do
    local upgradeObjectOption, upgradeObjectMenuContext = self:createUpgradableObjectMenu(upgradeMenuContext,
      moveProps)

    local function upgradeAction(upgradeItem)
      local adjacent = AdjacentFreeTileFinder.Find(moveProps.object:getSquare(), player)
      if adjacent ~= nil then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(player, adjacent))
      end
      return ISTimedActionQueue.add(UpgradeContainerAction:new(player, moveProps.object, upgradeItem))
    end

    local woodenOption = upgradeObjectMenuContext:addOption("Wooden Upgrade", self.woodenUpgrade, upgradeAction);
    local woodenToolTip, woodenNotAvailable = self:createUpgradeToolTip(moveProps, self.woodenUpgrade)
    woodenOption.toolTip = woodenToolTip
    woodenOption.notAvailable = woodenNotAvailable

    local metalOption = upgradeObjectMenuContext:addOption("Metal Upgrade", self.metalUpgrade, upgradeAction);
    local metalToolTip, metalNotAvailable = self:createUpgradeToolTip(moveProps, self.metalUpgrade)
    metalOption.toolTip = metalToolTip
    metalOption.notAvailable = metalNotAvailable

    --- Add show info option
    -- local woodenOption = upgradeObjectMenuContext:addOption("Wooden Upgrade", self.woodenUpgrade, upgradeAction);
    -- local woodenToolTip, woodenNotAvailable = self:createUpgradeToolTip(moveProps, self.woodenUpgrade)
    -- woodenOption.toolTip = woodenToolTip
    -- woodenOption.notAvailable = woodenNotAvailable
  end
end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
function UpgradeContainerContextMenu.onFillWorldObjectContextMenu(playerIndex, context, worldObjects)
  UpgradeContainerContextMenu:renderContextMenu(playerIndex, context, worldObjects)
end

return UpgradeContainerContextMenu
