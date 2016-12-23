minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:grass"},
	sidelen = 16,
	noise_params = {offset=0, scale=0.0001, spread={x=100, y=100, z=100}, seed=354, octaves=3, persist=0.7},
	biomes = {
		"grassland", "forest"
	},
	y_min = 6,
	y_max = 20,
	schematic = minetest.get_modpath("village").."/schematics/house1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dry_grass"},
	fill_ratio = 0.0005,
	biomes = {
		"savanna"
	},
	y_min = 6,
	y_max = 20,
	schematic = minetest.get_modpath("village").."/schematics/house2.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})
