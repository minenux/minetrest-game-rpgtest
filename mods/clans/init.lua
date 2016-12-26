clans = {}
clans.players = {}
clans.all_clans = {}
clans.clans_file = minetest.get_worldpath() .. "/clans"

function clans.create_clan(clan_name)
	if not(clans.all_clans[clan_name]) then
		clans.all_clans[clan_name] = {}
		clans.save_clans()
		return true
	else
		return false
	end
end

function clans.join_clan(clan_name, name)
	if clans.all_clans[clan_name] then
		clans.players[name] = clan_name
		clans.save_clans()
		return true
	else
		clans.save_clans()
		return false
	end
end

function clans.leave_clan(name)
	clans.players[name] = ""
	clans.save_clans()
end

function clans.get_members(clan_name)
	local members = {}
	
	for name, clan in pairs(clans.players) do
		if clan == clan_name then
			table.insert(members, name)
		end
	end
	
	return members
end

function clans.list_clans()
	local all_clans = {}
	
	for name, _ in pairs(clans.all_clans) do
		table.insert(all_clans, name)
	end
	
	return all_clans
end


--TODO
function clans.load_clans()
	local input = io.open(clans.clans_file, "r")
	if input then
		local str = input:read()
		if str then
			if minetest.deserialize(str) then
				local data = minetest.deserialize(str)
				clans.all_clans = data.all_clans
				clans.players = data.players
			end
		end
		io.close(input)
	end
end

function clans.save_clans()
	if clans.all_clans then
		local data = {}
		data.all_clans = clans.all_clans
		data.players = clans.players
	
		local output = io.open(clans.clans_file, "w")
		local str = minetest.serialize(data)
		output:write(str)
		io.close(output)
	end
end

clans.load_clans()

minetest.register_chatcommand("clan", {
	params = "join/leave/new/show/all (<clan>)",
	description = "",
	privs = {interact = true},
	func = function(name, text)
		local params = string.split(text, " ")
		
		if #params > 0 then
			if params[1] == "join" and #params > 1 then
				local out = clans.join_clan(params[2], name)
				if out then
					clans.join_clan(params[2], name)
					return true, "Done"
				else
					return false, "Error"
				end
				
			elseif params[1] == "leave" then
				clans.leave_clan(name)
				return true, "Done"
				
			elseif (params[1] == "new" or params[1] == "add" or params[1] == "create") and #params > 1 then
				local out = clans.create_clan(params[2])
				if out then
					clans.join_clan(params[2], name)
					return true, "Done"
				else
					return false, "Error"
				end
				
			elseif params[1] == "show" then
				if clans.players[name] then
					return true, "Members: " .. table.concat(clans.get_members(clans.players[name]), ", ")
				else
					return false, "Error"
				end
				
			elseif (params[1] == "all" or params[1] == "list") then
				return true, "Clans: " .. table.concat(clans.list_clans(), ", ")
				
			else
				return false, "/clan join/leave/new/show/all (<clan>)"
			end
		end
	end,
})
