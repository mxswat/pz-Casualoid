function Casualoid.getRespawnModData()
  local respawnData = ModData.getOrCreate("CasualoidRespawnData");

  respawnData.perks = respawnData.perks or {}
  respawnData.knownMediaLines = respawnData.knownMediaLines or {}
  respawnData.knownRecipes = respawnData.knownRecipes or {}
  respawnData.readBooks = respawnData.readBooks or {}
  respawnData.weight = respawnData.weight or nil

  return respawnData
end
