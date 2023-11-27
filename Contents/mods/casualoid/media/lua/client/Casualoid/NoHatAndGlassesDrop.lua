local NoHatAndGlassesDrop = {}

---@param player IsoPlayer
function NoHatAndGlassesDrop.applyNoDrop(player)
  local wornItems = player:getWornItems()

  for i = 0, wornItems:size() - 1 do
    local item = wornItems:getItemByIndex(i);
    if item.setChanceToFall then
      ---@diagnostic disable-next-line: undefined-field
      item:setChanceToFall(0)
    end
  end
end

function NoHatAndGlassesDrop:init()
  Events.OnClothingUpdated.Add(self.applyNoDrop)
  Events.OnCreatePlayer.Add(function(playerIndex, player)
    if not player then return end
    self.applyNoDrop(player)
  end)
end

return NoHatAndGlassesDrop
