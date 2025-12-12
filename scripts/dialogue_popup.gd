extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var dialogue_label: Label = $Panel/MarginContainer/VBoxContainer/DialogueLabel

const CHAR_DISPLAY_TIME = 0.05  # Tempo entre cada letra

func show_dialogue(text: String):
	get_tree().paused = true
	show()
	
	# Animar texto letra por letra
	dialogue_label.text = ""
	for i in range(text.length()):
		dialogue_label.text += text[i]
		await get_tree().create_timer(CHAR_DISPLAY_TIME, true, false, true).timeout
	
	# Aguardar input do jogador
	await get_tree().create_timer(0.5, true, false, true).timeout
	while not (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump")):
		await get_tree().process_frame
	
	hide()
	queue_free()
	get_tree().paused = false
