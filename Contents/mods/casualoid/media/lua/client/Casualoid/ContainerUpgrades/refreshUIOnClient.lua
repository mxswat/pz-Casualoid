local function refreshUIOnClient(module, command, args)
  if module ~= "Casualoid" then return end;

  if command ~= "refreshUIOnClient" then
    return
  end

  ISInventoryPage.dirtyUI()
end

Events.OnServerCommand.Add(refreshUIOnClient);