local function isTraitDisabled(id)
  local positives = CasualoidParseSandboxString(SandboxVars.Casualoid.MultiSelectDisablePositiveTraits)
  if positives.map[id] then
    return true
  end

  local negatives = CasualoidParseSandboxString(SandboxVars.Casualoid.MultiSelectDisableNegativeTraits)
  if negatives.map[id] then
    return true
  end
end

local oldAddTrait = TraitFactory.addTrait
TraitFactory.addTrait = function(...)
	local args = { ... }
	local traitId = args[1]
	local name = args[2]
	local cost = args[3]
	local description = args[4]
	local isProfOnly = args[5]
	if isTraitDisabled(traitId) then
		CasualoidPrint('Noob trap detected, remove it', traitId)
		-- oh no! I need to set this to pro only
		isProfOnly = true
	end
	return oldAddTrait(traitId, name, cost, description, isProfOnly)
end
