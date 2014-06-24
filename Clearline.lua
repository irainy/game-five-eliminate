module ( "cll", package.seeall )

function valid_range( y, size )
	return y > 0 and y <= size
end

function linpos( pos, size)
	local row, col, dia, udi = {}, {}, {}, {}
	for x = 1, size do
		local p1, p2, p3, p4 = {x, pos.y}, {pos.x, x}, {x, x + pos.y - pos.x}, {x, pos.x + pos.y - x}
		if valid_range( p1[2], size ) then
			table.insert(row, p1)
		end
		if valid_range( p2[2], size ) then
			table.insert(col, p2)
		end
		if valid_range( p3[2], size ) then
			table.insert(dia, p3)
		end
		if valid_range( p4[2], size ) then
			table.insert(udi, p4)
		end
	end
	return { row, col, dia, udi }
end

function find_line( pos, map, score, samecolor_valid )
	local size = #map
	local dirs = linpos( pos, size)
	local scoreLine = {}

	for k,v in pairs(dirs) do
		local start = {0, 0}
		local len   = 1
		local t = { }
		for i,g in ipairs(v) do
			local cursor = g
			-- print(start[1], start[2])
			-- print(cursor[1], cursor[2])
			-- print(samecolor_valid(start, cursor, map))
			if samecolor_valid(start, cursor, map) then
				len = len + 1
				table.insert(t, cursor)
				print("match ", len)
			elseif len >= score then
				print("got a line ", len)
				-- table.insert(t, 1, start)
				-- table.insert(scoreLine, t)
				break
			else
				t, start, len = { }, cursor, 1
			end
		end
		if len >= score then
			table.insert(t, 1, start)
			table.insert(scoreLine, t)
		end
	end
	return #scoreLine > 0 and scoreLine or nil

end