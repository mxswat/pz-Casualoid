local function onDialogButtonClick(target, button, inventory)
  Casualoid.print('renameContainer')
  if button.internal ~= "OK" then return end
  if not button.parent.entry:getText() or button.parent.entry:getText() == "" then
    return
  end

  inventory:getParent():getModData().ContainerCustomName = button.parent.entry:getText()
  inventory:getParent():transmitModData()

  -- Force re-render
  ISInventoryPage.renderDirty = true
end

function OpenRenameDialog(player, title, inventory)
  Casualoid.print('openRenameDialog')
  local modalTitle = getText("ContextMenu_RenameBag") .. ': ' .. title
  local modal = ISTextBox:new(0, 0, 280, 180, modalTitle, title, nil, onDialogButtonClick, player, inventory)
  modal:initialise()
  modal:addToUIManager()
  modal.entry:focus()
end
