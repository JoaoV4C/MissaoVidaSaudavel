extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 80
var direction = 1
var distance_traveled = 0.0
var has_hit = false
const MAX_DISTANCE = 300.0

func _ready():
	add_to_group("PlayerProjectile")

func _process(delta: float) -> void:
	if has_hit:
		return
		
	var movement = speed * delta * direction
	position.x += movement
	distance_traveled += abs(movement)
	
	# Destruir projétil após percorrer 300 pixels
	if distance_traveled >= MAX_DISTANCE:
		queue_free()

func set_direction(throw_direction: int):
	direction = throw_direction
	if anim:
		anim.flip_h = direction < 0

func _on_area_entered(area: Area2D) -> void:
	# Se já acertou algo, ignorar
	if has_hit:
		return
	
	# Ignorar completamente qualquer coisa relacionada ao player
	var parent = area.get_parent()
	if area.is_in_group("Player") or (parent and parent.is_in_group("Player")):
		return
	
	# Verificar se acertou um inimigo
	if area.is_in_group("Enemies"):
		has_hit = true
		monitoring = false
		monitorable = false
		
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage()
			print("[APPLE] Dano causado ao inimigo!")
		
		queue_free()
		return

func _on_body_entered(body: Node2D) -> void:
	# Se já acertou algo, ignorar
	if has_hit:
		return
	
	# NUNCA colidir com o player - ignorar completamente
	if body.is_in_group("Player"):
		return
	
	# Ignorar inimigos aqui (já tratado em _on_area_entered)
	if body.is_in_group("Enemies"):
		return
	
	# Colidir com qualquer body (chão, parede, etc)
	queue_free()
