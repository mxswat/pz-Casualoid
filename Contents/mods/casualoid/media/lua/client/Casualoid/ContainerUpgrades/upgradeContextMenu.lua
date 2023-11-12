local Debug = require("Casualoid/Debug")

local getContainerUpgradeInfoTable = require("Casualoid/ContainerUpgrades/getContainerUpgradeInfoTable")

local containerUpgradeIcon = getTexture("media/textures/Item_ContainerUpgrade.png")

---@class UpgradeContainerProps:ISMoveableSpriteProps
---@field hasWoodenUpgrade boolean
---@field hasMetalUpgrade boolean

---@param context ISContextMenu
---@param player IsoPlayer
local function createUpgradeOption(context, player)
  local option = context:addOption(getText("ContextMenu_UpgradeContainer"), player, nil);
  option.iconTexture = containerUpgradeIcon;
  return option
end

---@param player IsoPlayer
---@param worldObjects table
---@return table<string, UpgradeContainerProps>
local function extractValidMoveProps(player, worldObjects)
  local hasWoodenUpgrade = player:getInventory():FindAndReturn("Casualoid.WoodenContainerUpgrade")
  local hasMetalUpgrade = player:getInventory():FindAndReturn("Casualoid.MetalContainerUpgrade")

  local validObjects = {}

  for _, object in ipairs(worldObjects) do
    local square = object:getSquare()

    if square then
      local moveProps = ISMoveableSpriteProps.fromObject(object)

      if moveProps and object:getContainerCount() > 0 then
        local upgradeProps = moveProps
        upgradeProps.hasWoodenUpgrade = hasWoodenUpgrade
        upgradeProps.hasMetalUpgrade = hasMetalUpgrade
        validObjects[tostring(object)] = upgradeProps
      end
    end
  end

  return validObjects
end

---@param subMenu table
---@param moveProps UpgradeContainerProps
local function createUpgradeToolTip(subMenu, moveProps)
  local color = getCore():getGoodHighlitedColor()
  local tooltipFont = ISToolTip.GetFont()

  local toolTip = ISToolTip:new();
  toolTip:initialise();
  toolTip:setVisible(false);
  toolTip.description = "Upgrade container"
  toolTip.object = moveProps.object;
  toolTip:setTexture(moveProps.object:getSprite():getName());
  toolTip.description = "";

  local infoTable = getContainerUpgradeInfoTable(moveProps)

  local column2 = 0;
  for _, t1 in ipairs(infoTable) do
    if #t1 == 2 then
      local textWid = getTextManager():MeasureStringX(tooltipFont, t1[1]);
      column2 = math.max(column2, textWid + 10)
    end
  end

  for _, t1 in ipairs(infoTable) do
    toolTip.description = string.format("%s %s", toolTip.description, t1[1]);
    if #t1 == 2 then
        toolTip.description = string.format("%s <SETX:%d> <INDENT:%d> %s", toolTip.description, column2, column2, t1[2]);
    end
    toolTip.description = toolTip.description .. " <LINE> <INDENT:0> ";
  end

  --highlight the object on tile while the tooltip is showing
  subMenu.showTooltip = function(_subMenu, _option)
    ISContextMenu.showTooltip(_subMenu, _option);
    if _subMenu.toolTip.object ~= nil then
      _subMenu.toolTip.object:setHighlightColor(color);
      _subMenu.toolTip.object:setHighlighted(true, false);
    end
  end

  --stop highlighting the object when the tooltip is not showing
  subMenu.hideToolTip = function(_subMenu)
    if _subMenu.toolTip and _subMenu.toolTip.object then
      _subMenu.toolTip.object:setHighlighted(false);
    end;
    ISContextMenu.hideToolTip(_subMenu);
  end

  return toolTip
end

---@param subMenu table
---@param moveProps UpgradeContainerProps
local function insertUpgradeOption(subMenu, moveProps)
  local object = moveProps.object

  local objName = moveProps.name or "Unknown Object (Unnamed)"

  local option = subMenu:addOption(Translator.getMoveableDisplayName(objName), {}, function() end, object);

  option.toolTip = createUpgradeToolTip(subMenu, moveProps);

end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
local function upgradeContextMenu(playerIndex, context, worldObjects)
  local player = getSpecificPlayer(playerIndex)

  local hasWoodenUpgrade = player:getInventory():FindAndReturn("Casualoid.WoodenContainerUpgrade")
  local hasMetalUpgrade = player:getInventory():FindAndReturn("Casualoid.MetalContainerUpgrade")

  if not hasWoodenUpgrade and not hasMetalUpgrade then
    local option = createUpgradeOption(context, player)
    option.notAvailable = true

    local tooltip = ISInventoryPaneContextMenu.addToolTip();
    tooltip.description = getText("ContextMenu_MissingUpgradeContainerItem");
    option.toolTip = tooltip;
    return
  end

  local validProps = extractValidMoveProps(player, worldObjects)

  Debug:print('validObjects:', Debug:printTable(validProps))

  if table.isempty(validProps) then
    return
  end

  local upgradeOption = createUpgradeOption(context, player)
  local subMenu = context:getNew(context);
  context:addSubMenu(upgradeOption, subMenu);

  for _, moveProps in pairs(validProps) do
    insertUpgradeOption(subMenu, moveProps)
  end
end

return upgradeContextMenu
