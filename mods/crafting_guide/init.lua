crafting_guide = {}

crafting_guide.form = "size[3,3;]"..default.gui_colors..default.gui_bg;
crafting_guide.form_back = "size[3,4;]"..default.gui_colors..default.gui_bg.."button[0,3;3,1;btn_back;Back]";

crafting_guide.form_items = "size[8,7]"..default.gui_colors..default.gui_bg.."button[0,6;4,1;btn_left;<]button[4,6;4,1;btn_right;>]"

crafting_guide.pages = {}

minetest.register_privilege("creative", {
	description = "",
	give_to_singleplayer = false,
})

function crafting_guide.get_formspec(crafts,back_button)
	local str = crafting_guide.form
	if back_button then
		str = crafting_guide.form_back
	end
	local x = 1
	local y = 1
	local j = 1
	
	local w = crafts[1].width
	if w == 0 or w == nil then
		w = 3
	end
	
	local h = 3
	
	for i=1,w*h do
		if (string.find((crafts[1].items[j] or ""),"group:") or 0) == 1 then
			if crafts[1].items[j] and crafts[1].items[j] ~= "" then
				str = str .. ("button["..(x-1)..","..(y-1)..";1,1;group_"..i..";"..string.sub(crafts[1].items[j], 7).."]")
			else
				--str = str .. ("button["..(x-1)..","..(y-1)..";1,1;;]")
			end
		elseif crafts[1].items[j] and crafts[1].items[j] ~= "" then
			str = str .. ("item_image_button["..(x-1)..","..(y-1)..";1,1;"..(crafts[1].items[j] or "")..";"..(crafts[1].items[j] or "")..";]")
		end
		j = j + 1

		x = x+1
		
		if x > w then
			x = 1
			y = y+1
		end
	end
	return str
end

function crafting_guide.get_furnace_formspec(recipe,back_button)
	local str = crafting_guide.form
	if back_button then
		str = crafting_guide.form_back
	end

	str = str .. "label[0,0;Furnace:]"

	str = str .. "item_image_button[0,1;1,1;" .. recipe.input .. ";" .. recipe.input .. ";]"
	str = str .. "item_image_button[2,1;1,1;" .. recipe.output .. ";" .. recipe.output .. ";]"
	
	return str
end

