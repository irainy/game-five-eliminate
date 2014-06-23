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

	local boardLayer = Board()
	-- local boardSprit = Board()

	
	boardLayer:setPosition(CCPoint(0, 0))
	initScene:addChild(boardLayer)


	for i=1,3 do
		-- boardSprit:addBall(i, i)
		boardLayer:randAdd()
	end
	-- boardSprit:move();

	director:setDisplayStats(false)
	director:runWithScene(initScene)
end


main()