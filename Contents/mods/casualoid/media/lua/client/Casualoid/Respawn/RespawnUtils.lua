local CasualoidSettings = require "Casualoid/CasualoidSettings"
local Utils = require "MxUtilities/Utils"

local RespawnUtils = {}

function RespawnUtils.isRespawnAvailable()
  local respawnData = CasualoidSettings:get().respawnData;

  return respawnData and respawnData[Utils:getUserID()];
end

function RespawnUtils.hasRespawnModData()
  local respawnData = ModData.getOrCreate("CasualoidRespawnData");

  return respawnData.hoursSurvived ~= nil
end

function RespawnUtils.getRespawnModData()
  local respawnData = ModData.getOrCreate("CasualoidRespawnData");

  respawnData.perks = respawnData.perks or {}
  respawnData.knownMediaLines = respawnData.knownMediaLines or {}
  respawnData.knownRecipes = respawnData.knownRecipes or {}
  respawnData.weight = respawnData.weight or 80
  respawnData.occupation = respawnData.occupation or nil
  respawnData.traits = respawnData.traits or {}
  respawnData.hoursSurvived = respawnData.hoursSurvived or nil
  respawnData.zombieKills = respawnData.zombieKills or nil

  return respawnData
end

return RespawnUtils