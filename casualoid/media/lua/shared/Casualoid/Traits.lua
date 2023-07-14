local oldGetTraits = TraitFactory.getTraits
TraitFactory.getTraits = function()
  local positives = CasualoidParseSandboxString(SandboxVars.Casualoid.MultiSelectDisablePositiveTraits)
  local negatives = CasualoidParseSandboxString(SandboxVars.Casualoid.MultiSelectDisableNegativeTraits)

  local filteredTraits = ArrayList:new()

  local traits = oldGetTraits()
  for i = 0, traits:size() - 1 do
    local trait = traits:get(i);
    local traitId = trait:getType()
    if not positives.map[traitId] and not negatives.map[traitId] then
      filteredTraits:add(trait)
    end
  end

  return filteredTraits
end
