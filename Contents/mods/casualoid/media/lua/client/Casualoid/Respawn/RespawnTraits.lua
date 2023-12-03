local TraitsHook = require "MxUtilities/TraitsHook"

---@class Inject: Trait
local RespawnTraits = {}

function RespawnTraits:getCost()
  if self:getType() == 'RespawnPenalty' then
    return SandboxVars.Casualoid.RespawnPenaltyTraitCost
  end
end

function RespawnTraits:getDescription()
  if self:getType() == 'RespawnPenalty' then
    local XPKeptByRespawnPenaltyTrait = SandboxVars.Casualoid.XPKeptByRespawnPenaltyTrait
    local XPKeptOnRespawn = SandboxVars.Casualoid.XPKeptOnRespawn

    return getText('UI_trait_RespawnPenalty_desc', XPKeptByRespawnPenaltyTrait, XPKeptOnRespawn)
  end
end

TraitsHook:PostHooksFromTable(RespawnTraits, 'CasualoidRespawnTraits')
