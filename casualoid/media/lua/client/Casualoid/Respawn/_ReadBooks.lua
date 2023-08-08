CasualoidReadBooks = {}

CasualoidReadBooks.skillBooksCache = nil

function CasualoidReadBooks:getSkillBooks()
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

function CasualoidReadBooks:save(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()

  local skillBooks = self:getSkillBooks()
  for _, book in ipairs(skillBooks) do
    local readPages = player:getAlreadyReadPages(book:getFullName())
    if readPages > 0 then
      casualoidRespawnData.readBooks[book:getFullName()] = readPages
    end
  end
end

function CasualoidReadBooks:load(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()
  for bookFullName, readPages in pairs(casualoidRespawnData.readBooks) do
    player:setAlreadyReadPages(bookFullName, readPages)
  end

  local skillBooks = self:getSkillBooks()
  for i, skillBook in ipairs(skillBooks) do
    local mockAction = ISReadABook:new(player, skillBook:InstanceItem(nil), 2)
    -- checkMultiplier sets the multiplier on the player too :D
    ISReadABook.checkMultiplier(mockAction)
  end
end
