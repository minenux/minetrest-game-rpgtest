armor = {}
armor.invs = {}
armor.data = {}

armor.armor_file = minetest.get_worldpath() .. "/armor"

function armor.register_armor(name, def)
	minetest.register_craftitem("armor:" .. name .. "_chestplate", {
		description = def.description .. " Chestplate",
		inventory_image = def.tex .. "_chestplate.png",
		protection = def.protection,
		skin = def.skin .. "_chestplate.png",
		skin_pos = 0,
	})
	
	minetest.register_craftitem("armor:" .. name .. "_boots", {
		description = def.description .. " Boots",
		inventory_image = def.tex .. "_boots.png",
		protection = def.protection,
		skin = def.skin .. "_boots.png",
		skin_pos = 3,
	})
	
	minetest.register_craftitem("armor:" .. name .. "_leggings", {
		description = def.description .. " Leggings",
		inventory_image = def.tex .. "_leggings.png",
		protection = def.protection,
		skin = def.skin .. "_leggings.png",
		skin_pos = 2,
	})
	
	minetest.register_craftitem("armor:" .. name .. "_helm", {
		description = def.description .. " Helm",
		inventory_image = def.tex .. "_helm.png",
		protection = def.protection,
		skin = def.skin .. "_helm.png",
		skin_pos = 1,
	})

	blueprint.register_blueprint("armor_" .. name .. "_chestplate", {
		description = def.description .. " Chestplate",
		materials = {def.material, def.material, def.material2 or def.material, def.material2 or def.material},
		out = "armor:" .. name .. "_chestplate",
		color = "red"
	})

	blueprint.register_blueprint("armor_" .. name .. "_leggings", {
		description = def.description .." Leggings",
		materials = {def.material, def.material2 or def.material},
		out = "armor:" .. name .. "_leggings",
		color = "red"
	})

	blueprint.register_blueprint("armor_" .. name .. "_boots", {
		description = def.description .." Boots",
		materials = {def.material, def.material2 or def.material},
		out = "armor:" .. name .. "_boots",
		color = "red"
	})

	blueprint.register_blueprint("armor_" .. name .. "_helm", {
		description = def.description .." Helm",
		materials = {def.material, def.material2 or def.material},
		out = "armor:" .. name .. "_helm",
		color = "red"
	})
end

function armor.update_armor(name, pl)
	local a = armor.invs[name]:get_list("main")
	local p = 100
	local skin = {}
	
	for k,v in pairs(a) do
		if v:get_definition() and v:get_definition().protection then
			p = p - v:get_definition().protection
		end
		
		if v:get_definition() and v:get_definition().skin then
			table.insert(skin, v:get_definition().skin)
		end
		
		armor.data[name][k] = v:to_string() 
		print("[armor] " .. armor.data[name][k])
	end
	
	if #skin == 0 then
		character_editor.set_texture(pl, 2, nil)
	else
		character_editor.set_texture(pl, 2, table.concat(skin, "^"))
	end
	
	pl:set_armor_groups({friendly = p})
	armor.save_armor()
end


default.player_inventory.register_tab({
	name = "Armor",
	formspec = default.player_inventory.get_default_inventory_formspec() .. 
		   "list[detached:armor_<player_name>;main;3,0.5;2,2;]" .. 
		   "listring[detached:armor_<player_name>;main]" .. 
		   "listring[current_player;main]" .. 
		   default.itemslot_bg(3,0.5,2,2)
})


function armor.load_armor()
	local input = io.open(armor.armor_file, "r")
	if input then
		local str = input:read()
		if str then
			print("[INFO] armor string : " .. str)
			if minetest.deserialize(str) then
				armor.data = minetest.deserialize(str)
			end
		else 
			print("[WARNING] armor file is empty")
		end
		io.close(input)
	else
		print("[error] couldnt find armor file")
	end
end

function armor.save_armor()
	if armor.data then
		local output = io.open(armor.armor_file, "w")
		local str = minetest.serialize(armor.data)
		output:write(str)
		io.close(output)
	end
end

minetest.register_on_joinplayer(function(player)
	player:set_armor_groups({friendly = 100})
	if armor.invs[player:get_player_name()] then
		return
	end

	armor.invs[player:get_player_name()] = minetest.create_detached_inventory("armor_" .. player:get_player_name(), {
		on_put = function(inv, listname, index, stack, player) 
			armor.update_armor(player:get_player_name(), player)
		end,
		on_take = function(inv, listname, index, stack, player) 
			armor.update_armor(player:get_player_name(), player)
		end,
	})
	armor.invs[player:get_player_name()]:set_size("main", 4)

	if armor.data[player:get_player_name()] then
		armor.invs[player:get_player_name()]:add_item('main', armor.data[player:get_player_name()][1])
		armor.invs[player:get_player_name()]:add_item('main', armor.data[player:get_player_name()][2])
		armor.invs[player:get_player_name()]:add_item('main', armor.data[player:get_player_name()][3])
		if armor.data[player:get_player_name()][4] then
			armor.invs[player:get_player_name()]:add_item('main', armor.data[player:get_player_name()][4])
		end
	else
		armor.data[player:get_player_name()] = {}
	end
	armor.update_armor(player:get_player_name(), player)
	
end)

minetest.register_on_leaveplayer(function(player)
	armor.save_armor()
end)

armor.register_armor("iron", {
	description = "Iron",
	tex = "armor_iron",
	protection = 12,
	skin = "armor_skin_iron",

	material = "furnace:iron_plate"
})

armor.register_armor("copper", {
	description = "Copper",
	tex = "armor_copper",
	protection = 15,
	skin = "armor_skin_copper",

	material = "furnace:iron_plate",
})

armor.register_armor("diamond", {
	description = "Diamond",
	tex = "armor_diamond",
	protection = 20,
	skin = "armor_skin_diamond",

	material = "furnace:iron_plate",
	material2 = "default:diamond"
})

armor.load_armor()
