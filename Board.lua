require("Astar")
require("Ball")
require("Clearline")

function Board( RATE )
	-- Size(9, 9)
	math.randomseed(os.time())
	-- local self = CCLayer:create()

	-- init board background
	-- local self = CCLayerColor:create(ccc4(255,255,255,128))
	self = CCSprite:create("board.png")
	-- self:setPosition(CCPoint(320,480))
	-- self:addChild(self.background)

	-- board parameters
	self.SIZE = 9
	self.map = {}
	self.free = {}
	self.ballSelected = nil	-- which ball is selected
	self.randAdded = {}
	self.scoreLines = {}
	self.score = 0

	function initContainer( )
		for i=1,self.SIZE do
			self.map[i] = {}
			for j=1,self.SIZE do
				self.map[ i ][ j ] = {ball=nil, pos=CCPoint(i, j)}
				table.insert(self.free, 1, CCPoint(i, j))
			end
		end
	end

	-- Touch and Move
	function valid_neighbors( cur, map )
		-- print("Neighbor of", cur.x, cur.y)
		local neighbor = {{cur.x, cur.y + 1},	-- up
							{cur.x, cur.y - 1}, -- down
							{cur.x - 1, cur.y}, -- left
							{cur.x + 1, cur.y}}	-- right
		local valid = {}
		for k,n in pairs(neighbor) do
			if n[1] > 0 and n[1] <= #map and n[2] > 0 and n[2] <= #map and map[n[1]][n[2]].ball == nil then
				table.insert(valid, map[ n[ 1 ] ][ n[ 2 ] ].pos)
			end
		end
		return valid
	end
	function samecolor_valid( p1, p2, map )
		if p1[1] == 0 then return false end
		local ball1 = map[ p1[1] ][ p1[2] ].ball
		local ball2 = map[ p2[1] ][ p2[2] ].ball
		return ball1 ~= nil and ball2 ~= nil and ball1.color == ball2.color
	end
	function self:checkClear()
		if #self.scoreLines == 0 then return nil end
		for _,line in pairs(self.scoreLines) do
			for k,v in pairs(line) do
				self.score = self.score + #v * 20 - 50
				for _,g in pairs(v) do
					print("Clear ", g[1], g[2])
					self:removeBall(CCPoint(g[1], g[2]))
				end
			end
		end
		self.scoreLines = { }
	end

	function self.touchBall( e, x, y, callback)
		local touchPos = self:pixTopos(x, y)
		if self:posIsFree(touchPos) then
			if self.ballSelected ~= nil then
				local currPos = self.map[self.ballSelected.pos.x][self.ballSelected.pos.y].pos
				local goalPos = touchPos
				local path = astar.path(currPos, goalPos, self.map, valid_neighbors)

				if path then
					self:freeBall(self.ballSelected)	-- free old position
					self.ballSelected.pos = goalPos -- update ball's position
					self:occupyBall(self.ballSelected) -- occupy new position

					table.insert(self.scoreLines, cll.find_line(goalPos, self.map, 5, samecolor_valid))
					self:moveBall(self.ballSelected, goalPos, path, callback)
					
					self.ballSelected = nil -- set unselected
				end
				-- self.ballSelected = nil
			end
		else
			self.ballSelected = self.map[touchPos.x][touchPos.y].ball
			-- print("Pos is NOT Free")
		end
	end

	initContainer()
	-- self:setTouchEnabled(true)
	-- self:registerScriptTouchHandler(touchBall)

	function self:randAdd()
		if #self.free <= 0 then return nil end
		local randFree = math.random(1, #self.free)
		local pos = table.remove(self.free, randFree)

		self:addBall( pos.x, pos.y, 1)--math.random(0, 4))
		return pos
		-- table.insert(self.randAdded, pos)
	end
	function self:randAddThree()
		for i=1,3 do
			local pos = self:randAdd()
			table.insert(self.scoreLines, cll.find_line(pos, self.map, 5, samecolor_valid))
		end
	end
	function self:addBall( i, j, color)
		if not color then color = 0 end
		local ball = Ball(color)
		ball.pos = CCPoint(i,j)
		ball:setPosition(self:posTopix(i, j))
		self:addChild(ball)

		self:occupyBall(ball)
	end
	function self:removeBall( pos )
		local ball = self.map[pos.x][pos.y].ball
		self:freeBall(ball)
		self:removeChild(ball, true)
	end

	function self:moveOne( ball, dir )
		if dir == "LEFT" then
			print("left")
			ball:setPosition(self:posTopix(ball.pos.x - 1, ball.pos.y))
		end
	end

	
	function self:posIsFree( pos )
		if pos.x > self.SIZE or pos.x <= 0 or pos.y > self.SIZE or pos.y <= 0 or #self.free == 0 then
			-- print "Out of boundary"
			return false
		end
		for k, v in pairs(self.free) do
			-- print(k)
			if self:posEqual(pos, v) then
				-- print "This pos is free"
				return true
			end
		end
		-- print "End of loop"
		return false
	end

	function self:moveBall( ball, dest, path, callback)
		-- ball:setPosition(self:posTopix(dest.x, dest.y))
		local pa = CCArray:create()
		for k,v in pairs(path) do
			local mb = CCMoveTo:create(0.2 / #path, self:posTopix(v.x, v.y))
			pa:addObject(mb)
		end
		local ccl = CCCallFunc:create(function()
			self:checkClear()
			callback(self.score)
		end)
		pa:addObject(ccl)

		if self.scoreLines == nil then print("scorelines is nil") else print("#scorelines = ", #self.scoreLines) end
		-- if self.scoreLines == nil or #self.scoreLines == 0 then
		if #self.scoreLines == 0 then
			local randomAdd = CCCallFunc:create(function() self:randAddThree() end)
			pa:addObject(randomAdd)
			pa:addObject(ccl)
			-- self.scoreLines = { }
		end
		-- local action = CCCardinalSplineBy:create(6, pa, 7)
		-- local reverse = action:reverse()
		local seq    = CCSequence:create(pa)
		-- local seq    = CCSequence:create(pa)--, reverse)
		-- ball:runAction(cb)
		ball:runAction(seq)
		-- self.scored = false
	end
	function self:freeBall( ball )
		if ball and self.map[ball.pos.x][ball.pos.y].ball then
			self.map[ball.pos.x][ball.pos.y].ball = nil
			table.insert(self.free, 1, ball.pos)
		end
	end
	function self:occupyBall( ball )
		self.map[ball.pos.x][ball.pos.y].ball = ball
		for k,v in pairs(self.free) do
			if self:posEqual(ball.pos, v) then
				table.remove(self.free, k)
			end
		end
	end

	-- position conversion functions
	function self:posTopix(i, j)
		-- return CCPoint((i-1) * 70 + 5, (j-1) * 70 + 5)
		return CCPoint((i-1) * 70 + 5, (j-1) * 70 + 5)
	end
	function self:pixTopos(x, y)
		local i = math.floor((x - 5) / 70 + 1)
		local j = math.floor((y - 5) / 70 + 1)
		print("touched", x, y)
		print("pos", i, j)
		return self.map[i][j].pos
	end
	function self:posEqual( p1, p2 )
		-- return p1 == p2
		return p1.x == p2.x and p1.y == p2.y
	end
	-- end position conversion functions

	return self
end
