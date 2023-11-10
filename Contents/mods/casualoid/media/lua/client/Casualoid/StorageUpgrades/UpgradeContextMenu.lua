local Debug = require("Casualoid/Debug")

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
local function contextMenu(playerIndex, context, worldObjects)
  local player = getSpecificPlayer(playerIndex)

  ---@type table<string, IsoObject>
  local validObjects = {};
  local hasValidObjects = false;
  for _, object in ipairs(worldObjects) do
    local square = object:getSquare();
    if square then
      local moveProps = ISMoveableSpriteProps.fromObject(object);

      if moveProps and object:getContainerCount() == 1 then
        local getContainerCount = object:getContainerCount()
        Debug:print(tostring(object), getContainerCount)
        validObjects[tostring(object)] = object;
        hasValidObjects = true
      end
    end
  end

  if not hasValidObjects then
    return
  end

  local disassembleMenu = context:addOption(getText("ContextMenu_UpgradeContainer"), player, nil);
  local subMenu = context:getNew(context);
  context:addSubMenu(disassembleMenu, subMenu);

  local color = getCore():getGoodHighlitedColor();

  for _, object in pairs(validObjects) do
    -- local object = object
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

Events.OnFillWorldObjectContextMenu.Add(contextMenu)

return contextMenu
