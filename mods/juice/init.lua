juice = {}
function juice.drink(player, itemstack, hp)
	player:set_hp(player:get_hp()+hp)
	itemstack = {name = "juice:glass", count = 1}
	return itemstack
end

minetest.register_craftitem("juice:glass", {
	description = "Glass",
	inventory_image = "juice_glass.png",
})

minetest.register_craftitem("juice:water", {
	description = "Water",
	inventory_image = "juice_water.png",
	on_use = function(itemstack, user, pointed_thing)
		return juice.drink(user, itemstack, 3)
	end,
	stack_max = 1,
})

minetest.register_craftitem("juice:cactus", {
	description = "Cactus Juice",
	inventory_image = "juice_cactus.png",
	on_use = function(itemstack, user, pointed_thing)
		return juice.drink(user, itemstack, 6)
	end,
	stack_max = 1,
})

minetest.register_craftitem("juice:strawberry", {
	description = "Strawberry Juice",
	inventory_image = "juice_strawberry.png",
	on_use = function(itemstack, user, pointed_thing)
		return juice.drink(user, itemstack, 6)
	end,
	stack_max = 1,
})

minetest.register_craftitem("juice:apple", {
	description = "Apple Juice",
	inventory_image = "juice_apple.png",
	on_use = function(itemstack, user, pointed_thing)
		return juice.drink(user, itemstack, 7)
	end,
	stack_max = 1,
})

minetest.register_craft({
	type = "shapeless",
	output = "juice:cactus",
	recipe = {"juice:glass", "farming:cactus"},
})

minetest.register_craft({
	type = "shapeless",
	output = "juice:water",
	recipe = {"juice:glass", "farming:bowl_with_water"},
	replacements = {
		{"farming:bowl_with_water", "farming:bowl"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "juice:apple",
	recipe = {"juice:water", "farming:apple"},
})

minetest.register_craft({
	output = "juice:glass 20",
	recipe = {
		{"default:glass", "", "default:glass"},
		{"default:glass", "", "default:glass"},
		{"default:glass", "default:glass", "default:glass"},
	}
})
