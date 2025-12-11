extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 60
var direction = 1
var distance_traveled = 0.0
const MAX_DISTANCE = 200.0

func _process(delta: float) -> void:
	var movement = speed * delta * direction
	position.x += movement
	distance_traveled += abs(movement)
	
	# Destruir projétil após percorrer 200 pixels
	if distance_traveled >= MAX_DISTANCE:
		queue_free()

func set_direction(skeleton_direction):
	direction = skeleton_direction
	anim.flip_h = direction < 0

func _on_self_destruct_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	# Verificar se colidiu com a hitbox do player
	var parent = area.get_parent()
	if parent and parent.is_in_group("Player"):
		if parent.has_method("take_damage"):
			parent.take_damage()
			print("[PROJECTILE] Dano causado ao player!")
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Verificar se colidiu diretamente com o player
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage()
			print("[PROJECTILE] Dano causado ao player (body)!")
	queue_free()
