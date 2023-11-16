require "ISUI/ISInventoryPage"
local SetWidthDialog = require "Casualoid/NamedContainers/SetWidthDialog"
local NamedContainersUIData = require "Casualoid/NamedContainers/NamedContainersUIData"
local Hooks = require "MxUtilities/Hooks"
local Debug = require "Casualoid/Debug"

---@class NamedContainersUI: ISInventoryPage
local NamedContainersUI = {}

function NamedContainersUI:createChildren()
  self.inventoryPane.anchorRight = false;
end

function NamedContainersUI.onResizeIconsColumn(self, button)
  if button then
    NamedContainersUI.saveSize(self)
    -- self:refreshBackpacks()
  end
end

---@param reason string
function NamedContainersUI.onRefreshBackpacks(self, reason)
  if reason ~= "buttonsAdded" then return end
  if self.iconsHeader then
    self:removeChild(self.iconsHeader)
  end

  local titleBarHeight = self:titleBarHeight()

  local size = NamedContainersUIData.getSavedSize(self)
  self.buttonSize = size
  self.minimumWidth = 256 + size
  local x = self.width - size
  local y = titleBarHeight
  local fontHgtSmall = getTextManager():getFontHeight(UIFont.Small)
  self.iconsHeader = ISButton:new(x, y, size, fontHgtSmall + 1, "~", self, SetWidthDialog.open);
  self.iconsHeader.borderColor.a = 0.2;
  self.iconsHeader:setBackgroundRGBA(0.0, 0.0, 0.0, 0.0)
  self.iconsHeader:setBackgroundColorMouseOverRGBA(0.3, 0.3, 0.3, 1.0)
  self.iconsHeader:setTextureRGBA(1.0, 1.0, 1.0, 1.0)
  self.iconsHeader.anchorLeft = false
  self.iconsHeader.anchorTop = false
  self.iconsHeader.anchorRight = true
  self.iconsHeader.anchorBottom = false
  self.iconsHeader:initialise()
  self:addChild(self.iconsHeader);

  local newPaneWidth = self.width - NamedContainersUIData.getSavedSize(self)

  self.inventoryPane:setWidth(newPaneWidth)
  self.inventoryPane:setHeight(self.height-titleBarHeight-9)
  self.inventoryPane:recalcSize()

  if self.iconsHeader.x <= (self.inventoryPane.typeHeader.x + 100) then
    self.inventoryPane.typeHeader:resize(100)
    self.inventoryPane:onResizeColumn(self.inventoryPane.typeHeader)
  end

  self.inventoryPane.vscroll:setX(newPaneWidth - 16)
  self.inventoryPane:updateScrollbars();

  self.inventoryPane.borderColor.a = 1;
  self.inventoryPane.borderColor.r = 1;
  -- self.inventoryPane:onResize()

  local sizes = { 32, 40, 48 }
  local vanillaButtonSize = sizes[getCore():getOptionInventoryContainerSize()]

  ---@param button ISButton
  for i, button in ipairs(self.backpacks) do

    local y = ((i - 1) * vanillaButtonSize) + titleBarHeight - 1
    button:setY(y + self.iconsHeader:getHeight() + 1)
    button:setWidth(NamedContainersUIData.getSavedSize(self))
    button:setHeight(vanillaButtonSize)
    button:setX(self.iconsHeader.x)
    button:setBorderRGBA(0.6, 0.6, 0.6, 0.5)
    if button.inventory ~= self.inventory then
      button:setBackgroundRGBA(0.1, 0.1, 0.1, 0.7)
    end
  end
end

Events.OnRefreshInventoryWindowContainers.Add(NamedContainersUI.onRefreshBackpacks)

Hooks:PostHooksFromTable(ISInventoryPage, NamedContainersUI, 'NamedContainersUI')
