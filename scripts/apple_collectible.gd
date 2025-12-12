extends Area2D

const ITEM_POPUP = preload("res://entities/item_popup.tscn")

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
	
	# Verificar se é a primeira vez
	if not Globals.first_apple_collected:
		Globals.first_apple_collected = true
		show_item_popup()
	
	queue_free()

func show_item_popup():
	var popup = ITEM_POPUP.instantiate()
	get_tree().root.add_child(popup)
	popup.show_item("apple")
