require "ISInventoryPaneContextMenu"

local function renameAllItems(player, context, items)
  local canBeRenamed = nil;
  local canBeAlreadyRenamed = false

  for i, v in ipairs(items) do
    local item = v;

    if not instanceof(v, "InventoryItem") then
      item = v.items[1];
    end

    if instanceof(item, "InventoryContainer") then
      canBeAlreadyRenamed = true;
    end

    canBeRenamed = item;
  end

  if canBeRenamed and not canBeAlreadyRenamed then
    context:addOption(getText("ContextMenu_RenameBag"), canBeRenamed, ISInventoryPaneContextMenu.onRenameBag, player);
  end
end

return renameAllItems
