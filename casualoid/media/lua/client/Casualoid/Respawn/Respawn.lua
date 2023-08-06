local function getSkillBooks()
  local skillBooks = {}
  local other = {}
  local media = {}
  local allItems = getScriptManager():getAllItems()
  for i = 1, allItems:size() do
    local item = allItems:get(i - 1)
    if item:getType() == Type.Literature then
      if SkillBook[item:getSkillTrained()] then
        table.insert(skillBooks, item)
      elseif item:getTeachedRecipes() ~= nil then
        table.insert(other, item)
      end
    end
    local mediaCategory = item:getRecordedMediaCat()
    if mediaCategory then
      media[mediaCategory] = media[mediaCategory] or {}
      table.insert(media[mediaCategory], item)
    end
  end

  return skillBooks
end

local function getCasualoidRespawnData()
  local casualoidRespawnData = ModData.getOrCreate("CasualoidRespawnData");
  casualoidRespawnData.perks = casualoidRespawnData.perks or {}
  casualoidRespawnData.knownMediaLines = casualoidRespawnData.knownMediaLines or {}

  return casualoidRespawnData
end

-- Save XP, and ignore any profession based multiplier
local function saveXP(player, perk)
  local currentTotalXp = player:getXp():getXP(perk)
  if currentTotalXp <= 0 then
    return
  end

  local perkId = perk:getId()
  local casualoidRespawnData = getCasualoidRespawnData();
  local perkBoostId = player:getXp():getPerkBoost(perk)
  local professionXpToSubtract = perk:getTotalXpForLevel(perkBoostId)
  local xpToSave = currentTotalXp - professionXpToSubtract

  casualoidRespawnData.perks[perkId] = math.max(casualoidRespawnData.perks[perkId] or 0, xpToSave)

  -- CasualoidPrint(perk, 'currentTotalXp:', currentTotalXp, "professionXpToIgnore:", professionXpToSubtract)
  -- CasualoidPrint('xpToSave:', xpToSave)
end

local function savePlayerProgress()
  local player = getPlayer()
  if not player:isAlive() or not player then return end

  CasualoidPrint('savePlayerProgress')
  for i = 0, Perks.getMaxIndex() - 1 do
    local perk = PerkFactory.getPerk(Perks.fromIndex(i));
    if perk and perk:getParent():getId() ~= "None" then
      saveXP(player, perk)
      -- local parent = perk:getParent()
      -- local currentTotalXp = player:getXp():getXP(perk)
      -- local info = player:getPerkInfo(perk)
      -- local level = info and info:getLevel() or 0
      -- local perkBoostId = player:getXp():getPerkBoost(perk)
      -- local totalXpForLevel = perk:getTotalXpForLevel(10)

      -- CasualoidPrint('perk:', perk, 'parent:', parent, 'currentXp:', currentTotalXp, "level:", level, "perkBoost:", perkBoostId, "totalXpForLevel:", totalXpForLevel)
    end
  end

  getSkillBooks()
end

Events.EveryHours.Add(savePlayerProgress)

-- ISPlayerStatsUI.instance.char:getXp():AddXP(perk:getType(), amount, false, false, true);

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

    local casualoidRespawnData = getCasualoidRespawnData()
    casualoidRespawnData.knownMediaLines[_guid] = true

    return result
  end

  instance.checkPlayer = new_checkPlayer

  injected_instance = instance

  return instance
end
