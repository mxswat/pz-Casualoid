local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"
CasualoidOccupation = {};

function CasualoidOccupation:save(player)
  local casualoidRespawnData = RespawnUtils.getRespawnModData();
  casualoidRespawnData.occupation = player:getDescriptor():getProfession();
end

function CasualoidOccupation:load(player)
  player:getDescriptor():setProfession(RespawnUtils.getRespawnModData().occupation);
end