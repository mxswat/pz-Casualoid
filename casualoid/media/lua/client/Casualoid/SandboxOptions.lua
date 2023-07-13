local old_SandboxOptionsScreen_createPanel = SandboxOptionsScreen.createPanel
function SandboxOptionsScreen:createPanel(page)
  local result = old_SandboxOptionsScreen_createPanel(self, page)

  for name, control in pairs(self.controls) do
    if string.find(name, "MultiSelect") then
      CasualoidPrint(name)
      self:overrideTextBox(control, name)
    end
  end

  return result
end

function SandboxOptionsScreen:overrideTextBox(control, name)
  local button = ISButton:new(control:getX(), control:getY(), control:getWidth(), control:getHeight(), 'Edit Values', self,
    function()
      local value = CasualoidStringToTable(control:getText())
      local modal = MultiSelectModal:new(name, value);
      modal:initialise();
      modal:addToUIManager();
    end);

  control.parent:addChild(button)
end
