function Welcome( directorHandler )
	local director = CCDirector:sharedDirector()
	local self = CCScene:create()
	local bgLayer = CCLayer:create()
	local bgSprite = CCSprite:create("background.png")

	local startBtn= CCSprite:create("play.png")
	startBtn:setScale(1.5)
	startBtn:setAnchorPoint(CCPoint(0.5, 0.5))
	startBtn:setPosition(director:getWinSize().width / 2, director:getWinSize().height * 0.25)

	bgSprite:setAnchorPoint(CCPoint(0, 0))
	bgSprite:setPosition(CCPoint(0, 0))
	local sr = director:getWinSize().width / bgSprite:getContentSize().width
	bgSprite:setScale(sr)

	bgLayer:setAnchorPoint(CCPoint(0, 0))
	bgLayer:setPosition(CCPoint(0, 0))

	bgLayer:setTouchEnabled(true)
	bgLayer:registerScriptTouchHandler(function ( e, x, y )
		if startBtn:boundingBox():containsPoint(CCPoint(x, y)) then
			directorHandler()
		end
	end)

	bgLayer:addChild(bgSprite)
	bgLayer:addChild(startBtn)
	self:addChild(bgLayer)
	return self
end