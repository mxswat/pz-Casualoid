local function onDialogButtonClick(target, button)
  if button.internal ~= "OK" then return end
  local value = tonumber(button.parent.entry:getText() or 0)
  local settings = Casualoid.Settings.loadSettings()

  settings.buttonsSize = math.max(math.min(value, 500), 32)

  Casualoid.Settings.saveSettings(settings)
  ISInventoryPage.ContainerSizeChanged()
end

function OpenSetWidthDialog(player)
  local modalTitle = getText("IGUI_SetButtonsWidth").."Min=32 Max=500 Vanilla=0"
  local buttonSize = ISInventoryPage.getSafeButtonSize()
  local modal = ISTextBox:new(0, 0, 280, 180, modalTitle, tostring(buttonSize), nil, onDialogButtonClick, player, {})
  modal:initialise()
  modal:setOnlyNumbers(true)
  modal:addToUIManager()
  modal.entry:focus()
end
