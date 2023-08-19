local respawnProf = nil
local function addRespawnTraits()
  TraitFactory.addTrait("RespawnLowerXP", "Lower Respawn XP", -10,
    'You will respawn with a percentage of your total XP, set in the sandbox settings', false);

  TraitFactory.addTrait("RespawnTrait", "Respawn", 0, 'You took Merasmus\'s "Kill Me Come Back Stronger Pills"', true);

  local traits = TraitFactory.getTraits();
  for i = 0, traits:size() - 1 do
    TraitFactory.setMutualExclusive("RespawnTrait", traits:get(i):getType());
  end

  respawnProf = ProfessionFactory.addProfession("Respawn", "Respawn and resume progress", "profession_respawn", 0);
  respawnProf:addFreeTrait("RespawnTrait");
end

Events.OnGameBoot.Add(addRespawnTraits);

local old_CharacterCreationProfession_setVisible = CharacterCreationProfession.setVisible;
function CharacterCreationProfession:setVisible(visible, joypadData)
  old_CharacterCreationProfession_setVisible(self, visible, joypadData);

  if not visible then
    return;
  end

  self:removeRespawnProfession();

  if not SandboxVars.Casualoid.EnableRespawn then
    Casualoid.print('Respawn Disabled')
    return
  end

  if Casualoid.isRespawnAvailable() then
    Casualoid.print('Respawn Enabled')
    self:addRespawnProfession();
  end
end

function CharacterCreationProfession:addRespawnProfession()
  self.listboxProf:insertItem(2, respawnProf:getName(), respawnProf);
end

function CharacterCreationProfession:removeRespawnProfession()
  self.listboxProf:removeItem(respawnProf:getName());
end