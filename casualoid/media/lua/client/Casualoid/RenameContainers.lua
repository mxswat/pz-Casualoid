local function onDialogButtonClick(target, button, inventory)
  CasualoidPrint('renameContainer')
  if button.internal ~= "OK" then return end
  if not button.parent.entry:getText() or button.parent.entry:getText() == "" then
    return
  end

  inventory:getParent():getModData().ContainerCustomName = button.parent.entry:getText()
  inventory:getParent():transmitModData()
end

local function openRenameDialog(player, title, inventory)
  CasualoidPrint('openRenameDialog')
  local modalTitle = getText("ContextMenu_RenameBag") .. ': ' .. title
  local modal = ISTextBox:new(0, 0, 280, 180, modalTitle, title, nil, onDialogButtonClick, player, inventory)
  modal:initialise()
  modal:addToUIManager()
  modal.entry:focus()
end

local function getInventoryTitle(inventory)
  return (inventory:getParent() and inventory:getParent():getModData().ContainerCustomName)
      or getTextOrNull("IGUI_ContainerTitle_" .. inventory:getType())
end

local old_ISInventoryPage_onBackpackRightMouseDown = ISInventoryPage.onBackpackRightMouseDown
function ISInventoryPage:onBackpackRightMouseDown(x, y)
  local result = old_ISInventoryPage_onBackpackRightMouseDown(self, x, y)

  if not self.title or self.onCharacter or self.inventory:getType() == "floor" or not self.inventory:getParent() then
    return
  end

  local context = ISContextMenu.get(self.parent.player, getMouseX(), getMouseY())

  local title =
      self.inventory:getParent():getModData().ContainerCustomName
      or getTextOrNull("IGUI_ContainerTitle_" .. self.inventory:getType())
      or ""

  local renameOption = context:addOption(getText("ContextMenu_RenameBag"), self.inventory, function()
    openRenameDialog(self.player, title, self.inventory)
  end);

  renameOption.iconTexture = getTexture("media/ui/RenameIcon.png");

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

local old_ISInventoryPage_onInventoryContainerSizeChanged = ISInventoryPage.onInventoryContainerSizeChanged
function ISInventoryPage:onInventoryContainerSizeChanged()
  old_ISInventoryPage_onInventoryContainerSizeChanged(self)
  self.buttonSizeBackup = self.buttonSize
end

local old_ISInventoryPage_prerender = ISInventoryPage.prerender
function ISInventoryPage:prerender()
  self.buttonSizeBackup = self.buttonSizeBackup or self.buttonSize
  self.buttonSize = math.max(self.casualoidButtonWidth or 0, self.buttonSize)

  local result = old_ISInventoryPage_prerender(self)

  return result
end

local old_ISInventoryPage_refreshBackpacks = ISInventoryPage.refreshBackpacks
function ISInventoryPage:refreshBackpacks()
  self.casualoidButtonWidth = 0

  local result = old_ISInventoryPage_refreshBackpacks(self)

  self.inventoryPane:setWidth(self.width - self.casualoidButtonWidth)

  for _, button in ipairs(self.backpacks) do
    button:setX(self.width - self.casualoidButtonWidth)
    button:setWidth(self.casualoidButtonWidth)
    -- button:forceImageSize(math.min(self.buttonSize - 2, 32), math.min(self.buttonSize - 2, 32))
  end

  return result
end

local old_ISInventoryPage_addContainerButton = ISInventoryPage.addContainerButton
function ISInventoryPage:addContainerButton(container, texture, name, tooltip)
  self.buttonSize = self.buttonSizeBackup or self.buttonSize

  local button = old_ISInventoryPage_addContainerButton(self, container, texture, name, tooltip)

  CasualoidPrint('getInventoryTitle(container):', getInventoryTitle(container))
  button:setTitle(getInventoryTitle(container) or name)
  button:setWidthToTitle()
  button:forceImageSize()

  self.casualoidButtonWidth = math.max(self.casualoidButtonWidth, button:getWidth())
  -- button.tooltip = button.tooltip or name

  return button
end
