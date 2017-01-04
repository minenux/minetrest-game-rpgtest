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
	end

	minetest.register_node(name, def)	
end

--TEST
npcs.register_npc("npcs:farmer", {
	npc_type = "text",
	npc_text = "Hi!",
	npc_quest_title = "Test",
	npc_get_quest = function(pos, player)
		local quest = quests.new(nil, "Test", "Test")
		local goal_1 = quests.add_place_goal(quest, "Place dirt", {"default:dirt"}, 10, "Place some dirt!")
		return quest
	end,
})
