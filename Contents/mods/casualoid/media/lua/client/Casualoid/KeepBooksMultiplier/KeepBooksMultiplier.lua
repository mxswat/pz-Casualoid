local Debug = require("Casualoid/Debug")

local KeepBooksMultiplier = {}

KeepBooksMultiplier.skillBooksCache = nil


function KeepBooksMultiplier:getModData()
  return ModData.getOrCreate("KeepBooksMultiplier");
end

function KeepBooksMultiplier:getSkillBooks()
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

function KeepBooksMultiplier:save(player)
  local modData = self:getModData()

  local skillBooks = self:getSkillBooks()
  for _, book in ipairs(skillBooks) do
    local readPages = player:getAlreadyReadPages(book:getFullName())
    if readPages > 0 then
      modData[book:getFullName()] = readPages
    end
  end
end

function KeepBooksMultiplier:load(player)
  local modData = self:getModData()

  for bookFullName, readPages in pairs(modData) do
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
      Debug:print('Apply XP multiplier from:', item:getDisplayName())
      -- checkMultiplier sets the multiplier on the player too :D
      ISReadABook.checkMultiplier(mockAction)
    end
  end
end

function KeepBooksMultiplier:init()
  Events.LevelPerk.Add(function(character)
    -- To avoid tediousness, reapply existing multiplier on new level up
    KeepBooksMultiplier:load(character)
  end);

  Events.OnCreatePlayer.Add(function(_, player)
    KeepBooksMultiplier:load(player)
  end);

  Events.OnPlayerDeath.Add(function(player)
    KeepBooksMultiplier:save(player)
  end)
end

return KeepBooksMultiplier
