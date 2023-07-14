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
  local OPTIONS = {
    ["Casualoid.MultiSelectDisablePositiveTraits"] = getTraits().positive,
    ["Casualoid.MultiSelectDisableNegativeTraits"] = getTraits().negative
  }

  return OPTIONS[name] or {}
end

local function overrideTextBox(self, control, name)
  local button = ISButton:new(control:getX(), control:getY(), control:getWidth(), control:getHeight(), 'Edit Values',
    self,
    function()
      local options = getOptions(tostring(name))
      local modal = MultiSelectModal:new(name, control, options);
      modal:initialise();
      modal:addToUIManager();
    end);

  control.parent:addChild(button)
end

local old_SandboxOptionsScreen_createPanel = SandboxOptionsScreen.createPanel
function SandboxOptionsScreen:createPanel(page)
  local result = old_SandboxOptionsScreen_createPanel(self, page)

  for name, control in pairs(self.controls) do
    if string.find(name, "MultiSelect") then
      overrideTextBox(self, control, name)
    end
  end

  return result
end

local old_ServerSettingsScreen_create = ServerSettingsScreen.create
function ServerSettingsScreen:create()
  old_ServerSettingsScreen_create(self)

  for name, control in pairs(self.pageEdit.controls.Sandbox) do
    if string.find(name, "MultiSelect") then
      overrideTextBox(self, control, name)
    end
  end
end

local old_CharacterCreationProfession_setVisible = CharacterCreationProfession.setVisible
function CharacterCreationProfession:setVisible(visible, joypadData)
	local result = old_CharacterCreationProfession_setVisible(self, visible, joypadData)

  if visible then
    self.listboxTrait:clear()
    self:populateTraitList(self.listboxTrait);
    self.listboxBadTrait:clear()
    self:populateBadTraitList(self.listboxBadTrait);

    CharacterCreationMain.sort(self.listboxTrait.items);
    CharacterCreationMain.invertSort(self.listboxBadTrait.items);
  end

	return result
end
