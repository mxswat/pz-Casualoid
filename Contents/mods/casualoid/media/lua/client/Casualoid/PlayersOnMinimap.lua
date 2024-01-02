local Hooks = require "MxUtilities/Hooks"

--- @class PlayersOnMinimap: ISMiniMap, HookedTable
local PlayersOnMinimap = Hooks:CreateHookedTable(ISMiniMap)

function PlayersOnMinimap:InitPlayer()
  -- Sadly, it's the only way to do this, cause this is called before the `OnGameStart` is fired :( 
  if not SandboxVars.Casualoid.ShowPlayersOnMinimap then return end

  local MINIMAP = Hooks:GetReturn()

  local INNER = MINIMAP.inner
  INNER.mapAPI:setBoolean("RemotePlayers", true)
  INNER.mapAPI:setBoolean("PlayerNames", true)
end

PlayersOnMinimap:AttachHooks()