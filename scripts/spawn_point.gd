extends Marker2D

func _ready():
	# Registrar este spawn point com o wave manager
	var wave_manager = get_tree().get_first_node_in_group("WaveManager")
	if not wave_manager:
		wave_manager = get_node("/root/MainGame/WaveManager")
	
	if wave_manager:
		wave_manager.register_spawn_point(self)
	else:
		print("[SPAWN_POINT] ERRO: Wave manager não encontrado!")

func _register_spawn_point(wave_manager):
	wave_manager.register_spawn_point(self)
