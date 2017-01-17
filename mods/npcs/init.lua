npcs = {}
npcs.npcs = {}
npcs.all_npcs = {}

function npcs.register_npc(name, def)
	npcs.npcs[name] = true
	table.insert(npcs.all_npcs, name)

	def.description = def.description or "NPC"
	def.groups = def.groups or ""
	
	def.drawtype = def.drawtype or "mesh"
	if def.drawtype == "mesh" then
		def.mesh = def.mesh or "npc.x"
		def.paramtype = def.paramtype or "light"
		def.paramtype2 = def.paramtype2 or "facedir"
		def.visual_scale = def.visual_scale or 1.0
	end
	
	def.tiles = def.tiles or {"character.png"}

	if def.npc_type == "quest" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			local name = player:get_player_name()
			if quests.process_npc_goals(name, "talk", pt.under) then
				return
			end
		
			local q = def.npc_get_quest(pos, player)
			
			if not(quests.has_quest(name, q.title .. (q.id or ""))) then
				local d = dialogue.new(q.text)
			
				d:add_option("Ok", function(n)
					quests.add_quest(n, q)
				end)
				
				d:add_option("Quit", function(n)
				end)
				
				d:show(name)
			end
		end
	elseif def.npc_type == "text" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			if quests.process_npc_goals(player:get_player_name(), "talk", pt.under) then
				return
			end
			
			local name = player:get_player_name()
			quests.show_text(def.npc_text, name)
		end
	elseif def.npc_type == "texts" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			if quests.process_npc_goals(player:get_player_name(), "talk", pt.under) then
				return
			end
			
			local name = player:get_player_name()
			quests.show_text(def.npc_texts[math.random(#def.npc_texts)], name)
		end
	elseif def.npc_type == "quests" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			if quests.process_npc_goals(player:get_player_name(), "talk", pt.under) then
				return
			end
		
			local d = dialogue.new(def.npc_text)
			local my_quests = def.npc_get_quests(pos, player)
			
			
			for i, q in ipairs(my_quests) do
				if not(quests.has_quest(player:get_player_name(), q.title .. (q.id or ""))) then
					d:add_option(q.title, function(name)
						quests.add_quest(name, q)
					end)
				end
			end
			
			d:show(player:get_player_name())
		end
	elseif def.npc_type == "shop" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			if quests.process_npc_goals(player:get_player_name(), "talk", pt.under) then
				return
			end
			
			local d = dialogue.new(def.npc_text)
			
			
			for i, item in ipairs(def.npc_items) do
				d:add_option(item.text, function(name)
					if player then
						local inv = player:get_inventory()
						
						if inv:contains_item("main", item.input) and inv:room_for_item("main", item.output) then
							inv:remove_item("main", item.input)
							inv:add_item("main", item.output)	
						end
					end
				end)
			end
			
			d:show(player:get_player_name())
		end
	end

	minetest.register_node(name, def)	
end

minetest.register_node("npcs:spawner", {
	description = "NPC Spawner",
	drawtype = "airlike",
})

minetest.register_abm({
	nodenames = {"npcs:spawner"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = npcs.all_npcs[math.random(#npcs.all_npcs)], param2 = math.random(0,3)})
	end,
})

npcs.register_npc("npcs:farmer_1", {
	tiles = {"npc_1.png"},
	npc_type = "shop",
	npc_text = "Hi! Do you want to buy an item?",
	npc_items = {
		{
			input = "money:silver_coin",
			output = "farming:apple 9",
			text = "1 Silver Coin -> 8 Apple",
		}, {
			input = "money:silver_coin 1",
			output = "farming:slice_of_bread 9",
			text = "4 Silver Coin -> 4 Slice of Bread",
		}, {
			input = "money:silver_coin 1",
			output = "default:mushroom 2",
			text = "1 Silver Coin -> 2 Mushroom",
		}
	},
})

npcs.register_npc("npcs:miner_1", {
	tiles = {"npc_3.png"},
	npc_type = "shop",
	npc_text = "Hi! Do you want to buy an item?",
	npc_items = {
		{
			input = "money:silver_coin 10",
			output = "furnace:furnace",
			text = "10 Silver Coin -> 1 Furnace",
		}, {
			input = "money:silver_coin 10",
			output = "furnace:anvil",
			text = "10 Silver Coin -> 1 Anvil",
		}, {
			input = "money:silver_coin",
			output = "torch:torch 4",
			text = "1 Silver Coin -> 4 Torch",
		}, {
			input = "money:coin",
			output = "default:pick",
			text = "1 Gold Coin -> 1 Iron Pick",
		}, {
			input = "default:stone_item 999",
			output = "money:silver_coin 5",
			text = "999 Stone -> 5 Silver Coin",
		}
	},
})

npcs.register_npc("npcs:hunter_1", {
	tiles = {"npc_2.png"},
	npc_type = "quest",
	npc_get_quest = function(pos, player)
		local quest = quests.new(nil, "Test", "Test")
		quest.id = tostring(minetest.get_day_count()) .. " " .. minetest.pos_to_string(pos)
		local goal_1 = quests.add_place_goal(quest, "Place dirt", {"default:dirt"}, 1, "Place some dirt blocks!")
		local goal_2 = quests.add_talk_goal(quest, "Talk", pos, "Place some dirt blocks!")
		
		goal_2.requires = goal_1
		
		return quest
	end,
})

npcs.register_npc("npcs:builder_1", {
	tiles = {"npc_4.png"},
	npc_type = "texts",
	npc_texts = {
		"Hello!",
		"Hi!",
		"Hey!",
		
		"Hello.\nHow are you?",
		"Hi.\nHow are you?",
		"Hey.\nHow are you?",
	},
})

--TEST
--npcs.register_npc("npcs:farmer", {
--	tiles = {"npc_1.png"},
--	visual_scale = 1.0,
--	npc_type = "quest",
--	npc_text = "Hi!",
--	npc_quest_title = "Test",
--	npc_get_quest = function(pos, player)
--		local quest = quests.new(nil, "Test", "Test")
--		quest.id = tostring(minetest.get_day_count()) .. " " .. minetest.pos_to_string(pos)
--		local goal_1 = quests.add_place_goal(quest, "Place dirt", {"default:dirt"}, 1, "Place some dirt blocks!")
--		local goal_2 = quests.add_talk_goal(quest, "Talk", pos, "Place some dirt blocks!")
--		
--		goal_2.requires = goal_1
--		
--		return quest
--	end,
--	npc_get_quests = function(pos, player)
--		local my_quests = {}
--	
--		do
--			local quest = quests.new(nil, "Test 1", "Test 1")
--			local goal_1 = quests.add_place_goal(quest, "Place dirt", {"default:dirt"}, 10, "Place some dirt blocks!")
--			table.insert(my_quests, quest)
--		end
--		
--		do
--			local quest = quests.new(nil, "Test 2", "Test 2")
--			local goal_1 = quests.add_place_goal(quest, "Place stone", {"default:stone"}, 10, "Place some stone blocks!")
--			table.insert(my_quests, quest)
--		end
--		
--		return my_quests
--	end,
--	npc_items = {
--		{
--			input = "default:stone_item",
--			output = "default:pick",
--			text = "Stone -> Pick",
--		}
--	},
--})
