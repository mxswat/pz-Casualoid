CasualoidPerks = {}

function CasualoidPerks:savePerks(player, perk)
  local totalXp = player:getXp():getXP(perk)
  if totalXp <= 0 then
    return
  end

  local perkId = perk:getId()
  local boostId = player:getXp():getPerkBoost(perk);

  local professionXpToSubtract = boostId > 0 and perk:getTotalXpForLevel(boostId) or 0
  local totalXpNoBoost = math.max(totalXp - professionXpToSubtract, 0)

  local casualoidRespawnData = Casualoid.getRespawnModData()
  casualoidRespawnData.perks[perkId] = casualoidRespawnData.perks[perkId] or {}
  casualoidRespawnData.perks[perkId].totalXp = math.max(totalXp, casualoidRespawnData.perks[perkId].totalXp or 0)
  casualoidRespawnData.perks[perkId].boost = boostId
  casualoidRespawnData.perks[perkId].totalXpNoBoost =
      math.max(totalXpNoBoost, casualoidRespawnData.perks[perkId].totalXpNoBoost or 0)
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

  local xpMultiplier = casualoidRespawnData.traits["RespawnLowerXP"]
      and SandboxVars.Casualoid.XPKeptByLowerXPTrait
      or SandboxVars.Casualoid.XPKeptOnRespawn

  for perkId, data in pairs(casualoidRespawnData.perks) do
    local perk = Perks[perkId]
    if perk then
      xp:AddXP(perk, data.totalXp * (xpMultiplier / 100), false, false, true);
      xp:setPerkBoost(perk, math.min(data.boost or 0, 3));
    end
  end
end
