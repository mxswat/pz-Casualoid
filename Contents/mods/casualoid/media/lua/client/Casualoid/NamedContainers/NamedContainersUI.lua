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
  self.inventoryPane:setWidth(self.iconsHeader.x)

  if self.iconsHeader.x <= (self.inventoryPane.typeHeader.x + 100) then
    self.inventoryPane.typeHeader:resize(100)
    self.inventoryPane:onResizeColumn(self.inventoryPane.typeHeader)
  end

  self.inventoryPane:recalcSize()
  self.inventoryPane.vscroll:setX(self.inventoryPane.width - self.inventoryPane.vscroll.width)
  self:updateScrollbars();
  -- self.inventoryPane:refreshContainer()

  ---@param button ISButton
  for _, button in ipairs(self.backpacks) do
    button:setY(button:getY() + self.iconsHeader:getHeight() + 1)
    button:setWidth(NamedContainersUIData.getSavedSize(self))
    button:setX(self.iconsHeader.x)
    button:setBorderRGBA(0.6, 0.6, 0.6, 0.5)
    if button.inventory ~= self.inventory then
      button:setBackgroundRGBA(0.1, 0.1, 0.1, 0.7)
    end
  end

  if button then
    NamedContainersUI.saveSize(self)
    -- self:refreshBackpacks()
  end
end

local old_drawRectBorder = ISInventoryPage.drawRectBorder
function ISInventoryPage.drawRectBorder(self, x, y, w, h, ...)
  -- Intecepts the "Draw backpack border over backpacks"
  local titleBarHeight = self:titleBarHeight()
  local height = self:getHeight();
  if x == self:getWidth() - self.buttonSize
      and y == titleBarHeight - 1
      and w == self.buttonSize
      and h == height - titleBarHeight - 7
  then
    x = self:getWidth() - NamedContainersUIData.getSavedSize(self)
    w = NamedContainersUIData.getSavedSize(self)
  end

  return old_drawRectBorder(self, x, y, w, h, ...)
end

---@param reason string
function NamedContainersUI.onRefreshBackpacks(self, reason)
  if reason ~= "buttonsAdded" then return end
  if self.iconsHeader then
    self:removeChild(self.iconsHeader)
  end

  local size = NamedContainersUIData.getSavedSize(self)
  self.minimumWidth = 256 + size
  local x = self.width - size
  local y = self:titleBarHeight()
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

  NamedContainersUI.onResizeIconsColumn(self)
end

Events.OnRefreshInventoryWindowContainers.Add(NamedContainersUI.onRefreshBackpacks)

Hooks:PostHooksFromTable(ISInventoryPage, NamedContainersUI, 'NamedContainersUI')
