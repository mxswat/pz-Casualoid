local Hooks = require("MxUtilities/Hooks")

---@class Disassemble: ISMoveableSpriteProps
local DisassembleWithItems = {}

function DisassembleWithItems:getInfoPanelDescription(_square, _object, _player, _mode)
  local infoTable = Hooks:GetReturn()
  if not (InfoPanelFlags.hasItems and _mode == "scrap") then
    return infoTable
  end

  for i, line in ipairs(infoTable) do
    for _, entry in ipairs(line) do
      if entry.txt == "- " .. getText("IGUI_ItemsInContainer") then
        table.remove(infoTable, i)
        return infoTable
      end
    end
  end

  return infoTable
end

function DisassembleWithItems:scrapObjectInternal(_character, _scrapDef, _square, _object, ...)
  local object = _object
  if not (_scrapDef and object and _square) then
    return
  end

  if object:isFloor() and (_square:getZ() == 0) then
    return
  end

  for i = 1, object:getContainerCount() do
    local container = object:getContainerByIndex(i - 1)
    for j = 1, container:getItems():size() do
      object:getSquare():AddWorldInventoryItem(container:getItems():get(j - 1), 0.0, 0.0, 0.0)
    end
  end
end

function DisassembleWithItems:canScrapObjectInternal(_result, _object)
  local canScrap = Hooks:GetReturn()

  if canScrap == false and self:objectNoContainerOrEmpty(_object) == false then
    return true
  end

  return canScrap
end

return DisassembleWithItems