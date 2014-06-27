require("Ball")
require("Board")


local function GameScene( director )
	local self = CCScene:create()

	local boardLayer = CCLayerColor:create(ccc4(255,255,255,128))
	local boardSprit = Board()

	local labelScore = CCLabelAtlas:create("0", "numbers.png", 12, 32, 46);
	labelScore:setPosition(CCPoint(director:getWinSize().width - 200, director:getWinSize().height - 100))
	labelScore:setScale(2)
	boardLayer:addChild(labelScore)

	local function updateScore( score )
		labelScore:setString(score)
	end

	scaleRate = director:getWinSize().width / boardSprit:boundingBox().size.width
	boardSprit:setScale(scaleRate)

	boardSprit:setPosition(CCPoint(director:getWinSize().width / 2, director:getWinSize().height / 2))
	boardLayer:addChild(boardSprit)
	boardLayer:setPosition(CCPoint(0, 0))

	boardLayer:setTouchEnabled(true)
	boardLayer:registerScriptTouchHandler(function(e, x, y)
		local tp = CCPoint(x, y)
		if boardSprit:boundingBox():containsPoint(tp) then 
			local relativePos = CCPoint(tp.x - director:getWinSize().width / 2 + boardSprit:boundingBox().size.width / 2, 
				tp.y - director:getWinSize().height / 2 + boardSprit:boundingBox().size.height / 2)
			boardSprit.touchBall(e, relativePos.x / scaleRate, relativePos.y / scaleRate, updateScore)
		end
	end)

	for i=1,3 do
		boardSprit:randAdd()
	end

	self:addChild(boardLayer)

	-- key binding
	-- boardLayer:setKeypadEnabled(true)
	-- boardLayer.keyBackClicked = function(self)
	-- 	print("back pressed")
	-- 	director:endToLua()
	-- end
	return self
end

function main()
	local director = CCDirector:sharedDirector()

	local initScene = CCScene:create()
	local gameScene = GameScene( director )
	local endScene  = CCScene:create()

	director:setDisplayStats(false)
	director:runWithScene(gameScene)
end


main()