local Debug = require("Casualoid/Debug")

local containerUpgradeIcon = getTexture("media/textures/Item_ContainerUpgrade.png")

---@param context ISContextMenu
---@param player IsoPlayer
local function createUpgradeOption(context, player)
  local option = context:addOption(getText("ContextMenu_UpgradeContainer"), player, nil);
  option.iconTexture = containerUpgradeIcon;
  return option
end

---@param worldObjects table
---@return table<string, IsoObject>
local function extractValidObjects(worldObjects)
  local validObjects = {}

  for _, object in ipairs(worldObjects) do
    local square = object:getSquare()

    if square then
      local moveProps = ISMoveableSpriteProps.fromObject(object)

      if moveProps and object:getContainerCount() == 1 then
        validObjects[tostring(object)] = object
      end
    end
  end

  return validObjects
end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
local function upgradeContextMenu(playerIndex, context, worldObjects)
  local player = getSpecificPlayer(playerIndex)

  if not player:getInventory():FindAndReturn("Casualoid.ContainerUpgrade") then
    local option = createUpgradeOption(context, player)
    option.notAvailable = true

    local tooltip = ISInventoryPaneContextMenu.addToolTip();
    tooltip.description = getText("ContextMenu_MissingUpgradeContainerItem");
    option.toolTip = tooltip;
    return
  end

  local validObjects = extractValidObjects(worldObjects)

  Debug:print('validObjects:', Debug:printTable(validObjects))

  if table.isempty(validObjects) then
    return
  end

  local upgradeOption = createUpgradeOption(context, player)
  local subMenu = context:getNew(context);
  context:addSubMenu(upgradeOption, subMenu);

  local color = getCore():getGoodHighlitedColor();

  for _, object in pairs(validObjects) do
    local objName = object:getName() or object:getProperties():Val("CustomName") or "Unknown Object (Unnamed)"

    local option = subMenu:addOption(Translator.getMoveableDisplayName(objName), {}, function() end, object);
    -- option.notAvailable = not object.resultScrap.canScrap;

    local tooltip = ISToolTip:new();
    tooltip:initialise();
    tooltip:setVisible(false);
    tooltip.description = "Upgrade container"
    tooltip.object = object;
    tooltip:setTexture(object:getSprite():getName());
    option.toolTip = tooltip;

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
  end
end

return upgradeContextMenu
