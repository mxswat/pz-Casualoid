CasualoidTraits = {};

function CasualoidTraits:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()
  -- Reset the table, in case the player has lost or gained traits
  casualoidRespawnData.traits = {}

  local traits = player:getTraits();
  for i = 0, traits:size() - 1 do
    casualoidRespawnData.traits[traits:get(i)] = true
  end
end

function CasualoidTraits:load(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()

  -- Hard reset existing traits
  player:getTraits():clear();

  for trait, _ in pairs(casualoidRespawnData.traits) do
    player:getTraits():add(trait);
  end
end
