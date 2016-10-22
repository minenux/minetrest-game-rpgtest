mobs.register_component("walk", {
	action = function(self, params, def)
		if self.destination then	
			local destination = self.destination
			if self.destination and self.destination.is_player and self.destination:is_player() then
				destination = self.destination:getpos()
			end
			if not(destination) then
				return 0
			end

			local pos = self.object:getpos()
			if(vector.distance(destination, pos) < (params.distance or 3)) then
				self.object:setvelocity(vector.new(0, params.gravity or def.gravity or -9, 0))
				return 2
			end

			local velocity = vector.multiply(vector.direction(pos, destination), params.speed or 3)
			velocity.y = (params.gravity or def.gravity or -9.2)
			self.object:setvelocity(velocity)

			local yaw = math.atan(velocity.z/velocity.x)+math.pi/2
			if velocity.x + pos.x > pos.x then
				yaw = yaw + math.pi
			end

			self.object:setyaw(yaw)
			return 1
		else
			self.object:setvelocity(vector.new(0, params.gravity or def.gravity or -9, 0))
		end
		return 0
	end
})

mobs.register_component("find_player", {
	action = function(self, params, def)
		local all_objects = minetest.get_objects_inside_radius(self.object:getpos(), params.range or def.range or 10)
		for _,obj in ipairs(all_objects) do
			if obj:is_player() then
				self.destination = obj
				return 1
			end
		end
		return 0
	end
})

mobs.register_component("attack", {
	action = function(self, params, def)
		if self.destination and self.destination.is_player and self.destination:is_player() and 
		   vector.distance(self.destination:getpos(), self.object:getpos()) < (params.range or def.range or 3) then
			if minetest.line_of_sight(vector.add(self.object:getpos(), vector.new(0, 0.5, 0)),
			   vector.add(self.destination:getpos(), vector.new(0, 0.5, 0)), 1) then
				self.destination:punch(self.object, 10, params.damage or def.damage or def.dmg or 3, nil)
				return 1
			end
		end
		return 0
	end
})

mobs.register_component("randomize_destination", {
	action = function(self, params, def)
		local pos = self.object:getpos()
		self.destination = vector.add(pos, vector.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)))
		return 1
	end
})
