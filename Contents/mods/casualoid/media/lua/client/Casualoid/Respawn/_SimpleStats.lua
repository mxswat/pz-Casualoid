local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"
local Debug = require "Casualoid/Debug"

CasualoidSimpleStats = {};

function CasualoidSimpleStats:save(player)
  local casualoidRespawnData = RespawnUtils.getRespawnModData();
  casualoidRespawnData.weight = player:getNutrition():getWeight()
  casualoidRespawnData.hoursSurvived = player:getHoursSurvived()
  casualoidRespawnData.zombieKills = player:getZombieKills()
end

function CasualoidSimpleStats:load(player)
  local casualoidRespawnData = RespawnUtils.getRespawnModData();
  Debug:print('CasualoidSimpleStats:load')
  player:getNutrition():setWeight(casualoidRespawnData.weight);
  player:setHoursSurvived(casualoidRespawnData.hoursSurvived);
  player:setZombieKills(casualoidRespawnData.zombieKills)
end