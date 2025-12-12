extends Area2D

func _ready():
	add_to_group("WaterBottle")

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("Player"):
		collect(parent)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collect(body)

func collect(_player):
	# Restaurar 60 de energia (60% de 100)
	Globals.energy = min(100, Globals.energy + 60)
	print("[WATER_BOTTLE] Coletado! Energia: ", Globals.energy)
	queue_free()
