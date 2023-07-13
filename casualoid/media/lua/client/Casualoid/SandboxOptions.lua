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

local function getTraits()
  local traitIds = {
    positive = {},
    negative = {},
  }
  for i = 0, TraitFactory.getTraits():size() - 1 do
    local trait = TraitFactory.getTraits():get(i);
    if trait:getCost() >= 0 then
      table.insert(traitIds.positive, trait)
    else
      table.insert(traitIds.negative, trait)
    end
  end
  return traitIds
end

local function getOptions(name)
  if name == 'Casualoid.MultiSelectDisablePositiveTraits' then
    local traitIds = getTraits()
    return traitIds.positive
  end

  if name == 'Casualoid.MultiSelectDisableNegativeTraits' then
    local traitIds = getTraits()
    return traitIds.negative
  end

  return {}
end

function SandboxOptionsScreen:overrideTextBox(control, name)
  local button = ISButton:new(control:getX(), control:getY(), control:getWidth(), control:getHeight(), 'Edit Values',
    self,
    function()
      local selectedValuesString = control:getText()
      local options = getOptions(tostring(name))
      local modal = MultiSelectModal:new(name, selectedValuesString, options);
      modal:initialise();
      modal:addToUIManager();
    end);

  control.parent:addChild(button)
end
