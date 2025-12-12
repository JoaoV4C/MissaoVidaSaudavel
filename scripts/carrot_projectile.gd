extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 120
var direction = 1
var distance_traveled = 0.0
var has_hit = false

func _ready():
	add_to_group("PlayerProjectile")

func _process(delta: float) -> void:
	if has_hit:
		return
	
	# Movimento reto horizontal (sem gravidade)
	var movement = speed * delta * direction
	position.x += movement
	distance_traveled += abs(movement)

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
	
	# Se acertou o hitbox de um inimigo, causar dano e destruir
	if area.is_in_group("Enemies"):
		has_hit = true
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(100)
			print("[CARROT] Causou 100 de dano ao inimigo!")
		queue_free()
		return
	
	# Verificar se o parent da area é um inimigo (alternativa)
	if parent and parent.has_method("take_damage"):
		has_hit = true
		parent.take_damage(100)
		print("[CARROT] Causou 100 de dano ao inimigo!")
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
	has_hit = true
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
