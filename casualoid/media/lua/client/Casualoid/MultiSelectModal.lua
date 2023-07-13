require "ISUI/ISCollapsableWindowJoypad"

MultiSelectModal = ISCollapsableWindowJoypad:derive("MultiSelectModal")

function MultiSelectModal:createChildren()
  ISCollapsableWindowJoypad.createChildren(self)

  local titleBarHeight = self:titleBarHeight()

  self.tickBox = ISTickBox:new(10, titleBarHeight + 6, self:getWidth() - 20, 0, "", self, self.onTickBox)
  self.tickBox:initialise()

  self:addChild(self.tickBox)
  for index, value in ipairs(self.values) do
    self.tickBox:addOption(value, value)
  end

  self:setHeight(self.tickBox:getHeight() + titleBarHeight + 10)
end

function MultiSelectModal:onMouseDownOutside(x, y)
	self:close()
	return true
end

function MultiSelectModal:close()
  self:removeFromUIManager()
end

function MultiSelectModal:new(name, values)
  local width = 260
  local height = 180
  local x = getCore():getScreenWidth() / 2 - (width / 2);
  local y = getCore():getScreenHeight() / 2 - (height / 2);
  local o = ISCollapsableWindowJoypad.new(self, x, y, width, height)
  o.values = values
  o.title = "Set Values for: " .. name;
  o:setResizable(false)
  return o
end
