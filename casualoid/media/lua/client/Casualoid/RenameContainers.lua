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
  local modal = ISTextBox:new(0, 0, 280, 180, getText("ContextMenu_RenameBag")..': '..title, title, nil, onDialogButtonClick, player,
    inventory)
  modal:initialise()
  modal:addToUIManager()
  modal.entry:focus()
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
