extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var velocity = Vector2.ZERO
var direction = 1
var distance_traveled = 0.0
var has_exploded = false
const MAX_DISTANCE = 80.0
const HORIZONTAL_SPEED = 150.0
const INITIAL_VERTICAL_VELOCITY = -200.0
const GRAVITY = 600.0
const EXPLOSION_RADIUS = 50.0

func _ready():
	add_to_group("PlayerProjectile")

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
	print("[APPLE] Explosão na posição: ", global_position)
	
	# Tocar animação de explosão
	if anim:
		anim.play("explosion")
		anim.animation_finished.connect(_on_explosion_finished)
	
	# Buscar todos os nós do grupo "Enemies" e verificar distância
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var enemies_killed = 0
	
	for enemy_hitbox in enemies:
		# Calcular distância até a hitbox do inimigo
		var distance = global_position.distance_to(enemy_hitbox.global_position)
		
		if distance <= EXPLOSION_RADIUS:
			# Inimigo está dentro da área de explosão
			var enemy = enemy_hitbox.get_parent()
			if enemy and enemy.has_method("take_damage"):
				enemy.take_damage(50)
				enemies_killed += 1
				print("[APPLE] Causou 50 de dano ao inimigo! Distância: ", distance)
	
	print("[APPLE] Explosão matou ", enemies_killed, " inimigo(s)")

func _on_area_entered(area: Area2D) -> void:
	# Se já explodiu, ignorar
	if has_exploded:
		return
	
	# Ignorar completamente qualquer coisa relacionada ao player
	var parent = area.get_parent()
	if area.is_in_group("Player") or (parent and parent.is_in_group("Player")):
		return
	
	# Se acertou um inimigo diretamente, explodir imediatamente
	if area.is_in_group("Enemies"):
		explode()
		return

func _on_body_entered(body: Node2D) -> void:
	# Se já explodiu, ignorar
	if has_exploded:
		return
	
	# NUNCA colidir com o player - ignorar completamente
	if body.is_in_group("Player"):
		return
	
	# Ignorar inimigos aqui (já tratado em _on_area_entered)
	if body.is_in_group("Enemies"):
		return
	
	# Colidir com qualquer body (chão, parede, etc) - explodir
	explode()

func _on_explosion_finished():
	# Destruir a maçã após a animação de explosão terminar
	queue_free()
