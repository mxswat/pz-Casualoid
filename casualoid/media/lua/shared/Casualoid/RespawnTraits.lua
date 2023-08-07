
local function AddRespawnTraits()
  TraitFactory.addTrait('Respawn', getText("UI_trait_Respawn"), -5, '', false, true);

  -- TODO: Use sandbox options to change the XP and cost
  TraitFactory.addTrait('RespawnWithPartialXP', getText("UI_trait_RespawnWithPartialXP"), -5, '', false, false);

  -- Your gear will still appear on your dead character
  TraitFactory.addTrait('RespawnWithoutGear', getText("UI_trait_RespawnWithoutGear"), -2, '', false, false);

  local prof = ProfessionFactory.addProfession('Respawn', 'Respawn', "", 0);
  prof:addFreeTrait('Respawn');
end

Events.OnGameBoot.Add(AddRespawnTraits)