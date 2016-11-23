furnace.anvil.materials = {}

function furnace.anvil.register_material(name, def)
	furnace.anvil.materials[name] = def
end

-- formspec

local anvil_form = "size[8,9]"
local anvil_form = anvil_form..default.gui_colors
local anvil_form = anvil_form..default.gui_bg

local anvil_form = anvil_form.."list[current_name;main;1.5,1.5;1,1]" 
local anvil_form = anvil_form..default.itemslot_bg(1.5, 1.5, 2, 2)
local anvil_form = anvil_form.."list[current_name;output;5,1;2,2;]" 
local anvil_form = anvil_form..default.itemslot_bg(5, 1, 2, 2)

local anvil_form = anvil_form.."label[1.5,1;Input:]"
local anvil_form = anvil_form.."label[5,0.5;Output:]"

local anvil_form = anvil_form.."list[current_player;main;0,4.85;8,1;]" 
local anvil_form = anvil_form..default.itemslot_bg(0,4.85,8,1)
local anvil_form = anvil_form.."list[current_player;main;0,6.08;8,3;8]" 
local anvil_form = anvil_form..default.itemslot_bg(0,6.08,8,3)
local anvil_form = anvil_form.."listring[current_name;main]"
local anvil_form = anvil_form.."listring[current_name;output]" 
local anvil_form = anvil_form.."listring[current_player;main]"

-- register block

minetest.register_node("furnace:anvil", {
	description = "Anvil",
	tiles = {"missing.png"},
	groups = {cracky = 2},
	paramtype2 = "facedir",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",anvil_form)
		meta:set_string("infotext", "Anvil");
		
		local inv = meta:get_inventory()
		inv:set_size("main", 1)
		inv:set_size("output", 2*2)
	end,
	after_dig_node = default.drop_inv({"main"}),
	
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		if listname == "main" then
			local item = inv:get_list("main")[1]:get_name()
			local items = {}
			
			for name, def in pairs(furnace.anvil.materials) do
				if item == def.items.rod or
				   item == def.items.plate or
				   item == (def.items.blade or "none") then
					table.insert(items, def.items.rod)
					table.insert(items, def.items.plate)
					if def.items.blade then
						table.insert(items, def.items.blade)
					end
				end
			end
			
			inv:set_list("output", items)
		end
	end,
	
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		if listname == "output" then
			inv:set_list("main", {})
			inv:set_list("output", {})
		elseif listname == "main" then
			inv:set_list("output", {})
		end
	end,
})

furnace.anvil.register_material("iron", {
	items = {
		plate = "furnace:iron_plate",
		rod = "furnace:iron_rod",
		blade = "default:blade"
	}
})

furnace.anvil.register_material("copper", {
	items = {
		plate = "furnace:copper_plate",
		rod = "furnace:copper_rod"
	}
})

furnace.anvil.register_material("gold", {
	items = {
		plate = "furnace:gold_plate",
		rod = "furnace:gold_rod"
	}
})