function crafting_guide.get_item_formspec(page, player)
	page = page or 0
	local str = crafting_guide.form_items
	local creative_priv = minetest.get_player_privs(player:get_player_name()).creative

	if page > -1 then
		local i = 0
		local x = 0
		local y = 0

		local items = {}
		for name,def in pairs(minetest.registered_items) do
			if not(def.groups.not_in_creative_inventory) then
				table.insert(items,name)
			end
		end

		table.sort(items)

		for _,name in ipairs(items) do
			if ((minetest.get_all_craft_recipes(name) or furnace.get_recipe(name)) or creative_priv) and 
			   i < (8*6)*(page+1) then
				if i > (8*6)*(page)-1 then
					str = str .. "item_image_button["..x..","..y..";1,1;"..name..";"..name..";]"
					x = x + 1
					if x > 7 then
						x = 0
						y = y +1
					end
				end
				i = i +1
			end
		end
	elseif page == -1 then
		str = str .. "label[0,0;Mining :]"
		str = str .. "item_image_button[0,0.5;1,1;default:axe_stone;default:axe_stone;]"
		str = str .. "item_image_button[1,0.5;1,1;default:simple_hammer;default:simple_hammer;]"
		str = str .. "item_image_button[2,0.5;1,1;default:flint_pick;default:flint_pick;]"
		str = str .. "item_image_button[3,0.5;1,1;default:pick;default:pick;]"
		str = str .. "item_image_button[4,0.5;1,1;default:pick_copper;default:pick_copper;]"
		str = str .. "item_image_button[5,0.5;1,1;default:pick_diamond;default:pick_diamond;]"
		str = str .. "item_image_button[7,0.5;1,1;torch:torch;torch:torch;]"
		
		str = str .. "label[0,2;Weapons :]"
		str = str .. "item_image_button[0,2.5;1,1;skills:spear_lvl_1;skills:spear_lvl_1;]"
		str = str .. "item_image_button[1,2.5;1,1;skills:sword_lvl_20;skills:sword_lvl_20;]"
		str = str .. "item_image_button[2,2.5;1,1;skills:bow_lvl_1;skills:bow_lvl_1;]"

		str = str .. "label[0,4;Furnace :]"
		str = str .. "item_image_button[0,4.5;1,1;furnace:furnace;furnace:furnace;]"
		str = str .. "item_image_button[1,4.5;1,1;furnace:anvil;furnace:anvil;]"
		str = str .. "item_image_button[2,4.5;1,1;default:coalblock;default:coalblock;]"

		str = str .. "label[4,4;Workbench :]"
		str = str .. "item_image_button[4,4.5;1,1;default:workbench;default:workbench;]"
		str = str .. "item_image_button[5,4.5;1,1;default:workbench_v2;default:workbench_v2;]"
	elseif page == -2 then
		str = str .. "label[0,0;Logs :]"
		str = str .. "item_image_button[0,0.5;1,1;default:log;default:log;]"
		str = str .. "item_image_button[1,0.5;1,1;default:jungle_tree;default:jungle_tree;]"
		str = str .. "item_image_button[2,0.5;1,1;default:log_birch;default:log_birch;]"
		
		str = str .. "label[0,1.5;Wood :]"
		str = str .. "item_image_button[0,2;1,1;default:wood;default:wood;]"
		str = str .. "item_image_button[1,2;1,1;default:jungle_wood;default:jungle_wood;]"
		str = str .. "item_image_button[2,2;1,1;default:birch_wood;default:birch_wood;]"

		str = str .. "label[0,3;Wooden Planks :]"
		str = str .. "item_image_button[0,3.5;1,1;default:wooden_planks;default:wooden_planks;]"
		str = str .. "item_image_button[1,3.5;1,1;default:wooden_planks_2;default:wooden_planks_2;]"
		
		str = str .. "item_image_button[2,3.5;1,1;default:wooden_planks_jungle;default:wooden_planks_jungle;]"
		str = str .. "item_image_button[0,4.5;1,1;default:wooden_planks_2_jungle;default:wooden_planks_2_jungle;]"
		
		str = str .. "item_image_button[1,4.5;1,1;default:wooden_planks_birch;default:wooden_planks_birch;]"
		str = str .. "item_image_button[2,4.5;1,1;default:wooden_planks_2_birch;default:wooden_planks_2_birch;]"
	elseif page == -3 then
		local x = 0
		local y = 0
		str = str .. "label[0,0;Mobs :]"
		for i,v in ipairs(mobs.mobs) do
			local name = v[1]
			str = str .. "item_image_button[".. x ..",".. y+0.5 ..";1,1;"..name..";"..name..";]"
			x = x + 1
			if x > 7 then
				x = 0
				y = y +1
			end
		end

		local ores = {}
		local a = {}
		for _,v in pairs(minetest.registered_ores) do
			if not(a[v.ore]) then
				table.insert(ores, v.ore)
				a[v.ore] = true
			end
		end
		str = str .. "label[0,2.5;Ores :]"
		x = 0
		y = 3
		for _,name in ipairs(ores) do
			str = str .. "item_image_button[".. x ..",".. y ..";1,1;"..name..";"..name..";]"
			x = x + 1
			if x > 7 then
				x = 0
				y = y +1
			end
		end
	end

	return str
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "crafting_guide:book" then
		if fields.btn_back then
			minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(crafting_guide.pages[player:get_player_name()], player))
		elseif fields.quit then
			crafting_guide.pages[player:get_player_name()] = nil
		else
			for i,j in pairs(fields) do
				local crafts = minetest.get_all_craft_recipes(i)
				if crafts then
					minetest.show_formspec(player:get_player_name(), "crafting_guide:book", crafting_guide.get_formspec(crafts,true))
				elseif furnace.get_recipe(i) then
					minetest.show_formspec(player:get_player_name(), "crafting_guide:book", crafting_guide.get_furnace_formspec(furnace.get_recipe(i),true))
				end
			end
		end
	end
	if formname == "crafting_guide:book_items" then
		if fields.btn_left then
			crafting_guide.pages[player:get_player_name()] = crafting_guide.pages[player:get_player_name()] -1
			
			if crafting_guide.pages[player:get_player_name()] < -3 then
				crafting_guide.pages[player:get_player_name()] = -3
			end
			
			minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(crafting_guide.pages[player:get_player_name()], player))
		elseif fields.btn_right then
			crafting_guide.pages[player:get_player_name()] = crafting_guide.pages[player:get_player_name()] +1
			
			
			
			minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(crafting_guide.pages[player:get_player_name()], player))
		elseif fields.btn_quests then
			minetest.show_formspec(player:get_player_name(), "quests:show_quests", quests.get_formspec(player:get_player_name()))
		elseif fields.quit then
			crafting_guide.pages[player:get_player_name()] = nil		
		else
			for i,j in pairs(fields) do
				local crafts = minetest.get_all_craft_recipes(i)
				local has_creative_priv = minetest.get_player_privs(player:get_player_name()).creative
				if has_creative_priv then
					player:get_inventory():add_item("main", i .. " 99")
					print("[crafting_guide] give " .. player:get_player_name() .. " " .. i .. " 99")
				elseif crafts then
					minetest.show_formspec(player:get_player_name(), "crafting_guide:book", crafting_guide.get_formspec(crafts,true))
				elseif furnace.get_recipe(i) then
					minetest.show_formspec(player:get_player_name(), "crafting_guide:book", crafting_guide.get_furnace_formspec(furnace.get_recipe(i),true))
				end
			end
		end
	end
end)

minetest.register_craftitem("crafting_guide:lens", {
	inventory_image = "crafting_guide_lens.png",
	description = "Lens",

	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local crafts = minetest.get_all_craft_recipes(minetest.get_node(pointed_thing.under).name)
			if crafts then
				minetest.show_formspec(user:get_player_name(), "crafting_guide:lens", crafting_guide.get_formspec(crafts))
			else
				minetest.show_formspec(user:get_player_name(), "crafting_guide:lens", "size[3,3;]"..default.gui_colors..default.gui_bg.."label[0,0;No crafts]")
			end
		end
	end
})

minetest.register_craftitem("crafting_guide:book", {
	inventory_image = "crafting_guide_book.png",
	description = "Crafting Guide",

	on_use = function(itemstack, user, pointed_thing)
		crafting_guide.pages[user:get_player_name()] = 0
		minetest.show_formspec(user:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(0, user))
	end
})


default.player_inventory.get_tab("Crafting").on_event = function(player, fields)
	if fields.crafting_guide then
		crafting_guide.pages[player:get_player_name()] = 0
		minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(0, player))
	end
end
