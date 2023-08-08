CasualoidReadSkillBooks = {}

CasualoidReadSkillBooks.skillBooksCache = nil

function CasualoidReadSkillBooks:getSkillBooks()
  if self.skillBooksCache then
    return self.skillBooksCache
  end

  self.skillBooksCache = {}
  local allItems = getScriptManager():getAllItems()
  for i = 1, allItems:size() do
    local item = allItems:get(i - 1)
    if item:getType() == Type.Literature then
      if SkillBook[item:getSkillTrained()] then
        table.insert(self.skillBooksCache, item)
      end
    end
  end

  return self.skillBooksCache
end

function CasualoidReadSkillBooks:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()

  local skillBooks = self:getSkillBooks()
  for _, book in ipairs(skillBooks) do
    local readPages = player:getAlreadyReadPages(book:getFullName())
    if readPages > 0 then
      casualoidRespawnData.readBooks[book:getFullName()] = readPages
    end
  end
end

function CasualoidReadSkillBooks:load(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()
  for bookFullName, readPages in pairs(casualoidRespawnData.readBooks) do
    player:setAlreadyReadPages(bookFullName, readPages)
  end

  local skillBooks = self:getSkillBooks()
  for _, skillBook in ipairs(skillBooks) do
    local item = skillBook:InstanceItem(nil)
    local mockAction = ISReadABook:new(player, item, 2)

    local skillTrainedLevel = player:getPerkLevel(SkillBook[item:getSkillTrained()].perk) + 1
    local isTooHighLvl = item:getLvlSkillTrained() > skillTrainedLevel
    local isTooLowLvl = item:getMaxLevelTrained() < skillTrainedLevel
    if item:getAlreadyReadPages() > 0 and not isTooHighLvl and not isTooLowLvl then
      Casualoid.print('Apply XP multiplier from:', item:getDisplayName())
      -- checkMultiplier sets the multiplier on the player too :D
      ISReadABook.checkMultiplier(mockAction)
    end
  end
end

-- To avoid tediousness, reapply existing multiplier on new level up after the first load
function CasualoidReadSkillBooks.onLevelPerk(player, perk, perkLevel)
  CasualoidReadSkillBooks:load(player)
end

Events.LevelPerk.Add(CasualoidReadSkillBooks.onLevelPerk);
