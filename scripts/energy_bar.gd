extends TextureProgressBar

func _ready():
	max_value = 100
	value = Globals.energy
	print("[ENERGY_BAR] Initialized. Max: ", max_value, " Current: ", value)

func _process(_delta):
	if value != Globals.energy:
		print("[ENERGY_BAR] Atualizando: ", value, " -> ", Globals.energy)
	value = Globals.energy
