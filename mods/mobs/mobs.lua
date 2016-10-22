--mobs
mobs.register_mob("mobs:slime", {
	textures = {"mobs_slime.png",},
	lvl = 3,
	hits = 6,
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=3},
	},
	collisionbox = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
	description = "Slime",
	range = 3,
})

mobs.register_mob("mobs:big_slime", {
	textures = {"mobs_slime.png",},
	lvl = 7,
	hits = 6,
	visual_size = {x=2,y=2},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=3},
	},
	collisionbox = {-0.9, -1, -0.9, 0.9, 1, 0.9},
	description = "Big Slime",
	range = 3,

})

mobs.register_mob("mobs:dungeon_guardian", {
	textures = {"mobs_dungeon_guardian.png",},
	lvl = 15,
	hits = 6,
	visual_size = {x=2,y=2},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=3},
	},
	collisionbox = {-0.8, -1, -0.8, 0.8, 1, 0.8},
	description = "Dungeon Guardian",
	range = 4,

})

mobs.register_mob("mobs:blue_cube", {
	textures = {"mobs_blue_cube.png",},
	lvl = 20,
	hits = 6,
	visual_size = {x=1.5,y=1.5},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=3},
	},
	collisionbox = {-0.6, -0.75, -0.6, 0.6, 0.75, 0.6},
	description = "Blue Cube",
	range = 4,

})

mobs.register_mob("mobs:small_grass_monster", {
	textures = {"mobs_grass_monster.png",},
	lvl = 7,
	hits = 3,
	visual_size = {x=0.5,y=0.5},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=3},
	},
	drops = {"default:grass 5"},
	collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
	description = "Small Grass Monster",
	range = 4,

})

mobs.register_mob("mobs:grass_monster", {
	textures = {"mobs_grass_monster.png",},
	lvl = 22,
	hits = 6,
	visual_size = {x=1.5,y=1.5},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=3},
	},
	drops = {"default:grass 10"},
	collisionbox = {-0.6, -0.75, -0.6, 0.6, 0.6, 0.6},
	description = "Grass Monster",
	range = 4,

})

mobs.register_mob("mobs:angry_cloud", {
	textures = {"mobs_angry_cloud.png",},
	lvl = 25,
	hits = 4,
	visual_size = {x=1.5,y=1.5},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=4},
	},
	collisionbox = {-0.6, -0.25, -0.6, 0.6, 0.25, 0.6},
	description = "Angry Cloud",
	range = 5,

})

mobs.register_mob("mobs:hedgehog", {
	textures = {"mobs_hedgehog.png",},
	lvl = 30,
	hits = 7,
	visual_size = {x=1,y=1},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=1},
	},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, -0.25, 0.3},
	description = "Hedgehog",
	range = 8,

})

mobs.register_mob("mobs:book", {
	textures = {"mobs_book.png",},
	lvl = 35,
	hits = 7,
	visual_size = {x=1,y=1},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=5},
	},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.4, 0.3},
	description = "Book",
	range = 3,
	drops = {"money:coin"}
})

mobs.register_mob("mobs:coal_monster", {
	textures = {"mobs_coal_monster.png",},
	lvl = 40,
	hits = 4,
	visual_size = {x=1,y=1},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=5},
	},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3},
	description = "Coal Monster",
	range = 6,
	drops = {"money:coin"}
})

mobs.register_mob("mobs:lava_flower", {
	textures = {"mobs_lava_flower.png",},
	lvl = 37,
	hits = 10,
	visual_size = {x=1,y=1},
	dmg = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		},
		damage_groups = {friendly=6},
	},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3},
	description = "Lava Flower",
	range = 2,
	drops = {"money:coin 2"}
})
