-- functions

function furnace.register_recipe(def)
	table.insert(furnace.recipes, def)	-- add fuel to list
end

function furnace.register_fuel(def)
	table.insert(furnace.fuels, def)	-- add recipe to list
end

function furnace.get_recipe(item)
	-- search recipe for item
	for i,recipe in ipairs(furnace.recipes) do
		if recipe.output == item then
			return recipe	-- return recipe for item
		end
	end
	return nil	-- no recipe found
end

-- formspec

local furnace_form = "size[8,9]"
local furnace_form = furnace_form..default.gui_colors
local furnace_form = furnace_form..default.gui_bg

local furnace_form = furnace_form.."list[current_name;main;1.5,0.5;2,2;]" 
local furnace_form = furnace_form..default.itemslot_bg(1.5, 0.5, 2, 2)
local furnace_form = furnace_form.."list[current_name;fuel;2,3;1,1;]" 
local furnace_form = furnace_form..default.itemslot_bg(2, 3, 1, 1)
local furnace_form = furnace_form.."list[current_name;output;5,1;2,2;]" 
local furnace_form = furnace_form..default.itemslot_bg(5, 1, 2, 2)

local furnace_form = furnace_form.."label[1.5,0;Input:]"
local furnace_form = furnace_form.."label[5,0.5;Output:]"

local furnace_form = furnace_form.."list[current_player;main;0,4.85;8,1;]" 
local furnace_form = furnace_form..default.itemslot_bg(0,4.85,8,1)
local furnace_form = furnace_form.."list[current_player;main;0,6.08;8,3;8]" 
local furnace_form = furnace_form..default.itemslot_bg(0,6.08,8,3)
local furnace_form = furnace_form.."listring[current_name;main]"
local furnace_form = furnace_form.."listring[current_name;output]" 
local furnace_form = furnace_form.."listring[current_player;main]"

-- register block

minetest.register_node("furnace:furnace", {
	description = "Furnace",
	tiles = {"default_stonebrick.png", "default_stonebrick.png", "default_stonebrick.png", "default_stonebrick.png","default_stonebrick.png","furnace_stone_front.png"},
	groups = {cracky = 2},
	paramtype2 = "facedir",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",furnace_form)
		meta:set_string("infotext", "Furnace");
		meta:set_int("fuel", 0);
		
		local inv = meta:get_inventory()
		inv:set_size("main", 2*2)
		inv:set_size("output", 2*2)
		inv:set_size("fuel", 1)
	end,
	after_dig_node = default.drop_inv({"main", "output", "fuel"}),
})

minetest.register_abm({
	nodenames = {"furnace:furnace"},
	neighbors = {},
	interval = 2.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)	-- get meta
		local inv = meta:get_inventory()	-- get inventory
		local fuel = meta:get_int("fuel")	-- get fuel level
		
		-- check if fuel slot contains fuel
		for i,fuel_def in ipairs(furnace.fuels) do
			if inv:contains_item("fuel", {name = fuel_def.item}) then
				fuel = fuel + fuel_def.fuel
				inv:remove_item("fuel", {name = fuel_def.item})
				break
			end
		end
		
		for i,recipe in ipairs(furnace.recipes) do
			if inv:contains_item("main", {name = recipe.input})  then
				inv:add_item("output", {name = recipe.output})	-- add output to inventory
				inv:remove_item("main", {name = recipe.input})	-- remove input
				meta:set_int("fuel", fuel-1)	-- decrease fuel level
				break
			end
		end
		
		-- update infotext
		meta:set_string("infotext", "Furnace\n Fuel : " .. tostring(fuel))
		
		-- update meta
		meta:set_int("fuel", fuel)
	end,
})

-- fuel

furnace.register_fuel({
	item = "default:coalblock",
	fuel = 100
})

furnace.register_fuel({
	item = "default:coal_lump",
	fuel = 10
})

furnace.register_fuel({
	item = "default:coal_dust",
	fuel = 1
})


-- recipes

furnace.register_recipe({
	pattern = "furnace:pattern_rod",
	input = "default:stone_with_iron",
	output = "furnace:iron_rod",
})

furnace.register_recipe({
	input = "default:stone_with_copper",
	output = "furnace:copper_rod",
})

furnace.register_recipe({
	input = "default:stone_with_gold",
	output = "furnace:gold_rod",
})

furnace.register_recipe({
	input = "default:sand",
	output = "default:glass",
})

-- items

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

minetest.register_craftitem("furnace:diamond_plate", {
	description = "Diamond Plate",
	inventory_image = "furnace_diamond_plate.png",
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
		{"furnace:iron_rod", "default:diamond", "default:diamond"},
	}
})

minetest.register_craft({
	output = "furnace:diamond_plate",
	recipe = {
		{"furnace:iron_plate", "default:diamond", "default:diamond"},
	}
})
