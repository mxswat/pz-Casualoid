local NamedContainersSettings = require "Casualoid/NamedContainers/NamedContainersSettings"
local SetWidthDialog = {}

---@param inventoryPage ISInventoryPage
function SetWidthDialog.open(inventoryPage)
  local sizes = { 32, 40, 48 }
  local vanillaButtonSize = sizes[getCore():getOptionInventoryContainerSize()]
  local minWidth = vanillaButtonSize
  local modalTitle = getText("IGUI_SetButtonsWidth") .. " | Min:"..(tostring(minWidth)).." Max:400"
  local size = NamedContainersSettings.getSavedSize(inventoryPage)

  -- self.speedScale = ISSliderPanel:new(self.width / 2 - 400 / 2, self.bottomPanel.y - 30, 400, 20, self, self.onSpeedScaleChanged)
	-- self.speedScale.anchorTop = false
	-- self.speedScale.anchorBottom = true
	-- self.speedScale:setValues(0.0, 5.0, 0.1, 1.0)
	-- self.speedScale:setCurrentValue(1.0, true)
	-- self:addChild(self.speedScale)

  local modal = ISTextBox:new(0, 0, 280, 180, modalTitle, tostring(size), nil, nil, nil, nil)
  modal:initialise()
  modal:setOnlyNumbers(true)
  modal:addToUIManager()
  modal.entry.onTextChange = function(entry)
    local value = tonumber(entry:getInternalText()) or 0

    local newSize = math.max(math.min(value, 400), minWidth)
    NamedContainersSettings.saveSize(inventoryPage, newSize)

    inventoryPage:refreshBackpacks()
  end
  modal.entry:focus()
end

return SetWidthDialog
