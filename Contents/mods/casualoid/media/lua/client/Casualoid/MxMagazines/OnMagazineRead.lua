require "TimedActions/ISReadABook"

---@param self ISReadABook
local function giveNutritionistTrait(self)
  if self.item:getFullType() ~= "Casualoid.NutritionistMag1" then
    return
  end
  if self.character:HasTrait("Nutritionist2") then
    return
  end

  self.character:getTraits():add("Nutritionist2");
  HaloTextHelper.addTextWithArrow(self.character, 'Nutritionist Trait', true, HaloTextHelper.getColorGreen())
end

local old_ISReadABook_perform = ISReadABook.perform
function ISReadABook:perform(...)
  giveNutritionistTrait(self)
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

