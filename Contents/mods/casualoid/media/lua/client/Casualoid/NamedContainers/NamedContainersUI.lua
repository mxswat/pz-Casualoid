require "ISUI/ISInventoryPage"
local SetWidthDialog = require "Casualoid/NamedContainers/SetWidthDialog"
local NamedContainersSettings = require "Casualoid/NamedContainers/NamedContainersSettings"
local Hooks = require "MxUtilities/Hooks"
local MxDebug = require "MxUtilities/MxDebug"
local RenameDialog = require "Casualoid/NamedContainers/RenameDialog"
local Utils = require "MxUtilities/Utils"

---@class NamedContainersUI: ISInventoryPage
local NamedContainersUI = {}

function NamedContainersUI.createIconsHeader(self)
  local titleBarHeight = self:titleBarHeight()
  local size = NamedContainersSettings.getSavedSize(self)
  local x = self.width - size
  local y = titleBarHeight
  local fontHgtSmall = getTextManager():getFontHeight(UIFont.Small)
  local iconsHeader = ISButton:new(x, y, size, fontHgtSmall + 1, "~", self, SetWidthDialog.open);
  iconsHeader.borderColor.a = 0.2;
  iconsHeader:setBackgroundRGBA(0.0, 0.0, 0.0, 0.0)
  iconsHeader:setBackgroundColorMouseOverRGBA(0.3, 0.3, 0.3, 1.0)
  iconsHeader:setTextureRGBA(1.0, 1.0, 1.0, 1.0)
  iconsHeader.anchorLeft = false
  iconsHeader.anchorTop = true
  iconsHeader.anchorRight = true
  iconsHeader.anchorBottom = false
  iconsHeader:initialise()

  return iconsHeader
end

local pre_ISInventoryPage_createChildren = ISInventoryPage.createChildren
function ISInventoryPage:createChildren()
  pre_ISInventoryPage_createChildren(self)

  -- Sadly, it's the only way to do add the button on createChildren, cause they are create before the `OnGameStart` is fired :( 
  if not SandboxVars.Casualoid.NamedContainersUI then return end

  local iconsHeader = NamedContainersUI.createIconsHeader(self)
  self:addChild(iconsHeader)
  self.iconsHeader = iconsHeader
end

function NamedContainersUI.getVanillaButtonSize()
  local sizes = { 32, 40, 48 }
  return sizes[getCore():getOptionInventoryContainerSize()]
end

function NamedContainersUI.getInventoryName(self, inventory)
  if getSpecificPlayer(self.player):getInventory() == inventory then
    return getText("IGUI_Controller_Inventory")
  end
  return (inventory:getParent() and inventory:getParent():getModData().ContainerCustomName)
      or getTextOrNull("IGUI_ContainerTitle_" .. inventory:getType())
end

function NamedContainersUI:onBackpackRightMouseDown(x, y)
  local page = self.parent

  if page.onCharacter or self.inventory:getContainingItem() then
    return
  end

  local context = getPlayerContextMenu(page.player);

  if not context:getIsVisible() then
    context = ISContextMenu.get(page.player, getMouseX(), getMouseY());
    context.origin = page
    context.mouseOver = 1
    setJoypadFocus(page.player, context)
  end

  context:addOption(getText("ContextMenu_RenameBag"), self.inventory, function()
    RenameDialog.open(self.player, self.name, self.inventory)
  end);

  MxDebug:print('context', context, context:getIsVisible() and 1 or 0)
end

function NamedContainersUI:addContainerButton(container, texture, _name, tooltip)
  local name = NamedContainersUI.getInventoryName(self, container) or _name
  local maxWidth = NamedContainersSettings.getSavedSize(self) - 48
  local trimmedName = Utils:trimTextWithEllipsis(self.font, name, maxWidth)

  ---@type ISButton
  local button = Hooks:GetReturn()
  button:setTitle(trimmedName)
  button.name = name
  -- Forces text on the left
  button.drawText = function(self, str, x, ...)
    ISButton.drawText(self, str, 4 + 32, ...)
  end
  -- Forces icon on the left
  button.drawTextureScaledAspect = function(self, texture, x, ...)
    ISButton.drawTextureScaledAspect(self, texture, 2, ...)
  end
end

function NamedContainersUI.patchInventoryPane(self)
  local newWidth = self.width - NamedContainersSettings.getSavedSize(self)
  local newHeight = self.height - self:titleBarHeight() - 9
  self.inventoryPane:setWidth(newWidth)
  self.inventoryPane:setHeight(newHeight)
  self.inventoryPane.vscroll:setX(newWidth - 16)
  self.inventoryPane.vscroll:setHeight(newHeight)
  self.inventoryPane:updateScrollbars();
  self.inventoryPane.borderColor.a = 1;
  self.inventoryPane.borderColor.r = 1;

  if self.iconsHeader.x <= (self.inventoryPane.typeHeader.x + 100) then
    self.inventoryPane.typeHeader:resize(100)
    self.inventoryPane:onResizeColumn(self.inventoryPane.typeHeader)
  end

  self.inventoryPane:recalcSize()
end

function NamedContainersUI:refreshBackpacks()
  local savedSize = NamedContainersSettings.getSavedSize(self)

  self.buttonSize = savedSize
  self.minimumWidth = 256 + savedSize

  NamedContainersUI.patchInventoryPane(self)

  local titleBarHeight = self:titleBarHeight()
  local vanillaButtonSize = NamedContainersUI.getVanillaButtonSize()
  ---@param button ISButton
  for i, button in ipairs(self.backpacks) do
    -- Patch buttons location and backgroundColor as it's done inside the original refreshBackpacks
    local y = ((i - 1) * vanillaButtonSize) + (titleBarHeight - 1 + self.iconsHeader:getHeight() + 1)
    button:setY(y)
    button:setWidth(savedSize)
    button:setHeight(vanillaButtonSize)
    button:setX(self.iconsHeader.x)
    button:setBorderRGBA(0.6, 0.6, 0.6, 0.5)
    if button.inventory ~= self.inventory then
      button:setBackgroundRGBA(0.1, 0.1, 0.1, 0.7)
    else
      self.title = button.name
    end
  end
end

function NamedContainersUI:init()
  Hooks:PostHooksFromTable(ISInventoryPage, NamedContainersUI, 'NamedContainersUI')
end

return NamedContainersUI
