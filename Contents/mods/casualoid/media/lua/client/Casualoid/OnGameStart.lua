local Hooks = require "MxUtilities/Hooks"
local DisassembleWithItems = require "Casualoid/DisassembleWithItems"
local renameAllItems = require "Casualoid/renameAllItems"
local disableMxMagazines = require "Casualoid/MxMagazines/disableMxMagazines"

Events.OnGameStart.Add(function()
  if SandboxVars.Casualoid.DisassembleContainerWithItems then
    Hooks:PostHooksFromTable(ISMoveableSpriteProps, DisassembleWithItems, 'DisassembleWithItem')
  end

  if SandboxVars.Casualoid.RenameAllItems then
    Events.OnFillInventoryObjectContextMenu.Add(renameAllItems)
  end

  if not SandboxVars.Casualoid.EnableMxMagazines  then
    return disableMxMagazines()
  end
end);
