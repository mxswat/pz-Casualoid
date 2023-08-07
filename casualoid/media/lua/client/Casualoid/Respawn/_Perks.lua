CasualoidPerks = {}

function CasualoidPerks:savePerks(player, perk)
  local currentTotalXp = player:getXp():getXP(perk)
  if currentTotalXp <= 0 then
    return
  end

  local perkId = perk:getId()
  local boostId = player:getXp():getPerkBoost(perk);

  -- local professionXpToSubtract = boostId > 0 and perk:getTotalXpForLevel(boostId) or 0
  -- local xpExcludingBoost = math.max(currentTotalXp - professionXpToSubtract, 0)

  local casualoidRespawnData = Casualoid.getRespawnModData()
  casualoidRespawnData.perks[perkId] = {
    totalXp = currentTotalXp,
    boost = boostId,
  }
end

function CasualoidPerks:save(player)
  local perks = PerkFactory.PerkList;
  for i = 0, perks:size() - 1 do
    self:savePerks(player, perks:get(i));
  end
end
