require "ISUI/ISInventoryPage"

local Hooks = require "MxUtilities/Hooks"
local Debug = require("Casualoid/Debug")

local tempWidth = 100

---@class NamedContainersUI: ISInventoryPage
local NamedContainersUI = {}

function NamedContainersUI:createChildren()
  Debug:print('NamedContainersUI:createChildren', 'self.onCharacter', self.onCharacter)
  self.inventoryPane:setWidth(self.width - tempWidth)
end

function NamedContainersUI:addContainerButton(container, texture, name, tooltip)
  ---@type ISButton
  local button = Hooks:GetReturn()
  button:setY(button:getY() + self.buttonSize)
end

function NamedContainersUI:onResizeIconsColumn()
  self.inventoryPane:setWidth(self.iconsHeader.x - 1)
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
    x = self:getWidth() - tempWidth
    w = tempWidth
  end

  return old_drawRectBorder(self, x, y, w, h, ...)
end

function NamedContainersUI:render()
  if not self.iconsHeader then
    return
  end
  local resize = self.iconsHeader.mouseOverResize or self.iconsHeader.resizing

  if resize then
    local height = self.inventoryPane:getHeight()
    self:repaintStencilRect(self.inventoryPane:getRight() + 1, self.inventoryPane.y, 2, height)
    self:drawRectStatic(self.inventoryPane:getRight() + 1, self.inventoryPane.y, 2, height, 0.5, 1, 1, 1)
  end
end

function NamedContainersUI:refreshBackpacks()
  if self.iconsHeader then
    self:removeChild(self.iconsHeader)
  end

  local x = self.width - tempWidth
  local y = self:titleBarHeight()
  local fontHgtSmall = getTextManager():getFontHeight(UIFont.Small)
  self.iconsHeader = ISResizableButton:new(x, y, tempWidth, fontHgtSmall + 1, "~", self, function() end);
  self.iconsHeader.borderColor.a = 0.2;
  self.iconsHeader:setBackgroundRGBA(0.0, 0.0, 0.0, 0.0)
  self.iconsHeader:setBackgroundColorMouseOverRGBA(0.3, 0.3, 0.3, 1.0)
  self.iconsHeader:setTextureRGBA(1.0, 1.0, 1.0, 1.0)
  self.iconsHeader.minimumWidth = self.buttonSize
  self.iconsHeader.resizeLeft = true
  self.iconsHeader.anchorRight = true
  self.iconsHeader.maximumWidth = 200
  self.iconsHeader:initialise();
  self.iconsHeader.onresize = { NamedContainersUI.onResizeIconsColumn, self, self.iconsHeader }
  self:addChild(self.iconsHeader);
end

Events.OnRefreshInventoryWindowContainers.Add(function(self, reason)
  if reason ~= "buttonsAdded" then return end
end)

Hooks:PostHooksFromTable(ISInventoryPage, NamedContainersUI, 'NamedContainersUI')
