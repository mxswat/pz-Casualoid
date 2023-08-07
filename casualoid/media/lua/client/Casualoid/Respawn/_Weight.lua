CasualoidWeight = {};

function CasualoidWeight:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData();
  casualoidRespawnData.weight = player:getNutrition():getWeight()
end

function CasualoidWeight:load(player)
  local casualoidRespawnData = Casualoid.getRespawnModData();
  player:getNutrition():setWeight(casualoidRespawnData.weight);
end