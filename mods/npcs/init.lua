npcs = {}
npcs.npcs = {}

function npcs.register_npc(name, def)
	npcs.npcs[name] = true

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
			if not(quests.has_quest(name, def.npc_quest_title)) then
				quests.add_quest(name, def.npc_get_quest(pos, player))
			else
				--TODO
			end
		end
	elseif def.npc_type == "text" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			local name = player:get_player_name()
			quests.show_text(def.npc_text, name)
		end
	elseif def.npc_type == "quests" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
			local d = dialogue.new(def.npc_text)
			local my_quests = def.npc_get_quests(pos, player)
			
			
			for i, q in ipairs(my_quests) do
				if not(quests.has_quest(player:get_player_name(), q.title)) then
					d:add_option(q.title, function(name)
						quests.add_quest(name, q)
					end)
				end
			end
			
			d:show(player:get_player_name())
		end
	elseif def.npc_type == "shop" then
		def.on_rightclick = function(pos, node, player, itemstack, pt)
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

--TEST
npcs.register_npc("npcs:farmer", {
	npc_type = "shop",
	npc_text = "Hi!",
	npc_quest_title = "Test",
	npc_get_quest = function(pos, player)
		local quest = quests.new(nil, "Test", "Test")
		local goal_1 = quests.add_place_goal(quest, "Place dirt", {"default:dirt"}, 10, "Place some dirt blocks!")
		return quest
	end,
	npc_get_quests = function(pos, player)
		local my_quests = {}
	
		do
			local quest = quests.new(nil, "Test 1", "Test 1")
			local goal_1 = quests.add_place_goal(quest, "Place dirt", {"default:dirt"}, 10, "Place some dirt blocks!")
			table.insert(my_quests, quest)
		end
		
		do
			local quest = quests.new(nil, "Test 2", "Test 2")
			local goal_1 = quests.add_place_goal(quest, "Place stone", {"default:stone"}, 10, "Place some stone blocks!")
			table.insert(my_quests, quest)
		end
		
		return my_quests
	end,
	npc_items = {
		{
			input = "default:stone_item",
			output = "default:pick",
			text = "Stone -> Pick",
		}
	},
})
