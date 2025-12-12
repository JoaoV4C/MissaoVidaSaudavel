extends Area2D

func _ready():
	add_to_group("AppleCollectible")

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("Player"):
		collect(parent)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collect(body)

func collect(_player):
	Globals.apples += 1
	print("[APPLE_COLLECTIBLE] Coletado! Maçãs: ", Globals.apples)
	queue_free()
