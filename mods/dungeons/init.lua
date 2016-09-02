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
