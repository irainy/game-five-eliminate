function GameoverScene( directorHandler )
	local director = CCDirector:sharedDirector()
	local self = CCScene:create()
	local bgLayer = CCLayer:create()
	local bgSprite = CCSprite:create("background.png")

	local overTxt = CCSprite:create("txt_gameover.png")
	local restartBtn = CCSprite:create("restart.png")
	restartBtn:setScale(2)
	restartBtn:setAnchorPoint(CCPoint(0.5, 0.5))

	overTxt:setAnchorPoint(CCPoint(0.5, 0.5))
	overTxt:setPosition(CCPoint(director:getWinSize().width / 2, director:getWinSize().height * 0.75))
	restartBtn:setPosition(CCPoint(director:getWinSize().width / 2, director:getWinSize().height * 0.25))

	bgSprite:setAnchorPoint(CCPoint(0, 0))
	bgSprite:setPosition(CCPoint(0, 0))
	bgLayer:setAnchorPoint(CCPoint(0, 0))
	bgLayer:setPosition(CCPoint(0, 0))

	local sr = director:getWinSize().width / bgSprite:getContentSize().width
	bgSprite:setScale(sr)


	bgLayer:setTouchEnabled(true)
	bgLayer:registerScriptTouchHandler(function ( e, x, y )
		if restartBtn:boundingBox():containsPoint(CCPoint(x, y)) then
			directorHandler()
		end
	end)

	bgLayer:addChild(bgSprite)
	bgLayer:addChild(restartBtn)
	bgLayer:addChild(overTxt)
	self:addChild(bgLayer)
	return self
end