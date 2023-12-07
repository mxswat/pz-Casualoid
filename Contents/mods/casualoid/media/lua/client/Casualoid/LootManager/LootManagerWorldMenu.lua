local Debug = require("Casualoid/Debug")

---@class LootManagerWorldMenu
local LootManagerWorldMenu = {}

---@param worldObjects table<number, IsoObject>
---@param customName string
---@param groupName string
---@return IsoObject?
function LootManagerWorldMenu:findObjectByNameAndGroup(worldObjects, groupName, customName)
  for _, object in ipairs(worldObjects) do
    local props = object:getSprite():getProperties()
    local objCustomName = props and props:Val('CustomName')
    local objGroupName = props and props:Val('GroupName')
    Debug:print('objCustomName:', objCustomName, 'objGroupName:', objGroupName)
    if objGroupName == groupName and objCustomName == customName  then
      return object
    end
  end
end

-- ISGeneratorInfoWindow

---@param spriteName string # the sprite name eg: `loot_manager_0`
---@return string # returns the sprite name with the last digit plus 4, wrapped between 0 and 7
function LootManagerWorldMenu:getOppositeStateSpriteName(spriteName)
  local lastDigit = tonumber(spriteName:sub(-1))

  return spriteName:sub(1, -2) .. (lastDigit + 4) % 8
end

---@param object IsoObject
---@param character IsoPlayer 
function LootManagerWorldMenu:toggleLootManager(object, character)
  local spriteName = self:getOppositeStateSpriteName(object:getSprite():getName())
  -- object:setSprite(spriteName) -- this only changes the square tile estetics, not the actual object, good to know
  local square = object:getSquare() 
  square:transmitRemoveItemFromSquare(object)

  ISBrushToolTileCursor:create(square:getX(),square:getY(), square:getZ(), nil, spriteName)
end

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
function LootManagerWorldMenu.renderEnableMenu(playerIndex, context, worldObjects)
  local self = LootManagerWorldMenu
  local player = getSpecificPlayer(playerIndex)

  local lootManagerObject = self:findObjectByNameAndGroup(worldObjects, 'LootManager', 'Off')
  if not lootManagerObject then return end


  local text = getText("ContextMenu_EnableLootManager")
  local menuOption = context:addOption(text, self, LootManagerWorldMenu.toggleLootManager, lootManagerObject, player);

  if not ISMoveableSpriteProps:objectNoContainerOrEmpty(lootManagerObject) then
    menuOption.notAvailable = true
    local tooltip = ISInventoryPaneContextMenu.addToolTip()
    tooltip.description = getText("ContextMenu_EmptyTheLootManager")

    return
  end
  -- On click use setSpriteFromName
end

function LootManagerWorldMenu:init()
  Events.OnFillWorldObjectContextMenu.Add(LootManagerWorldMenu.renderEnableMenu)
end

LootManagerWorldMenu:init()

return LootManagerWorldMenu
