CasualoidTraits = {};

function CasualoidTraits:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()

  local traits = player:getTraits();
  for i = 0, traits:size() - 1 do
    casualoidRespawnData.traits[traits:get(i)] = true
  end
end

function CasualoidTraits:load(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()

  player:getTraits():clear();

  for trait, _ in pairs(casualoidRespawnData.traits) do
    player:getTraits():add(trait);
  end
end
