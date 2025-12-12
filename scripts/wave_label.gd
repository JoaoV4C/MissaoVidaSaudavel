extends Label

var wave_manager

func _ready():
	# Encontrar WaveManager usando o grupo
	var wave_managers = get_tree().get_nodes_in_group("WaveManager")
	if wave_managers.size() > 0:
		wave_manager = wave_managers[0]
		wave_manager.wave_completed.connect(_on_wave_completed)
		wave_manager.all_waves_completed.connect(_on_all_waves_completed)
		update_text()

func update_text():
	if wave_manager:
		text = "Onda " + str(wave_manager.current_wave) + "/6"

func _on_wave_completed():
	await get_tree().create_timer(0.5).timeout
	update_text()
	
	# Mostrar mensagem temporária
	var original_text = text
	text = "Onda Completa!"
	await get_tree().create_timer(2.0).timeout
	text = original_text

func _on_all_waves_completed():
	text = "VITORIA!"
	modulate = Color(1, 1, 0)  # Amarelo
