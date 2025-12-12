extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var game_over_label: Label = $Panel/VBoxContainer/GameOverLabel

func _ready():
	hide()

func show_game_over():
	# Pausar o jogo
	get_tree().paused = true
	show()
	
	# Aguardar 2 segundos
	await get_tree().create_timer(2.0, true, false, true).timeout
	
	# Esconder e remover
	hide()
	queue_free()
	
	# Despausar e resetar
	get_tree().paused = false
	
	# Resetar munição e energia
	Globals.apples = 10
	Globals.carrots = 10
	Globals.energy = 100
	
	# Resetar flags de primeira coleta
	Globals.first_apple_collected = false
	Globals.first_carrot_collected = false
	Globals.first_water_collected = false
	
	# Recarregar cena
	get_tree().reload_current_scene()
