dialogue = {
	contexts = {}
}

function dialogue.ask(name, question, answers)
	dialogue.contexts[name] = {
		answers = answers
	}

	-- generate formspec and show
	local arrays = {
		"size[8," .. tostring(#answers*0.75+0.75) .. "]",
		default.gui_colors,
		default.gui_bg,
		"label[0,0;",
		question
	}

	for i = 1, #answers do
		local ans = answers[i]
		arrays[#arrays + 1] = "]button_exit[0,"
		arrays[#arrays + 1] = i * 0.75
		arrays[#arrays + 1] = ";8,1;btn_"
		arrays[#arrays + 1] = i
		arrays[#arrays + 1] = ";"
		arrays[#arrays + 1] = ans.text
	end
	arrays[#arrays + 1] = "]"

	minetest.show_formspec(name, "dialogue:ask", table.concat(arrays, ""))
end

function dialogue.new(question)
	return {
		_answers = {},
		add_option = function(self, text, callback)
			self._answers[#self._answers + 1] = {
				text = text,
				callback = callback
			}
		end,
		show = function(self, name)
			dialogue.ask(name, question, self._answers)
		end
	}
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "dialogue:ask" then
		return
	end

	local context = dialogue.contexts[player:get_player_name()]
	if context then
		for i = 1, #context.answers do
			if fields["btn_" .. i] then
				local ans = context.answers[i]
				if ans.callback then
					ans.callback(player:get_player_name())
				end
			end
		end
	end
end)
