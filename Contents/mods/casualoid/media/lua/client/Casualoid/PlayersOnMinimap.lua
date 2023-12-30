local old_ISMiniMap_InitPlayer = ISMiniMap.InitPlayer
function ISMiniMap.InitPlayer(playerNum)
  local MINIMAP = old_ISMiniMap_InitPlayer(playerNum)

  local INNER = MINIMAP.inner
  INNER.mapAPI:setBoolean("RemotePlayers", true)
  INNER.mapAPI:setBoolean("PlayerNames", true)

  return MINIMAP
end
