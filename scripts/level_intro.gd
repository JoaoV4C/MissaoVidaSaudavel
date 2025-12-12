extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var level_name: Label = $Panel/VBoxContainer/LevelName
@onready var level_subtitle: Label = $Panel/VBoxContainer/LevelSubtitle

func _ready():
	hide()

func show_level_intro(title: String, subtitle: String):
	level_name.text = title
	level_subtitle.text = subtitle
	
	# Pausar o jogo
	get_tree().paused = true
	show()
	
	# Aguardar 2 segundos (com processo_mode que ignora pause)
	await get_tree().create_timer(2.0, true, false, true).timeout
	
	# Despausar o jogo
	hide()
	get_tree().paused = false
	queue_free()
