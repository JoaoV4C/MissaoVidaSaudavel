extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var menu_button: Button = $Panel/VBoxContainer/MenuButton

const CHAR_DISPLAY_TIME = 0.05  # Tempo entre cada letra

func show_victory():
	get_tree().paused = true
	show()
	
	# Esconder botão inicialmente
	menu_button.visible = false
	
	var message = "Uau! Sinto a energia da Vila Viva voltando!\n\nA entrada esta limpa, mas ainda ha muita preguica a ser combatida.\n\nNovos desafios e mais superalimentos virao em breve!"
	
	# Animar texto letra por letra
	message_label.text = ""
	for i in range(message.length()):
		message_label.text += message[i]
		await get_tree().create_timer(CHAR_DISPLAY_TIME, true, false, true).timeout
	
	# Aguardar meio segundo e mostrar botão
	await get_tree().create_timer(0.5, true, false, true).timeout
	menu_button.visible = true

func _on_menu_button_pressed():
	print("[VICTORY] Botao pressionado!")
	get_tree().paused = false
	print("[VICTORY] Jogo despausado")
	queue_free()
	print("[VICTORY] Mudando para tilescreen...")
	get_tree().change_scene_to_file("res://scene/tilescreen.tscn")
