if isClient() then
  return
end

require "Farming/SPlantGlobalObject"

local function isDisableCropsRotting()
  return SandboxVars.Casualoid.DisableCropsRotting
end

local old_SPlantGlobalObject_rottenThis = SPlantGlobalObject.rottenThis
function SPlantGlobalObject:rottenThis()
  if not isDisableCropsRotting() then
    return old_SPlantGlobalObject_rottenThis(self)
  end

  -- Ensures that over fertilizing still kills the plant, as mentioned in the "SPlantGlobalObject:fertilize"
  if self.fertilizer > 4 then
    return old_SPlantGlobalObject_rottenThis(self)
  end

  return nil
end
