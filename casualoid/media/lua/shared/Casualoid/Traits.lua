local function getNoobTraps()
	return {
		Asthmatic = SandboxVars.Casualoid.DisableAsthmatic,
		Deaf = SandboxVars.Casualoid.DisableDeaf,
		SundayDriver = SandboxVars.Casualoid.DisableSundayDriver,
	}
end

-- Maybe override TraitFactory.getTraits() instead

local oldAddTrait = TraitFactory.addTrait
TraitFactory.addTrait = function(...)
	local args = { ... }
	local traitId = args[1]
	local name = args[2]
	local cost = args[3]
	local description = args[4]
	local isProfOnly = args[5]
	if getNoobTraps()[traitId] then
		CasualoidPrint('Noob trap detected, remove it', traitId)
		-- oh no! I need to set this to pro only
		isProfOnly = true
	end
	return oldAddTrait(traitId, name, cost, description, isProfOnly)
end
