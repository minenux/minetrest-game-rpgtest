# Dialogue

Formspec API to chat with NPCs

```lua
minetest.register_chatcommand("a", {
	func = function(name, param)
		local d = dialogue.new("Hi! I'm the blacksmith. How can I help you?")
		d:add_option("What do you have for sale?", function(name)
			print("ans: sale")
		end)
		d:add_option("Could you use any help?", function(name)
			print("ans: ask for quests")
		end)
		d:add_option("Nevermind", function(name)
			print("ans: nevermind")
		end)
		d:show(name)
	end
})
```

## Methods

* `dialogue.new(question_text)` - returns dialogue builder (used below as `d` variable)
	* `d:add_option(answer_text, callback_func)` - adds option to dialogue builder
	* `d:show(player_name)` - show to player name using dialogue.ask
	* `callback_func` - called like callback_func(name_of_player_shown_to)
* `dialogue.ask(name, question, answers)`
	* Shouldn't be used directly unless you need finer control.
	* `name`: player to show formspec to
	* `question`: text, what the NPC said
	* `answer`: array of objects. `{ { text = "answer", callback = function(name) end } }`
