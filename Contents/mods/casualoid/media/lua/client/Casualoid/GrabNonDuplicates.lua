local Hooks = require "MxUtilities/Hooks"

---@class GrabNonDuplicates: ISInventoryPaneContextMenu
local GrabNonDuplicates = {}

---@param lootItems table<number, unknown>
---@param playerIdx number
function GrabNonDuplicates.grabItems(lootItems, playerIdx)
  ---@type table<string, boolean>
  local playerItemsMap = {}

  local player = getSpecificPlayer(playerIdx)
  local playerInv = getPlayerInventory(playerIdx).inventory;
  local playerInvItems = playerInv:getItems()

  for i = playerInvItems:size() - 1, 0, -1 do
    ---@type InventoryItem
    local item = playerInvItems:get(i)
    playerItemsMap[item:getFullType()] = true
  end

  local backpacks = getPlayerInventory(playerIdx).backpacks;
  for _, backpack in ipairs(backpacks) do
    ---@type InventoryContainer|nil
    local bpItem = backpack and backpack.inventory and backpack.inventory:getContainingItem();
    if bpItem then
      local container = bpItem:getInventory()
      local items = container:getItems()
      for i = items:size() - 1, 0, -1 do
        ---@type InventoryItem
        local item = items:get(i)
        playerItemsMap[item:getFullType()] = true
      end
    end
  end

  local lootedItems = 0
  ---@type table<number,InventoryItem>
  local actualLootItems = ISInventoryPane.getActualItems(lootItems)
  for _, item in ipairs(actualLootItems) do
    if not playerItemsMap[item:getFullType()] then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(player, item, item:getContainer(), playerInv))
      playerItemsMap[item:getFullType()] = true
      lootedItems = lootedItems + 1
    end
  end

  if lootedItems > 0 then return end
  -- player:Say(getText("IGUI_NoUniqueItemsToGrab"))
  HaloTextHelper.addText(player, getText("IGUI_NoUniqueItemsToGrab"), HaloTextHelper.getColorRed())
end

---@param context ISContextMenu
---@param items table<number, unknown>
---@param playerIdx number
function GrabNonDuplicates.doGrabMenu(context, items, playerIdx)
  if #items < 2 then return end

  context:addOption(getText("ContextMenu_GrabNonDuplicates"), items, GrabNonDuplicates.grabItems, playerIdx);
end

function GrabNonDuplicates:init()
  Hooks:PostHooksFromTable(ISInventoryPaneContextMenu, GrabNonDuplicates, 'GrabNonDuplicates')
end

return GrabNonDuplicates

-- Events.OnFillInventoryObjectContextMenu.Add(AddContextPutItems)
