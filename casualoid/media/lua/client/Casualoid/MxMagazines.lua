require "TimedActions/ISReadABook"

local old_ISReadABook_perform = ISReadABook.perform
function ISReadABook:perform(...)
  if self.item:getFullType() == "Casualoid.NutritionistMag1" then
    if not self.character:HasTrait("Nutritionist2") then
      self.character:getTraits():add("Nutritionist2");
      HaloTextHelper.addTextWithArrow(self.character, 'Nutritionist Trait', true, HaloTextHelper.getColorGreen())
    end
  end
  return old_ISReadABook_perform(self, ...)
end

-- This should make it compatible with the journal mod on respawn
local function onCreatePlayer(playerNum, playerObj)
  if playerNum ~= 0 then return end
  if playerObj:isRecipeKnown("Nutritionist Trait") and not playerObj:HasTrait("Nutritionist2") then
    playerObj:getTraits():add("Nutritionist2");
  end
end

Events.OnCreatePlayer.Add(onCreatePlayer);
