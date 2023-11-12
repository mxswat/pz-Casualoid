local Hooks = require "MxUtilities/Hooks"
local Debug = require "Casualoid/Debug"
local DisassembleWithItems = require "Casualoid/DisassembleWithItems"
local renameAllItems = require "Casualoid/renameAllItems"
local disableMxMagazines = require "Casualoid/MxMagazines/disableMxMagazines"
local UpgradeContainerContextMenu = require "Casualoid/ContainerUpgrades/UpgradeContextMenu"

local function initCasualoidHooks()
  Debug:print('Initalizing Casualoid Hooks')
  if SandboxVars.Casualoid.DisassembleContainerWithItems then
    Hooks:PostHooksFromTable(ISMoveableSpriteProps, DisassembleWithItems, 'DisassembleWithItem')
  end

  if SandboxVars.Casualoid.RenameAllItems then
    Events.OnFillInventoryObjectContextMenu.Add(renameAllItems)
  end

  if not SandboxVars.Casualoid.EnableMxMagazines then
    disableMxMagazines()
  end

  if SandboxVars.Casualoid.EnableContainerUpgrades then
    Events.OnFillWorldObjectContextMenu.Add(UpgradeContainerContextMenu.onFillWorldObjectContextMenu)
  end
end

Events.OnGameStart.Add(initCasualoidHooks);