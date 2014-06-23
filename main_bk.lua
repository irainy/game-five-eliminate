require("Card")

function main()

  local scene = CCScene:create()
  local layer
  local allPoints
  local allCards = {}

  local function getAllPoints()
    allPoints = {}
    for i=0, 9 do
      for j=0, 5  do
        table.insert(allPoints, 1, CCPoint(i*80, j*80))
      end
    end
  end

  local function addCards()
    local c
    local randInd
    local p

    math.randomseed(os.time())

    for var=1, 5 do
      c = Card(var)
      layer:addChild(c)

      randInd = math.random(table.maxn(allPoints))
      p = table.remove(allPoints, randInd)
      c:setPosition(p)

      table.insert(allCards, 1, c)
    end
  end


  local function onTouch(type, x, y)
    local p = CCPoint(x, y)
    for key, var in pairs(allCards) do
      if var:boundingBox():containsPoint(p) then
        var:showFace()
        break
      end
    end
  end
  local function startGame()
    getAllPoints()
    addCards()
  end

  local function init()
    layer = CCLayer:create()
    scene:addChild(layer)

    --    local sprite = CCSprite:create("bookstar.png")
    --    sprite:setPosition(ccp(200,200))
    --    layer:addChild(sprite)

    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(onTouch)

    startGame()

  end



  init()

  return scene
end

function __main()

  local director = CCDirector:sharedDirector()
  director:setDisplayStats(false)
  director:runWithScene(main())
  --  CCEGLView:sharedOpenGLView():setDesignResolutioSize(400,800)
end

__main()