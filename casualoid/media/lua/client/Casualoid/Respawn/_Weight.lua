CasualoidWeight = {};

function CasualoidWeight:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData();
  casualoidRespawnData.weight = player:getNutrition():getWeight()
end

function CasualoidWeight:load(player)
  
end