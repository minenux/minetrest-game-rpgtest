minetest.register_craftitem("fishing:fishing_rod", {
	description = "Fishing rod",
	inventory_image = "fishing_fishing_rod.png",
	wield_image = "fishing_fishing_rod_wield.png",
	liquids_pointable = true,
	range = 10.0,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.above then
			if minetest.get_node(pointed_thing.under).name == "default:water_source" then
				if skills.lvls[user:get_player_name()] and skills.lvls[user:get_player_name()]["hunter"] and skills.lvls[user:get_player_name()]["hunter"] > 3 then
					if math.random(6) == 2 then
						user:get_inventory():add_item("main", "fishing:fish")
					end
				else
					if math.random(10) == 2 then
						user:get_inventory():add_item("main", "fishing:fish")
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

minetest.register_craftitem("fishing:fish", {
	description = "Fish",
	inventory_image = "fishing_fish.png",
	on_use = minetest.item_eat(3),
})
