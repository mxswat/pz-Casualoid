---@diagnostic disable: duplicate-set-field
local function getNoobTraps()
	return {
		Asthmatic = SandboxVars.Casualoid.RemoveAsthmatic,
		Deaf = SandboxVars.Casualoid.RemoveDeaf,
		SundayDriver = SandboxVars.Casualoid.RemoveSundayDriver,
		HardOfHearing = SandboxVars.Casualoid.RemoveHardOfHearing,
		Disorganized = SandboxVars.Casualoid.RemoveDisorganized,
		Illiterate = SandboxVars.Casualoid.RemoveIlliterate,
		Clumsy = SandboxVars.Casualoid.RemoveClumsy,
		Nutritionist = SandboxVars.Casualoid.RemoveNutritionist,
		Herbalist = SandboxVars.Casualoid.RemoveHerbalist,
		AllThumbs = SandboxVars.Casualoid.RemoveAllThumbs,
	}
end

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
