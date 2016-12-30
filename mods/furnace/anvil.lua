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
	tiles = {"furnace_anvil_top.png", "furnace_anvil_top.png", "furnace_anvil_front.png", "furnace_anvil_front.png", "furnace_anvil_side.png", "furnace_anvil_side.png"},
	groups = {cracky = 2},
	paramtype = "light",
	paramtype2 = "facedir",
	
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-6/16, -8/16, -5/16, 6/16, -6/16, 5/16},
			{-5/16, -6/16, -3/16, 5/16, 0, 3/16},
			{-7/16, -2/16, -4/16, 7/16, 4/16, 4/16}
		}
	},
	
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
			local count = inv:get_list("main")[1]:get_count()
			local items = {}
			
			for name, def in pairs(furnace.anvil.materials) do
				if item == def.items.rod or
				   item == def.items.plates or
				   item == (def.items.blade or "none") or
				   item == (def.items.other or "none") then

					table.insert(items, def.items.rod .. " " .. tostring(count))
					table.insert(items, def.items.plate .. " " .. tostring(count))
					if def.items.blade then
						table.insert(items, def.items.blade .. " " .. tostring(count))
					end
					
					if def.items.other then
						table.insert(items, def.items.other .. " " .. tostring(count))
					end
				end
			end
			
			inv:set_list("output", items)
		end
	end,
	
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local count = stack:get_count()
		
		if listname == "output" then
			local c = inv:get_list("main")[1]:get_count() - count
			local my_item = inv:get_list("main")[1]
			my_item:set_count(c)
			inv:set_list("main", {my_item})
			inv:set_list("output", {})
			
			if c > 0 then
				print(c)
				
				local item = inv:get_list("main")[1]:get_name()
				local items = {}
				for name, def in pairs(furnace.anvil.materials) do
					if item == def.items.rod or
					   item == def.items.plates or
					   item == (def.items.blade or "none") or
					   item == (def.items.other or "none") then

						table.insert(items, def.items.rod .. " " .. tostring(c))
						table.insert(items, def.items.plate .. " " .. tostring(c))
						if def.items.blade then
							table.insert(items, def.items.blade .. " " .. tostring(c))
						end
					
						if def.items.other then
							table.insert(items, def.items.other .. " " .. tostring(c))
						end
					end
				end
				
				inv:set_list("output", items)
			else
				inv:set_list("main", {})
			end
			
		elseif listname == "main" then
			inv:set_list("output", {})
		end
	end,
})

furnace.anvil.register_material("iron", {
	items = {
		plate = "furnace:iron_plate",
		rod = "furnace:iron_rod",
		blade = "default:blade",
		other = "stairs:chisel"
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

minetest.register_craft({
	output = "furnace:anvil",
	recipe = {
		{"default:stonebrick", "default:stonebrick", "default:stonebrick"},
		{"", "default:stonebrick", ""},
		{"default:stonebrick", "default:stonebrick", "default:stonebrick"},
	}
})
