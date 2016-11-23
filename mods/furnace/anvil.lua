furnace.anvil.materials = {}

function furnace.anvil.register_material(name, def)
	furnace.anvil.materials[name] = def
end

furnace.anvil.register_material("iron", {
	items = {
		plate = "furnace:iron_plate",
		rod = "furnace:iron_rod",
		blade = "default:blade"
	}
})

furnace.anvil.register_material("copper", {
	items = {
		plate = "furnace:copper_plate",
		rod = "furnace:copper_rod"
	}
})

furnace.anvil.register_material("gold", {
	items = {
		plate = "furnace:gold_plate",
		rod = "furnace:gold_rod"
	}
})
