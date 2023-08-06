local ActionBlacklist = {
  ISWalkToTimedAction = true,       -- Always ignore
  ISPathFindAction = true,          -- Always ignore
  -- ISEquipWeaponAction = true,    -- Can be skill depended but enabled because makes the game snappier
  -- ISReloadWeaponAction = true,      -- Skill depended and animation depended AFAIK
  -- ISReadABook = true,               -- Affected by FastReader and SlowReader
  -- ISGrabItemAction = true,          -- Affected by Dextrous  and AllThumbs
  -- ISInventoryTransferAction = true, -- Affected by Dextrous  and AllThumbs
}


local old_ISTimedActionQueue_addToQueue = ISTimedActionQueue.addToQueue
function ISTimedActionQueue:addToQueue(action)
  local actionType = getmetatable(action).Type

  -- CasualoidPrint("FasterActions: actionType: " .. actionType)
  if not ActionBlacklist[actionType] and action.maxTime > 0 then
    local modifier = SandboxVars.Casualoid.FasterActionsModifier
    -- CasualoidPrint("FasterActions: old maxTime: " .. action.maxTime)
    action.maxTime = math.max(action.maxTime * (1 - (modifier * 0.01)), 0)
    -- CasualoidPrint("FasterActions: new maxTime: " .. action.maxTime)
  end

  return old_ISTimedActionQueue_addToQueue(self, action)
end
