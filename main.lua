require("Ball")
require("Board")

function main()
	local initScene = CCScene:create()
	local gameScene = CCScene:create()
	local endScene  = CCScene:create()

	local director = CCDirector:sharedDirector()

	-- local initSceneLayer = CCLayer:create()
	-- local initSceneColorLayer = CCLayerColor:create(ccc4(128,128,128,255))
	-- initSceneColorLayer:setPosition(CCPoint(0,0))
	-- initScene:addChild(initSceneLayer)

	-- local scale = CCSize(rate, rate)

	local boardLayer = CCLayerColor:create(ccc4(255,255,255,128))
	local boardSprit = Board()
	
	scaleRate = director:getWinSize().width / boardSprit:boundingBox().size.width
	boardSprit:setScale(scaleRate)
	-- boardSprit:setScaleY(director:getWinSize().width / boardSprit:boundingBox().size.width)
	-- local boardLayer = Board()
	-- local boardSprit = Board()

	boardSprit:setPosition(CCPoint(director:getWinSize().width / 2, director:getWinSize().height / 2))
	boardLayer:addChild(boardSprit)

	boardLayer:setPosition(CCPoint(0, 0))
	initScene:addChild(boardLayer)

	boardLayer:setTouchEnabled(true)
	boardLayer:registerScriptTouchHandler(function(e, x, y)
		local tp = CCPoint(x, y)
		if boardSprit:boundingBox():containsPoint(tp) then 
			local relativePos = CCPoint(tp.x - director:getWinSize().width / 2 + boardSprit:boundingBox().size.width / 2, 
				tp.y - director:getWinSize().height / 2 + boardSprit:boundingBox().size.height / 2)
			boardSprit.touchBall(e, relativePos.x / scaleRate, relativePos.y / scaleRate)
		end
	end)


	for i=1,3 do
		-- boardSprit:addBall(i, i)
		boardSprit:randAdd()
	end
	-- boardSprit:move();


	director:setDisplayStats(false)
	director:runWithScene(initScene)
end


main()