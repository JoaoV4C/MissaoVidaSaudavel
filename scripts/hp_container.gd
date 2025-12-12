extends HBoxContainer

@onready var player: CharacterBody2D = null
var heart_nodes: Array[TextureRect] = []

func _ready():
	# Aguardar o player estar disponível
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	
	# Coletar todos os TextureRect filhos (corações)
	for child in get_children():
		if child is TextureRect:
			heart_nodes.append(child)
	
	# Atualizar UI inicial
	update_hearts()

func _process(_delta):
	if player:
		update_hearts()

func update_hearts():
	if not player:
		return
	
	var current_health = player.health
	
	# Mostrar/esconder corações baseado na vida atual
	for i in range(heart_nodes.size()):
		if i < current_health:
			heart_nodes[i].visible = true
		else:
			heart_nodes[i].visible = false
