extends CharacterBody2D

enum BurgerState {
	walk,
	attack,
	hurt
}

const SPINNING_PROJECT = preload("res://entities/tomato.tscn")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition

const SPEED = 30.0
const CHASE_SPEED = 50.0
const DETECTION_RANGE = 100.0
const JUMP_VELOCITY = -400.0

var status: BurgerState

var direction = 1
var can_throw = true
var player: CharacterBody2D = null

func _ready() -> void:
	anim.flip_h = true
	player = get_tree().get_first_node_in_group("Player")
	go_to_walk_state()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		BurgerState.walk:
			walk_state(delta)
		BurgerState.attack:
			attack_state(delta)
		BurgerState.hurt:
			hurt_state(delta)

	move_and_slide()

func go_to_walk_state():
	status = BurgerState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status = BurgerState.attack
	anim.play("attack")
	velocity = Vector2.ZERO
	can_throw = true
	
func go_to_hurt_state():
	status = BurgerState.hurt
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
			# Mover em direção ao player
			velocity.x = CHASE_SPEED * direction
	
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
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return

func attack_state(_delta):
	if anim.frame == 2 && can_throw:
		throw_bone()
		can_throw = false

func hurt_state(_delta):
	pass
	
func take_damage():
	go_to_hurt_state()
	
func throw_bone():
	var new_bone = SPINNING_PROJECT.instantiate()
	add_sibling(new_bone)
	new_bone.position = bone_start_position.global_position
	new_bone.set_direction(self.direction)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return
