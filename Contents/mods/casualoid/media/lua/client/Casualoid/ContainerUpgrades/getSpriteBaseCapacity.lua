---@param sprite IsoSprite
local function getSpriteBaseCapacity(sprite)
  -- NOTE: 50 is the default value coming from ItemContainer.java => public int Capacity = 50;
  ---@type number
  return sprite and sprite:getProperties():Val("ContainerCapacity") or 50
end

return getSpriteBaseCapacity