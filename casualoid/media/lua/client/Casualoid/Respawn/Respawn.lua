local respawnHandlers = {}

local function registerHandler(data)
  table.insert(respawnHandlers, data);
end

registerHandler(CasualoidKnownMediaLines)
registerHandler(CasualoidPerks)
registerHandler(CasualoidRecipes)
registerHandler(CasualoidWeight)
registerHandler(CasualoidReadBooks) -- has to be last to correctly apply the XP multiplier

local function savePlayerProgress()
  Casualoid.print('savePlayerProgress')
  local player = getPlayer()

  for _, handler in ipairs(respawnHandlers) do
    handler:save(player)
  end
end

-- TODO: Replace with OnPlayerDeath
Events.EveryTenMinutes.Add(savePlayerProgress)

local function OnCreatePlayer()
  if not getPlayer():HasTrait('RespawnTrait') then
    return;
  end

  
  for i, handler in ipairs(respawnHandlers) do
    -- handler:load(getPlayer());
  end
end

Events.OnCreatePlayer.Add(OnCreatePlayer);

-- -- ISPlayerStatsUI.instance.char:getXp():AddXP(perk:getType(), amount, false, false, true);

local function OnCreatePlayer(_, player)
  Casualoid.print('applySavedXP', player:getHoursSurvived())
  if player:getHoursSurvived() > 0 then return end
  local casualoidRespawnData = GetCasualoidRespawnData();

  for perkId, xp in pairs(casualoidRespawnData.perksXp) do
    player:getXp():AddXP(Perks[perkId], xp, false, false, false)
  end


  for bookFullName, readPages in pairs(casualoidRespawnData.readBooks) do
    player:setAlreadyReadPages(bookFullName, readPages)
    -- ISReadABook.checkMultiplier()
  end
end

Events.OnCreatePlayer.Add(OnCreatePlayer)
