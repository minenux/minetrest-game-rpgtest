crafting_guide = {}

crafting_guide.form = "size[3,3;]"..default.gui_colors..default.gui_bg;
crafting_guide.form_back = "size[3,4;]"..default.gui_colors..default.gui_bg.."button[0,3;3,1;btn_back;Back]";

crafting_guide.form_items = "size[8,7]"..default.gui_colors..default.gui_bg.."button[0,6;3,1;btn_left;<]button[5,6;3,1;btn_right;>]button[3,6;2,1;btn_quests;Quests]"

crafting_guide.pages = {}

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

function crafting_guide.get_item_formspec(page)
	page = page or 0

	local str = crafting_guide.form_items
	local i = 0
	local x = 0
	local y = 0

	local items = {}
	for name,def in pairs(minetest.registered_items) do
		table.insert(items,name)
	end

	table.sort(items)

	for _,name in ipairs(items) do
		if minetest.get_all_craft_recipes(name) and i < (8*6)*(page+1) then
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
	return str
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "crafting_guide:book" then
		if fields.btn_back then
			minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(crafting_guide.pages[player:get_player_name()]))
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
			minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(crafting_guide.pages[player:get_player_name()]))
		elseif fields.btn_right then
			crafting_guide.pages[player:get_player_name()] = crafting_guide.pages[player:get_player_name()] +1
			minetest.show_formspec(player:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(crafting_guide.pages[player:get_player_name()]))
		elseif fields.btn_quests then
			minetest.show_formspec(player:get_player_name(), "quests:show_quests", quests.get_formspec(player:get_player_name()))
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
		minetest.show_formspec(user:get_player_name(), "crafting_guide:book_items", crafting_guide.get_item_formspec(0))
	end
})
