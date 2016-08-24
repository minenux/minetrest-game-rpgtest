local furnace_form = "size[8,9]"
local furnace_form = furnace_form..default.gui_colors
local furnace_form = furnace_form..default.gui_bg
local furnace_form = furnace_form.."list[current_name;main;2,0.3;4,4;]" 
local furnace_form = furnace_form..default.itemslot_bg(2,0.3,4,4)
local furnace_form = furnace_form.."list[current_player;main;0,4.85;8,1;]" 
local furnace_form = furnace_form..default.itemslot_bg(0,4.85,8,1)
local furnace_form = furnace_form.."list[current_player;main;0,6.08;8,3;8]" 
local furnace_form = furnace_form..default.itemslot_bg(0,6.08,8,3)
local furnace_form = furnace_form.."listring[current_name;main]" 
local furnace_form = furnace_form.."listring[current_player;main]"

minetest.register_node("furnace:furnace", {
	description = "Furnace",
	tiles = {"default_stonebrick.png", "default_stonebrick.png", "default_stonebrick.png", "default_stonebrick.png","default_stonebrick.png","furnace_stone_front.png"},
	groups = {cracky = 2},
	paramtype2 = "facedir",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",furnace_form)
		meta:set_string("infotext", "Furnace");
		local inv = meta:get_inventory()
		inv:set_size("main", 4*4)
	end,
	after_dig_node = default.drop_items,
})

