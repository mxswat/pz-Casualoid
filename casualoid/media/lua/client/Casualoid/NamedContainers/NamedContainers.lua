local function getInventoryName(inventory)
  return (inventory:getParent() and inventory:getParent():getModData().ContainerCustomName)
      or getTextOrNull("IGUI_ContainerTitle_" .. inventory:getType())
end

function ISInventoryPage.getSafeButtonHeight()
  local sizes = { 32, 40, 48 }
  return sizes[getCore():getOptionInventoryContainerSize()] + 1
end

function ISInventoryPage.getSafeButtonSize()
  local settings = Casualoid.Settings.loadSettings()
  return settings.buttonsSize or 100
end

function ISInventoryPage:getTextMaxChars()
  if self.lastButtonSize == self.buttonSize then
    return self.textMaxChar
  end

  local text = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  local textWidth = getTextManager():MeasureStringX(self.font, text)
  while textWidth > self.buttonSize do
    text = text:sub(1, -2)
    textWidth = getTextManager():MeasureStringX(self.font, text)
  end

  self.textMaxChar = string.len(text)
  self.lastButtonSize = self.buttonSize
  return self.textMaxChar
end

local old_ISInventoryPage_new = ISInventoryPage.new
function ISInventoryPage:new(...)
  local o = old_ISInventoryPage_new(self, ...)
  o.buttonSize = ISInventoryPage.getSafeButtonSize()

  o.safeButtonHeight = ISInventoryPage.getSafeButtonHeight()
  return o
end

local old_ISInventoryPage_onBackpackRightMouseDown = ISInventoryPage.onBackpackRightMouseDown
function ISInventoryPage:onBackpackRightMouseDown(x, y)
  local result = old_ISInventoryPage_onBackpackRightMouseDown(self, x, y)
  
  if not self.title or self.onCharacter or self.inventory:getType() == "floor" or not self.inventory:getParent() then
    return
  end

  local context = getPlayerContextMenu(self.parent.player);

  local title =
      self.inventory:getParent():getModData().ContainerCustomName
      or getTextOrNull("IGUI_ContainerTitle_" .. self.inventory:getType())
      or ""

  local renameOption = context:addOption(getText("ContextMenu_RenameBag"), self.inventory, function()
    OpenRenameDialog(self.player, title, self.inventory)
  end);
  renameOption.iconTexture = getTexture("media/ui/RenameIcon.png");

  local setWidthOption = context:addOption(getText("IGUI_SetButtonsWidth"), self.inventory, function()
    OpenSetWidthDialog(self.player)
  end);

  return result
end

local old_ISInventoryPage_prerender = ISInventoryPage.prerender
function ISInventoryPage:prerender()
  local modData = self.inventory:getParent() and self.inventory:getParent():getModData() or {}
  if modData.ContainerCustomName and modData.ContainerCustomName ~= "" then
    self.title = modData.ContainerCustomName
  end

  return old_ISInventoryPage_prerender(self)
end

-- I'm overriding the function entirelly, I don't think there is a better way
function ISInventoryPage:onInventoryContainerSizeChanged()
  self.buttonSize = self:getSafeButtonSize()
  self.minimumWidth = 256 + self.buttonSize
  self.inventoryPane:setWidth(self.width - self.buttonSize)
  self.inventoryPane.typeHeader:resize(self.inventoryPane.typeHeader.width)
  self.inventoryPane:updateScrollbars()
  self.safeButtonHeight = ISInventoryPage.getSafeButtonHeight()

  for _,button in ipairs(self.buttonPool) do
		button:setWidth(self.buttonSize)
		button:setHeight(self.safeButtonHeight)
		button:forceImageSize(math.min(self.buttonSize - 2, 32), math.min(self.buttonSize - 2, 32))
	end
	local y = self:titleBarHeight() - 1
	for _,button in ipairs(self.backpacks) do
		button:setWidth(self.buttonSize)
		button:setX(self.width - self.buttonSize)
		button:setY(y)
		y = y + self.safeButtonHeight
		button:setHeight(self.safeButtonHeight)
		button:forceImageSize(math.min(self.buttonSize - 2, 32), math.min(self.buttonSize - 2, 32))
	end
end

local old_ISInventoryPage_refreshBackpacks = ISInventoryPage.refreshBackpacks
function ISInventoryPage:refreshBackpacks()
  local result = old_ISInventoryPage_refreshBackpacks(self)

  if self.selectedButton then
    -- Setting it here because "ISInventoryPage:refreshBackpacks()" sets it before
    self.selectedButton:setBackgroundRGBA(0.3, 0.3, 0.3, 1.0)
  end

  return result
end

local old_ISInventoryPage_addContainerButton = ISInventoryPage.addContainerButton
function ISInventoryPage:addContainerButton(container, texture, name, tooltip)
  local player = getSpecificPlayer(self.player)
  if player and player:getInventory() == container then
    name = getText("IGUI_Controller_Inventory")
  end

  local button = old_ISInventoryPage_addContainerButton(self, container, texture, name, tooltip)

  local oldName = getInventoryName(container) or name
  -- TODO: add mod option for max clamping
  local newName = Casualoid.clapAndEllipsis(getInventoryName(container) or name, self:getTextMaxChars())
  button:setTitle(newName)
  button.tooltip = button.tooltip or (#newName < #oldName and oldName or nil)

  button:setBorderRGBA(0.6, 0.6, 0.6, 0.5)
  -- local isTileSquare = container:getSourceGrid() and container:getType() ~= "floor"
  -- -- Force tile sprite to render as the icon
  -- if isTileSquare then
  --   button:setImage(getTexture(container:getParent():getSprite():getName()))
  --   button:forceImageSize(64, 64)
  -- else
  --   -- Set original size
  --   button:forceImageSize(math.min(self.buttonSize - 2, 32), math.min(self.buttonSize - 2, 32))
  -- end

  -- Setting the BG does nothing here, because it's overridden inside "ISInventoryPage:refreshBackpacks()"
  button:setBackgroundColorMouseOverRGBA(0.2, 0.2, 0.2, 1.0)

  local titleBarHeight = self:titleBarHeight()
  local y = ((#self.backpacks - 1) * self.safeButtonHeight) + titleBarHeight - 1
  button:setY(y)

  -- Add extra width to compensate for the icon and text aligned on the left
  button:setWidth(self.buttonSize)

  -- Use safe height
  button:setHeight(self.safeButtonHeight)

  -- Forces text on the left
  button.drawText = function(self, str, x, ...)
    ISButton.drawText(self, str, 4 + 32, ...)
  end
  -- Forces icon on the left
  button.drawTextureScaledAspect = function(self, texture, x, ...)
    ISButton.drawTextureScaledAspect(self, texture, 2, ...)
  end

  return button
end
