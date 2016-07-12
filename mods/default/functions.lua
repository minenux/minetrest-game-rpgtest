default.LIGHT_MAX = 14

function default.drop_items(pos, oldnode, oldmetadata, digger)
	local meta = minetest.get_meta(pos)
	meta:from_table(oldmetadata)
	local inv = meta:get_inventory()
	for i = 1, inv:get_size("main") do
		local stack = inv:get_stack("main", i)
		if not stack:is_empty() then
			local p = {	x = pos.x + math.random(0, 5)/5 - 0.5,
					y = pos.y, 
					z = pos.z + math.random(0, 5)/5 - 0.5
				  }
			minetest.add_item(p, stack)
		end
	end
end

function default.register_fence(name,def)
	def.description = def.description or minetest.registered_nodes[def.material].description .. " Fence"
	def.tiles = def.tiles or minetest.registered_nodes[def.material].tiles
	def.groups = def.groups or minetest.registered_nodes[def.material].groups
	def.sounds = def.sounds or minetest.registered_nodes[def.material].sounds
	def.drawtype = "nodebox"
	def.node_box = {
		type = "connected",
		fixed = {{-3/16, -0.5, -3/16, 3/16, 0.5, 3/16}},
		connect_front = {{-2/16,-0.5,-1/2,2/16,0.5,-2/16}},
		connect_left = {{-1/2,-0.5,-2/16,-2/16,0.5,2/16}},
		connect_back = {{-2/16,-0.5,2/16,2/16,0.5,1/2}},
		connect_right = {{2/16,-0.5,-2/16,1/2,0.5,2/16}},
	}
	def.paramtype = "light"
	def.connects_to = {name, "group:cracky", "group:choppy"}

	minetest.register_node(name, def)

	minetest.register_craft({
		output = name .. " 12",
		recipe = {
			{def.material, def.material, def.material},
			{def.material, def.material, def.material}
		}
	})
end

default.sounds = {}

function default.sounds.wood(t)
	t = t or {}
	t.dug = table.dug or
			{name = "default_wood_1", gain = 0.25}
	t.place = table.place or
			{name = "default_wood_1", gain = 0.7}
	t.footstep = t.footstep or
			{name = "default_stone_2", gain = 0.1}
	return t
end

function default.sounds.stone(t)
	t = t or {}
	t.dig = table.dug or
			{name = "default_stone_2", gain = 0.08}
	t.dug = table.dug or
			{name = "default_stone_2", gain = 0.2}
	t.place = table.place or
			{name = "default_stone_1", gain = 0.5}
	t.footstep = t.footstep or
			{name = "default_stone_2", gain = 0.2}
	return t
end

function default.sounds.dirt(t)
	t = t or {}
	t.dug = table.dug or
			{name = "default_dirt_1", gain = 0.25}
	t.place = table.place or
			{name = "default_dirt_1", gain = 0.5}
	t.footstep = t.footstep or
			{name = "default_dirt_1", gain = 0.1}
	return t
end

default.node_sound_stone_defaults = default.sounds.stone
default.node_sound_dirt_defaults = default.sounds.dirt
default.node_sound_wood_defaults = default.sounds.wood

default.node_sound_sand_defaults = default.sounds.dirt
default.node_sound_gravel_defaults = default.sounds.dirt
default.node_sound_leaves_defaults = default.sounds.dirt
default.node_sound_glass_defaults = default.sounds.dirt
