skills.abilities = {}
skills.abilities.all = {}
skills.abilities.energy = {}
skills.abilities.energy_hud = {}


minetest.register_on_joinplayer(function(player)
	if not player then
		return
	end
	skills.abilities.energy_hud[player:get_player_name()] = player:hud_add({
		hud_elem_type = "statbar",
		position = {x=0.5,y=1.0},
		size = {x=16, y=16},
	   	offset = {x=-(32*5), y=-(48*2+32+8)},
		text = "skills_abilities_energy.png",
		number = 0,
	})
	skills.abilities.energy[player:get_player_name()] = 40
end)

function skills.abilities.change_energy(player, v)
	skills.abilities.energy[player:get_player_name()] = skills.abilities.energy[player:get_player_name()] + v
	local val = 0
	if skills.abilities.energy[player:get_player_name()] > 39 then
		val = 0
	else
		val = skills.abilities.energy[player:get_player_name()]
	end
	player:hud_change(skills.abilities.energy_hud[player:get_player_name()], "number",val)
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >=0.5 then
		for _, player in pairs(minetest.get_connected_players()) do
			if skills.abilities.energy[player:get_player_name()] < 40 then
				skills.abilities.change_energy(player, 1)
				if skills.abilities.energy[player:get_player_name()] > 39 then
					cmsg.push_message_player(player, "[energy] Your energy is full!")
				end	
			end
		end
		timer = 0
	end
end)

function skills.abilities.register_skill(name, def)
	minetest.register_craftitem("skills:ability_" .. name, {
		description = def.description,
		inventory_image = def.img,
		skill = def.skill,
		on_use = function(itemstack, user, pointed_thing)
			if user == nil then return end
			if skills.lvls[user:get_player_name()] and skills.lvls[user:get_player_name()][def.skill] > def.lvl-1 then
				if skills.abilities.energy[user:get_player_name()] > def.energy -1 then
					def.on_use(itemstack, user, pointed_thing)
					skills.abilities.change_energy(user, -def.energy)
				else
					cmsg.push_message_player(user, "[WARNING] You dont have enought energy to use this ability!")	
				end
			else
				cmsg.push_message_player(user, "[info] You have to be " .. def.skill .. " level "..tostring(def.lvl).. " to use this ability!")	
			end					
			return nil
		end
	})
	
	table.insert(skills.abilities.all, "skills:abilities_" .. name)
end

minetest.register_craftitem("skills:skill_book", {
	description = "Ability Book",
	inventory_image = "skills_abilities_book.png",
	on_use = function(itemstack, user, pointed_thing)
		if user == nil then return end
		user:get_inventory():add_item("main", skills.abilities.all[math.random(#skills.abilities.all)])
		itemstack:take_item()
		return itemstack
	end
})
table.insert(default.treasure_chest_items, "skills:skill_book")

skills.abilities.register_skill("super_jump", {
	description = "Super Jump\nLevel: 15\nSkill: thief\nTime: 7.0\nEffect: gravity = 0.1\nEnergy: 10",
	img = "skills_abilities_super_jump.png",
	skill = "thief",
	lvl = 15,
	energy = 10,
	on_use = function(itemstack, user, pointed_thing)
		user:set_physics_override({
			gravity = 0.1,
		})
		cmsg.push_message_player(user, "[skill] + super jump")
		
		minetest.after(7.0, function(player)
			if not player or not player:is_player() then
				return
			end
			player:set_physics_override({
				gravity = 1,
			})
			cmsg.push_message_player(player, "[skill] - super jump")
		end, user)
	end
})

skills.abilities.register_skill("lift", {
	description = "Lift\nLevel: 25\nSkill: thief\nTime: 2.0\nEffect: gravity = -0.5\nEnergy: 20",
	img = "skills_abilities_lift.png",
	skill = "thief",
	lvl = 25,
	energy = 20,
	on_use = function(itemstack, user, pointed_thing)
		user:set_physics_override({
			gravity = -0.5,
		})
		cmsg.push_message_player(user, "[skill] + lift")
		
		minetest.after(2.0, function(player)
			if not player or not player:is_player() then
				return
			end
			player:set_physics_override({
				gravity = 1,
			})
			cmsg.push_message_player(player, "[skill] - lift")
		end, user)
	end
})

skills.abilities.register_skill("heal", {
	description = "Heal\nLevel: 13\nSkill: farmer\nEffect: hp + 4\nEnergy: 15",
	img = "skills_abilities_heal.png",
	skill = "farmer",
	lvl = 13,
	energy = 15,
	on_use = function(itemstack, user, pointed_thing)
		user:set_hp(user:get_hp()+4)
		cmsg.push_message_player(user, "[skill][hp] + 4")
	end
})

skills.abilities.register_skill("grow", {
	description = "Grow\nLevel: 6\nSkill: farmer\nEffect: -\nEnergy: 30",
	img = "skills_abilities_grow.png",
	skill = "farmer",
	lvl = 6,
	energy = 30,
	on_use = function(itemstack, user, pointed_thing)
		if minetest.get_node(pointed_thing.under).name == "default:dirt" then
			minetest.set_node(pointed_thing.under, {name = "default:grass"})
		elseif minetest.get_node(pointed_thing.under).name == "default:dry_grass" then
			minetest.set_node(pointed_thing.under, {name = "default:grass"})
		elseif minetest.get_node(pointed_thing.above).name == "air" then
			minetest.set_node(pointed_thing.above, {name = "default:plant_grass_5"})
		end
	end
})

