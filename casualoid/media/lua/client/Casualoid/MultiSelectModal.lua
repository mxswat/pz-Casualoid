require "ISUI/ISCollapsableWindowJoypad"

MultiSelectModal = ISCollapsableWindowJoypad:derive("MultiSelectModal")

function MultiSelectModal:createChildren()
  ISCollapsableWindowJoypad.createChildren(self)

  local titleBarHeight = self:titleBarHeight()

  self.scrollView = CasualoidScrollView:new(0, titleBarHeight, self:getWidth(), self:getHeight())
	self.scrollView:initialise()
	self:addChild(self.scrollView)

  self.tickBox = ISTickBox:new(8, 4, self:getWidth(), 0, "", self, self.onTicked)
  self.tickBox:initialise()

  local text = self.control:getText()
  CasualoidPrint('self.control:getText(): ', text)
  local parsed = CasualoidParseSandboxString(text)
  for _, value in ipairs(self.options) do
    local tBoxOption = self.tickBox:addOption(value:getLabel(), value:getType(), value:getTexture())
    self.tickBox:setSelected(tBoxOption, parsed.map[value:getType()])
  end

  self.scrollView:addScrollChild(self.tickBox)
  self.scrollView:setScrollHeight((#self.options * self.tickBox.itemHgt) + 8)
  self:setHeight(self:getHeight() + titleBarHeight)
end

function MultiSelectModal:onTicked()
  local string = ''
  for i, isSelected in pairs(self.tickBox.selected) do
    if isSelected then
      string = self.tickBox.optionData[i] .. ';' .. string
    end
  end

  self.control:setText(string)
  CasualoidPrint('MultiSelectModal:onTicked.string', string)
end

function MultiSelectModal:onMouseDownOutside()
  self:close()
  return true
end

function MultiSelectModal:close()
  self:removeFromUIManager()
end

function MultiSelectModal:new(name, control, options)
  local width = control:getWidth()
  local height = 400
  local x = getCore():getScreenWidth() / 2 - (width / 2);
  local y = getCore():getScreenHeight() / 2 - (height / 2);
  local o = ISCollapsableWindowJoypad.new(self, x, y, width, height)
  o.control = control
  o.options = options
  o.title = name;
  o.backgroundColor = {r=0, g=0, b=0, a=0.95};
  o:setResizable(false)
  return o
end
