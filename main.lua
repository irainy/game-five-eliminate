require("Welcome")
require("Gameover")

require("Ball")
require("Board")


local function GameScene( )
	local director = CCDirector:sharedDirector()
	local self = CCScene:create()

	local boardLayer = CCLayer:create() --CCLayerColor:create(ccc4(255,255,255,128))
	local background = CCSprite:create("background.png")
	background:setAnchorPoint(CCPoint(0, 0))
	background:setPosition(CCPoint(0, 0))

	boardLayer:addChild(background)
	local boardSprit = Board()

	scaleRate = director:getWinSize().width / boardSprit:boundingBox().size.width
	boardSprit:setScale(scaleRate)
	boardSprit:setAnchorPoint(CCPoint(0.5, 0.5))

	boardSprit:setPosition(CCPoint(director:getWinSize().width / 2, director:getWinSize().height / 2))
	boardLayer:addChild(boardSprit)
	boardLayer:setPosition(CCPoint(0, 0))

	local restartBtn = CCSprite:create("restart.png")
	restartBtn:setAnchorPoint(CCPoint(0, 0))
	local labelScore = CCLabelBMFont:create("0", "markerFelt.fnt")
	local textScore = CCLabelBMFont:create("Score:", "markerFelt.fnt")

	labelScore:setPosition(CCPoint(director:getWinSize().width - labelScore:getContentSize().width * 10, boardSprit:getPositionY() + boardSprit:getContentSize().height / 2 + restartBtn:getContentSize().height))
	textScore:setPosition(CCPoint(labelScore:getPositionX() - labelScore:getContentSize().width - textScore:getContentSize().width - 10, labelScore:getPositionY()))
	restartBtn:setPosition(CCPoint(restartBtn:getContentSize().width, labelScore:getPositionY()))
	labelScore:setScale(2)
	textScore:setScale(2)
	restartBtn:setScale(1.5)

	boardLayer:addChild(restartBtn)
	boardLayer:addChild(textScore)
	boardLayer:addChild(labelScore)

	local function updateScore( score, free )
		labelScore:setString(score)
		if free == 0 then
			director:replaceScene(GameoverScene( restartGame ))
		end
	end

	boardLayer:setTouchEnabled(true)
	boardLayer:registerScriptTouchHandler(function(e, x, y)
		local tp = CCPoint(x, y)
		if boardSprit:boundingBox():containsPoint(tp) then 
			local relativePos = CCPoint(tp.x - director:getWinSize().width / 2 + boardSprit:boundingBox().size.width / 2, 
				tp.y - director:getWinSize().height / 2 + boardSprit:boundingBox().size.height / 2)
			boardSprit.touchBall(e, relativePos.x / scaleRate, relativePos.y / scaleRate, updateScore)
		end

		if restartBtn:boundingBox():containsPoint(tp) then
			restartGame()
		end
	end)

	for i=1,80 do
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

function restartGame(  )
	CCDirector:sharedDirector():replaceScene(GameScene())
end
function startGame(  )
	CCDirector:sharedDirector():replaceScene(GameScene())
end
function main()
	local director = CCDirector:sharedDirector()
	director:setDisplayStats(false)
	director:runWithScene(Welcome(startGame))
end


main()