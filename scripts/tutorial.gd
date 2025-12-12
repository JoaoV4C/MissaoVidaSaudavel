extends Control

@onready var click_sound: AudioStreamPlayer = $ClickSound

func _on_back_button_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scene/tilescreen.tscn")
