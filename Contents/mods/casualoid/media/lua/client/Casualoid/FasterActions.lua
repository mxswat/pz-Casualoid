local Debug = require("Casualoid/Debug")
local Hooks = require("MxUtilities/Hooks")

local ActionBlacklist = {
  ISWalkToTimedAction = true, -- Always ignore
  ISPathFindAction = true,    -- Always ignore
  -- ISEquipWeaponAction = true,    -- Can be skill depended but enabled because makes the game snappier
  -- ISReloadWeaponAction = true,      -- Skill depended and animation depended AFAIK
  -- ISReadABook = true,               -- Affected by FastReader and SlowReader
  -- ISGrabItemAction = true,          -- Affected by Dextrous  and AllThumbs
  -- ISInventoryTransferAction = true, -- Affected by Dextrous  and AllThumbs
}

---@class FasterActions: ISTimedActionQueue
local FasterActions = {}
function FasterActions:addToQueue(action)
  local actionType = getmetatable(action).Type

  if ActionBlacklist[actionType] or action.maxTime <= 0 then
    return
  end

  local modifier = SandboxVars.Casualoid.FasterActionsModifier
  local oldMaxTime = action.maxTime
  action.maxTime = math.max(action.maxTime * (1 - (modifier * 0.01)), 0)

  Debug:print("FasterActions modifier:", modifier, "old maxTime: " .. oldMaxTime, "new maxTime", action.maxTime)

  return action
end

Hooks:PostHooksFromTable(ISTimedActionQueue, FasterActions, 'FasterActions')
