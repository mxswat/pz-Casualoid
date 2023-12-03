local Debug = require "Casualoid/Debug"
local RespawnCharacterCreationProfession = require "Casualoid/Respawn/RespawnCharacterCreationProfession"

local function onGameBoot()
  Debug:print('Initalizing Casualoid onGameBoot Hooks')

  if SandboxVars.Casualoid.EnableRespawn then
    RespawnCharacterCreationProfession:init()
  end
end

Events.OnGameBoot.Add(onGameBoot);
