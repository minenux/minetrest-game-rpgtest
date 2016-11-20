legendary_items = {}
legendary_items.rare_weapons = {}
legendary_items.register_rare_weapon = function(name, level, def)
	if not def.damage then
		if def.damage_m and def.damage_d then
			def.damage = math.floor(skills.get_dmg(level)*def.damage_m-def.damage_d)
		end
	end
	
	table.insert(legendary_items.rare_weapons, name)
	minetest.register_tool(":legendary_items:"..name, {
		description = def.description.."\n Level: ".. tostring(level).. "\n Damage: " .. def.damage .. "\n Skill: " .. tostring(def.skill) .. "\n Rare Item",
		inventory_image = def.inventory_image,
		wield_scale = def.wield_scale,
		tool_capabilities = {
			max_drop_level=3,
			damage_groups = {fleshy=def.damage+skills.get_dmg(level)},
		},
		skill = def.skill,
		on_use = function(itemstack, user, pointed_thing)
			if user == nil then return end
			if pointed_thing.type == "object" then
				if skills.lvls[user:get_player_name()] and skills.lvls[user:get_player_name()][def.skill] > level - 1 then
					pointed_thing.ref:punch(user, 10,minetest.registered_tools[itemstack:get_name()].tool_capabilities)
					itemstack:add_wear(300)
					print("[info]" .. user:get_player_name() .. " is fighting!")
				else
					cmsg.push_message_player(user, "[info] You have to be " .. def.skill .. " level ".. tostring(level) .. " to use this weapon!")
				end
				return itemstack
			end
		end
	})

	table.insert(def.materials, "default:ruby")
	blueprint.register_blueprint(name, {
		description = def.description .. "\n Level: ".. tostring(level).. "\n Damage: " .. tostring(def.damage+skills.get_dmg(level)) .. "\n Rare Item",
		materials = def.materials,
		out = "legendary_items:"..name,
		color = "yellow"
	})
end

-- rare

legendary_items.register_rare_weapon("old_hammer", 3, {
	description = "Old Hammer",
	inventory_image = "legendary_items_old_hammer.png",
	wield_scale = {x = 2, y = 2, z =1},
	damage_m = 1.0,
	damage_d = -2,
	skill = "warrior",
	materials = {"default:stick", "default:stone"},
})

legendary_items.register_rare_weapon("old_hammer_lvl_5", 5, {
	description = "Old Hammer",
	inventory_image = "legendary_items_old_hammer.png",
	wield_scale = {x = 2, y = 2, z =1},
	damage_m = 1.0,
	damage_d = -3,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})

legendary_items.register_rare_weapon("old_hammer_lvl_30", 30, {
	description = "Old Hammer",
	inventory_image = "legendary_items_old_hammer.png",
	wield_scale = {x = 2, y = 2, z =1},
	damage_m = 1.0,
	damage_d = -7,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})

legendary_items.register_rare_weapon("old_hammer_lvl_60", 60, {
	description = "Old Hammer",
	inventory_image = "legendary_items_old_hammer.png",
	wield_scale = {x = 2, y = 2, z =1},
	damage_m = 1.0,
	damage_d = -15,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})

legendary_items.register_rare_weapon("old_hammer_lvl_100", 100, {
	description = "Old Hammer",
	inventory_image = "legendary_items_old_hammer.png",
	wield_scale = {x = 2, y = 2, z =1},
	damage_m = 1.0,
	damage_d = -20,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})


legendary_items.register_rare_weapon("old_battle_axe", 3, {
	description = "Old Battle Axe",
	inventory_image = "legendary_items_old_battle_axe.png",
	wield_scale = {x = 1.2, y = 1.2, z =1},
	damage_m = 1.0,
	damage_d = -2,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})

legendary_items.register_rare_weapon("old_battle_axe_lvl_10", 10, {
	description = "Old Battle Axe",
	inventory_image = "legendary_items_old_battle_axe.png",
	wield_scale = {x = 1.2, y = 1.2, z =1},
	damage_m = 1.0,
	damage_d = -4,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})

legendary_items.register_rare_weapon("old_battle_axe_lvl_14", 14, {
	description = "Old Battle Axe",
	inventory_image = "legendary_items_old_battle_axe.png",
	wield_scale = {x = 1.2, y = 1.2, z =1},
	damage_m = 1.0,
	damage_d = -6,
	skill = "warrior",
	materials = {"default:stick", "default:stone", "default:stone"},
})

legendary_items.register_rare_weapon("sugar_sword_lvl_2", 2, {
	description = "Sugar Sword",
	inventory_image = "legendary_items_sugar_sword.png",
	wield_scale = {x = 1.2, y = 1.2, z =1},
	damage_m = 1.0,
	damage_d = -3,
	skill = "warrior",
	materials = {"default:stick", "farming:sugar"},
})

legendary_items.register_rare_weapon("sugar_sword_lvl_17", 17, {
	description = "Sugar Sword",
	inventory_image = "legendary_items_sugar_sword.png",
	wield_scale = {x = 1.2, y = 1.2, z =1},
	damage_m = 1.0,
	damage_d = -5,
	skill = "warrior",
	materials = {"default:stick", "farming:sugar"},
})
