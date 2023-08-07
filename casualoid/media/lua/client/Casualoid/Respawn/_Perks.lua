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

function CasualoidPerks:load(player)
  -- Hard reset player perks if the user picked up any
  local perks = PerkFactory.PerkList;
  local xp = player:getXp();
  for i = 0, perks:size() - 1 do
    local perk = perks:get(i);
    xp:setXPToLevel(perk, 0);
    while player:getPerkLevel(perk) > 0 do
      player:LoseLevel(perk);
    end
  end

  local casualoidRespawnData = Casualoid.getRespawnModData()
  for perkId, data in pairs(casualoidRespawnData.perks) do
    if Perks[perkId] then
      xp:AddXP(Perks[perkId], data.totalXp, false, false, false);
    end
  end
end
