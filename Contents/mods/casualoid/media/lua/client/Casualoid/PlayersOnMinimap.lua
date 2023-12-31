local Hooks = require "MxUtilities/Hooks"

--- @class PlayersOnMinimap: ISMiniMap, HookedTable
local PlayersOnMinimap = Hooks:CreateHookedTable(ISMiniMap)

function PlayersOnMinimap:InitPlayer()
  if not SandboxVars.Casualoid.ShowPlayersOnMinimap then return end

  local MINIMAP = Hooks:GetReturn()

  local INNER = MINIMAP.inner
  INNER.mapAPI:setBoolean("RemotePlayers", true)
  INNER.mapAPI:setBoolean("PlayerNames", true)
end

PlayersOnMinimap:AttachHooks()