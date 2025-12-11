extends Control

func _ready():
	pass

func _process(delta):
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/intro.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
