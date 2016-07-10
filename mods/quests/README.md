# Quests

Mod to manage tasks.

Todo:

* Add support for more goals than digging and placing
* Multiple goal.requires
* Call backs on quest completion

## Creating quests

Here is a basic quest:

```lua
local quest = quests.new(name, "Preparing a small feast")
quests.add_dig_goal(quest, "Harvest wheat", "farming:wheat_8", 5)
quests.add_dig_goal(quest, "Harvest apples", "default:apple", 3)
quests.add_quest(name, quest)
```

This will show up in the quest menu as:

	-> Preparing a small feast
	    [ ] Harvest wheat (0/5)
		[ ] Harvest apples (0/3)

For longer quests, certain goals need to be done in an order.
To do this, use goal.require:

```lua
local quest = quests.new(name, "Breaking Bread")
local g1 = quests.add_dig_goal(quest, "Harvest wheat", "treasure:raregem", 1)
local g2 = quests.add_give_goal(quest, "Return to Bob the Farmer", bob, "treasure:raregem", 1)
g2.requires = g1
quest.next = quest2
```
