module ( "astar", package.seeall )

INF = 1/0
function distance( p1, p2 )
	return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end
function heuristic_cost_estimate( start, goal )
	return distance(start, goal)
end
function lowest_f_score( openset, f_score)
	local lowest, bestNode = INF, nil
	for _, node in ipairs(openset) do
		if f_score[ node ] < lowest then
			lowest, bestNode = f_score[ node ], node
		end
	end
	return bestNode
end
function remove_node( openset, node )
	for k,n in ipairs( openset ) do
		if n == node then
			table.remove(openset, k)
		end
	end
end
function not_in( set, node )
	for _, n in pairs(set) do
		if node == n then
			return false
		end
	end
	-- print("Node ", node.x, node.y, " not in set")
	return true
end
function unwind_path( flat_path, parent, current )
	if parent[ current ] then
		table.insert(flat_path, 1, parent[ current ])
		return unwind_path( flat_path, parent, parent[ current ])
	else
		return flat_path
	end
end

function dump_parent( parent )
	for k,v in pairs(parent) do
		-- print("From ", v.x, v.y, " To ", k.x, k.y)
	end
	print("===")
end
function path( start, goal, map, valid_neighbor_func )
	local closeset = {}
	local openset  = { start }
	local parent   = {}

	-- print(start.x, start.y)
	local g_score, f_score = {}, {}
	g_score[ start ] = 0
	f_score[ start ] = g_score [ start ] + heuristic_cost_estimate(start, goal)

	while #openset > 0 do
		local current = lowest_f_score ( openset, f_score )
		-- print("current: ", current.x, current.y)
		-- print("goal: ", goal[1], goal[2])
		if current == goal then
			local path = unwind_path({}, parent, goal)
			-- dump_parent(parent)
			table.insert(path, goal)
			return path 
		end

		remove_node( openset, current)
		-- dump_set(openset)
		table.insert( closeset, current)

		local neighbors = valid_neighbor_func( current, map )
		for _, neb in pairs(neighbors) do
			if not_in(closeset, neb) then
				local tmp_g_score = g_score[ current ] + distance( current, neb)
				if not_in(openset, neb) or tmp_g_score < g_score[ neb ] then
					-- print("parent[ net ] ", current.x, current.y)
					parent[ neb ] = current
					g_score[ neb ] = tmp_g_score
					f_score[ neb ] = g_score[ neb ] + heuristic_cost_estimate(neb, goal)
					if not_in(openset, neb) then
						table.insert(openset, neb)
					end
				end
			end
		end
		-- break
	end
	return nil
end
