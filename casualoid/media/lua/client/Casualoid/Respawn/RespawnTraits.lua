local professionCached = nil
local function addRespawnTraits()
  TraitFactory.addTrait("trait_respawnlowxp", "Respawn with X% XP", -8, 'You will respawn with X% of your total XP', true, false);

  TraitFactory.addTrait("RespawnTrait", "Respawn", 0, 'I took Merasmus\'s "Kill Me Come Back Stronger Pills"', true, false);

  local traits = TraitFactory.getTraits();
  for i = 0, traits:size() - 1 do
    TraitFactory.setMutualExclusive("RespawnTrait", traits:get(i):getType());
  end

  professionCached = ProfessionFactory.addProfession("Respawn", "Respawn and keep progress", "profession_respawn", 0);

  professionCached:addFreeTrait("RespawnTrait");
end

Events.OnGameBoot.Add(addRespawnTraits);

local old_CharacterCreationProfession_setVisible = CharacterCreationProfession.setVisible;
function CharacterCreationProfession:setVisible(visible, joypadData)
  old_CharacterCreationProfession_setVisible(self, visible, joypadData);

  if not visible then
    return;
  end

  self:removeRespawnProfession();

  if Casualoid.isRespawnAvailable() then
    Casualoid.print('Respawn Enabled')
    self:addRespawnProfession();
  end
end

function CharacterCreationProfession:addRespawnProfession()
  self.listboxProf:insertItem(2, professionCached:getName(), professionCached);
end

function CharacterCreationProfession:removeRespawnProfession()
  self.listboxProf:removeItem(professionCached:getName());
end
