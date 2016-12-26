character_editor = {}
character_editor.characters = {}
character_editor.language = {}
character_editor.mesh = {}

character_editor.shirts = {"character_editor_red_shirt.png", "character_editor_blue_shirt.png", "character_editor_yellow_shirt.png"}

function character_editor.update_character(player)
	local name = player:get_player_name()
	player:set_properties({
		mesh = character_editor.mesh[name],
		textures = {table.concat(character_editor.characters[name], "^")},
		visual = "mesh",
		visual_size = {x=1, y=1},
	})
	print("[character_editor] skin : " .. table.concat(character_editor.characters[name], "^"))
end

function character_editor.set_mesh(player, mesh)
	local name = player:get_player_name()
	character_editor.mesh[name] = mesh
	character_editor.update_character(player)
end

function character_editor.set_texture(player, pos, texture)
	local name = player:get_player_name()
	if not character_editor.characters[name] then
		character_editor.characters[name] = {}
	end

	character_editor.characters[name][pos] = texture
	character_editor.update_character(player)
end

--default.player_inventory.register_tab({
--	name = "Settings",
--	type = "normal",
--	formspec = "size[8,7.5;]" ..
--			default.gui_colors .. 
--			default.gui_bg .. 
--			"label[0,0;Language:]" ..
--			"button[0,0.5;1,1;lang_EN;EN]" .. 
--			"button[1,0.5;1,1;lang_DE;DE]" .. 
--			"button[2,0.5;1,1;lang_FR;FR]" .. 
--			"button[3,0.5;1,1;lang_ID;ID]" .. 
--			"button[4,0.5;1,1;lang_TR;TR]",
--	on_event = function(player, fields)
--		local name = player:get_player_name()
--		if fields["lang_EN"] then
--			print("EN")
--			character_editor.language[name] = ""
--		elseif fields["lang_DE"] then
--			print("DE")
--			character_editor.language[name] = "de/"
--		elseif fields["lang_FR"] then
--			print("FR")
--			character_editor.language[name] = "fr/"
--		elseif fields["lang_ID"] then
--			print("ID")
--			character_editor.language[name] = "id/"
--		elseif fields["lang_TR"] then
--			print("TR")
--			character_editor.language[name] = "tr/"
--		end
--	end
--})

minetest.register_chatcommand("shirt", {
	params = "<name>",
	description = "[TEST CMD] Select your shirt",
	privs = {interact = true},
	func = function(plname , name)
		local player = minetest.get_player_by_name(plname)
		if character_editor.shirts[tonumber(name)] then
			character_editor.set_texture(player, 2, character_editor.shirts[tonumber(name)])
			return true, "You selected ".. name
		else
			return true, "There is no shirt named ".. name
		end
	end,
})

minetest.register_on_joinplayer(function(player)
	character_editor.mesh[player:get_player_name()] = "character.x"
	character_editor.characters[player:get_player_name()] = {}
	character_editor.set_texture(player, 1, "character.png")
end)

