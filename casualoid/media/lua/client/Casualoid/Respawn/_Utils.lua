function GetCasualoidRespawnData()
  local casualoidRespawnData = ModData.getOrCreate("CasualoidRespawnData");
  casualoidRespawnData.perksXp = casualoidRespawnData.perksXp or {}
  casualoidRespawnData.knownMediaLines = casualoidRespawnData.knownMediaLines or {}
  casualoidRespawnData.knownRecipes = casualoidRespawnData.knownRecipes or {}
  casualoidRespawnData.readBooks = casualoidRespawnData.readBooks or {}
  casualoidRespawnData.weight = casualoidRespawnData.weight or nil

  return casualoidRespawnData
end

local skillBooksCache = nil
function CasualoidGetSkillBooks()
  if skillBooksCache then
    return skillBooksCache
  end

  skillBooksCache = {}
  local allItems = getScriptManager():getAllItems()
  for i = 1, allItems:size() do
    local item = allItems:get(i - 1)
    if item:getType() == Type.Literature then
      if SkillBook[item:getSkillTrained()] then
        table.insert(skillBooksCache, item)
      end
    end
  end

  return skillBooksCache
end

-- Intercept the knownMediaLines
local injected_instance = nil
local old_ISRadioInteractions_getInstance = ISRadioInteractions.getInstance
function ISRadioInteractions:getInstance()
  if injected_instance then
    return injected_instance
  end

  local instance = old_ISRadioInteractions_getInstance(self)

  local old_self_checkPlayer = instance.checkPlayer
  local function new_checkPlayer(player, _guid, ...)
    local result = old_self_checkPlayer(player, _guid, ...)
    
    CasualoidPrint('ISRadioInteractions: _guid', _guid)

    if _guid ~= nil and _guid ~= "" then return end

    local casualoidRespawnData = GetCasualoidRespawnData()
    casualoidRespawnData.knownMediaLines[_guid] = true

    return result
  end

  instance.checkPlayer = new_checkPlayer

  injected_instance = instance

  return instance
end
