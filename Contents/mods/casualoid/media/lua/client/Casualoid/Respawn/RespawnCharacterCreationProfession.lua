local Debug = require "Casualoid/Debug"
local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"
local Hooks = require "MxUtilities/Hooks"
local MxClientEvents = require "MxUtilities/MxClientEvents"

---@class RespawnCharacterCreationProfession: CharacterCreationProfession
local RespawnCharacterCreationProfession = {}

function RespawnCharacterCreationProfession:getRespawnTrait()
  local respawnTrait = TraitFactory.addTrait("RespawnTrait", getText("UI_trait_RespawnTrait"), 0,
    getText("UI_trait_RespawnTrait_desc"), true);

  local traits = TraitFactory.getTraits();
  for i = 0, traits:size() - 1 do
    TraitFactory.setMutualExclusive("RespawnTrait", traits:get(i):getType());
  end

  return respawnTrait
end

function RespawnCharacterCreationProfession:create()
  self.respawnPenaltyTrait = TraitFactory.addTrait("RespawnPenalty", getText("UI_trait_RespawnPenalty"), -10,
    getText("UI_trait_RespawnPenalty_desc"), false);

  self.respawnProfession = ProfessionFactory.addProfession("RespawnProfession", getText("UI_prof_RespawnProfession"),
    "profession_respawn", 0);

  self.respawnTrait = RespawnCharacterCreationProfession:getRespawnTrait()

  self.respawnProfession:addFreeTrait("RespawnTrait");
end

function RespawnCharacterCreationProfession.removeRespawnProfession(self)
  self.listboxProf:removeItem(self.respawnProfession:getName());

  self.listboxProf.selected = 1;
  self:onSelectProf(self.listboxProf.items[1].item);
end

function RespawnCharacterCreationProfession.addRespawnProfession(self)
  self.listboxProf:insertItem(0, self.respawnProfession:getName(), self.respawnProfession);
  self:onSelectProf(self.respawnProfession);
end

function RespawnCharacterCreationProfession:setVisible(visible)
  if not visible then return end

  RespawnCharacterCreationProfession.removeRespawnProfession(self)

  if not SandboxVars.Casualoid.EnableRespawn then
    return Debug:print('Respawn Disabled')
  end

  if RespawnUtils.isRespawnAvailable() then
    Debug:print('Respawn Enabled')
    RespawnCharacterCreationProfession.addRespawnProfession(self);
  end
end

function RespawnCharacterCreationProfession:init()
  Hooks:PostHooksFromTable(CharacterCreationProfession, RespawnCharacterCreationProfession,
    'RespawnCharacterCreationProfession')
end

-- -- Anti-Crash fix below

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

return RespawnCharacterCreationProfession
