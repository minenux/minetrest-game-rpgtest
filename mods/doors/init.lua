doors = {}

function doors.register_door(name, def)
	minetest.register_node(name, {
		description = def.description,	
		tiles = def.tiles,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-8/16,-8/16,6/16,8/16,8/16,8/16}
			},
		},
		groups = def.groups,

		on_rightclick = function(pos, node, player, pointed_thing)
			local n = minetest.get_node(pos)
			n.name = name.."_open"
			minetest.swap_node(pos, n)

			local below = minetest.get_node(vector.new(pos.x, pos.y-1, pos.z)).name
			local above = minetest.get_node(vector.new(pos.x, pos.y+1, pos.z)).name
			if below and minetest.registered_nodes[below] and minetest.registered_nodes[below].doors_open then
				minetest.registered_nodes[below].doors_open(vector.new(pos.x, pos.y-1, pos.z))
			end
			if above and minetest.registered_nodes[above] and minetest.registered_nodes[above].doors_open then
				minetest.registered_nodes[above].doors_open(vector.new(pos.x, pos.y+1, pos.z))
			end
		end,

		doors_open = function(pos)
			local n = minetest.get_node(pos)
			n.name = name.."_open"
			minetest.swap_node(pos, n)

			local below = minetest.get_node(vector.new(pos.x, pos.y-1, pos.z)).name
			local above = minetest.get_node(vector.new(pos.x, pos.y+1, pos.z)).name
			if below and minetest.registered_nodes[below] and minetest.registered_nodes[below].doors_open then
				minetest.registered_nodes[below].doors_open(vector.new(pos.x, pos.y-1, pos.z))
			end
			if above and minetest.registered_nodes[above] and minetest.registered_nodes[above].doors_open then
				minetest.registered_nodes[above].doors_open(vector.new(pos.x, pos.y+1, pos.z))
			end
		end,
	})

	minetest.register_node(name.."_open", {
		description = def.description,	
		tiles = def.tiles,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{6/16,-8/16,-8/16,8/16,8/16,8/16}
			},
		},
		drop = name,
		groups = def.groups,

		on_rightclick = function(pos, node, player, pointed_thing)
			local n = minetest.get_node(pos)
			n.name = name
			minetest.swap_node(pos, n)

			local below = minetest.get_node(vector.new(pos.x, pos.y-1, pos.z)).name
			local above = minetest.get_node(vector.new(pos.x, pos.y+1, pos.z)).name
			if below and minetest.registered_nodes[below] and minetest.registered_nodes[below].doors_close then
				minetest.registered_nodes[below].doors_close(vector.new(pos.x, pos.y-1, pos.z))
			end
			if above and minetest.registered_nodes[above] and minetest.registered_nodes[above].doors_close then
				minetest.registered_nodes[above].doors_close(vector.new(pos.x, pos.y+1, pos.z))
			end
		end,

		doors_close = function(pos)
			local n = minetest.get_node(pos)
			n.name = name
			minetest.swap_node(pos, n)

			local below = minetest.get_node(vector.new(pos.x, pos.y-1, pos.z)).name
			local above = minetest.get_node(vector.new(pos.x, pos.y+1, pos.z)).name
			if below and minetest.registered_nodes[below] and minetest.registered_nodes[below].doors_close then
				minetest.registered_nodes[below].doors_close(vector.new(pos.x, pos.y-1, pos.z))
			end
			if above and minetest.registered_nodes[above] and minetest.registered_nodes[above].doors_close then
				minetest.registered_nodes[above].doors_close(vector.new(pos.x, pos.y+1, pos.z))
			end
		end,
	})
end

doors.register_door("doors:wood", {
	description = "Wooden Door",
	tiles = {"default_wooden_planks.png"},
	groups = {choppy = 3},
})

doors.register_door("doors:jungle_wood", {
	description = "Jungle Wood Door",
	tiles = {"default_wooden_planks_jungle.png"},
	groups = {choppy = 3},
})

doors.register_door("doors:glass", {
	description = "Glass Door",
	tiles = {"default_glass.png"},
	groups = {snappy = 3},
})

doors.register_door("doors:stonebrick", {
	description = "Stonebrick Door",
	tiles = {"default_stonebrick.png"},
	groups = {cracky = 3},
})
