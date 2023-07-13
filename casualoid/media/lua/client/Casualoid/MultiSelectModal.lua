require "ISUI/ISCollapsableWindowJoypad"

MultiSelectModal = ISCollapsableWindowJoypad:derive("MultiSelectModal")

function MultiSelectModal:createChildren()
  ISCollapsableWindowJoypad.createChildren(self)

  local titleBarHeight = self:titleBarHeight()

  self.tickBox = ISTickBox:new(10, titleBarHeight + 6, self:getWidth() - 20, 0, "", self, self.onTicked)
  self.tickBox:initialise()

  self:addChild(self.tickBox)

  local res = CasualoidParseSandboxString(self.selectedValuesString)
  
  for _, value in ipairs(self.options) do
    local tBoxOption = self.tickBox:addOption(value:getLabel(), value:getType(), value:getTexture())
    self.tickBox:setSelected(tBoxOption, res.map[value:getType()])
  end

  self:setHeight(self.tickBox:getHeight() + titleBarHeight + 10)
end

function MultiSelectModal:onTicked()
  local string = ''
  for i, isSelected in pairs(self.tickBox.selected) do
    if isSelected then
      string = self.tickBox.optionData[i] .. ';' .. string
    end
  end

  CasualoidPrint('MultiSelectModal:onTicked.string', string)
end

function MultiSelectModal:onMouseDownOutside()
  self:close()
  return true
end

function MultiSelectModal:close()
  self:removeFromUIManager()
end

function MultiSelectModal:new(name, selectedValuesString, options)
  local width = 260
  local height = 180
  local x = getCore():getScreenWidth() / 2 - (width / 2);
  local y = getCore():getScreenHeight() / 2 - (height / 2);
  local o = ISCollapsableWindowJoypad.new(self, x, y, width, height)
  o.selectedValuesString = selectedValuesString
  o.options = options
  o.title = name;
  o.backgroundColor = {r=0, g=0, b=0, a=0.95};
  o:setResizable(false)
  return o
end
