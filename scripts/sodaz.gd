extends CharacterBody2D

enum SodazState {
	walk,
	attack,
	hurt
}

const SODA_BUBBLE = preload("res://entities/soda_bubble.tscn")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var bubble_start_position: Node2D = $TomatoStartPosition

const SPEED = 30.0
const CHASE_SPEED = 50.0
const DETECTION_RANGE = 250.0
const ATTACK_DISTANCE = 200.0
const MIN_DISTANCE = 15.0
const ATTACK_COOLDOWN = 3.0
const JUMP_VELOCITY = -400.0

var status: SodazState

var direction = 1
var can_throw = true
var attack_cooldown_timer = 0.0
var player: CharacterBody2D = null
var health = 200
const MAX_HEALTH = 200

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	go_to_walk_state()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Atualizar cooldown do ataque
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta
		
	match status:
		SodazState.walk:
			walk_state(delta)
		SodazState.attack:
			attack_state(delta)
		SodazState.hurt:
			hurt_state(delta)

	move_and_slide()

func go_to_walk_state():
	status = SodazState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status = SodazState.attack
	anim.play("attack")
	velocity = Vector2.ZERO
	can_throw = true
	
func go_to_hurt_state():
	status = SodazState.hurt
	anim.play("hurt")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
func walk_state(_delta):
	# Verificar se o player está próximo
	var is_chasing = false
	if player:
		# Calcular diferença no eixo X
		var x_difference = player.global_position.x - global_position.x
		var abs_x_distance = abs(x_difference)
		
		# Verificar se está dentro do range de 100 pixels no eixo X
		if abs_x_distance <= DETECTION_RANGE:
			is_chasing = true
			# Determinar direção para o player - SEMPRE atualiza a direção enquanto persegue
			var direction_to_player = sign(x_difference)
			if direction_to_player != 0 and direction_to_player != direction:
				scale.x *= -1
				direction = direction_to_player
			
			# Parar a 15 pixels de distância para evitar ficar em cima do player
			if abs_x_distance <= MIN_DISTANCE:
				velocity.x = 0
				if anim.animation != "idle":
					anim.play("idle")
			# Se está dentro do range de ataque, usa velocidade normal (padrão)
			elif abs_x_distance <= ATTACK_DISTANCE:
				velocity.x = SPEED * direction
				if anim.animation != "walk":
					anim.play("walk")
			# Senão, usa velocidade de perseguição
			else:
				velocity.x = CHASE_SPEED * direction
				if anim.animation != "walk":
					anim.play("walk")
			
			# Verificar se está próximo o suficiente para atacar
			if abs_x_distance <= ATTACK_DISTANCE and attack_cooldown_timer <= 0:
				go_to_attack_state()
				return
	
	if not is_chasing:
		# Comportamento normal de patrulha
		if anim.frame == 3 or anim.frame == 4:
			velocity.x = SPEED * direction
		else:
			velocity.x = 0
		
		if wall_detector.is_colliding():
			scale.x *= -1
			direction *= -1
		
		if not ground_detector.is_colliding():
			scale.x *= -1
			direction *= -1

func attack_state(_delta):
	if anim.frame == 2 && can_throw:
		throw_bubble()
		can_throw = false

func hurt_state(_delta):
	pass
	
func take_damage(damage = 100):
	health -= damage
	print("[SODAZ] Took ", damage, " damage. Health: ", health, "/", MAX_HEALTH)
	
	if health <= 0:
		go_to_hurt_state()
	else:
		# Piscar para indicar dano
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 1)
	
func throw_bubble():
	var new_bubble = SODA_BUBBLE.instantiate()
	add_sibling(new_bubble)
	new_bubble.position = bubble_start_position.global_position
	new_bubble.set_direction(self.direction)
	attack_cooldown_timer = ATTACK_COOLDOWN
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return
