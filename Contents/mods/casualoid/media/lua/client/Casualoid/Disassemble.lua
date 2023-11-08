local Hooks = require("MxUtilities/Hooks")

local Disassemble = {}

function Disassemble:getInfoPanelDescription(_square, _object, _player, _mode)
  local infoTable = Hooks:getLastResult()
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

function Disassemble:scrapObjectInternal(_character, _scrapDef, _square, _object, ...)
  local result = Hooks:getLastResult()

  local object = _object
  if not (_scrapDef and object and _square) then
    return result
  end

  if object:isFloor() and (_square:getZ() == 0) then
    return result
  end

  for i = 1, object:getContainerCount() do
    local container = object:getContainerByIndex(i - 1)
    for j = 1, container:getItems():size() do
      object:getSquare():AddWorldInventoryItem(container:getItems():get(j - 1), 0.0, 0.0, 0.0)
    end
  end

  return result
end

function Disassemble:canScrapObjectInternal(_result, _object)
  local canScrap = Hooks:getLastResult()

  if canScrap == false and self:objectNoContainerOrEmpty(_object) == false then
    return true
  end

  return canScrap
end

Events.OnGameStart.Add(function()
  if not SandboxVars.Casualoid.DisassembleContainerWithItems then
    return
  end

  Hooks:autoApplyPostHooks(ISMoveableSpriteProps, Disassemble)
end);
