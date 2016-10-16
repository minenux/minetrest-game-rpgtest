crafting_guide = {}

crafting_guide.form = "size[3,3;]"..default.gui_colors..default.gui_bg;
crafting_guide.form_back = "size[3,4;]"..default.gui_colors..default.gui_bg.."button[0,3;3,1;btn_back;Back]";

crafting_guide.form_items = "size[8,7]"..default.gui_colors..default.gui_bg.."button[0,6;3,1;btn_left;<]button[5,6;3,1;btn_right;>]button[3,6;2,1;btn_quests;Quests]"

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
	for i=1,9 do
		if (string.find((crafts[1].items[j] or ""),"group:") or 0) == 1 then
			if crafts[1].items[j] then
				str = str .. ("button["..(x-1)..","..(y-1)..";1,1;group_"..i..";"..string.sub(crafts[1].items[j], 7).."]")
			else
				str = str .. ("button["..(x-1)..","..(y-1)..";1,1;;]")
			end
		else
			str = str .. ("item_image_button["..(x-1)..","..(y-1)..";1,1;"..(crafts[1].items[j] or "")..";"..(crafts[1].items[j] or "")..";]")
		end
		j = j + 1

		x = x+1
		if x > 3 then
			x = 1
			y = y+1
		end
	end
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
			if (minetest.get_all_craft_recipes(name) or creative_priv) and 
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
		str = str .. "item_image_button[1,4.5;1,1;furnace:pattern_rod;furnace:pattern_rod;]"
		str = str .. "item_image_button[2,4.5;1,1;default:coalblock_glowing;default:coalblock_glowing;]"

		str = str .. "label[4,4;Workbench :]"
		str = str .. "item_image_button[4,4.5;1,1;default:workbench;default:workbench;]"
		str = str .. "item_image_button[5,4.5;1,1;default:workbench_v2;default:workbench_v2;]"
	elseif page == -2 then
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
				end
			end
		end
	end
	if formname == "crafting_guide:book_items" then
		if fields.btn_left then
			crafting_guide.pages[player:get_player_name()] = crafting_guide.pages[player:get_player_name()] -1
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
				if crafts or has_creative_priv then
					if has_creative_priv then
						player:get_inventory():add_item("main", i .. " 99")
						print("[crafting_guide] give " .. player:get_player_name() .. " " .. i .. " 99")
					else
						minetest.show_formspec(player:get_player_name(), "crafting_guide:book", crafting_guide.get_formspec(crafts,true))
					end
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
