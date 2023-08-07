CasualoidRecipes = {}

function CasualoidRecipes:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()

  local recipes = player:getKnownRecipes();
  for i = 0, recipes:size() - 1 do
    casualoidRespawnData.knownRecipes[recipes:get(i)] = true
  end
end
