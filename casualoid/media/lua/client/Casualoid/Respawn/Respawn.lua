local function saveReadBooks()
  local player = getPlayer()
  local casualoidRespawnData = GetCasualoidRespawnData();
  for i, book in ipairs(CasualoidGetSkillBooks()) do
    local readPages = player:getAlreadyReadPages(book:getFullName())
    if readPages > 0 then
      casualoidRespawnData.readBooks[book:getFullName()] = readPages
    end
  end
end

-- Save XP, and ignore any profession based multiplier
local function savePerkData(player, perk)
  local currentTotalXp = player:getXp():getXP(perk)
  if currentTotalXp <= 0 then
    return
  end

  local perkId = perk:getId()
  local casualoidRespawnData = GetCasualoidRespawnData();
  local perkBoostId = player:getXp():getPerkBoost(perk)
  local professionXpToSubtract = perkBoostId > 0 and perk:getTotalXpForLevel(perkBoostId) or 0

  CasualoidPrint('professionXpToSubtract', professionXpToSubtract)

  local xpToSave = math.max(currentTotalXp - professionXpToSubtract, 0)

  casualoidRespawnData.perksXp[perkId] = math.max(casualoidRespawnData.perksXp[perkId] or 0, xpToSave)
end

local function saveRecipes()
  local player = getPlayer()
  local knownRecipes = player:getKnownRecipes()

  local casualoidRespawnData = GetCasualoidRespawnData();
  for i = 0, knownRecipes:size() - 1 do
    local recipeID = knownRecipes:get(i)
    casualoidRespawnData.knownRecipes[recipeID] = true
  end
end

local function savePlayerProgress()
  local player = getPlayer()
  if not player:isAlive() or not player then return end

  CasualoidPrint('savePlayerProgress')

  for i = 0, Perks.getMaxIndex() - 1 do
    local perk = PerkFactory.getPerk(Perks.fromIndex(i));
    local parent = perk:getParent()
    if perk and parent ~= Perks.None then
      savePerkData(player, perk)
    end
  end

  saveRecipes()

  saveReadBooks()

  local casualoidRespawnData = GetCasualoidRespawnData();
  casualoidRespawnData.weight = player:getNutrition():getWeight()

  CasualoidGetSkillBooks()
end

Events.EveryHours.Add(savePlayerProgress)

-- ISPlayerStatsUI.instance.char:getXp():AddXP(perk:getType(), amount, false, false, true);

local function applySavedXP(_, player)
  CasualoidPrint('applySavedXP', player:getHoursSurvived())
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

Events.OnCreatePlayer.Add(applySavedXP)
