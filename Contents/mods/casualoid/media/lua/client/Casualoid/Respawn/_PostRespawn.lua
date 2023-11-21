CasualoidPostRespawn = {};

function CasualoidPostRespawn:save(player)
  
end

function CasualoidPostRespawn:load(player)
  local perks = PerkFactory.PerkList;
  for i = 0, perks:size() - 1 do
    local perk = perks:get(i)
    -- Trigger event for some mods that change the traits depending on the XP
    -- and the KeepBooksMultiplier module
    triggerEvent("LevelPerk", player, perk, player:getPerkLevel(perk))
  end
end