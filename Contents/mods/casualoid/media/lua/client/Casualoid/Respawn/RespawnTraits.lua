local Debug = require "Casualoid/Debug"
local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"

function CharacterCreationProfession:createRespawnTraits()
  local respawnTrait = TraitFactory.addTrait("RespawnTrait", "Respawn", 0, 'You took Merasmus\'s "Kill Me Come Back Stronger Pills"', true);

  local traits = TraitFactory.getTraits();
  for i = 0, traits:size() - 1 do
    TraitFactory.setMutualExclusive("RespawnTrait", traits:get(i):getType());
  end

  return respawnTrait
end

function CharacterCreationProfession:createRespawnProfession()
  -- Create me before anything else
  self.respawnLowerXPTrait = TraitFactory.addTrait("RespawnLowerXP", "Lower Respawn XP", -10,    'You will respawn with a percentage of your total XP, set in the sandbox settings', false);

  self.respawnProf = ProfessionFactory.addProfession("Respawn", "Respawn and resume progress", "profession_respawn", 0);

  self.respawnTrait = self:createRespawnTraits()

  self.respawnProf:addFreeTrait("RespawnTrait");
end

local old_CharacterCreationProfession_create = CharacterCreationProfession.create
function CharacterCreationProfession:create()
  old_CharacterCreationProfession_create(self)
  self:createRespawnProfession()
end

local old_CharacterCreationProfession_setVisible = CharacterCreationProfession.setVisible;
function CharacterCreationProfession:setVisible(visible, joypadData)
  old_CharacterCreationProfession_setVisible(self, visible, joypadData);

  if not visible then
    return;
  end

  self:removeRespawnProfession();

  if not SandboxVars.Casualoid.EnableRespawn then
    return Debug:print('Respawn Disabled')
  end

  if RespawnUtils.isRespawnAvailable() then
    Debug:print('Respawn Enabled')
    self:addRespawnProfession();
  end
end

function CharacterCreationProfession:addRespawnProfession()
  self.listboxProf:insertItem(0, self.respawnProf:getName(), self.respawnProf);
  self:onSelectProf(self.respawnProf);
end

function CharacterCreationProfession:removeRespawnProfession()
  self.listboxProf:removeItem(self.respawnProf:getName());

  self.listboxProf.selected = 1;
  self:onSelectProf(self.listboxProf.items[1].item);
end

-- Anti-Crash fix below

-- I'm overriding the function entirelly, I don't think there is a better way
function CharacterCreationProfession:resetBuild()
  local index = self:getUnemployedProfessionIndex();

  self.listboxProf.selected = index;
  self:onSelectProf(self.listboxProf.items[self.listboxProf.selected].item);

  while #self.listboxTraitSelected.items > 0 do
    self.listboxTraitSelected.selected = 1;
    self:onOptionMouseDown(self.removeTraitBtn);
  end
end

-- I'm overriding the function entirelly, I don't think there is a better way
function CharacterCreationProfession:resetTraits()
  local index = self:getUnemployedProfessionIndex();

  self:onSelectProf(self.listboxProf.items[index].item);

  while #self.listboxTraitSelected.items > 0 do
    self.listboxTraitSelected.selected = 1;
    self:onOptionMouseDown(self.removeTraitBtn);
  end

  self:onSelectProf(self.listboxProf.items[self.listboxProf.selected].item);
end

function CharacterCreationProfession:getUnemployedProfessionIndex()
  local index = 1;

  while self.listboxProf.items[index].item:getType() ~= "unemployed" do
    index = index + 1;
  end

  return index;
end
