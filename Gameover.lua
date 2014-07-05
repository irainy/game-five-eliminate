function GameoverScene(  )
	local self = CCScene:create()
	local bgLayer = CCLayer:create()
	local bgSprite = CCSprite:create("over.jpg")
	bgSprite:setAnchorPoint(CCPoint(0, 0))
	bgSprite:setPosition(CCPoint(0, 0))
	bgLayer:setAnchorPoint(CCPoint(0, 0))
	bgLayer:setPosition(CCPoint(0, 0))

	local director = CCDirector:sharedDirector()
	local sr = director:getWinSize().width / bgSprite:getContentSize().width

	bgSprite:setScale(sr)

	bgLayer:addChild(bgSprite)
	self:addChild(bgLayer)
	return self
end