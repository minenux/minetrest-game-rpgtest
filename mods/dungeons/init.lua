minetest.set_gen_notify("dungeon")
minetest.register_on_generated(function(minp, maxp, seed)
	local g = minetest.get_mapgen_object("gennotify")
	if g and g.dungeon and #g.dungeon > 3 then
		minetest.after(3, function(d)
			if d == nil or #d < 1 then
				return
			end
			for i=1,2 do
				local p = d[math.random(1, #d)]
				if minetest.get_node({x=p.x, y =p.y-1, z=p.z}).name ~= "air" then
					minetest.set_node(p, {name = "default:treasure_chest"})
				end
			end
		end, table.copy(g.dungeon))
	end
end)

local chest_form = "size[8,7]"
local chest_form = chest_form..default.gui_colors
local chest_form = chest_form..default.gui_bg
local chest_form = chest_form.."list[current_name;main;0,0.3;8,2;]" 
local chest_form = chest_form..default.itemslot_bg(0,0.3,8,2)
local chest_form = chest_form.."list[current_player;main;0,2.85;8,1;]" 
local chest_form = chest_form..default.itemslot_bg(0,2.85,8,1)
local chest_form = chest_form.."list[current_player;main;0,4.08;8,3;8]" 
local chest_form = chest_form..default.itemslot_bg(0,4.08,8,3)
local chest_form = chest_form.."listring[current_name;main]"
local chest_form = chest_form.."listring[current_player;main]"

minetest.register_node("dungeons:custom_treasure_chest", {
	description = "Custom Treasure Chest",
	tiles = {"default_treasure_chest.png"},
	groups = {choppy = 3},
	
	after_place_node = function(pos, placer, itemstack, pt)
		local name = placer:get_player_name()
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		inv:set_size("main", 8 * 2)
		
		meta:set_string("owner", name)
		meta:set_string("infotext", "Custom Treasure Chest (" .. name .. ")")
		meta:set_string("formspec", chest_form)
		
		itemstack:take_item()
		return itemstack
	end,
	
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local name = player:get_player_name()
	end,
})
