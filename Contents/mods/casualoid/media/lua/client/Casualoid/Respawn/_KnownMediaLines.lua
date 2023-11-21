local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"
local Debug = require "Casualoid/Debug"

local injected_instance = nil
local old_ISRadioInteractions_getInstance = ISRadioInteractions.getInstance
function ISRadioInteractions:getInstance()
  if injected_instance then
    return injected_instance
  end

  local instance = old_ISRadioInteractions_getInstance(self)

  local old_self_checkPlayer = instance.checkPlayer
  local function new_checkPlayer(player, _guid, ...)
    local result = old_self_checkPlayer(player, _guid, ...)

    if _guid ~= nil and _guid ~= "" then
      Debug:print('ISRadioInteractions: _guid', _guid)

      local casualoidRespawnData = RespawnUtils.getRespawnModData()
      casualoidRespawnData.knownMediaLines[_guid] = true
    end

    return result
  end

  instance.checkPlayer = new_checkPlayer

  injected_instance = instance

  return instance
end

CasualoidKnownMediaLines = {}

function CasualoidKnownMediaLines:save(player)
  -- The saving is made by the ISRadioInteractions:getInstance() injection
end

function CasualoidKnownMediaLines:load(player)
  local knownMediaLines = RespawnUtils.getRespawnModData().knownMediaLines
  for guid, _ in pairs(knownMediaLines) do
    player:addKnownMediaLine(guid)
  end
end
