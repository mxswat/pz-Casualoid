local Hooks = require "MxUtilities/Hooks"
local Debug = require "Casualoid/Debug"
local DisassembleWithItems = require "Casualoid/DisassembleWithItems"
local renameAllItems = require "Casualoid/renameAllItems"
local disableMxMagazines = require "Casualoid/MxMagazines/disableMxMagazines"
local upgradeContextMenu = require "Casualoid/ContainerUpgrades/upgradeContextMenu"

local function initCasualoidHooks()
  Debug:print('Initalizing Casualoid Hooks')
  if SandboxVars.Casualoid.DisassembleContainerWithItems then
    Hooks:PostHooksFromTable(ISMoveableSpriteProps, DisassembleWithItems, 'DisassembleWithItem')
  end

  if SandboxVars.Casualoid.RenameAllItems then
    Events.OnFillInventoryObjectContextMenu.Add(renameAllItems)
  end

  if not SandboxVars.Casualoid.EnableMxMagazines  then
    disableMxMagazines()
  end

  if SandboxVars.Casualoid.EnableContainerUpgrades  then
    Events.OnFillWorldObjectContextMenu.Add(upgradeContextMenu)
  end
end

Events.OnGameStart.Add(initCasualoidHooks);
