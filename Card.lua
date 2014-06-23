function Card(num)

  local self = CCSprite:create()
  local face, bg
  
  local function init()
    self.num = num
    self:setContentSize(CCSizeMake(80, 80))
    self:setAnchorPoint(ccp(0,0))

    face = CCLabelTTF:create(num, "Courier", 50)
    face:setPosition(ccp(40,40))
    self:addChild(face)

    bg = CCSprite:create()
    bg:setTextureRect(CCRectMake(0,0,80,80))
    bg:setAnchorPoint(ccp(0,0))
    --		bg:setColor(ccc3{255,255,255})
    self:addChild(bg)

    self:showBg()
  end


  self.showFace = function ()
    face:setVisible(true)
    bg:setVisible(false)
  end

  self.showBg = function ()
    face:setVisible(false)
    bg:setVisible(true)
  end


  init()

  return self
end