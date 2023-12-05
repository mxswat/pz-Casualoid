local Debug = require("Casualoid/Debug")

---@class LootManagerWorldMenu
local LootManagerWorldMenu = {}

---@param worldObjects table<number, IsoObject>
---@param customName string
---@param groupName string
---@return IsoObject?
function LootManagerWorldMenu:findByNameAndGroup(worldObjects, groupName, customName)
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

---@param playerIndex int
---@param context ISContextMenu
---@param worldObjects table
function LootManagerWorldMenu.renderPlaceMenu(playerIndex, context, worldObjects)
  local self = LootManagerWorldMenu
  local player = getSpecificPlayer(playerIndex)

  local lootManagerObject = self:findByNameAndGroup(worldObjects, 'LootManager', 'Off')
  if not lootManagerObject then return end


  local text = getText("ContextMenu_EnableLootManager")
  local menuOption = context:addOption(text, worldObjects, ISCampingMenu.onPlaceCampfire, player, lootManagerObject);
end

function LootManagerWorldMenu:init()
  Events.OnFillWorldObjectContextMenu.Add(LootManagerWorldMenu.renderPlaceMenu)
end

LootManagerWorldMenu:init()

return LootManagerWorldMenu
