require "ISUI/ISInventoryPage"

local Hooks = require "MxUtilities/Hooks"
local Debug = require("Casualoid/Debug")

---@class NamedContainersUI: ISInventoryPage
local NamedContainersUI = {}

function NamedContainersUI.saveSize(self)
  -- save the data
  local namedContainersUIdata = NamedContainersUI.getModData()
  if self.onCharacter then
    namedContainersUIdata.sizeCharacter = self.iconsHeader:getWidth()
    return
  end
  namedContainersUIdata.sizeLoot = self.iconsHeader:getWidth()
end


function NamedContainersUI.getSavedSize(self)
  local modData = NamedContainersUI.getModData()
  if self.onCharacter then
    return modData.sizeCharacter
  end

  return modData.sizeLoot
end

function NamedContainersUI.getModData()
  ---@class NamedContainersUIModata
  ---@field sizeLoot number
  ---@field sizeCharacter number
  local modData = ModData.getOrCreate('NamedContainersUI')

  modData.sizeLoot = modData.sizeLoot or 100
  modData.sizeCharacter = modData.sizeCharacter or 100

  return modData
end

function NamedContainersUI:createChildren()
  Debug:print('NamedContainersUI:createChildren', 'self.onCharacter', self.onCharacter)
end

function NamedContainersUI:addContainerButton()
  ---@type ISButton
  local button = Hooks:GetReturn()
  button:setY(button:getY() + self.iconsHeader:getHeight() + 1)
  button:setWidth(self.iconsHeader:getWidth())
  button:setX(self.iconsHeader.x)
end

function NamedContainersUI.onResizeIconsColumn(self, button)
  self.inventoryPane:setWidth(self.iconsHeader.x - 1)

  ---@param button ISButton
  for _, button in ipairs(self.backpacks) do
    button:setWidth(self.iconsHeader:getWidth())
    button:setX(self.iconsHeader.x)
    button:setBorderRGBA(0.6, 0.6, 0.6, 0.5)
    if button.inventory ~= self.inventory then
      button:setBackgroundRGBA(0.1, 0.1, 0.1, 0.7)
    end
  end

  if button then
    NamedContainersUI.saveSize(self)
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
    x = self:getWidth() - self.iconsHeader:getWidth()
    w = self.iconsHeader:getWidth()
  end

  return old_drawRectBorder(self, x, y, w, h, ...)
end

local old_ISInventoryPage_refreshBackpacks = ISInventoryPage.refreshBackpacks
function ISInventoryPage:refreshBackpacks()
  if self.iconsHeader then
    self:removeChild(self.iconsHeader)
  end

  local size = NamedContainersUI.getSavedSize(self)
  local x = self.width - size
  local y = self:titleBarHeight()
  local fontHgtSmall = getTextManager():getFontHeight(UIFont.Small)
  self.iconsHeader = ISResizableButton:new(x, y, size, fontHgtSmall + 1, "~");
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

  old_ISInventoryPage_refreshBackpacks(self)
  NamedContainersUI.onResizeIconsColumn(self)
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

Hooks:PostHooksFromTable(ISInventoryPage, NamedContainersUI, 'NamedContainersUI')
