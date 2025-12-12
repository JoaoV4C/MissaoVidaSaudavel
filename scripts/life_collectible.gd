extends Area2D

func _ready():
	add_to_group("LifeCollectible")

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("Player"):
		collect(parent)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collect(body)

func collect(player):
	if player.health < 3:
		player.health += 1
		print("[LIFE_COLLECTIBLE] Coletado! Health: ", player.health)
		queue_free()
	else:
		print("[LIFE_COLLECTIBLE] Vida já está no máximo!")
