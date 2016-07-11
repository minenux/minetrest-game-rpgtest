-- story quests

quests = {}
quests.player_quests = {}
quests.file = minetest.get_worldpath() .. "/quests"
quests.callback = nil

function quests.load()
	local input = io.open(quests.file, "r")
	if input then
		local str = input:read("*all")
		if str then
			if minetest.deserialize(str) then
				quests.player_quests = minetest.deserialize(str)
			end
		else
			print("[WARNING] quest file is empty")
		end
		io.close(input)
	else
		print("[ERROR] couldnt find quest file")
	end
end

function quests.save()
	if quests.player_quests then
		local output = io.open(quests.file, "w")
		local str = minetest.serialize(quests.player_quests)
		output:write(str)
		io.close(output)
	end
end

function quests.add_quest(player, quest)
	if not quests.player_quests[player] then
		quests.player_quests[player] = {}
	end
	print("[quests] add quest")
	table.insert(quests.player_quests[player], quest)
	quests.save()
	return #quests.player_quests[player]
end

function quests.finish_quest(player, quest)
	xp.add_xp(minetest.get_player_by_name(player), quest.xp)
	quest.done = true
	if quests.callback then
		quests.callback(minetest.get_player_by_name(player))
	end
end

function quests.finish_goal(player, quest, goal)
	goal.done = true
	if not quest.done then
		local all_done = true
		for i = 1, #quest.goals do
			if not quest.goals[i].done then
				all_done = false
				break
			end
		end
		if all_done then
			quests.finish_quest(player, quest)
		end
	end
	quests.save()
end

function quests.new(player, title)
	local quest = {
		title = title,
		done = false,
		goals = {},
		xp = 0
	}

	return quest
end

function quests.add_dig_goal(quest, title, node, number)
	local goal = {
		title = title,
		type = "dig",
		node = node,
		max = number,
		progress = 0,
		done = false
	}
	table.insert(quest.goals, goal)
	return goal
end

function quests.add_place_goal(quest, title, node, number)
	local goal = {
		title = title,
		type = "placenode",
		node = node,
		max = number,
		progress = 0,
		done = false
	}
	table.insert(quest.goals, goal)
	return goal
end

function quests.process_node_count_goals(player, type, node)
	local player_quests = quests.player_quests[player]
	table.foreach(player_quests, function(_, quest)
		table.foreach(quest.goals, function(_, goal)
			if (not goal.requires or goal.requires.done) and
					goal.type == type and goal.node == node then
				goal.progress = goal.progress + 1
				if goal.progress >= goal.max then
					goal.progress = goal.max
					goal.done = true
					if goal.done then
						quests.finish_goal(player, quest, goal)
					end
				end
				quests.save()
			end
		end)
	end)
end

quests.show_quests_form = "size[8,7.5;]" .. default.gui_colors ..
		default.gui_bg .. "label[0,0;%s]"

function quests.format_goal(player, quest, goal)
	-- TODO: support formatting for more than just digging and placing
	if goal.done then
		return "     [x] " .. goal.title .. " (" .. tostring(goal.progress) ..
		   	"/" .. tostring(goal.max) .. ")\n"
	else
		return "     [ ] " .. goal.title .. " (" .. tostring(goal.progress) ..
		   "/" .. tostring(goal.max) .. ")\n"
	end
end

minetest.register_chatcommand("quests", {
	params = "",
	description = "Shows your quests",
	privs = {},
	func = function(name, text)
		local player_quests = quests.player_quests[name]
		if not player_quests or #player_quests == 0 then
			local s = quests.show_quests_form
			s = string.format(s, "You have not got any quests yet.")
			minetest.show_formspec(name, "quests:show_quests", s)
			return
		end

		local s = quests.show_quests_form
		local txt = ""
		for _, quest in pairs(player_quests) do
			if quest.done then
				txt = txt .. " -> " .. quest.title .. " (Completed)\n"
			else
				txt = txt .. " -> " .. quest.title .. "\n"
				for _, goal in pairs(quest.goals) do
					if not goal.requires or goal.requires.done then
						txt = txt .. quests.format_goal(name, quest, goal)
					end
				end
			end
		end
		s = string.format(s, minetest.formspec_escape(txt))
		minetest.show_formspec(name, "quests:show_quests", s)
		return true, ""
	end,
})

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger or not digger:is_player() or
			not quests.player_quests[digger:get_player_name()] then
		return
	end

	quests.process_node_count_goals(digger:get_player_name(), "dig", oldnode.name)
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if not placer or not placer:is_player() or
			not quests.player_quests[placer:get_player_name()] then
		return
	end

	quests.process_node_count_goals(placer:get_player_name(), "placenode", newnode.name)
end)

minetest.register_on_newplayer(function(player)
	if not player then
		return
	end
	quests.player_quests[player:get_player_name()] = {}

	local name = player:get_player_name()
	local quest = quests.new(name, "Quest 1")
	local q1 = quests.add_dig_goal(quest, "Harvest dirt", "default:dirt", 5)
	local q2 = quests.add_dig_goal(quest, "Harvest sand", "default:sand", 5)
	q2.requires = q1
	quests.add_quest(name, quest)
end)

quests.load()

-- exploring
minetest.register_node("quests:map", {
	description = "Map",
	tiles = {"quests_map_top.png", "quests_map_top.png", "quests_map.png", "quests_map.png", "quests_map.png", "quests_map.png"},
	groups = {quest = 1, cracky = 3},
	on_punch = function(pos, node, player, pointed_thing)
		xp.add_xp(player, math.random(3, 30))
		minetest.remove_node(pos)
	end,
})

minetest.register_node("quests:ray", {
	description = "Ray",
	tiles = {"quests_glowing_ray.png"},
	groups = {cracky = 1, ray=1},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	light_source = 7,
	node_box = {
		type = "fixed",
		fixed = {
				{-0.2, -0.5, -0.2, 0.2, 0.5, 0.2},
			},
	},
	drop = "",
})
