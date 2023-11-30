local Debug = require("Casualoid/Debug")

---@class KeepBooksMultiplier
local KeepBooksMultiplier = {}

KeepBooksMultiplier.perkToSkillBookMap = nil

function KeepBooksMultiplier:getModData()
  return ModData.getOrCreate("KeepBooksMultiplier");
end

---@param perk Perk
---@param perkLevel number
---@return Literature
function KeepBooksMultiplier:getBookForPerk(perk, perkLevel)
  --- skills start at 0, but if it as 0 it won't count the first book
  local level = perkLevel + 1
  local skillToBookMap = self:getSkillToBookMap()
  -- Perk and getSkillTrained are not aligned inside `java\characters\skills\PerkFactory.java` so I need to use getName()
  local perkName = perk:getName()
  return skillToBookMap[perkName] and skillToBookMap[perkName][level]
end

function KeepBooksMultiplier:getSkillToBookMap()
  if self.perkToSkillBookMap then
    return self.perkToSkillBookMap
  end

  self.perkToSkillBookMap = {}

  local allItems = getAllItems()
  local allItemsSize = allItems:size()
  for i = allItemsSize - 1, 0, -1 do
    local item = allItems:get(i)
    if item:getType() == Type.Literature and SkillBook[item:getSkillTrained()] then
      local instanceItem = item:InstanceItem(nil)
      local skillTrained = item:getSkillTrained()
      self.perkToSkillBookMap[skillTrained] = self.perkToSkillBookMap[skillTrained] or {}
      self.perkToSkillBookMap[skillTrained][instanceItem:getLvlSkillTrained()] = instanceItem
      self.perkToSkillBookMap[skillTrained][instanceItem:getMaxLevelTrained()] = instanceItem
    end
  end

  return self.perkToSkillBookMap
end

function KeepBooksMultiplier:save(player)
  local modData = self:getModData()

  local perks = PerkFactory.PerkList;
  for i = 0, perks:size() - 1 do
    local perk = perks:get(i);
    local level = player:getPerkLevel(perk)
    local book = self:getBookForPerk(perk, level)
    if book then
      local readPages = player:getAlreadyReadPages(book:getFullType())
      if readPages > 0 then
        modData[book:getFullType()] = readPages
      end
    end
  end
end

---@param player IsoGameCharacter
---@param perk Perk
function KeepBooksMultiplier:giveXpMultiplier(player, perk)
  local level = player:getPerkLevel(perk)
  local book = self:getBookForPerk(perk, level)
  if not book then
    return
  end

  local alreadyReadPages = player:getAlreadyReadPages(book:getFullType())
  if alreadyReadPages <= 0 then
    return
  end

  local mockAction = ISReadABook:new(player, book, 2)
  Debug:print('PerkName:', perk, '|', 'Level:', level)
  Debug:print('Apply XP multiplier from:', book:getDisplayName())
  -- checkMultiplier sets the multiplier on the player too :D
  ISReadABook.checkMultiplier(mockAction)
end

function KeepBooksMultiplier:load(player)
  local modData = self:getModData()

  for bookFullName, readPages in pairs(modData) do
    player:setAlreadyReadPages(bookFullName, readPages)
  end

  local skillToBookMap = self:getSkillToBookMap()
  Debug:print('skillToBookMap')
  Debug:printTable(skillToBookMap)
  local perks = PerkFactory.PerkList;
  for i = 0, perks:size() - 1 do
    local perk = perks:get(i);
    self:giveXpMultiplier(player, perk)
  end
end

function KeepBooksMultiplier:init()
  Events.LevelPerk.Add(function(character, perk)
    -- To avoid tediousness, reapply existing multiplier on new level up
    self:giveXpMultiplier(character, perk)
  end);

  Events.OnCreatePlayer.Add(function(_, player)
    self:load(player)
  end);

  Events.OnPlayerDeath.Add(function(player)
    self:save(player)
  end)
end

return KeepBooksMultiplier
