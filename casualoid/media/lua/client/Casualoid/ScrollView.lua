require "ISUI/ISUIElement"

-- Based on: NotlocScrollView.lua
-- Full credits to Notloc -> https://steamcommunity.com/sharedfiles/filedetails/?id=2950902979

CasualoidScrollView = ISUIElement:derive("CasualoidScrollView");

function CasualoidScrollView:new(x, y, w, h)
	local o = {};
	o = ISUIElement:new(x, y, w, h);
	setmetatable(o, self);
	self.__index = self;

	o.scrollChildren = {};
	o.lastY = 0;

	o.scrollSensitivity = 40;

	return o;
end

function CasualoidScrollView:createChildren()
	ISUIElement.createChildren(self);
	self:addScrollBars();
end

function CasualoidScrollView:addScrollChild(child)
	self:addChild(child);
	table.insert(self.scrollChildren, child);

	local y = self:getYScroll()
	child.keepOnScreen = false
	child:setY(child:getY() + y)
end

function CasualoidScrollView:removeScrollChild(child)
	self:removeChild(child);
	for i, v in ipairs(self.scrollChildren) do
		if v == child then
			table.remove(self.scrollChildren, i);
			return
		end
	end
end

function CasualoidScrollView:isChildVisible(child)
	local childY = child:getY()
	local childH = child:getHeight()
	local selfH = self:getHeight()
	return childY + childH > 0 and childY < selfH
end

function CasualoidScrollView:prerender()
	self:setStencilRect(0, 0, self.width, self.height);
	self:updateScrollbars();

	local deltaY = self:getYScroll() - self.lastY
	for _, child in pairs(self.scrollChildren) do
		child:setY(child:getY() + deltaY)
	end
	self.lastY = self:getYScroll()

	ISUIElement.prerender(self)
end

function CasualoidScrollView:render()
	ISUIElement.render(self);
	self:clearStencilRect();
end

function CasualoidScrollView:onMouseWheel(del)
	self:setYScroll(self:getYScroll() - (del * self.scrollSensitivity));
	return true;
end
