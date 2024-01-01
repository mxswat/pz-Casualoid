local MxDebug  = require("MxUtilities/MxDebug ")

local function broadcastContainerUpgrade(module, command, srcPlayer, args)
  if not isServer() or module ~= "Casualoid" then return end;

  if command ~= "broadcastContainerUpgrade" then
    return
  end

  MxDebug:print(srcPlayer:getUsername(), 'upgraded a container')

  local players = getOnlinePlayers();
  local x = args.x; -- Get X and Y of the square with the upgraded container.
  local y = args.y;

  for i = 0, players:size() - 1 do
    ---@type IsoPlayer
    local player = players:get(i);

    if srcPlayer:getOnlineID() ~= player:getOnlineID() then
      local x2, y2 = player:getX(), player:getY();
      local vDist = math.sqrt(((x - x2) ^ 2) + ((y - y2) ^ 2));

      MxDebug:print('vDist', vDist)

      if vDist < 4 then -- Find the closest players.
        MxDebug:print(player:getUsername(), 'is in range:', vDist, 'notified to update ISInventoryPage UI')
        sendServerCommand(player, "Casualoid", "refreshUIOnClient", {});
      end
    end
  end
end

Events.OnClientCommand.Add(broadcastContainerUpgrade)
