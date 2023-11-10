local Debug = require("Casualoid/Debug")

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
local function contextMenu(playerIndex, context, worldObjects)
  local player = getSpecificPlayer(playerIndex)

  local validObjList = {};
  for _, object in ipairs(worldObjects) do
    local square = object:getSquare();
    if square then
      local moveProps = ISMoveableSpriteProps.fromObject(object);
      -- Check for partially-destroyed multi-tile objects.
      if moveProps.isMultiSprite then
        local grid = moveProps:getSpriteGridInfo(object:getSquare(), true)
        if not grid then moveProps = nil end
      end
      if moveProps then
        local resultScrap, chance, perkname = moveProps:canScrapObject(player);
        if resultScrap.craftValid then
          table.insert(validObjList,
            {
              object = object,
              moveProps = moveProps,
              square = square,
              chance = chance,
              perkName = perkname,
              resultScrap = resultScrap
            });
        end
      end
    end
  end

  if #validObjList == 0 then
    return
  end

  local disassembleMenu = context:addOption(getText("ContextMenu_Disassemble") .. 'Mx', player, nil);
  local subMenu = ISContextMenu:getNew(context);
  context:addSubMenu(disassembleMenu, subMenu);

  local tooltipFont = ISToolTip.GetFont()
  local hc = getCore():getBadHighlitedColor();

  for k, v in ipairs(validObjList) do
    local infoTable = v.moveProps:getInfoPanelDescription(v.square, v.object, player, "scrap");

    local option = subMenu:addOption(Translator.getMoveableDisplayName(v.moveProps.name), {}, function() end, v);
    -- local option = subMenu:addOption(Translator.getMoveableDisplayName(v.moveProps.name), _data, self.disassemble, v );
    option.notAvailable = not v.resultScrap.canScrap;

    local toolTip = ISToolTip:new();
    toolTip:initialise();
    toolTip:setVisible(false);
    toolTip.description = "";

    local column2 = 0;
    for _, t1 in ipairs(infoTable) do
      if #t1 == 2 then
        local textWid = getTextManager():MeasureStringX(tooltipFont, t1[1].txt);
        column2 = math.max(column2, textWid + 10)
      end
    end

    for _, t1 in ipairs(infoTable) do
      toolTip.description = string.format("%s <RGB:%.2f,%.2f,%.2f> %s", toolTip.description, t1[1].r / 255, t1[1].g / 255,
        t1[1].b / 255, t1[1].txt);
      if #t1 == 2 then
        toolTip.description = string.format("%s <SETX:%d> <INDENT:%d> <RGB:%.2f,%.2f,%.2f> %s", toolTip.description,
          column2, column2, t1[2].r / 255, t1[2].g / 255, t1[2].b / 255, t1[2].txt);
      end
      toolTip.description = toolTip.description .. " <LINE> <INDENT:0> ";
    end
    toolTip.object = v.moveProps.object;
    toolTip:setTexture(v.moveProps.spriteName);
    option.toolTip = toolTip;

    --highlight the object on tile while the tooltip is showing
    subMenu.showTooltip = function(_subMenu, _option)
      ISContextMenu.showTooltip(_subMenu, _option);
      if _subMenu.toolTip.object ~= nil then
        _subMenu.toolTip.object:setHighlightColor(hc);
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
