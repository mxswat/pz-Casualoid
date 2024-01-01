local MxDebug = require "MxUtilities/MxDebug"
local RespawnCharacterCreationProfession = require "Casualoid/Respawn/RespawnCharacterCreationProfession"

local function onGameBoot()
  MxDebug:print('Initalizing Casualoid onGameBoot Hooks')

  if SandboxVars.Casualoid.EnableRespawn then
    RespawnCharacterCreationProfession:init()
  end
end

Events.OnGameBoot.Add(onGameBoot);
