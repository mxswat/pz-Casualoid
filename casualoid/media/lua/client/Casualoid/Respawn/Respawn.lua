local respawnHandlers = {}

local function registerHandler(data)
  table.insert(respawnHandlers, data);
end

registerHandler(CasualoidPerks)
registerHandler(CasualoidKnownMediaLines)
registerHandler(CasualoidRecipes)
registerHandler(CasualoidWeight)
registerHandler(CasualoidOccupation)
registerHandler(CasualoidTraits)
registerHandler(CasualoidReadSkillBooks) -- has to be last to correctly apply the XP multiplier

local function savePlayerProgress(player)
  Casualoid.print('savePlayerProgress')

  for _, handler in ipairs(respawnHandlers) do
    handler:save(player)
  end

  -- Save to file that this player can respawn
  local available = Casualoid.File.Load(Casualoid.getRespawnFilePath()) or {};
  available[Casualoid.getUserID()] = true;

  Casualoid.File.Save(Casualoid.getRespawnFilePath(), available);
end

-- TODO: Replace with OnPlayerDeath
Events.OnPlayerDeath.Add(savePlayerProgress)

local function OnCreatePlayer()
  if not getPlayer():HasTrait('RespawnTrait') then
    return;
  end

  
  for _, handler in ipairs(respawnHandlers) do
    handler:load(getPlayer());
  end
end

Events.OnCreatePlayer.Add(OnCreatePlayer);
