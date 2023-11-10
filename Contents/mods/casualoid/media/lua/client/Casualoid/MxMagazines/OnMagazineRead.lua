local Hooks = require "MxUtilities/Hooks"

---@class MxMagazineRead: ISReadABook
local MxMagazineRead = {}

function MxMagazineRead:perform(...)
  if self.item:getFullType() ~= "Casualoid.NutritionistMag1" then
    return
  end
  if self.character:HasTrait("Nutritionist2") then
    return
  end

  self.character:getTraits():add("Nutritionist2");
  HaloTextHelper.addTextWithArrow(self.character, 'Nutritionist Trait', true, HaloTextHelper.getColorGreen())
end

Hooks:PostHooksFromTable(ISReadABook, MxMagazineRead, 'MxMagazineRead')

-- This should make it compatible with the journal mod on respawn
local function onCreatePlayer(playerNum, playerObj)
  if playerNum ~= 0 then return end
  if playerObj:isRecipeKnown("Nutritionist Trait") and not playerObj:HasTrait("Nutritionist2") then
    playerObj:getTraits():add("Nutritionist2");
  end
end

Events.OnCreatePlayer.Add(onCreatePlayer);
