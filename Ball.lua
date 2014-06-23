function Ball(color)
	-- 0-blue; 1-red; 2-green; 3-yellow; 4-purple

	local self = CCSprite:create()
	self.color = color
	self.pos   = CCPoint(0,0)
	local img, ball
	if color == 0  then
		img = "ball_blue.png"
	elseif color == 1  then
		img = "ball_red.png"
	elseif color == 2 then
		img = "ball_green.png"
	elseif color == 3 then
		img = "ball_yellow.png"
	elseif color == 4 then
		img = "ball_purple.png"
	end

	ball = CCSprite:create(img)
	ball:setAnchorPoint(CCPoint(0, 0))
	ball:setPosition(CCPoint(0, 0))

	self:addChild(ball)
	return self
end