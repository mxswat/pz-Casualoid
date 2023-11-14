require "ISUI/ISInventoryPage"

local Hooks = require "MxUtilities/Hooks"
local Debug = require("Casualoid/Debug")

---@class NamedContainersUI: ISInventoryPage
local NamedContainersUI = {}

function NamedContainersUI:createChildren()
  Debug:print('NamedContainersUI:createChildren', 'self.onCharacter', self.onCharacter)
  self.inventoryPane:setWidth(self.width - 100 - 5)
end

function NamedContainersUI:addContainerButton(container, texture, name, tooltip)
  ---@type ISButton
  local button = Hooks:GetReturn()
  button:setY(button:getY() + self.buttonSize)
end

function NamedContainersUI:onResizeIconsColumn()
  self.inventoryPane:setWidth(self.iconsHeader.x - 1)
end

function NamedContainersUI:refreshBackpacks()
  if self.iconsHeader then
    self:removeChild(self.iconsHeader)
  end

  local x = self.width - self.buttonSize
  local y = self:titleBarHeight()
  local fontHgtSmall = getTextManager():getFontHeight(UIFont.Small)
  self.iconsHeader = ISResizableButton:new(x, y, self.buttonSize, fontHgtSmall + 1, "~", self, function() end);
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