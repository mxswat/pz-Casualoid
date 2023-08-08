CasualoidOccupation = {};

function CasualoidOccupation:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData();
  casualoidRespawnData.occupation = player:getDescriptor():getProfession();
end

function CasualoidOccupation:load(player)
  player:getDescriptor():setProfession(Casualoid.getRespawnModData().occupation);
end