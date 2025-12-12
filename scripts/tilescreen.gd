extends Control

@onready var click_sound: AudioStreamPlayer = $ClickSound

func _ready():
	pass

func _process(delta):
	pass


func _on_button_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scene/intro.tscn")

func _on_button_3_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scene/tutorial.tscn")

func _on_button_4_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scene/credits.tscn")

func _on_button_2_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().quit()