minetest.register_abm({
	nodenames = {"furnace:furnace"},
	neighbors = {"group:pattern"},
	interval = 10.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local mymeta = minetest.get_meta(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "lava:lava_source" or minetest.get_node(pos).name == "default:coalblock_glowing" then
			local dir = vector.multiply(minetest.facedir_to_dir(minetest.get_node({x = pos.x, y= pos.y+1, z=pos.z}).param2), -1)
			local patternpos = vector.add(pos, dir)
	
			local pattern = minetest.get_node(patternpos).name
			if pattern == "furnace:pattern_rod" then
				local myinv = mymeta:get_inventory()
				if myinv:contains_item("main", {name = "default:stone_with_iron"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "furnace:iron_rod"})
					myinv:remove_item("main", {name = "default:stone_with_iron"})
				elseif myinv:contains_item("main", {name = "default:stone_with_gold"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "furnace:gold_rod"})
					myinv:remove_item("main", {name = "default:stone_with_gold"})
				elseif myinv:contains_item("main", {name = "default:stone_with_copper"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "furnace:copper_rod"})
					myinv:remove_item("main", {name = "default:stone_with_copper"})
				end
			end
			if pattern == "furnace:pattern_blade" then
				local myinv = mymeta:get_inventory()
				if myinv:contains_item("main", {name = "default:stone_with_iron"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "default:blade"})
					myinv:remove_item("main", {name = "default:stone_with_iron"})
				end
			end

			if pattern == "furnace:pattern_plate" then
				local myinv = mymeta:get_inventory()
				if myinv:contains_item("main", {name = "default:stone_with_iron"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "furnace:iron_plate"})
					myinv:remove_item("main", {name = "default:stone_with_iron"})
				elseif myinv:contains_item("main", {name = "default:stone_with_gold"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "furnace:gold_plate"})
					myinv:remove_item("main", {name = "default:stone_with_gold"})
				elseif myinv:contains_item("main", {name = "default:stone_with_copper"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "furnace:copper_plate"})
					myinv:remove_item("main", {name = "default:stone_with_copper"})
				elseif myinv:contains_item("main", {name = "default:sand"}) then
					minetest.get_meta(patternpos):get_inventory():add_item("main", {name = "default:glass"})
					myinv:remove_item("main", {name = "default:sand"})
				end
			end
		end
	end,
})

local pattern_form = "size[8,9]"
local pattern_form = pattern_form..default.gui_colors
local pattern_form = pattern_form..default.gui_bg
local pattern_form = pattern_form.."list[current_name;main;0,0.3;8,4;]" 
local pattern_form = pattern_form..default.itemslot_bg(0,0.3,8,4)
local pattern_form = pattern_form.."list[current_player;main;0,4.85;8,1;]" 
local pattern_form = pattern_form..default.itemslot_bg(0,4.85,8,1)
local pattern_form = pattern_form.."list[current_player;main;0,6.08;8,3;8]" 
local pattern_form = pattern_form..default.itemslot_bg(0,6.08,8,3)
local pattern_form = pattern_form.."listring[current_name;main]"
local pattern_form = pattern_form.."listring[current_player;main]"

minetest.register_node("furnace:pattern_rod", {
	description = "Pattern for a Rod",
	tiles = {"furnace_pattern_rod.png", "default_wooden_planks.png"},
	groups = {snappy = 3, pattern = 1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",pattern_form)
		meta:set_string("infotext", "Pattern");
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	after_dig_node = default.drop_items,
	on_punch = function(pos, node, player, pointed_thing)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		for i = 1, inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local p = {	x = pos.x + math.random(0, 5)/5 - 0.5,
						y = pos.y+1, 
						z = pos.z + math.random(0, 5)/5 - 0.5
					  }
				minetest.add_item(p, stack)
			end
		end	
		minetest.set_node(pos, {name="furnace:pattern_blade"})
	end,
})

minetest.register_node("furnace:pattern_blade", {
	description = "Pattern for a blade",
	tiles = {"furnace_pattern_blade.png", "default_wooden_planks.png"},
	groups = {snappy = 3, pattern = 1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",pattern_form)
		meta:set_string("infotext", "Pattern");
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	after_dig_node = default.drop_items,
	on_punch = function(pos, node, player, pointed_thing)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		for i = 1, inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local p = {	x = pos.x + math.random(0, 5)/5 - 0.5,
						y = pos.y+1, 
						z = pos.z + math.random(0, 5)/5 - 0.5
					  }
				minetest.add_item(p, stack)
			end
		end

		minetest.set_node(pos, {name="furnace:pattern_plate"})
	end,
	drop = "furnace:pattern_rod",
})

minetest.register_node("furnace:pattern_plate", {
	description = "Pattern for a plate",
	tiles = {"furnace_pattern_plate.png", "default_wooden_planks.png"},
	groups = {snappy = 3, pattern = 1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",pattern_form)
		meta:set_string("infotext", "Pattern");
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	after_dig_node = default.drop_items,
	on_punch = function(pos, node, player, pointed_thing)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		for i = 1, inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local p = {	x = pos.x + math.random(0, 5)/5 - 0.5,
						y = pos.y+1, 
						z = pos.z + math.random(0, 5)/5 - 0.5
					  }
				minetest.add_item(p, stack)
			end
		end
		minetest.set_node(pos, {name="furnace:pattern_rod"})
	end,
	drop = "furnace:pattern_rod",
})

minetest.register_craftitem("furnace:iron_rod", {
	description = "Iron Rod",
	inventory_image = "furnace_iron_rod.png",
})

minetest.register_craftitem("furnace:copper_rod", {
	description = "Copper Rod",
	inventory_image = "furnace_copper_rod.png",
})

minetest.register_craftitem("furnace:gold_rod", {
	description = "Gold Rod",
	inventory_image = "furnace_gold_rod.png",
})

minetest.register_craftitem("furnace:diamond_rod", {
	description = "Diamond Rod",
	inventory_image = "furnace_diamond_rod.png",
})

minetest.register_craftitem("furnace:iron_plate", {
	description = "Iron Plate",
	inventory_image = "furnace_iron_plate.png",
})

minetest.register_craftitem("furnace:gold_plate", {
	description = "Gold Plate",
	inventory_image = "furnace_gold_plate.png",
})

minetest.register_craftitem("furnace:copper_plate", {
	description = "Copper Plate",
	inventory_image = "furnace_copper_plate.png",
})

-- blocks

minetest.register_node("furnace:iron_block", {
	description = "Iron Block",
	tiles = {"furnace_iron_block.png"},
	groups = {cracky = 1},
})

minetest.register_node("furnace:gold_block", {
	description = "Gold Block",
	tiles = {"furnace_gold_block.png"},
	groups = {cracky = 1},
})

minetest.register_node("furnace:copper_block", {
	description = "Copper Block",
	tiles = {"furnace_copper_block.png"},
	groups = {cracky = 1},
})


-- crafting

minetest.register_craft({
	output = "furnace:furnace",
	recipe = {
		{"default:stonebrick", "default:stonebrick", "default:stonebrick"},
		{"default:stonebrick", "", "default:stonebrick"},
		{"default:stonebrick", "default:stonebrick", "default:stonebrick"},
	}
})

minetest.register_craft({
	output = "furnace:pattern_rod",
	recipe = {
		{"default:stonebrick", "", "default:stonebrick"},
		{"default:stonebrick", "default:stonebrick", "default:stonebrick"},
		{"default:wood", "default:wood", "default:wood"},
	}
})

minetest.register_craft({
	output = "furnace:iron_block",
	type = "shapeless",
	recipe = {"default:frame", "furnace:iron_plate", "furnace:iron_plate", "furnace:iron_plate", "furnace:iron_plate", "furnace:iron_plate", "furnace:iron_plate"}
})

minetest.register_craft({
	output = "furnace:gold_block",
	type = "shapeless",
	recipe = {"default:frame", "furnace:gold_plate", "furnace:gold_plate", "furnace:gold_plate", "furnace:gold_plate", "furnace:gold_plate", "furnace:gold_plate"}
})

minetest.register_craft({
	output = "furnace:copper_block",
	type = "shapeless",
	recipe = {"default:frame", "furnace:copper_plate", "furnace:copper_plate", "furnace:copper_plate", "furnace:copper_plate", "furnace:copper_plate", "furnace:copper_plate"}
})

minetest.register_node("furnace:steel_frame", {
	description = "Steel Frame",
	tiles = {"furnace_steel_frame.png", "furnace_steel_frame_detail.png"},
	drawtype = "glasslike_framed_optional",
	paramtype = "light",
	groups = {choppy = 2},
})


minetest.register_craft({
	output = "furnace:diamond_rod",
	recipe = {
		{"furnace:iron_rod", "default:diamond"},
	}
})
