function Casualoid.getRespawnModData()
  local respawnData = ModData.getOrCreate("CasualoidRespawnData");

  respawnData.perks = respawnData.perks or {}
  respawnData.knownMediaLines = respawnData.knownMediaLines or {}
  respawnData.knownRecipes = respawnData.knownRecipes or {}
  respawnData.readBooks = respawnData.readBooks or {}
  respawnData.weight = respawnData.weight or 80
  respawnData.occupation = respawnData.occupation or nil
  respawnData.traits = respawnData.traits or {}

  return respawnData
end
