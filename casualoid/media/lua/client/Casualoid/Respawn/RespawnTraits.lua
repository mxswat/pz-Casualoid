local function addRespawnTraits()
  TraitFactory.addTrait("RespawnTrait", "RespawnTrait", 0, "Reject zombiehood", true, false);

  local traits = TraitFactory.getTraits();
  for i = 0, traits:size() - 1 do
    TraitFactory.setMutualExclusive("RespawnTrait", traits:get(i):getType());
  end

  local prof = ProfessionFactory.addProfession("RespawnProfession", "RespawnProfession", "", 0);

  prof:addFreeTrait("RespawnTrait");

  return prof;
end

Events.OnGameBoot.Add(addRespawnTraits);

local function moveElementToIndex(tbl, elementName, newIndex)
  local currentIndex
  for i, value in ipairs(tbl) do
    if value.item:getName() == elementName then
      currentIndex = i
      break
    end
  end

  if currentIndex then
    local element = table.remove(tbl, currentIndex)
    table.insert(tbl, newIndex, element)
    return true
  else
    return false
  end
end

local old_CharacterCreationProfession_setVisible = CharacterCreationProfession.setVisible;
function CharacterCreationProfession:setVisible(visible, joypadData)
  old_CharacterCreationProfession_setVisible(self, visible, joypadData);

  Casualoid.print('CharacterCreationProfession:setVisible')

  if not visible then
    return;
  end

  -- Has to be the second one, otherwise the game shit itself when you try to reset the build
  moveElementToIndex(self.listboxProf.items, "RespawnProfession", 2)
end
