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

  local skillBooks = CasualoidReadBooks:getSkillBooks()
  for _, book in ipairs(skillBooks) do
    local readPages = player:getAlreadyReadPages(book:getFullName())
    if readPages > 0 then
      casualoidRespawnData.readBooks[book:getFullName()] = readPages
    end
  end
end
