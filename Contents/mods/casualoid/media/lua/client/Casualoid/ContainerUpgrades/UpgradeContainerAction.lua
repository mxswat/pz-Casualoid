local applyUpgradeToObjectContainer = require "Casualoid/ContainerUpgrades/applyUpgradeToObjectContainer"
local UpgradeContainerAction = ISBaseTimedAction:derive("UpgradeContainerAction");

-- UpgradeContainerAction.soundDelay = 6

function UpgradeContainerAction:isValid()
  return true
end

function UpgradeContainerAction:waitToStart()
  self:faceLocation()
  return self.character:shouldBeTurning()
end

function UpgradeContainerAction:update()
  local playingSound = self.sound ~= 0 and self.character:getEmitter():isPlaying(self.sound)

  if not playingSound then
    self.sound = self.character:getEmitter():playSound("Dismantle");
  end

  self.character:setMetabolicTarget(Metabolics.LightWork);
  self:faceLocation();
end

function UpgradeContainerAction:start()
  self:setActionAnim("Disassemble");
end

function UpgradeContainerAction:stop()
  if self.sound and self.sound ~= 0 and self.character:getEmitter():isPlaying(self.sound) then
    self.character:getEmitter():stopSound(self.sound);
  end
  ISBaseTimedAction.stop(self);
end

function UpgradeContainerAction:perform()
  if self.sound and self.sound ~= 0 and self.character:getEmitter():isPlaying(self.sound) then
    self.character:getEmitter():stopSound(self.sound);
  end

  applyUpgradeToObjectContainer(self.object, self.upgradeItem)

  local container = self.upgradeItem:getContainer()
  container:DoRemoveItem(self.upgradeItem)


  ISInventoryPage.dirtyUI()

  if isClient() then
    self.object:transmitModData()
    local square = self.object:getSquare()

    local args = {
      x = square:getX(),
      y = square:getY(),
      z = square:getZ(),
    }
    sendClientCommand(self.character, "Casualoid", "broadcastContainerUpgrade", args);
  end
  ISBaseTimedAction.perform(self);
end

function UpgradeContainerAction:faceLocation()
  self.character:faceThisObject(self.object)
end

function UpgradeContainerAction:new(character, object, upgradeItem)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.character = character;
  o.stopOnWalk = true;
  o.stopOnRun = true;
  o.maxTime = 250;
  o.caloriesModifier = 4;
  o.object = object
  o.upgradeItem = upgradeItem
  o.sound = 0
  o.soundTime = 0
  return o;
end

return UpgradeContainerAction
