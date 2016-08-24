minetest.register_craftitem("money:coin", {
	description = "Coin",
	inventory_image = "money_coin.png",
})

minetest.register_craftitem("money:silver_coin", {
	description = "Silver Coin",
	inventory_image = "money_silver_coin.png",
})

money = {}
money.shop = {}
money.shop.form = "size[8,8;]"..default.gui_colors..default.gui_bg.."list[current_player;main;0,4;8,4;]button[0,3;1,1;btn_back;<]button[7,3;1,1;btn_next;>]button[3,1;2,1;btn_trade;Trade]item_image_button[2,1;1,1;input_item;input_item;]item_image_button[5,1;1,1;output_item;output_item;]"
money.shop.page = {}
money.shop.offers = {
	{input="money:silver_coin", output="default:coal_lump"},
	{input="money:silver_coin 2", output="default:box"},
	{input="money:coin 1", output="default:pick"}
}

function money.shop.get_formspec(page)
	if not(money.shop.offers[page]) then
		return money.shop.form
	end

	local s = string.gsub(money.shop.form, "input_item", money.shop.offers[page].input)
	s = string.gsub(s, "output_item", money.shop.offers[page].output)

	return s
end

function money.shop.trade(player)
	if not(money.shop.page[player:get_player_name()]) then
		return
	end

	local offer = money.shop.offers[money.shop.page[player:get_player_name()]]

	if not(offer) then
		return
	end

	if player:get_inventory():contains_item("main", offer.input) then
		player:get_inventory():remove_item("main", offer.input)
		player:get_inventory():add_item("main", offer.output)
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "money:shop" then
		if fields.btn_next then
			money.shop.page[player:get_player_name()] = money.shop.page[player:get_player_name()] + 1
			minetest.show_formspec(player:get_player_name(), "money:shop", money.shop.get_formspec(money.shop.page[player:get_player_name()]))
		end
		if fields.btn_back then
			money.shop.page[player:get_player_name()] = money.shop.page[player:get_player_name()] - 1
			minetest.show_formspec(player:get_player_name(), "money:shop", money.shop.get_formspec(money.shop.page[player:get_player_name()]))
		end
		if fields.btn_trade then
			money.shop.trade(player)
		end
		if fields.quit then
			money.shop.page[player:get_player_name()] = nil
		end
	end
end)

minetest.register_node("money:shop", {
	description = "Shop",
	tiles = {"money_shop_top.png","money_shop.png","money_shop.png"},
	groups = {choppy = 3},

	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
				{-6/16, -0.5, -6/16, 6/16,4/16, 6/16},
			},
	},
	
	on_rightclick = function(pos, node, player, pointed_thing)
		money.shop.page[player:get_player_name()] = 1
		minetest.show_formspec(player:get_player_name(), "money:shop", money.shop.get_formspec(1))
	end
})

