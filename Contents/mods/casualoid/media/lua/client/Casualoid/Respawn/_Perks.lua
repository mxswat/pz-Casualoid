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

  Casualoid.print('Respawn: xpMultiplier', xpMultiplier)

  for perkId, data in pairs(casualoidRespawnData.perks) do
    local perk = Perks[perkId]
    if perk then
      local boost = math.min(data.boost or 0, 3)
      local xpToRecover = data.totalXp * (xpMultiplier / 100)
      local minXpToRecover = boost > 0 and perk:getTotalXpForLevel(boost) or 0

      if perk == Perks.Strength or perk == Perks.Fitness then
        minXpToRecover = data.totalXp
        minXpToRecover = data.totalXp
      end

      Casualoid.print(perk, 'xpToRecover:', xpToRecover, 'minimumXpToRecover', minXpToRecover, 'boost', boost)
      xp:AddXP(perk, math.max(minXpToRecover, xpToRecover), false, false, false);
      xp:setPerkBoost(perk, boost);
    end
  end
end

function CasualoidPerks:loadPartial(player)
  local casualoidRespawnData = Casualoid.getRespawnModData()
  local xpMultiplier = SandboxVars.Casualoid.XPKeptOnRespawn

  local xp = player:getXp();
  for perkId, data in pairs(casualoidRespawnData.perks) do
    local perk = Perks[perkId]
    if perk and perk ~= Perks.Strength or perk ~= Perks.Fitness then
      local xpToRecover = data.totalXpNoBoost * (xpMultiplier / 100)

      xp:AddXP(perk, math.max(0, xpToRecover), false, false, false);
    end
  end
end