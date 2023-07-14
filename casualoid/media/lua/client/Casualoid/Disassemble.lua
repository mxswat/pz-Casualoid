-- "Disassemble Container With Items" mod, Mx's version

local function removeLineFromInfoTable(_table, _lineA)
  for i, line in ipairs(_table) do
    for _, entry in ipairs(line) do
      if entry.txt == _lineA then
        table.remove(_table, i)
        return true
      end
    end
  end
  return false
end

local old_ISMoveableSpriteProps_getInfoPanelDescription = ISMoveableSpriteProps.getInfoPanelDescription
function ISMoveableSpriteProps:getInfoPanelDescription(_square, _object, _player, _mode)
  local infoTable = old_ISMoveableSpriteProps_getInfoPanelDescription(self, _square, _object, _player, _mode)

  if InfoPanelFlags.hasItems and _mode == "scrap" then
    removeLineFromInfoTable(infoTable, "- " .. getText("IGUI_ItemsInContainer"))
  end

  return infoTable
end

local old_ISMoveableSpriteProps_scrapObjectInternal = ISMoveableSpriteProps.scrapObjectInternal
function ISMoveableSpriteProps:scrapObjectInternal(_character, _scrapDef, _square, _object, _scrapResult, _chance,
                                                   _perkName)
  local result = old_ISMoveableSpriteProps_scrapObjectInternal(self, _character, _scrapDef, _square, _object,
    _scrapResult, _chance, _perkName)

  local object = _object;
  if _scrapDef and object and _square then
    if not (object:isFloor() and (_square:getZ() == 0)) then
      for i = 1, object:getContainerCount() do
        local container = object:getContainerByIndex(i - 1)
        for j = 1, container:getItems():size() do
          object:getSquare():AddWorldInventoryItem(container:getItems():get(j - 1), 0.0, 0.0, 0.0)
        end
      end
    end
  end

  return result
end

local old_ISMoveableSpriteProps_canScrapObjectInternal = ISMoveableSpriteProps.canScrapObjectInternal
function ISMoveableSpriteProps:canScrapObjectInternal(_result, _object)
  local canScrap = old_ISMoveableSpriteProps_canScrapObjectInternal(self, _result, _object)

  if canScrap == false and self:objectNoContainerOrEmpty(_object) == false then
    return true
  end

  return canScrap
end
