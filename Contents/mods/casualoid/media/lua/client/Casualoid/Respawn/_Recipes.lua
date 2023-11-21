local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"

CasualoidRecipes = {}

function CasualoidRecipes:save(player)
  local casualoidRespawnData = RespawnUtils.getRespawnModData()

  local recipes = player:getKnownRecipes();
  for i = 0, recipes:size() - 1 do
    casualoidRespawnData.knownRecipes[recipes:get(i)] = true
  end
end

function CasualoidRecipes:load(player)
  local casualoidRespawnData = RespawnUtils.getRespawnModData()
  local recipes = player:getKnownRecipes();

  for recipe, _ in pairs(casualoidRespawnData.knownRecipes) do
    recipes:add(recipe);
  end
end
