stairs = {}

stairs.blocks = {}

function stairs.register_stair_and_slab(name, base)
	if not minetest.registered_nodes[base] then 
		return
	end

	minetest.register_node(name.."_slab", {
		description = minetest.registered_nodes[base].description .. " Slab",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})

	stairs.blocks[base] = name.."_slab"

	minetest.register_node(name.."_stair", {
		description = minetest.registered_nodes[base].description .. " Stair",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
					{-0.5, -0.5, 0, 0.5, 0.5, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})

	stairs.blocks[name.."_slab"] = name.."_stair"

	minetest.register_node(name.."_stair_corner_1", {
		description = minetest.registered_nodes[base].description .. " Corner",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
					{-0.5, -0.5, 0, 0.5, 0.5, 0.5},
					{0, -0.5, -0.5, 0.5, 0.5, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})

	stairs.blocks[name.."_stair"] = name.."_stair_corner_1"

	minetest.register_node(name.."_stair_corner_2", {
		description = minetest.registered_nodes[base].description .. " Corner",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
					{0, -0.5, 0, 0.5, 0.5, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})

	stairs.blocks[name.."_stair_corner_1"] = name.."_stair_corner_2"

	stairs.blocks[name.."_stair_corner_2"] = base

	minetest.register_node(name.."_wall", {
		description = minetest.registered_nodes[base].description .. " Wall",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, 0, 0.5, 0.5, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})

	minetest.register_node(name.."_wall_corner_1", {
		description = minetest.registered_nodes[base].description .. " Corner",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{-0.5, -0.5, 0, 0.5, 0.5, 0.5},
					{0, -0.5, -0.5, 0.5, 0.5, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})

	minetest.register_node(name.."_wall_corner_2", {
		description = minetest.registered_nodes[base].description .. " Corner",
		tiles = minetest.registered_nodes[base].tiles,
		groups = minetest.registered_nodes[base].groups,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
					{0, -0.5, 0, 0.5, 0.5, 0.5},
				},
		},
		sounds = minetest.registered_nodes[base].sounds or nil,
	})
end

stairs.register_stair_and_slab("stairs:stonebrick", "default:stonebrick")
stairs.register_stair_and_slab("stairs:stone_tile", "default:stone_tile")
stairs.register_stair_and_slab("stairs:stone", "default:stone")
stairs.register_stair_and_slab("stairs:cobble", "default:cobble")
stairs.register_stair_and_slab("stairs:brick", "default:brick")
stairs.register_stair_and_slab("stairs:wood", "default:wood")
stairs.register_stair_and_slab("stairs:wooden_planks", "default:wooden_planks")
stairs.register_stair_and_slab("stairs:wooden_planks_jungle", "default:wooden_planks_jungle")

stairs.register_stair_and_slab("stairs:grass", "default:grass")
stairs.register_stair_and_slab("stairs:dirt", "default:dirt")

minetest.register_craftitem("stairs:chisel", {
	description = "Chisel",
	inventory_image = "stairs_chisel.png",
 
	on_use = function(itemstack, user, pt)
		if pt.type == "node" then
			if stairs.blocks[minetest.get_node(pt.under).name] then
				if minetest.registered_nodes[stairs.blocks[minetest.get_node(pt.under).name]].paramtype2 == "facedir" then
					minetest.set_node(pt.under, {name=stairs.blocks[minetest.get_node(pt.under).name], param2 = minetest.dir_to_facedir(vector.subtract(pt.under, pt.above))})
				else
					minetest.set_node(pt.under, {name=stairs.blocks[minetest.get_node(pt.under).name]})
				end
			end
		end
		return itemstack
	end,

	on_place = function(itemstack, placer, pt)
		if pt.type == "node" then
			local n = minetest.get_node(pt.under)
			if minetest.registered_nodes[n.name].paramtype2 == "facedir" then
				n.param2 = n.param2 + 1;
				if n.param2 > 3 then
					n.param2 = 0;
				end
				minetest.swap_node(pt.under, n)
			end
		end
		return itemstack
	end
})
