mobs = {}
mobs.mobs = {}
function mobs.get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end

function mobs.register_mob(name, def)
	mobs.mobs[#mobs.mobs+1] = {name, def.lvl}

	if not def.hp then
		if def.lvl and def.hits then
			def.hp = skills.get_dmg(def.lvl)*def.hits
		end
	end

	minetest.register_entity(name, {
		hp_max = def.hp,
		physical = true,
		collisionbox = def.collisionbox,
	 	visual = "upright_sprite",
	 	visual_size = def.visual_size or {x=1, y=1},
		textures = def.textures,
		spritediv = {x=1, y=1},
		initial_sprite_basepos = {x=0, y=0},
		is_visible = true,
		makes_footstep_sound = false,
		automatic_rotate = true,
		speed = 0,
		anim = "",
		t = 0.0,

		on_punch = function(self, player)
			if self.object:get_hp() <= 0 then
				if player and player:is_player() then
					xp.add_xp(player, def.xp or xp.get_xp(def.lvl, 10))
					if def.drops then
						minetest.spawn_item(self.object:getpos(), def.drops[math.random(1, #def.drops)])
					else
						minetest.spawn_item(self.object:getpos(), "money:silver_coin")
					end
					self.object:remove()
				end
			end
		end,

		on_step = function(self, dtime)
			self.t = self.t + dtime
			if self.t > 1 then
				local all_objects = minetest.get_objects_inside_radius(self.object:getpos(), def.range)
				local found = false
				local _,obj
				for _,obj in ipairs(all_objects) do
					if obj:is_player() then
						print("[mob] punch player")
						local v = vector.direction(self.object:getpos(), obj:getpos())
						v.y = (def.gravity or -9.2)
						self.object:setvelocity(v)
						self.object:setyaw(math.atan(v.x, v.z))

						local yaw = math.atan(v.z/v.x)+math.pi/2
						--yaw = yaw+(math.pi/2)
						if v.x + self.object:getpos().x > self.object:getpos().x then
							yaw = yaw+math.pi
						end
						self.object:setyaw(yaw)

						found = true
						obj:punch(self.object, 10, def.dmg, nil)
						break
					end
				end

				if not found then
					all_objects = minetest.get_objects_inside_radius(self.object:getpos(), 10)
					for _,obj in ipairs(all_objects) do
						if obj:is_player() then
							local obj_p = obj:getpos()
							local p = self.object:getpos()
							local v = vector.multiply(vector.direction(p, obj_p), 4)
							local d = obj_p.y - p.y
							if d > 0 and d < 2 then
								v.y = 2
							else
								v.y = (def.gravity or -9.2)
							end
							self.object:setvelocity(v)

							local yaw = math.atan(v.z/v.x)+math.pi/2
							--yaw = yaw+(math.pi/2)
							if v.x + self.object:getpos().x > self.object:getpos().x then
								yaw = yaw+math.pi
							end

							self.object:setyaw(yaw)
							found = true
							break
						end
					end
				end

				if not found then
					local v = {x=math.random(-2, 2), y=(def.gravity or -9.2), z=math.random(-2, 2)}
					self.object:setvelocity(v)

					local yaw = math.atan(v.z/v.x)+math.pi/2
					--yaw = yaw+(math.pi/2)
					if v.x + self.object:getpos().x > self.object:getpos().x then
						yaw = yaw+math.pi
					end
					self.object:setyaw(yaw)
				end
				self.t = 0
			end
		end,
	})

	minetest.register_craftitem(name, {
		description = def.description,
		inventory_image = "mobs_spawn.png",

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			local p = {x=pointed_thing.above.x, y=pointed_thing.above.y+2, z=pointed_thing.above.z}
			minetest.add_entity(p, name)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
end

function mobs.get_mob(lvl)
	local a = {}
	local found_mob = false
	for i,n in ipairs(mobs.mobs) do
		if n[2] < lvl +5 and n[2] > lvl-5 then
			found_mob = true
			a[#a+1] = n[1]
		end
	end

	if found_mob then
		return a[math.random(1, #a)]
	end

	a = {}
	found_mob = false
	for i,n in ipairs(mobs.mobs) do
		if n[2] < lvl +5 then
			found_mob = true
			a[#a+1] = n[1]
		end
	end

	if found_mob then
		return a[math.random(1, #a)]
	end

	return mobs.mobs[math.random(1, #mobs.mobs)][1]
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 5 then
		for _, player in pairs(minetest.get_connected_players()) do
			local p = player:getpos()
			local a = {-1, 1}
			local x = math.random(20, 40)*a[math.random(1,2)] + p.x
			local z = math.random(20, 40)*a[math.random(1,2)] + p.z
			if minetest.get_node(vector.new(x, p.y+2, z)).name == "air" then
				local n = mobs.get_mob(xp.player_levels[player:get_player_name()])
				minetest.add_entity(vector.new(x, p.y+2, z), n)
			end
		end
		timer = 0
	end
end)

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
