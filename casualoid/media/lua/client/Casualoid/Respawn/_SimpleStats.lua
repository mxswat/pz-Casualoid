CasualoidSimpleStats = {};

function CasualoidSimpleStats:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData();
  casualoidRespawnData.weight = player:getNutrition():getWeight()
  casualoidRespawnData.hoursSurvived = player:getHoursSurvived()
  casualoidRespawnData.zombieKills = player:getZombieKills()
end

function CasualoidSimpleStats:load(player)
  local casualoidRespawnData = Casualoid.getRespawnModData();
  player:getNutrition():setWeight(casualoidRespawnData.weight);
  player:setHoursSurvived(casualoidRespawnData.hoursSurvived);
  player:setZombieKills(casualoidRespawnData.zombieKills)
end