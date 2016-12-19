fishing = {}
fishing.fish = {}

function fishing.register_fish(name, def)
	minetest.register_craftitem(name, def)
	table.insert(fishing.fish, name)
end

function fishing.get_fish()
	return fishing.fish[math.random(#fishing.fish)]
end

minetest.register_craftitem("fishing:fishing_rod", {
	description = "Fishing rod",
	inventory_image = "fishing_fishing_rod.png",
	wield_image = "fishing_fishing_rod_wield.png",
	liquids_pointable = true,
	range = 10.0,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.above then
			if minetest.get_node(pointed_thing.under).name == "default:water_source" then
				if skills.lvls[user:get_player_name()] and 
				   (skills.lvls[user:get_player_name()]["hunter"] and 
				   skills.lvls[user:get_player_name()]["hunter"] > 3) or
				   (skills.lvls[user:get_player_name()]["farmer"] and 
				   skills.lvls[user:get_player_name()]["farmer"] > 3) then
					if math.random(6) == 2 then
						user:get_inventory():add_item("main", fishing.get_fish())
					end
				else
					if math.random(10) == 2 then
						user:get_inventory():add_item("main", fishing.get_fish())
					end
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "fishing:fishing_rod",
	recipe = {
		{"default:stick", "default:string", ""},
		{"default:stick", "default:string", ""},
		{"default:stick", "default:string", ""},
	}
})

-- fish

fishing.register_fish("fishing:fish", {
	description = "Fish",
	inventory_image = "fishing_fish.png",
	on_use = minetest.item_eat(3),
})

fishing.register_fish("fishing:fish_1", {
	description = "Fish",
	inventory_image = "fishing_fish_1.png",
	on_use = minetest.item_eat(4),
})

fishing.register_fish("fishing:fish_2", {
	description = "Fish",
	inventory_image = "fishing_fish_2.png",
	on_use = minetest.item_eat(2),
})

-- cooked fish

fishing.register_fish("fishing:cooked_fish", {
	description = "Cooked Fish",
	inventory_image = "fishing_cooked_fish.png",
	on_use = minetest.item_eat(6),
})

furnace.register_recipe({
	input = "fishing:fish",
	output = "fishing:cooked_fish",
})
