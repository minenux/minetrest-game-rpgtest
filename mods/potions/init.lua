potions = {}
function potions.register_potion(name, def)
	for i = 1, 5 do
		minetest.register_craftitem(name .. "_" .. tostring(i), {
			description = def.description .. "\n Level : " .. tostring(i),
			inventory_image = def.img,
		 
			on_drop = function(itemstack, dropper, pos)
				if not dropper or not dropper:is_player() then
					return
				end
				return def.on_use(itemstack, dropper, i)
			end,

			on_use = function(itemstack, user, pointed_thing)
				if not user or not user:is_player() then
					return
				end
				return def.on_use(itemstack, user, i)
			end,
		})
	end
end

potions.register_potion("potions:healing", {
	description = "Potion of Healing",
	img = "potions_red.png",
	on_use = function(itemstack, user, lvl)
		if not user or not user:is_player() then
			return
		end
		cmsg.push_message_player(user, "[hp] + ".. tostring(10+lvl))
		user:set_hp(user:get_hp()+10+lvl)
		itemstack:take_item()
		return itemstack
	end
})

potions.register_potion("potions:jumping", {
	description = "Potion of Jumping",
	img = "potions_blue.png",
	on_use = function(itemstack, user, lvl)
		if not user or not user:is_player() then
			return
		end
		user:set_physics_override({
			gravity = 0.1,
		})
		cmsg.push_message_player(user, "[effect] + jump")

		minetest.after(10.0+lvl*2, function(pl)
			if not pl or not pl:is_player() then
				return
			end
			pl:set_physics_override({
				gravity = 1,	
			})
			cmsg.push_message_player(pl, "[effect] - jump")
		end, user)
		itemstack:take_item()
		return itemstack
	end
})

potions.register_potion("potions:running", {
	description = "Potion of Running",
	img = "potions_yellow.png",
	on_use = function(itemstack, user, lvl)
		if not user or not user:is_player() then
			return
		end
		user:set_physics_override({
			speed = 3,
		})
		cmsg.push_message_player(user, "[effect] + speed")

		minetest.after(10.0+lvl*2, function(pl)
			if not pl or not pl:is_player() then
				return
			end
			pl:set_physics_override({
				speed = 1,	
			})
			cmsg.push_message_player(pl, "[effect] - speed")
		end, user)
		itemstack:take_item()
		return itemstack
	end
})

minetest.register_craftitem("potions:strange", {
	description = "Strange Potion",
	inventory_image = "potions_black.png",
})

minetest.register_craftitem("potions:glass", {
	description = "Glass",
	inventory_image = "potions_glass.png",
})

minetest.register_craftitem("potions:upgrading", {
	description = "Potion of Upgrading",
	inventory_image = "potions_green.png",
})

-- crafting

minetest.register_craft({
	type = "shapeless",
	output = "potions:strange",
	recipe = {"potions:glass", "juice:cactus", "juice:cactus", "juice:water"},
	replacements = {
		{"juice:cactus", "juice:glass"},
		{"juice:cactus", "juice:glass"},
		{"juice:water", "juice:glass"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "potions:running",
	recipe = {"juice:water_sugar", "juice:water_sugar", "juice:water_sugar", "potions:glass"},
	replacements = {
		{"juice:water_sugar", "juice:glass"},
		{"juice:water_sugar", "juice:glass"},
		{"juice:water_sugar", "juice:glass"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "potions:jumping",
	recipe = {"juice:water_sugar", "juice:water_sugar", "juice:water", "potions:glass"},
	replacements = {
		{"juice:water_sugar", "juice:glass"},
		{"juice:water_sugar", "juice:glass"},
		{"juice:water", "juice:glass"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "potions:upgrading",
	recipe = {"potions:strange", "default:stone_item", "farming:cactus", "default:sand"},
})

minetest.register_craft({
	output = "potions:glass 15",
	recipe = {
		{"", "default:glass", ""},
		{"default:glass", "", "default:glass"},
		{"default:glass", "default:glass", "default:glass"},
	}
})
