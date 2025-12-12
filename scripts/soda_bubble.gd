extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var velocity = Vector2.ZERO
var direction = 1
var has_exploded = false
const HORIZONTAL_SPEED = 150.0
const INITIAL_VERTICAL_VELOCITY = -200.0
const GRAVITY = 600.0
const EXPLOSION_RADIUS = 50.0

func _process(delta: float) -> void:
	if has_exploded:
		return
	
	# Aplicar gravidade (movimento parabólico)
	velocity.y += GRAVITY * delta
	
	# Movimento horizontal
	velocity.x = HORIZONTAL_SPEED * direction
	
	# Atualizar posição
	var movement = velocity * delta
	position += movement

func set_direction(throw_direction: int):
	direction = throw_direction
	velocity.x = HORIZONTAL_SPEED * direction
	velocity.y = INITIAL_VERTICAL_VELOCITY
	if anim:
		anim.flip_h = direction < 0

func explode():
	if has_exploded:
		return
	
	has_exploded = true
	velocity = Vector2.ZERO
	print("[SODA_BUBBLE] Explosão na posição: ", global_position)
	
	# Tocar animação de explosão
	if anim:
		anim.play("explosion")
		anim.animation_finished.connect(_on_explosion_finished)
	
	# Buscar o player e verificar se está no raio de explosão
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance <= EXPLOSION_RADIUS:
			# Player está dentro da área de explosão
			if player.has_method("take_damage"):
				player.take_damage()
				print("[SODA_BUBBLE] Causou dano ao player! Distância: ", distance)

func _on_explosion_finished():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	# Se já explodiu, ignorar
	if has_exploded:
		return
	
	# Ignorar completamente qualquer coisa relacionada a inimigos
	var parent = area.get_parent()
	if area.is_in_group("Enemies") or (parent and parent.is_in_group("Enemies")):
		return
	
	# Se acertou o player ou terreno, explodir
	if area.is_in_group("Player") or (parent and parent.is_in_group("Player")):
		explode()
		return

func _on_body_entered(body: Node2D) -> void:
	# Se já explodiu, ignorar
	if has_exploded:
		return
	
	# Ignorar inimigos
	if body.is_in_group("Enemies"):
		return
	
	# Colidir com terreno ou player
	explode()
